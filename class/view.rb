class View < Sprite
  def initialize(cell_num, _screen_size, cell_size)
    @cell_num = cell_num
    @cell_size = cell_size
    # 逆に言えばスクリーンサイズからセルサイズを持ってくることも可能
    @dead_img = Image.new(@cell_size - 1, @cell_size - 1, [8, 217, 214])
    @alive_img = Image.new(@cell_size - 1, @cell_size - 1, [7, 12, 22])
    @world_view = Array.new(@cell_num).map { Array.new(@cell_num).map { Sprite.new } }
  end

  def change(world, turn)
    (0...@cell_num).each do |wx|
      (0...@cell_num).each do |wy|
        @world_view[wx][wy].x = wx * @cell_size
        @world_view[wx][wy].y = wy * @cell_size
        @world_view[wx][wy].image = world[turn][wx][wy] == 1 ?
                                    @alive_img : @dead_img
      end
    end
  end

  def view_run
    Sprite.draw(@world_view)
  end
end
