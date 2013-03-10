Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:44489 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab3CJUjm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Mar 2013 16:39:42 -0400
Message-ID: <513CEF88.3070409@gmail.com>
Date: Sun, 10 Mar 2013 21:39:36 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
CC: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, s.nawrocki@samsung.com,
	shaik.samsung@gmail.com
Subject: Re: [RFC 03/12] media: fimc-lite: Adding support for Exynos5
References: <1362570838-4737-1-git-send-email-shaik.ameer@samsung.com> <1362570838-4737-4-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1362570838-4737-4-git-send-email-shaik.ameer@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/06/2013 12:53 PM, Shaik Ameer Basha wrote:
> This patch adds the following functionalities to existing driver
>
> 1] FIMC-LITE supports multiple DMA shadow registers from Exynos5 onwards.
> This patch adds the functionality of using shadow registers by
> checking the current FIMC-LITE hardware version.
> 2] Fixes Buffer corruption on DMA output from fimc-lite
> 3] Modified the driver to be used as pipeline endpoint

There seems to be too many things done in this single patch. Can
we have it split for example to the parts adding:
- registers definitions and hardware interface helpers
   for exynos5
- the DMA handling fix

So it is easier to apply it and test incrementally ?

> Signed-off-by: Shaik Ameer Basha<shaik.ameer@samsung.com>
> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
> ---
>   drivers/media/platform/s5p-fimc/fimc-lite-reg.c |   16 +-
>   drivers/media/platform/s5p-fimc/fimc-lite-reg.h |   41 ++++-
>   drivers/media/platform/s5p-fimc/fimc-lite.c     |  196 +++++++++++++++++++++--
>   drivers/media/platform/s5p-fimc/fimc-lite.h     |    3 +-
>   4 files changed, 236 insertions(+), 20 deletions(-)
...
>   void flite_hw_dump_regs(struct fimc_lite *dev, const char *label)
> diff --git a/drivers/media/platform/s5p-fimc/fimc-lite-reg.h b/drivers/media/platform/s5p-fimc/fimc-lite-reg.h
> index 0e34584..716df6c 100644
> --- a/drivers/media/platform/s5p-fimc/fimc-lite-reg.h
> +++ b/drivers/media/platform/s5p-fimc/fimc-lite-reg.h
> @@ -120,6 +120,10 @@
>   /* b0: 1 - camera B, 0 - camera A */
>   #define FLITE_REG_CIGENERAL_CAM_B		(1<<  0)
>
> +
> +#define FLITE_REG_CIFCNTSEQ			0x100
> +#define FLITE_REG_CIOSAN(x)			(0x200 + (4 * (x)))
> +
>   /* ----------------------------------------------------------------------------
>    * Function declarations
>    */
> @@ -143,8 +147,41 @@ void flite_hw_set_dma_window(struct fimc_lite *dev, struct flite_frame *f);
>   void flite_hw_set_test_pattern(struct fimc_lite *dev, bool on);
>   void flite_hw_dump_regs(struct fimc_lite *dev, const char *label);
>
> -static inline void flite_hw_set_output_addr(struct fimc_lite *dev, u32 paddr)
> +static inline void flite_hw_set_output_addr(struct fimc_lite *dev,
> +	u32 paddr, u32 index)
> +{
> +	u32 config;
> +
> +	/* FLITE in EXYNOS4 has only one DMA register */
> +	if (dev->variant->version == FLITE_VER_EXYNOS4)
> +		index = 0;
> +
> +	config = readl(dev->regs + FLITE_REG_CIFCNTSEQ);
> +	config |= 1<<  index;
> +	writel(config, dev->regs + FLITE_REG_CIFCNTSEQ);
> +
> +	if (index == 0)
> +		writel(paddr, dev->regs + FLITE_REG_CIOSA);
> +	else
> +		writel(paddr, dev->regs + FLITE_REG_CIOSAN(index-1));
> +}
> +
> +static inline void flite_hw_clear_output_addr(struct fimc_lite *dev, u32 index)
>   {
> -	writel(paddr, dev->regs + FLITE_REG_CIOSA);
> +	u32 config;
> +
> +	/* FLITE in EXYNOS4 has only one DMA register */
> +	if (dev->variant->version == FLITE_VER_EXYNOS4)
> +		index = 0;

I'm planning to remove struct flite_variant and put everything what's
needed in the driver data structure. Are there any differences between
FIMC-LITE IP block instances or Exynos5250 ? Or are these all same ?

That said it seems better to me to add a field like out_dma_bufs to the
driver data structure and embed a pointer to this structure in struct
fimc_lite. The driver data matching would be done automatically, based
on the compatible property and those unpleasant checks
if (variant->version == FLITE_VER_EXYNOS4) ...

> +
> +	config = readl(dev->regs + FLITE_REG_CIFCNTSEQ);
> +	config&= ~(1<<  index);
> +	writel(config, dev->regs + FLITE_REG_CIFCNTSEQ);
>   }
> +
> +static inline void flite_hw_clear_output_index(struct fimc_lite *dev)
> +{
> +	writel(0, dev->regs + FLITE_REG_CIFCNTSEQ);
> +}
> +
>   #endif /* FIMC_LITE_REG_H */
> diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
> index eb64f87..1edc5ce 100644
> --- a/drivers/media/platform/s5p-fimc/fimc-lite.c
> +++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
> @@ -136,6 +136,8 @@ static int fimc_lite_hw_init(struct fimc_lite *fimc, bool isp_output)
>   	if (fimc->fmt == NULL)
>   		return -EINVAL;
>
> +	flite_hw_clear_output_index(fimc);
> +
>   	/* Get sensor configuration data from the sensor subdev */
>   	src_info = v4l2_get_subdev_hostdata(sensor);
>   	spin_lock_irqsave(&fimc->slock, flags);
> @@ -266,19 +268,24 @@ static irqreturn_t flite_irq_handler(int irq, void *priv)
>
>   	if ((intsrc&  FLITE_REG_CISTATUS_IRQ_SRC_FRMSTART)&&
>   	test_bit(ST_FLITE_RUN,&fimc->state)&&
> -	    !list_empty(&fimc->active_buf_q)&&
>   	!list_empty(&fimc->pending_buf_q)) {
> +		vbuf = fimc_lite_pending_queue_pop(fimc);
> +		flite_hw_set_output_addr(fimc, vbuf->paddr,
> +					vbuf->vb.v4l2_buf.index);
> +		fimc_lite_active_queue_add(fimc, vbuf);
> +	}
> +
> +	if ((intsrc&  FLITE_REG_CISTATUS_IRQ_SRC_FRMEND)&&
> +	    test_bit(ST_FLITE_RUN,&fimc->state)&&
> +	    !list_empty(&fimc->active_buf_q)) {
>   		vbuf = fimc_lite_active_queue_pop(fimc);
>   		ktime_get_ts(&ts);
>   		tv =&vbuf->vb.v4l2_buf.timestamp;
>   		tv->tv_sec = ts.tv_sec;
>   		tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
>   		vbuf->vb.v4l2_buf.sequence = fimc->frame_count++;
> +		flite_hw_clear_output_addr(fimc, vbuf->vb.v4l2_buf.index);
>   		vb2_buffer_done(&vbuf->vb, VB2_BUF_STATE_DONE);
> -
> -		vbuf = fimc_lite_pending_queue_pop(fimc);
> -		flite_hw_set_output_addr(fimc, vbuf->paddr);
> -		fimc_lite_active_queue_add(fimc, vbuf);
>   	}
>
>   	if (test_bit(ST_FLITE_CONFIG,&fimc->state))
> @@ -406,7 +413,8 @@ static void buffer_queue(struct vb2_buffer *vb)
>   	if (!test_bit(ST_FLITE_SUSPENDED,&fimc->state)&&
>   	!test_bit(ST_FLITE_STREAM,&fimc->state)&&
>   	list_empty(&fimc->active_buf_q)) {
> -		flite_hw_set_output_addr(fimc, buf->paddr);
> +		flite_hw_set_output_addr(fimc, buf->paddr,
> +					buf->vb.v4l2_buf.index);
>   		fimc_lite_active_queue_add(fimc, buf);
>   	} else {
>   		fimc_lite_pending_queue_add(fimc, buf);
> @@ -646,7 +654,7 @@ static int fimc_vidioc_querycap_capture(struct file *file, void *priv,
>   	strlcpy(cap->driver, FIMC_LITE_DRV_NAME, sizeof(cap->driver));
>   	cap->bus_info[0] = 0;
>   	cap->card[0] = 0;
> -	cap->capabilities = V4L2_CAP_STREAMING;
> +	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE_MPLANE;
>   	return 0;
>   }
>
> @@ -725,13 +733,125 @@ static int fimc_lite_try_fmt_mplane(struct file *file, void *fh,
>   	return fimc_lite_try_fmt(fimc,&f->fmt.pix_mp, NULL);
>   }
>
> -static int fimc_lite_s_fmt_mplane(struct file *file, void *priv,
> -				  struct v4l2_format *f)
> +static struct media_entity *fimc_pipeline_get_head(struct media_entity *me)
>   {
> -	struct v4l2_pix_format_mplane *pixm =&f->fmt.pix_mp;
> -	struct fimc_lite *fimc = video_drvdata(file);
> +	struct media_pad *pad =&me->pads[0];
> +
> +	while (!(pad->flags&  MEDIA_PAD_FL_SOURCE)) {
> +		pad = media_entity_remote_source(pad);
> +		if (!pad)
> +			break;
> +		me = pad->entity;
> +		pad =&me->pads[0];
> +	}
> +
> +	return me;
> +}
> +
> +/**
> + * fimc_pipeline_try_format - negotiate and/or set formats at pipeline
> + *                            elements
> + * @ctx: FIMC capture context
> + * @tfmt: media bus format to try/set on subdevs
> + * @fmt_id: fimc pixel format id corresponding to returned @tfmt (output)
> + * @set: true to set format on subdevs, false to try only
> + */
> +static int fimc_pipeline_try_format(struct fimc_lite *fimc,
> +				    struct v4l2_mbus_framefmt *tfmt,
> +				    struct fimc_fmt **fmt_id,
> +				    bool set)
> +{
[...]
> +}
> +
> +
> +static int __fimc_lite_set_format(struct fimc_lite *fimc,
> +				     struct v4l2_format *f)
> +{
> +	struct v4l2_pix_format_mplane *pix_mp =&f->fmt.pix_mp;
>   	struct flite_frame *frame =&fimc->out_frame;
>   	const struct fimc_fmt *fmt = NULL;
> +	struct v4l2_mbus_framefmt mf;
> +	struct fimc_fmt *s_fmt = NULL;
>   	int ret;
>
>   	if (vb2_is_busy(&fimc->vb_queue))
> @@ -741,15 +861,59 @@ static int fimc_lite_s_fmt_mplane(struct file *file, void *priv,
>   	if (ret<  0)
>   		return ret;
>
> +	/* Reset cropping and set format at the camera interface input */
> +	if (!fimc->user_subdev_api) {
> +		fimc->inp_frame.f_width = pix_mp->width;
> +		fimc->inp_frame.f_height = pix_mp->height;
> +		fimc->inp_frame.rect.top = 0;
> +		fimc->inp_frame.rect.left = 0;
> +		fimc->inp_frame.rect.width = pix_mp->width;
> +		fimc->inp_frame.rect.height = pix_mp->height;
> +	}
> +
> +	/* Try to match format at the host and the sensor */
> +	if (!fimc->user_subdev_api) {
> +		mf.code   = fmt->mbus_code;
> +		mf.width  = pix_mp->width;
> +		mf.height = pix_mp->height;
> +		ret = fimc_pipeline_try_format(fimc,&mf,&s_fmt, true);
> +		if (ret)
> +			return ret;
> +
> +		pix_mp->width  = mf.width;
> +		pix_mp->height = mf.height;
> +	}
> +
>   	fimc->fmt = fmt;
> -	fimc->payload[0] = max((pixm->width * pixm->height * fmt->depth[0]) / 8,
> -			       pixm->plane_fmt[0].sizeimage);
> -	frame->f_width = pixm->width;
> -	frame->f_height = pixm->height;
> +	fimc->payload[0] = max((pix_mp->width * pix_mp->height *
> +			fmt->depth[0]) / 8, pix_mp->plane_fmt[0].sizeimage);
> +	frame->f_width = pix_mp->width;
> +	frame->f_height = pix_mp->height;
>
>   	return 0;
>   }
>
> +static int fimc_lite_s_fmt_mplane(struct file *file, void *priv,
> +				  struct v4l2_format *f)
> +{
> +	struct fimc_lite *fimc = video_drvdata(file);
> +	int ret;
> +
> +	exynos_pipeline_graph_lock(fimc->pipeline_ops,&fimc->pipeline);
> +	/*
> +	 * The graph is walked within __fimc_lite_set_format() to set
> +	 * the format at subdevs thus the graph mutex needs to be held at
> +	 * this point and acquired before the video mutex, to avoid  AB-BA
> +	 * deadlock when fimc_md_link_notify() is called by other thread.
> +	 * Ideally the graph walking and setting format at the whole pipeline
> +	 * should be removed from this driver and handled in userspace only.

You have copied this format setting code from fimc-capture.c, while I
would rather remove it from there as well. But it have to stay for
backward compatibility. Nevertheless on Exynos4x12 by default image
format on whole pipeline will not be set in kernel by the video capture
node driver, there is simply to many entities involved there and for
full flexibility format setting/negotiation at the whole pipeline needs
to be done by user space library. Or you can use media-ctl to configure
the formats at each subdev.


> --- a/drivers/media/platform/s5p-fimc/fimc-lite.h
> +++ b/drivers/media/platform/s5p-fimc/fimc-lite.h
> @@ -52,7 +52,6 @@ enum {
>   #define FLITE_VER_EXYNOS4	0
>   #define FLITE_VER_EXYNOS5	1
>
> -
>   struct flite_variant {
>   	unsigned short max_width;
>   	unsigned short max_height;
> @@ -175,6 +174,8 @@ struct fimc_lite {
>   	unsigned int		reqbufs_count;
>   	int			ref_count;
>
> +	bool			user_subdev_api;

No, please don't copy this. I don't really want to see that sysfs
workaround in other drivers.

--

Regards,
Sylwester
