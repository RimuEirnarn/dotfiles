"""Shell utility"""
from os import environ
from shlex import split
from subprocess import DEVNULL, run, Popen, PIPE, STDOUT
from pathlib import Path
from shutil import which
from typing import Any

path = Path("~/.cache/shell-commands.cache").expanduser()
PATH = environ['PATH'].split(':')
CACHED_COMMANDS = {}
SPECIAL_FUNCTIONS = {}
KwdArgs = dict[str, Any]

class Command:

    """Command class"""
    def __init__(self, name, path):
        self._name = name
        self._path = path

    @property
    def name(self):
        """Name of command"""
        return self._name

    @property
    def path(self):
        """Path of command"""
        return self._path

    def __call__(self, arg: str, ignore: bool = False, capture_stderr: bool = False):
        split_args = list(split(arg))
        x = []
        for i in split_args:
            if (i.startswith('"') or i.startswith("'")) and (i.endswith('"') or i.endswith("'")):
                x.append(i[1:-1])
                continue
            x.append(i)
        args = (self._name, *tuple(x))
        kwargs: KwdArgs = {}
        job = False
        if ignore:
            kwargs = {'stdout': DEVNULL, 'stderr': STDOUT}
        else:
            kwargs = {'stdout': PIPE, 'stderr': PIPE if capture_stderr else DEVNULL}
        if job:
            return Popen(args, **kwargs, executable=self._path, text=True)
        return run(args, **kwargs, executable=self._path, text=True)

    def __repr__(self) -> str:
        return f"<Command({self._name}) -> {id(self)}>"

def make_cmd(path):
    """Create new command from path"""
    if not path:
        raise ValueError("Must not empty string")
    name = path.split('/')[-1]
    return Command(name, path)

def fetch(name):
    """Fetch and return command from PATH"""
    if not name in CACHED_COMMANDS:
        path = which(name)
        if not path:
            raise LookupError(f"{name} is undefined")
        CACHED_COMMANDS[name] = Command(name, path)
    return CACHED_COMMANDS[name]

SPECIAL_FUNCTIONS['make_cmd'] = make_cmd
SPECIAL_FUNCTIONS['fetch'] = fetch

def __getattr__(name: str):
    if name in SPECIAL_FUNCTIONS:
        return SPECIAL_FUNCTIONS[name]
    if name in CACHED_COMMANDS:
        return CACHED_COMMANDS[name]
    path = which(name)
    if not path:
        raise AttributeError(f"{name} is undefined")
    command = Command(name, path)
    CACHED_COMMANDS[name] = command
    return command

