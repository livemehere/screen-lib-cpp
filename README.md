# screen lib cpp

```bash
clang++ ./src/main.cpp ./src/clipboard.mm ./src/overlay.mm -o ./dist/out \
    -std=c++17 \
    -framework AppKit \
    -framework Foundation \
    -framework CoreGraphics \
    -framework ImageIO
```
