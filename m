Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:49701 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725949AbeICTN2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2018 15:13:28 -0400
Message-ID: <1535986375.6568.5.camel@pengutronix.de>
Subject: Re: [PATCH 3/3] media: imx-pxp: add i.MX Pixel Pipeline driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        kernel@pengutronix.de, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Date: Mon, 03 Sep 2018 16:52:55 +0200
In-Reply-To: <966eb039-d850-75f0-5a65-56dae142aec5@xs4all.nl>
References: <20180810151822.18650-1-p.zabel@pengutronix.de>
         <20180810151822.18650-4-p.zabel@pengutronix.de>
         <966eb039-d850-75f0-5a65-56dae142aec5@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, 2018-09-03 at 14:55 +0200, Hans Verkuil wrote:
> Hi Philipp,
> 
> Apologies for the delay, but the Request API took most of my time.

Understandable. Also, I expect I'll profit from that work when adding
CODA960 JPEG support. So I have no reason to complain.

> But I finally got around to it:
>
> On 08/10/2018 05:18 PM, Philipp Zabel wrote:
> > Add a V4L2 mem-to-mem scaler/CSC driver for the Pixel Pipeline (PXP)
> > version found on i.MX6ULL SoCs. A similar variant is used on i.MX7D.
> > 
> > Since this driver only uses the legacy pipeline, it should be reasonably
> > easy to extend it to work with the older PXP versions found on i.MX6UL,
> > i.MX6SX, i.MX6SL, i.MX28, and i.MX23.
> > 
> > The driver supports scaling and colorspace conversion. There is
> > currently no support for rotation, alpha-blending, and the LUTs.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  drivers/media/platform/Kconfig   |    9 +
> >  drivers/media/platform/Makefile  |    2 +
> >  drivers/media/platform/imx-pxp.c | 1455 ++++++++++++++++++++++++++
> >  drivers/media/platform/imx-pxp.h | 1685 ++++++++++++++++++++++++++++++
> 
> Missing MAINTAINERS entry.

I'll add one for v2.

[...]
> > +static void pxp_setup_csc(struct pxp_ctx *ctx)
> > +{
> > +	struct pxp_dev *dev = ctx->dev;
> > +
> > +	if (pxp_v4l2_pix_fmt_is_yuv(ctx->q_data[V4L2_M2M_SRC].fmt->fourcc) &&
> > +	    !pxp_v4l2_pix_fmt_is_yuv(ctx->q_data[V4L2_M2M_DST].fmt->fourcc)) {
[...]
> > +		if (ctx->ycbcr_enc == V4L2_YCBCR_ENC_601 &&
> > +		    ctx->quant == V4L2_QUANTIZATION_FULL_RANGE)
> > +			csc1_coef = csc1_coef_bt601_full;
> > +		else
> > +			csc1_coef = csc1_coef_bt601_lim;
> 
> This is weird: setting ycbcr_enc to V4L2_YCBCR_ENC_709 would result in
> limited range BT601.
> 
> > +
> > +		writel(csc1_coef[0], dev->mmio + HW_PXP_CSC1_COEF0);
> > +		writel(csc1_coef[1], dev->mmio + HW_PXP_CSC1_COEF1);
> > +		writel(csc1_coef[2], dev->mmio + HW_PXP_CSC1_COEF2);
> 
> No support for Rec. 709?

Will add coefficients for Rec. 709.

> > +	} else {
> > +		writel(BM_PXP_CSC1_COEF0_BYPASS, dev->mmio + HW_PXP_CSC1_COEF0);
> > +	}
> > +
> > +	if (!pxp_v4l2_pix_fmt_is_yuv(ctx->q_data[V4L2_M2M_SRC].fmt->fourcc) &&
> > +	    pxp_v4l2_pix_fmt_is_yuv(ctx->q_data[V4L2_M2M_DST].fmt->fourcc)) {
[...]
> > +		if (ctx->ycbcr_enc == V4L2_YCBCR_ENC_601 &&
> > +		    ctx->quant == V4L2_QUANTIZATION_FULL_RANGE) {
> 
> This makes no sense. ctx->ycbcr_enc and ctx->quant refer to the output queue,
> i.e. the RGB side. ycbcr_enc is ignored for RGB and quant is in practice always
> full range. While you can have limited range RGB as well, that's not however
> what you are trying to implement here.
>
> The problem is that you cannot at the moment specify what ycbcr_enc etc.
> format you want for the capture queue. See below for a link to an RFC to add
> support for this.

Right. I'll split ycbcr_enc and quantization into per-queue settings for
v2 and revive your RFC to allow configuring capture queue colorimetry.

[...]
> > +/*
> > + * video ioctls
> > + */
> > +static int vidioc_querycap(struct file *file, void *priv,
> > +			   struct v4l2_capability *cap)
> > +{
> > +	strncpy(cap->driver, MEM2MEM_NAME, sizeof(cap->driver) - 1);
> > +	strncpy(cap->card, MEM2MEM_NAME, sizeof(cap->card) - 1);
> 
> Use strlcpy.

Ok.

> > +	snprintf(cap->bus_info, sizeof(cap->bus_info),
> > +			"platform:%s", MEM2MEM_NAME);
> > +	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
> > +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> 
> Please set the device_caps field of video_device, and then you can drop
> these two lines since the core will fill this in for you.

Ok.

[...]
> > +static int vidioc_g_fmt(struct pxp_ctx *ctx, struct v4l2_format *f)
> > +{
> > +	struct vb2_queue *vq;
> > +	struct pxp_q_data *q_data;
> > +
> > +	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
> > +	if (!vq)
> > +		return -EINVAL;
> > +
> > +	q_data = get_q_data(ctx, f->type);
> > +
> > +	f->fmt.pix.width	= q_data->width;
> > +	f->fmt.pix.height	= q_data->height;
> > +	f->fmt.pix.field	= V4L2_FIELD_NONE;
> > +	f->fmt.pix.pixelformat	= q_data->fmt->fourcc;
> > +	f->fmt.pix.bytesperline	= q_data->bytesperline;
> > +	f->fmt.pix.sizeimage	= q_data->sizeimage;
> > +	f->fmt.pix.colorspace	= ctx->colorspace;
> > +	f->fmt.pix.xfer_func	= ctx->xfer_func;
> > +	f->fmt.pix.ycbcr_enc	= ctx->ycbcr_enc;
> > +	f->fmt.pix.quantization	= ctx->quant;
> 
> Since you do colorspace conversion, these can't be the same for
> both output and capture.
> 
> colorspace and xfer_func will be the same (those are not converted),
> but ycbcr_enc should be set to 0 for RGB and quantization range
> will be different as well (either set to 0 for capture, or set
> to FULL for RGB capture and LIMITED for YUV).
> 
> Please note that it is not possible at the moment to request
> different values for these four field when capturing: they are currently
> set by the driver, and userspace cann't request something else.
>
> There is an old RFC to add support for this:
> 
> https://patchwork.linuxtv.org/patch/28847/
> 
> This driver might be a good opportunity to resurrect this RFC patch.

Yes, I'll fix these to defaults for v2 and add a new patch to enable
capture colorimetry configuration as per this RFC on top.

[...]
> > +static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
> > +				  struct v4l2_format *f)
> > +{
> > +	struct pxp_fmt *fmt;
> > +	struct pxp_ctx *ctx = file2ctx(file);
> > +
> > +	fmt = find_format(f);
> > +	if (!fmt) {
> > +		f->fmt.pix.pixelformat = formats[0].fourcc;
> > +		fmt = find_format(f);
> > +	}
> > +	if (!(fmt->types & MEM2MEM_OUTPUT)) {
> > +		v4l2_err(&ctx->dev->v4l2_dev,
> > +			 "Fourcc format (0x%08x) invalid.\n",
> > +			 f->fmt.pix.pixelformat);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (!f->fmt.pix.colorspace)
> > +		f->fmt.pix.colorspace = V4L2_COLORSPACE_REC709;
> 
> REC709 implies that ycbcr_enc also uses REC709. But you only support
> 601. To make this a practical driver you want to support both 601
> and 709.

Ack.

> Does this hardware also support gamma tables? Without it you can't
> convert between different transfer functions. Just curious if the hw
> can do this at all.

There is, but it is kind of useless for my purposes. It is located at
the end of the pipeline and can do RGB/YUV565 -> RGB/YUV565 lookups at
most (implemented as 16 KiB cache into a 128 KiB table in memory).
So no scaling/blending in linear space, and no useful conversion between
transfer functions.

[...]
> > +static int pxp_queue_setup(struct vb2_queue *vq,
> > +			   unsigned int *nbuffers, unsigned int *nplanes,
> > +			   unsigned int sizes[], struct device *alloc_devs[])
> > +{
> > +	struct pxp_ctx *ctx = vb2_get_drv_priv(vq);
> > +	struct pxp_q_data *q_data;
> > +	unsigned int size, count = *nbuffers;
> > +
> > +	q_data = get_q_data(ctx, vq->type);
> > +
> > +	size = q_data->sizeimage;
> > +
> > +	while (size * count > MEM2MEM_VID_MEM_LIMIT)
> > +		(count)--;
> 
> Why do this? It never made sense to me. If you try to allocate more memory then
> there is, you get -ENOMEM, which is just fine.
> 
> I'd drop this.

This is copied from vim2m. I'll remove it.

[...]
> > +static int pxp_probe(struct platform_device *pdev)
> > +{
[...]
> > +	/* Enable clocks and dump registers */
> > +	clk_prepare_enable(dev->clk);
> > +	pxp_soft_reset(dev);
> > +
> > +	spin_lock_init(&dev->irqlock);
> > +
> > +	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
> > +	if (ret)
> > +		return ret;
> > +
> > +	atomic_set(&dev->num_inst, 0);
> > +	mutex_init(&dev->dev_mutex);
> > +
> > +	dev->vfd = pxp_videodev;
> > +	vfd = &dev->vfd;
> > +	vfd->lock = &dev->dev_mutex;
> > +	vfd->v4l2_dev = &dev->v4l2_dev;
> > +
> > +	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
> 
> Please move this down until after v4l2_m2m_init: that should be done
> before you register the video device.

Yes, and I'll also fix the clock not being disabled on error. Thank you
for the review!

regards
Philipp
