Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:50936 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755959Ab2K0Qa1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 11:30:27 -0500
Date: Tue, 27 Nov 2012 17:30:25 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Albert Wang <twang13@marvell.com>
cc: corbet@lwn.net, linux-media@vger.kernel.org, lbyang@marvell.com
Subject: Re: [PATCH 15/15] [media] marvell-ccic: add 3 frame buffers support
 in DMA_CONTIG mode
In-Reply-To: <1353677705-24479-1-git-send-email-twang13@marvell.com>
Message-ID: <Pine.LNX.4.64.1211271713100.22273@axis700.grange>
References: <1353677705-24479-1-git-send-email-twang13@marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 23 Nov 2012, Albert Wang wrote:

> This patch adds support of 3 frame buffers in DMA-contiguous mode.
> 
> In current DMA_CONTIG mode, only 2 frame buffers can be supported.
> Actually, Marvell CCIC can support at most 3 frame buffers.
> 
> Currently 2 frame buffers mode will be used by default.
> To use 3 frame buffers mode, can do:
>   define MAX_FRAME_BUFS 3
> in mcam-core.h
> 
> Signed-off-by: Albert Wang <twang13@marvell.com>
> ---
>  drivers/media/platform/marvell-ccic/mcam-core.c |   59 +++++++++++++++++------
>  drivers/media/platform/marvell-ccic/mcam-core.h |   11 +++++
>  2 files changed, 55 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
> index 2d200d6..3b75594 100755
> --- a/drivers/media/platform/marvell-ccic/mcam-core.c
> +++ b/drivers/media/platform/marvell-ccic/mcam-core.c
> @@ -401,13 +401,32 @@ static void mcam_set_contig_buffer(struct mcam_camera *cam, unsigned int frame)
>  	struct mcam_vb_buffer *buf;
>  	struct v4l2_pix_format *fmt = &cam->pix_format;
>  
> -	/*
> -	 * If there are no available buffers, go into single mode
> -	 */
>  	if (list_empty(&cam->buffers)) {
> -		buf = cam->vb_bufs[frame ^ 0x1];
> -		set_bit(CF_SINGLE_BUFFER, &cam->flags);
> -		cam->frame_state.singles++;
> +		/*
> +		 * If there are no available buffers
> +		 * go into single buffer mode
> +		 *
> +		 * If CCIC use Two Buffers mode
> +		 * will use another remaining frame buffer
> +		 * frame 0 -> buf 1
> +		 * frame 1 -> buf 0
> +		 *
> +		 * If CCIC use Three Buffers mode
> +		 * will use the 2rd remaining frame buffer
> +		 * frame 0 -> buf 2
> +		 * frame 1 -> buf 0
> +		 * frame 2 -> buf 1
> +		 */
> +		buf = cam->vb_bufs[(frame + (MAX_FRAME_BUFS - 1))
> +						% MAX_FRAME_BUFS];
> +		if (cam->frame_state.tribufs == 0)
> +			cam->frame_state.tribufs++;

TBH, I don't understand what the "tribuf" field means and what it is 
doing. Could you explain a bit?

> +		else {
> +			set_bit(CF_SINGLE_BUFFER, &cam->flags);
> +			cam->frame_state.singles++;
> +			if (cam->frame_state.tribufs < 2)
> +				cam->frame_state.tribufs++;

This seems to be the only location, where tribuf affects the control flow. 
So, it looks like, it controls, if no more buffers are on the queue, 
wheather you need to set the CF_SINGLE_BUFFER flag and increment the 
singles count. 

Thanks
Guennadi

> +		}
>  	} else {
>  		/*
>  		 * OK, we have a buffer we can use.
> @@ -416,15 +435,15 @@ static void mcam_set_contig_buffer(struct mcam_camera *cam, unsigned int frame)
>  					queue);
>  		list_del_init(&buf->queue);
>  		clear_bit(CF_SINGLE_BUFFER, &cam->flags);
> +		if (cam->frame_state.tribufs != (3 - MAX_FRAME_BUFS))
> +			cam->frame_state.tribufs--;
>  	}
>  
>  	cam->vb_bufs[frame] = buf;
> -	mcam_reg_write(cam, frame == 0 ? REG_Y0BAR : REG_Y1BAR, buf->yuv_p.y);
> +	mcam_reg_write(cam, REG_Y0BAR + (frame << 2), buf->yuv_p.y);
>  	if (mcam_fmt_is_planar(fmt->pixelformat)) {
> -		mcam_reg_write(cam, frame == 0 ?
> -					REG_U0BAR : REG_U1BAR, buf->yuv_p.u);
> -		mcam_reg_write(cam, frame == 0 ?
> -					REG_V0BAR : REG_V1BAR, buf->yuv_p.v);
> +		mcam_reg_write(cam, REG_U0BAR + (frame << 2), buf->yuv_p.u);
> +		mcam_reg_write(cam, REG_V0BAR + (frame << 2), buf->yuv_p.v);
>  	}
>  }
>  
> @@ -433,10 +452,14 @@ static void mcam_set_contig_buffer(struct mcam_camera *cam, unsigned int frame)
>   */
>  void mcam_ctlr_dma_contig(struct mcam_camera *cam)
>  {
> -	mcam_reg_set_bit(cam, REG_CTRL1, C1_TWOBUFS);
> -	cam->nbufs = 2;
> -	mcam_set_contig_buffer(cam, 0);
> -	mcam_set_contig_buffer(cam, 1);
> +	unsigned int frame;
> +
> +	cam->nbufs = MAX_FRAME_BUFS;
> +	for (frame = 0; frame < cam->nbufs; frame++)
> +		mcam_set_contig_buffer(cam, frame);
> +
> +	if (cam->nbufs == 2)
> +		mcam_reg_set_bit(cam, REG_CTRL1, C1_TWOBUFS);
>  }
>  
>  /*
> @@ -1043,6 +1066,12 @@ static int mcam_vb_start_streaming(struct vb2_queue *vq, unsigned int count)
>  	for (frame = 0; frame < cam->nbufs; frame++)
>  		clear_bit(CF_FRAME_SOF0 + frame, &cam->flags);
>  
> +	/*
> +	 *  If CCIC use Two Buffers mode, init tribufs == 1
> +	 *  If CCIC use Three Buffers mode, init tribufs == 0
> +	 */
> +	cam->frame_state.tribufs = 3 - MAX_FRAME_BUFS;
> +
>  	return mcam_read_setup(cam);
>  }
>  
> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
> index 5b2cf6e..6420754 100755
> --- a/drivers/media/platform/marvell-ccic/mcam-core.h
> +++ b/drivers/media/platform/marvell-ccic/mcam-core.h
> @@ -68,6 +68,13 @@ enum mcam_state {
>  #define MAX_DMA_BUFS 3
>  
>  /*
> + * CCIC can support at most 3 frame buffers in DMA_CONTIG buffer mode
> + * 2 - Use Two Buffers mode
> + * 3 - Use Three Buffers mode
> + */
> +#define MAX_FRAME_BUFS 2 /* Current marvell-ccic used Two Buffers mode */
> +
> +/*
>   * Different platforms work best with different buffer modes, so we
>   * let the platform pick.
>   */
> @@ -105,6 +112,10 @@ struct mmp_frame_state {
>  	unsigned int frames;
>  	unsigned int singles;
>  	unsigned int delivered;
> +	/*
> +	 * Only tribufs == 2 can enter single buffer mode
> +	 */
> +	unsigned int tribufs;
>  };
>  
>  /*
> -- 
> 1.7.9.5
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
