Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:56852 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514Ab2K0QCV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 11:02:21 -0500
Date: Tue, 27 Nov 2012 17:02:14 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Albert Wang <twang13@marvell.com>
cc: corbet@lwn.net, linux-media@vger.kernel.org, lbyang@marvell.com
Subject: Re: [PATCH 14/15] [media] marvell-ccic: use unsigned int type replace
 int type
In-Reply-To: <1353677679-24443-1-git-send-email-twang13@marvell.com>
Message-ID: <Pine.LNX.4.64.1211271656580.22273@axis700.grange>
References: <1353677679-24443-1-git-send-email-twang13@marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 23 Nov 2012, Albert Wang wrote:

> This patch use unsigned int type replace int type in marvell-ccic.
> 
> These variables: frame number, buf number, irq... should be unsigned.

Several issues to be considered here:

* most these variables will never take values > INT_MAX, so, this isn't 
  very important
* sometimes it is convenient to use a variable, that normally should only 
  take positive values, to also check for negative values. These variables 
  should be signed.
* compile-time compatibility: if variables are used as arguments of 
  functions or are compared or assigned to other variables, their types 
  should be compatible.
* my "old" cross-compiler was hiding many such problems, I'm sure at 
  marvell you use new enough compilers to warn you about any such 
  issues:-)

So, mainly, just make sure you get no compiler warnings, otherwise it's 
not very important, IMHO.

Thanks
Guennadi

> 
> Signed-off-by: Albert Wang <twang13@marvell.com>
> ---
>  .../media/platform/marvell-ccic/mcam-core-soc.h    |    2 +-
>  .../platform/marvell-ccic/mcam-core-standard.h     |   10 ++++-----
>  drivers/media/platform/marvell-ccic/mcam-core.c    |   22 ++++++++++----------
>  drivers/media/platform/marvell-ccic/mcam-core.h    |    2 +-
>  drivers/media/platform/marvell-ccic/mmp-driver.c   |    2 +-
>  5 files changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/media/platform/marvell-ccic/mcam-core-soc.h b/drivers/media/platform/marvell-ccic/mcam-core-soc.h
> index a5b5fa6..bff8b2a 100644
> --- a/drivers/media/platform/marvell-ccic/mcam-core-soc.h
> +++ b/drivers/media/platform/marvell-ccic/mcam-core-soc.h
> @@ -11,7 +11,7 @@ extern const struct vb2_ops mcam_soc_vb2_ops;
>  
>  extern void mcam_ctlr_power_up(struct mcam_camera *cam);
>  extern void mcam_ctlr_power_down(struct mcam_camera *cam);
> -extern void mcam_dma_contig_done(struct mcam_camera *cam, int frame);
> +extern void mcam_dma_contig_done(struct mcam_camera *cam, unsigned int frame);
>  extern void mcam_ctlr_stop(struct mcam_camera *cam);
>  extern int mcam_config_mipi(struct mcam_camera *mcam, int enable);
>  extern void mcam_ctlr_image(struct mcam_camera *cam);
> diff --git a/drivers/media/platform/marvell-ccic/mcam-core-standard.h b/drivers/media/platform/marvell-ccic/mcam-core-standard.h
> index 148a1a1..090c1a2 100644
> --- a/drivers/media/platform/marvell-ccic/mcam-core-standard.h
> +++ b/drivers/media/platform/marvell-ccic/mcam-core-standard.h
> @@ -4,8 +4,8 @@
>   * Copyright 2011 Jonathan Corbet corbet@lwn.net
>   */
>  extern bool alloc_bufs_at_read;
> -extern int n_dma_bufs;
> -extern int buffer_mode;
> +extern unsigned int n_dma_bufs;
> +extern unsigned int buffer_mode;
>  extern const struct vb2_ops mcam_vb2_sg_ops;
>  extern const struct vb2_ops mcam_vb2_ops;
>  
> @@ -17,12 +17,12 @@ extern void mcam_ctlr_init(struct mcam_camera *cam);
>  extern int mcam_cam_init(struct mcam_camera *cam);
>  extern void mcam_free_dma_bufs(struct mcam_camera *cam);
>  extern void mcam_ctlr_dma_sg(struct mcam_camera *cam);
> -extern void mcam_dma_sg_done(struct mcam_camera *cam, int frame);
> +extern void mcam_dma_sg_done(struct mcam_camera *cam, unsigned int frame);
>  extern int mcam_check_dma_buffers(struct mcam_camera *cam);
>  extern void mcam_set_config_needed(struct mcam_camera *cam, int needed);
>  extern int __mcam_cam_reset(struct mcam_camera *cam);
>  extern int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime);
>  extern void mcam_ctlr_dma_contig(struct mcam_camera *cam);
> -extern void mcam_dma_contig_done(struct mcam_camera *cam, int frame);
> +extern void mcam_dma_contig_done(struct mcam_camera *cam, unsigned int frame);
>  extern void mcam_ctlr_dma_vmalloc(struct mcam_camera *cam);
> -extern void mcam_vmalloc_done(struct mcam_camera *cam, int frame);
> +extern void mcam_vmalloc_done(struct mcam_camera *cam, unsigned int frame);
> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
> index 3b05d8c..2d200d6 100755
> --- a/drivers/media/platform/marvell-ccic/mcam-core.c
> +++ b/drivers/media/platform/marvell-ccic/mcam-core.c
> @@ -111,7 +111,7 @@ static inline struct mcam_vb_buffer *vb_to_mvb(struct vb2_buffer *vb)
>  /*
>   * Hand a completed buffer back to user space.
>   */
> -static void mcam_buffer_done(struct mcam_camera *cam, int frame,
> +static void mcam_buffer_done(struct mcam_camera *cam, unsigned int frame,
>  		struct vb2_buffer *vbuf)
>  {
>  	vbuf->v4l2_buf.bytesused = cam->pix_format.sizeimage;
> @@ -125,7 +125,7 @@ static void mcam_buffer_done(struct mcam_camera *cam, int frame,
>   */
>  static void mcam_reset_buffers(struct mcam_camera *cam)
>  {
> -	int i;
> +	unsigned int i;
>  
>  	cam->next_buf = -1;
>  	for (i = 0; i < cam->nbufs; i++) {
> @@ -216,7 +216,7 @@ int mcam_config_mipi(struct mcam_camera *mcam, int enable)
>   */
>  int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime)
>  {
> -	int i;
> +	unsigned int i;
>  
>  	mcam_set_config_needed(cam, 1);
>  	if (loadtime)
> @@ -257,7 +257,7 @@ int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime)
>  
>  void mcam_free_dma_bufs(struct mcam_camera *cam)
>  {
> -	int i;
> +	unsigned int i;
>  
>  	for (i = 0; i < cam->nbufs; i++) {
>  		dma_free_coherent(cam->dev, cam->dma_buf_size,
> @@ -296,7 +296,7 @@ void mcam_ctlr_dma_vmalloc(struct mcam_camera *cam)
>  static void mcam_frame_tasklet(unsigned long data)
>  {
>  	struct mcam_camera *cam = (struct mcam_camera *) data;
> -	int i;
> +	unsigned int i;
>  	unsigned long flags;
>  	struct mcam_vb_buffer *buf;
>  
> @@ -344,7 +344,7 @@ int mcam_check_dma_buffers(struct mcam_camera *cam)
>  	return 0;
>  }
>  
> -void mcam_vmalloc_done(struct mcam_camera *cam, int frame)
> +void mcam_vmalloc_done(struct mcam_camera *cam, unsigned int frame)
>  {
>  	tasklet_schedule(&cam->s_tasklet);
>  }
> @@ -396,7 +396,7 @@ static bool mcam_fmt_is_planar(__u32 pfmt)
>   * space.  In this way, we always have a buffer to DMA to and don't
>   * have to try to play games stopping and restarting the controller.
>   */
> -static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
> +static void mcam_set_contig_buffer(struct mcam_camera *cam, unsigned int frame)
>  {
>  	struct mcam_vb_buffer *buf;
>  	struct v4l2_pix_format *fmt = &cam->pix_format;
> @@ -442,7 +442,7 @@ void mcam_ctlr_dma_contig(struct mcam_camera *cam)
>  /*
>   * Frame completion handling.
>   */
> -void mcam_dma_contig_done(struct mcam_camera *cam, int frame)
> +void mcam_dma_contig_done(struct mcam_camera *cam, unsigned int frame)
>  {
>  	struct mcam_vb_buffer *buf = cam->vb_bufs[frame];
>  
> @@ -518,7 +518,7 @@ void mcam_ctlr_dma_sg(struct mcam_camera *cam)
>   * safely change the DMA descriptor array here and restart things
>   * (assuming there's another buffer waiting to go).
>   */
> -void mcam_dma_sg_done(struct mcam_camera *cam, int frame)
> +void mcam_dma_sg_done(struct mcam_camera *cam, unsigned int frame)
>  {
>  	struct mcam_vb_buffer *buf = cam->vb_bufs[0];
>  
> @@ -935,7 +935,7 @@ static int mcam_vb_queue_setup(struct vb2_queue *vq,
>  		void *alloc_ctxs[])
>  {
>  	struct mcam_camera *cam = get_mcam(vq);
> -	int minbufs = (cam->buffer_mode == B_DMA_contig) ? 3 : 2;
> +	unsigned int minbufs = (cam->buffer_mode == B_DMA_contig) ? 3 : 2;
>  
>  	sizes[0] = cam->pix_format.sizeimage;
>  	*num_planes = 1; /* Someday we have to support planar formats... */
> @@ -1207,7 +1207,7 @@ const struct vb2_ops mcam_soc_vb2_ops = {
>  /*
>   * Interrupt handler stuff
>   */
> -static void mcam_frame_complete(struct mcam_camera *cam, int frame)
> +static void mcam_frame_complete(struct mcam_camera *cam, unsigned int frame)
>  {
>  	/*
>  	 * Basic frame housekeeping.
> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
> index 999b581..5b2cf6e 100755
> --- a/drivers/media/platform/marvell-ccic/mcam-core.h
> +++ b/drivers/media/platform/marvell-ccic/mcam-core.h
> @@ -197,7 +197,7 @@ struct mcam_camera {
>  
>  	/* Mode-specific ops, set at open time */
>  	void (*dma_setup)(struct mcam_camera *cam);
> -	void (*frame_complete)(struct mcam_camera *cam, int frame);
> +	void (*frame_complete)(struct mcam_camera *cam, unsigned int frame);
>  
>  	/* Current operating parameters */
>  	u32 sensor_type;		/* Currently ov7670 only */
> diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
> index e840941..9b631b7 100755
> --- a/drivers/media/platform/marvell-ccic/mmp-driver.c
> +++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
> @@ -52,7 +52,7 @@ struct mmp_camera {
>  	struct list_head devlist;
>  	/* will change here */
>  	struct clk *clk[3];	/* CCIC_GATE, CCIC_RST, CCIC_DBG clocks */
> -	int irq;
> +	unsigned int irq;
>  };
>  
>  static inline struct mmp_camera *mcam_to_cam(struct mcam_camera *mcam)
> -- 
> 1.7.9.5
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
