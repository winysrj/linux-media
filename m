Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59739 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752514AbdHDQDu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 Aug 2017 12:03:50 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v3 1/7] v4l: vsp1: Release buffers in start_streaming error path
Date: Fri, 04 Aug 2017 19:04:03 +0300
Message-ID: <8097894.HmeFa5IAJo@avalon>
In-Reply-To: <22778858.uLPLfpXYHT@avalon>
References: <cover.109dff74bad8730bc9559578df79f47dae253305.1501861813.git-series.kieran.bingham+renesas@ideasonboard.com> <cb35eec2aae25b07fdc303cf9e005c878f07ac92.1501861813.git-series.kieran.bingham+renesas@ideasonboard.com> <22778858.uLPLfpXYHT@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 04 Aug 2017 19:03:28 Laurent Pinchart wrote:
> Hi Kieran,
> 
> Thank you for the patch.
> 
> On Friday 04 Aug 2017 16:57:05 Kieran Bingham wrote:
> > Presently any received buffers are only released back to vb2 if
> > vsp1_video_stop_streaming() is called. If vsp1_video_start_streaming()
> > encounters an error, we will be warned by the vb2 handlers that buffers
> > have not been returned.
> > 
> > Move the buffer cleanup code to it's own function to prevent duplication
> 
> s/it's/its/
> 
> > and call from both vsp1_video_stop_streaming() and the error path in
> > vsp1_video_start_streaming()
> 
> s/$/./
> 
> > Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> > ---
> > 
> >  drivers/media/platform/vsp1/vsp1_video.c | 22 +++++++++++++++-------
> >  1 file changed, 15 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/media/platform/vsp1/vsp1_video.c
> > b/drivers/media/platform/vsp1/vsp1_video.c index
> > 5af3486afe07..a24033429cd7
> > 100644
> > --- a/drivers/media/platform/vsp1/vsp1_video.c
> > +++ b/drivers/media/platform/vsp1/vsp1_video.c
> > @@ -822,6 +822,19 @@ static int vsp1_video_setup_pipeline(struct
> > vsp1_pipeline *pipe) return 0;
> > 
> >  }
> > 
> > +static void vsp1_video_cleanup_pipeline(struct vsp1_video *video)
> 
> Should this function take a pipe pointer instead of a video pointer for
> symmetry with vsp1_video_setup_pipeline() ?
> 
> > +{
> > +	struct vsp1_vb2_buffer *buffer;
> > +	unsigned long flags;
> > +
> > +	/* Remove all buffers from the IRQ queue. */
> > +	spin_lock_irqsave(&video->irqlock, flags);
> > +	list_for_each_entry(buffer, &video->irqqueue, queue)
> > +		vb2_buffer_done(&buffer->buf.vb2_buf, VB2_BUF_STATE_ERROR);
> > +	INIT_LIST_HEAD(&video->irqqueue);
> > +	spin_unlock_irqrestore(&video->irqlock, flags);
> > +}
> > +
> > 
> >  static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int
> > 
> > count) {
> > 
> >  	struct vsp1_video *video = vb2_get_drv_priv(vq);
> > 
> > @@ -835,6 +848,7 @@ static int vsp1_video_start_streaming(struct vb2_queue
> > *vq, unsigned int count) ret = vsp1_video_setup_pipeline(pipe);
> > 
> >  		if (ret < 0) {
> >  		
> >  			mutex_unlock(&pipe->lock);
> > 
> > +			vsp1_video_cleanup_pipeline(video);
> > 
> >  			return ret;
> >  		
> >  		}
> > 
> > @@ -866,7 +880,6 @@ static void vsp1_video_stop_streaming(struct vb2_queue
> > *vq) {
> > 
> >  	struct vsp1_video *video = vb2_get_drv_priv(vq);
> >  	struct vsp1_pipeline *pipe = video->rwpf->pipe;
> > 
> > -	struct vsp1_vb2_buffer *buffer;
> > 
> >  	unsigned long flags;
> >  	int ret;
> > 
> > @@ -893,12 +906,7 @@ static void vsp1_video_stop_streaming(struct
> > vb2_queue
> > *vq) media_pipeline_stop(&video->video.entity);
> > 
> >  	vsp1_video_pipeline_put(pipe);
> > 
> > -	/* Remove all buffers from the IRQ queue. */
> > -	spin_lock_irqsave(&video->irqlock, flags);
> > -	list_for_each_entry(buffer, &video->irqqueue, queue)
> > -		vb2_buffer_done(&buffer->buf.vb2_buf, VB2_BUF_STATE_ERROR);
> > -	INIT_LIST_HEAD(&video->irqqueue);
> > -	spin_unlock_irqrestore(&video->irqlock, flags);
> > +	vsp1_video_cleanup_pipeline(video);
> 
> The vsp1_video_cleanup_pipeline() call should go before
> vsp1_video_pipeline_put(), as you've noticed in patch 7/7.

I meant 3/7.

> 
> With all that fixed,
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> >  }
> >  
> >  static const struct vb2_ops vsp1_video_queue_qops = {

-- 
Regards,

Laurent Pinchart
