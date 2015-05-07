class LinksController < ApplicationController

  def index
    @link = Link.new
    @links = Link.all    
  end

  def show
    if params[:slug]
      @link = Link.find_by(slug: params[:slug])
      if redirect_to @link.long_url
        if @link.ip_address == @local_ip = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last} 
        else
          @link.clicks += 1
          @link.ip_address = @local_ip = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last} 
          @link.save
        end   
      end  
    else
      @link = Link.find(params[:id])
    end
  end

  def create
    @link = Link.new(link_params)

    respond_to do |format|
      if @link.save
        format.js
        format.json { render action: 'index', status: :created, location: @link }
      else
        format.html { render action: 'new' }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end
 
  private
    
    def link_params
      params.require(:link).permit(:long_url)
    end

end
