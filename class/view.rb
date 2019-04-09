class View < Sprite
  def initialize(cell_num, _screen_size, cell_size)
    @cell_num = cell_num
    @cell_size = cell_size
    # 逆に言えばスクリーンサイズからセルサイズを持ってくることも可能
    @dead_img = Image.new(@cell_size - 1, @cell_size - 1, [255, 255, 255])
    @alive_img = Image.new(@cell_size - 1, @cell_size - 1, [65, 105, 225])
    @world_view = Array.new(@cell_num).map { Array.new(@cell_num).map { Sprite.new } }
  end

  def change(world, turn)
    (0...@cell_num).each do |wx|
      (0...@cell_num).each do |wy|
        @world_view[wx][wy].x = wx * @cell_size
        @world_view[wx][wy].y = wy * @cell_size
        @world_view[wx][wy].z=100
        @world_view[wx][wy].image = world[turn][wx][wy] == 1 ?
                                    @alive_img : @dead_img
      end
    end
  end

  def view_run
    Window.draw(0, 0,@background_img, z=0)
    Sprite.draw(@world_view)
  end
end
