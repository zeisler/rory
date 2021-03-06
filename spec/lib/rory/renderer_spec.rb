describe Rory::Renderer do
  describe "#render" do
    let(:app) { Fixture::Application }

    it "returns text of template" do
      renderer = Rory::Renderer.new('test/static', :app => app)
      expect(renderer.render).to eq('Static content')
    end

    it "returns text of template in given layout" do
      controller = Rory::Renderer.new('test/static', :layout => 'surround', :app => app)
      expect(controller.render).to eq('Surrounding Static content is fun')
    end

    it "handles symbolized layout name" do
      controller = Rory::Renderer.new('test/static', :layout => :surround, :app => app)
      expect(controller.render).to eq('Surrounding Static content is fun')
    end

    it "exposes locals to template" do
      controller = Rory::Renderer.new('test/dynamic', :locals => { :word => 'hockey' }, :app => app)
      expect(controller.render).to eq('Word: hockey')
    end

    it "can render nested templates" do
      controller = Rory::Renderer.new('test/double_nested', :locals => { :word => 'hockey' }, :app => app)
      expect(controller.render).to eq( 
        "Don't Say A Bad Word: Poop!"
      )
    end

    it "exposes base_path to template" do
      controller = Rory::Renderer.new('test/a_link', :base_path => 'spoo', :app => app)
      expect(controller.render).to eq('You came from spoo.')
    end
  end

  describe '#view_path' do
    it 'returns path to template from app root' do
      fake_app = double('Application', :root => 'marbles')
      renderer = Rory::Renderer.new('goose', :app => fake_app)
      expect(renderer.view_path).to eq(File.expand_path(File.join('views', 'goose.html.erb'), 'marbles'))
    end

    it 'uses Rory.root if no app specified' do
      renderer = Rory::Renderer.new('goose', :app => double(:root => "horse"))
      expect(renderer.view_path).to eq(File.expand_path(File.join('views', 'goose.html.erb'), "horse"))
    end
  end
end