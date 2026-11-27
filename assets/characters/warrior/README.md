# Guerreiro — proposta visual v1

## Walk

- Abra `scenes/characters/warrior.tscn` → `AnimatedSprite2D` → SpriteFrames. O recurso atual é `resources/characters/warrior/warrior_animations.tres`, com os giros de Idle e os novos ciclos.
- `walk` reproduz a caminhada clássica para sul; `walk_isometrico` reproduz a isométrica para sul. Para escolher direção: `walk_n`, `walk_ne`, `walk_e`, `walk_se`, `walk_s`, `walk_sw`, `walk_w`, `walk_nw`; na segunda perspectiva, use `walk_isometrico_n`, etc.
- Cada ciclo tem 8 frames a 8 FPS, em loop, editáveis no painel SpriteFrames. Walk mantém a direção fixa durante a reprodução.
- No laboratório (`scenes/warrior.tscn`, F5), ative o botão **Walk** e use os menus de perspectiva/direção. As oito miniaturas também reproduzem seus ciclos. O personagem caminha no lugar para avaliação; não há deslocamento de gameplay nesta etapa.
- PNGs RGBA e prompts da ferramenta integrada imagegen estão em `assets/characters/warrior/walk/<direção>/`. Cada prancha contém 16 frames: os primeiros oito clássicos e os últimos oito isométricos. Os recursos `classic_walk.tres` e `isometric_walk.tres` selecionam separadamente cada perspectiva por AtlasTexture.
- As pranchas originais de 1254 × 1254 foram preservadas. Cada ciclo utiliza um recorte e uma margem constantes, canvas virtual de 384 × 384 e pés em (192, 336). No Inspector do Guerreiro, `Walk Sprite Scale` (1/3) e `Walk Sprite Offset` mantêm o canvas exibido em 128 × 128, compatível com o Idle. Esses valores também são aplicados quando se escolhe uma animação no editor.
- Os arquivos de Idle anteriores permanecem preservados. As novas caminhadas precisam de avaliação artística em reprodução, especialmente contato dos pés, pequenas variações de desenho e transições entre direções.
- Teste: `godot --headless --path . --script res://tests/warrior_walk_smoke.gd`.

## Idle

Para visualizar o giro no editor, abra `scenes/characters/warrior.tscn`, selecione `AnimatedSprite2D` e abra seu SpriteFrames. Escolha `idle_normal` ou `idle_isometrico` e pressione Play no painel. Ambas percorrem N, NE, E, SE, S, SW, W e NW em loop, a 4 FPS (2 segundos por volta). O recurso é `resources/characters/warrior/idle_turnaround.tres`; ajuste FPS e loop diretamente no painel. O laboratório em execução continua permitindo escolher poses individuais.

- Execute `scenes/warrior.tscn` (F6), ou o projeto (F5).
- Selecione perspectiva e direção pelos menus; Tab alterna a perspectiva e as setas escolhem a direção, sem deslocamento.
- A cena reutilizável fica em `scenes/characters/warrior.tscn`. No Inspector, altere `perspective` e `direction` para visualizar a pose também no editor.
- Edite as animações em `resources/characters/warrior/classic_idle.tres` e `isometric_idle.tres`, pelo painel SpriteFrames. Cada `idle_*` tem somente um frame: ainda não é um ciclo animado.
- Os PNGs RGBA originais foram preservados em `classic/idle/` e `isometric/idle/`. Gerados pela ferramenta integrada de imagens; os prompts estão nos respectivos `generation_prompt.txt`.
- A saída gerada tem 1774 × 887 pixels. AtlasTextures recortam e compensam as margens em canvas virtual de 512 × 512, com pés em (256, 448). A escala de exibição padrão é 0,25, equivalente a canvas de 128 × 128, sem regravar ou reduzir os PNGs.
- Filtro Nearest; sem espelhamento. Colisão provisória nos pés; ajustar após aprovação artística.
- As poses são propostas para validação de identidade, acabamento dos pixels, equipamentos e distinção das perspectivas. A geração não garante uma malha de pixels uniforme; ainda requer revisão artística antes de produção definitiva ou animações.
- Sem acesso ao display nesta sessão: cenas e recursos configurados em arquivos nativos, com validação automatizada headless. Nenhuma configuração foi feita pela interface gráfica.
- Verificação: `godot --headless --path . --script res://tests/warrior_smoke.gd`.
