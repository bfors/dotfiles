#!/usr/bin/env -S uv run
# /// script
# dependencies = ['typer']
# ///
import typer


def main(name: str, num: int):
    print(f"Hello {name}, {num}")


if __name__ == "__main__":
    typer.run(main)
