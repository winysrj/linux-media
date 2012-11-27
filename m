Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:51014 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab2K0Lo7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 06:44:59 -0500
Date: Tue, 27 Nov 2012 12:44:57 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Albert Wang <twang13@marvell.com>
cc: corbet@lwn.net, linux-media@vger.kernel.org,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [PATCH 06/15] [media] marvell-ccic: add new formats support for
 marvell-ccic driver
In-Reply-To: <1353677621-24143-1-git-send-email-twang13@marvell.com>
Message-ID: <Pine.LNX.4.64.1211271218120.22273@axis700.grange>
References: <1353677621-24143-1-git-send-email-twang13@marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 23 Nov 2012, Albert Wang wrote:

> From: Libin Yang <lbyang@marvell.com>
> 
> This patch adds the new formats support for marvell-ccic.
> 
> Signed-off-by: Albert Wang <twang13@marvell.com>
> Signed-off-by: Libin Yang <lbyang@marvell.com>
> ---
>  drivers/media/platform/marvell-ccic/mcam-core.c |  178 ++++++++++++++++++-----
>  drivers/media/platform/marvell-ccic/mcam-core.h |    6 +
>  2 files changed, 151 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
> index 67d4f2f..c9f7250 100755
> --- a/drivers/media/platform/marvell-ccic/mcam-core.c
> +++ b/drivers/media/platform/marvell-ccic/mcam-core.c
> @@ -110,6 +110,30 @@ static struct mcam_format_struct {
>  		.bpp		= 2,
>  	},
>  	{
> +		.desc		= "UYVY 4:2:2",
> +		.pixelformat	= V4L2_PIX_FMT_UYVY,
> +		.mbus_code	= V4L2_MBUS_FMT_UYVY8_2X8,
> +		.bpp		= 2,
> +	},
> +	{
> +		.desc		= "YUV 4:2:2 PLANAR",
> +		.pixelformat	= V4L2_PIX_FMT_YUV422P,
> +		.mbus_code	= V4L2_MBUS_FMT_UYVY8_2X8,
> +		.bpp		= 2,
> +	},
> +	{
> +		.desc		= "YUV 4:2:0 PLANAR",
> +		.pixelformat	= V4L2_PIX_FMT_YUV420,
> +		.mbus_code	= V4L2_MBUS_FMT_YUYV8_1_5X8,
> +		.bpp		= 2,
> +	},
> +	{
> +		.desc		= "YVU 4:2:0 PLANAR",
> +		.pixelformat	= V4L2_PIX_FMT_YVU420,
> +		.mbus_code	= V4L2_MBUS_FMT_YVYU8_1_5X8,
> +		.bpp		= 2,
> +	},
> +	{
>  		.desc		= "RGB 444",
>  		.pixelformat	= V4L2_PIX_FMT_RGB444,
>  		.mbus_code	= V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE,
> @@ -168,6 +192,12 @@ struct mcam_dma_desc {
>  	u32 segment_len;
>  };
>  
> +struct yuv_pointer_t {
> +	dma_addr_t y;
> +	dma_addr_t u;
> +	dma_addr_t v;
> +};
> +
>  /*
>   * Our buffer type for working with videobuf2.  Note that the vb2
>   * developers have decreed that struct vb2_buffer must be at the
> @@ -179,6 +209,7 @@ struct mcam_vb_buffer {
>  	struct mcam_dma_desc *dma_desc;	/* Descriptor virtual address */
>  	dma_addr_t dma_desc_pa;		/* Descriptor physical address */
>  	int dma_desc_nent;		/* Number of mapped descriptors */
> +	struct yuv_pointer_t yuv_p;
>  };
>  
>  static inline struct mcam_vb_buffer *vb_to_mvb(struct vb2_buffer *vb)
> @@ -465,6 +496,18 @@ static inline int mcam_check_dma_buffers(struct mcam_camera *cam)
>  /*
>   * DMA-contiguous code.
>   */
> +
> +static bool mcam_fmt_is_planar(__u32 pfmt)
> +{
> +	switch (pfmt) {
> +	case V4L2_PIX_FMT_YUV422P:
> +	case V4L2_PIX_FMT_YUV420:
> +	case V4L2_PIX_FMT_YVU420:
> +		return true;
> +	}
> +	return false;
> +}
> +
>  /*
>   * Set up a contiguous buffer for the given frame.  Here also is where
>   * the underrun strategy is set: if there is no buffer available, reuse
> @@ -476,6 +519,8 @@ static inline int mcam_check_dma_buffers(struct mcam_camera *cam)
>  static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
>  {
>  	struct mcam_vb_buffer *buf;
> +	struct v4l2_pix_format *fmt = &cam->pix_format;
> +
>  	/*
>  	 * If there are no available buffers, go into single mode
>  	 */
> @@ -494,8 +539,13 @@ static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
>  	}
>  
>  	cam->vb_bufs[frame] = buf;
> -	mcam_reg_write(cam, frame == 0 ? REG_Y0BAR : REG_Y1BAR,
> -			vb2_dma_contig_plane_dma_addr(&buf->vb_buf, 0));
> +	mcam_reg_write(cam, frame == 0 ? REG_Y0BAR : REG_Y1BAR, buf->yuv_p.y);
> +	if (mcam_fmt_is_planar(fmt->pixelformat)) {
> +		mcam_reg_write(cam, frame == 0 ?
> +					REG_U0BAR : REG_U1BAR, buf->yuv_p.u);
> +		mcam_reg_write(cam, frame == 0 ?
> +					REG_V0BAR : REG_V1BAR, buf->yuv_p.v);
> +	}
>  }
>  
>  /*
> @@ -653,49 +703,91 @@ static inline void mcam_sg_restart(struct mcam_camera *cam)
>   */
>  static void mcam_ctlr_image(struct mcam_camera *cam)
>  {
> -	int imgsz;
>  	struct v4l2_pix_format *fmt = &cam->pix_format;
> +	u32 widthy = 0, widthuv = 0, imgsz_h, imgsz_w;
> +
> +	cam_dbg(cam, "camera: bytesperline = %d; height = %d\n",
> +		fmt->bytesperline, fmt->sizeimage / fmt->bytesperline);
> +	imgsz_h = (fmt->height << IMGSZ_V_SHIFT) & IMGSZ_V_MASK;
> +	imgsz_w = fmt->bytesperline & IMGSZ_H_MASK;
> +
> +	if (fmt->pixelformat == V4L2_PIX_FMT_YUV420
> +		|| fmt->pixelformat == V4L2_PIX_FMT_YVU420)
> +		imgsz_w = (fmt->bytesperline * 4 / 3) & IMGSZ_H_MASK;
> +	else if (fmt->pixelformat == V4L2_PIX_FMT_JPEG)
> +		imgsz_h = (fmt->sizeimage / fmt->bytesperline) << IMGSZ_V_SHIFT;
> +
> +	switch (fmt->pixelformat) {
> +	case V4L2_PIX_FMT_YUYV:
> +	case V4L2_PIX_FMT_UYVY:
> +		widthy = fmt->width * 2;
> +		widthuv = fmt->width * 2;
> +		break;

I think, you can move imgsz_h and imgsz_w calculations from above to this 
switch too?

> +	case V4L2_PIX_FMT_RGB565:
> +		widthy = fmt->width * 2;
> +		widthuv = 0;
> +		break;
> +	case V4L2_PIX_FMT_JPEG:
> +		widthy = fmt->bytesperline;
> +		widthuv = fmt->bytesperline;
> +		break;
> +	case V4L2_PIX_FMT_YUV422P:
> +	case V4L2_PIX_FMT_YUV420:
> +	case V4L2_PIX_FMT_YVU420:
> +		widthy = fmt->width;
> +		widthuv = fmt->width / 2;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	mcam_reg_write_mask(cam, REG_IMGPITCH, widthuv << 16 | widthy,
> +			IMGP_YP_MASK | IMGP_UVP_MASK);

Hm, are you sure you're not breaking other currently supported pixel 
formats, like V4L2_PIX_FMT_RGB444, V4L2_PIX_FMT_SBGGR8?

> +	mcam_reg_write(cam, REG_IMGSIZE, imgsz_h | imgsz_w);
> +	mcam_reg_write(cam, REG_IMGOFFSET, 0x0);
>  
> -	imgsz = ((fmt->height << IMGSZ_V_SHIFT) & IMGSZ_V_MASK) |
> -		(fmt->bytesperline & IMGSZ_H_MASK);
> -	mcam_reg_write(cam, REG_IMGSIZE, imgsz);
> -	mcam_reg_write(cam, REG_IMGOFFSET, 0);
> -	/* YPITCH just drops the last two bits */
> -	mcam_reg_write_mask(cam, REG_IMGPITCH, fmt->bytesperline,
> -			IMGP_YP_MASK);

Let's see. Before we had

	REG_IMGPITCH = fmt->bytesperline & 0x3ffc;

after your change, say, for V4L2_PIX_FMT_YUYV (fmt->bytesperline = 
fmt->width * 2), you get

	REG_IMGPITCH = ((fmt->bytesperline << 16) | fmt->bytesperline) &
		0x3ffc3ffc;

Is this intentional? Doesn't widthuv have to be 0 for non-planar formats 
like V4L2_PIX_FMT_YUYV? Please, always when you change existing code make 
sure the original behaviour is preserved, unless there used to be a bug, 
in which case it should be fixed by a separate patch.

>  	/*
>  	 * Tell the controller about the image format we are using.
>  	 */
> -	switch (cam->pix_format.pixelformat) {
> +	switch (fmt->pixelformat) {
> +	case V4L2_PIX_FMT_YUV422P:
> +		mcam_reg_write_mask(cam, REG_CTRL0,
> +			C0_DF_YUV | C0_YUV_PLANAR | C0_YUVE_YVYU, C0_DF_MASK);
> +		break;
> +	case V4L2_PIX_FMT_YUV420:
> +	case V4L2_PIX_FMT_YVU420:
> +		mcam_reg_write_mask(cam, REG_CTRL0,
> +			C0_DF_YUV | C0_YUV_420PL | C0_YUVE_YVYU, C0_DF_MASK);
> +		break;
>  	case V4L2_PIX_FMT_YUYV:
> -	    mcam_reg_write_mask(cam, REG_CTRL0,
> -			    C0_DF_YUV|C0_YUV_PACKED|C0_YUVE_YUYV,
> -			    C0_DF_MASK);
> -	    break;
> -
> +		mcam_reg_write_mask(cam, REG_CTRL0,
> +			C0_DF_YUV | C0_YUV_PACKED | C0_YUVE_UYVY, C0_DF_MASK);
> +		break;
> +	case V4L2_PIX_FMT_UYVY:
> +		mcam_reg_write_mask(cam, REG_CTRL0,
> +			C0_DF_YUV | C0_YUV_PACKED | C0_YUVE_YUYV, C0_DF_MASK);
> +		break;
> +	case V4L2_PIX_FMT_JPEG:
> +		mcam_reg_write_mask(cam, REG_CTRL0,
> +			C0_DF_YUV | C0_YUV_PACKED | C0_YUVE_YUYV, C0_DF_MASK);
> +		break;
>  	case V4L2_PIX_FMT_RGB444:
> -	    mcam_reg_write_mask(cam, REG_CTRL0,
> -			    C0_DF_RGB|C0_RGBF_444|C0_RGB4_XRGB,
> -			    C0_DF_MASK);
> -		/* Alpha value? */

Unless you have a specific reason, you could just as well preserve the 
comment.

> -	    break;
> -
> +		mcam_reg_write_mask(cam, REG_CTRL0,
> +			C0_DF_RGB | C0_RGBF_444 | C0_RGB4_XRGB, C0_DF_MASK);
> +		break;
>  	case V4L2_PIX_FMT_RGB565:
> -	    mcam_reg_write_mask(cam, REG_CTRL0,
> -			    C0_DF_RGB|C0_RGBF_565|C0_RGB5_BGGR,
> -			    C0_DF_MASK);
> -	    break;
> -
> +		mcam_reg_write_mask(cam, REG_CTRL0,
> +			C0_DF_RGB | C0_RGBF_565 | C0_RGB5_BGGR, C0_DF_MASK);
> +		break;
>  	default:
> -	    cam_err(cam, "Unknown format %x\n", cam->pix_format.pixelformat);
> -	    break;
> +		cam_err(cam, "camera: unknown format: %c\n", fmt->pixelformat);

Don't think "%c" will produce a meaningful result here.

> +		break;
>  	}
> +
>  	/*
>  	 * Make sure it knows we want to use hsync/vsync.
>  	 */
> -	mcam_reg_write_mask(cam, REG_CTRL0, C0_SIF_HVSYNC,
> -			C0_SIFM_MASK);
> -
> +	mcam_reg_write_mask(cam, REG_CTRL0, C0_SIF_HVSYNC, C0_SIFM_MASK);
>  	/*
>  	 * This field controls the generation of EOF(DVP only)
>  	 */
> @@ -706,7 +798,6 @@ static void mcam_ctlr_image(struct mcam_camera *cam)
>  	}
>  }
>  
> -
>  /*
>   * Configure the controller for operation; caller holds the
>   * device mutex.
> @@ -979,11 +1070,32 @@ static void mcam_vb_buf_queue(struct vb2_buffer *vb)
>  {
>  	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
>  	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
> +	struct v4l2_pix_format *fmt = &cam->pix_format;
>  	unsigned long flags;
>  	int start;
> +	dma_addr_t dma_handle;
> +	u32 base_size = fmt->width * fmt->height;

Shouldn't you be just using bytesperline? Is stride != width * height 
supported?

>  
>  	spin_lock_irqsave(&cam->dev_lock, flags);
> +	dma_handle = vb2_dma_contig_plane_dma_addr(vb, 0);
> +	BUG_ON(!dma_handle);
>  	start = (cam->state == S_BUFWAIT) && !list_empty(&cam->buffers);
> +
> +	if (cam->pix_format.pixelformat == V4L2_PIX_FMT_YUV422P) {

Better use a "switch."

> +		mvb->yuv_p.y = dma_handle;
> +		mvb->yuv_p.u = mvb->yuv_p.y + base_size;
> +		mvb->yuv_p.v = mvb->yuv_p.u + base_size / 2;
> +	} else if (cam->pix_format.pixelformat == V4L2_PIX_FMT_YUV420) {
> +		mvb->yuv_p.y = dma_handle;
> +		mvb->yuv_p.u = mvb->yuv_p.y + base_size;
> +		mvb->yuv_p.v = mvb->yuv_p.u + base_size / 4;
> +	} else if (cam->pix_format.pixelformat == V4L2_PIX_FMT_YVU420) {
> +		mvb->yuv_p.y = dma_handle;
> +		mvb->yuv_p.v = mvb->yuv_p.y + base_size;
> +		mvb->yuv_p.u = mvb->yuv_p.v + base_size / 4;
> +	} else
> +		mvb->yuv_p.y = dma_handle;
> +
>  	list_add(&mvb->queue, &cam->buffers);
>  	if (cam->state == S_STREAMING && test_bit(CF_SG_RESTART, &cam->flags))
>  		mcam_sg_restart(cam);
> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
> index 40368f6..3f75d7d 100755
> --- a/drivers/media/platform/marvell-ccic/mcam-core.h
> +++ b/drivers/media/platform/marvell-ccic/mcam-core.h
> @@ -233,6 +233,12 @@ int mccic_resume(struct mcam_camera *cam);
>  #define REG_Y0BAR	0x00
>  #define REG_Y1BAR	0x04
>  #define REG_Y2BAR	0x08
> +#define REG_U0BAR	0x0c
> +#define REG_U1BAR	0x10
> +#define REG_U2BAR	0x14
> +#define REG_V0BAR	0x18
> +#define REG_V1BAR	0x1C
> +#define REG_V2BAR	0x20
>  
>  /*
>   * register definitions for MIPI support
> -- 
> 1.7.9.5

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
