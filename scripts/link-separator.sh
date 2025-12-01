#!/bin/env bash

LISTS_DIR="$HOME/Projects/minecraft-kingdom/lists/"
INFO_DIR="$HOME/Projects/minecraft-kingdom/info/"

sed -E -n '/### Categories list:/,/#### 1.21.9/d;s/^.*\[(.*)\]\((.*)\).*$/\1;\2/p' $INFO_DIR/Mods.md | sed -e '$a\' > $LISTS_DIR/mods-list.txt
sed -E -n '/### Categories list:/,/- [Vocal Villagers]/d;s/^.*\[(.*)\]\((.*)\).*$/\1;\2/p' $INFO_DIR/Resourcepacks.md | sed -e '$a\' > $LISTS_DIR/resourcepacks-list.txt

# sed -E -n 's/^.*\[(.*)\]\((.*)\).*$/\1;\2/p' $INFO_DIR/Mods.md > $LISTS_DIR/mods-list.txt
# sed -E -n 's/^.*\[(.*)\]\((.*)\).*$/\1;\2/p' $INFO_DIR/Resourcepacks.md > $LISTS_DIR/resourcepacks-list.txt