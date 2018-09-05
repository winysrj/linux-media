Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:39787 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbeIERvO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Sep 2018 13:51:14 -0400
Message-ID: <1536153658.4084.7.camel@pengutronix.de>
Subject: Re: [PATCH v2 3/4] media: imx-pxp: add i.MX Pixel Pipeline driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Jacopo Mondi <jacopo@jmondi.org>,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Date: Wed, 05 Sep 2018 15:20:58 +0200
In-Reply-To: <b2968b6b-b6ab-dfbe-b51c-5c4e73786039@xs4all.nl>
References: <20180905100018.27556-1-p.zabel@pengutronix.de>
         <20180905100018.27556-4-p.zabel@pengutronix.de>
         <b2968b6b-b6ab-dfbe-b51c-5c4e73786039@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2018-09-05 at 14:50 +0200, Hans Verkuil wrote: 
[...]
> > +config VIDEO_IMX_PXP
> > +	tristate "i.MX Pixel Pipeline (PXP)"
> > +	depends on VIDEO_DEV && VIDEO_V4L2 && (ARCH_MXC || COMPILE_TEST)
> > +	select VIDEOBUF2_DMA_CONTIG
> > +	select V4L2_MEM2MEM_DEV
> > +	help
> > +	  The i.MX Pixel Pipeline is a memory-to-memory engine for scaling,
> > +          color space conversion, and rotation.
> 
> Weird indentation.

Huh, a tab got replaced with spaces.

[...]
> > +/* Per queue */
> > +#define MEM2MEM_DEF_NUM_BUFS	VIDEO_MAX_FRAME
> > +/* In bytes, per queue */
> > +#define MEM2MEM_VID_MEM_LIMIT	(16 * 1024 * 1024)
> 
> These two defines are now unused and can be removed.

Will be gone in v3.

[...]
> > +static enum v4l2_ycbcr_encoding pxp_default_ycbcr_enc(struct pxp_ctx *ctx)
> > +{
> > +	if (ctx->xfer_func)
> > +		return V4L2_MAP_YCBCR_ENC_DEFAULT(ctx->colorspace);
> > +	else
> > +		return V4L2_YCBCR_ENC_DEFAULT;
> > +}
> > +
> > +static enum v4l2_quantization
> > +pxp_default_quant(struct pxp_ctx *ctx, u32 pixelformat,
> > +		  enum v4l2_ycbcr_encoding ycbcr_enc)
> > +{
> > +	bool is_rgb = !pxp_v4l2_pix_fmt_is_yuv(pixelformat);
> > +
> > +	if (ctx->xfer_func)
> 
> Why check for xfer_func? (same question for the previous function)

That way if userspace sets
	V4L2_XFER_FUNC_DEFAULT
	V4L2_YCBCR_ENC_DEFAULT
	V4L2_QUANTIZATION_DEFAULT
on the output queue, it will get
	V4L2_XFER_FUNC_DEFAULT
	V4L2_YCBCR_ENC_DEFAULT
	V4L2_QUANTIZATION_DEFAULT
on the capture queue.

If userspace sets xfer_func explicitly, it will get the explicit default
ycbcr_enc and quantization values.

I think I did this to make v4l2-compliance at some point, but it could
be that the explicit output->capture colorimetry copy for RGB->RGB and
YUV->YUV conversions has me covered now.

[...]
> > +static int pxp_remove(struct platform_device *pdev)
> > +{
> > +	struct pxp_dev *dev = platform_get_drvdata(pdev);
> > +
> > +	writel(BM_PXP_CTRL_CLKGATE, dev->mmio + HW_PXP_CTRL_SET);
> > +	writel(BM_PXP_CTRL_SFTRST, dev->mmio + HW_PXP_CTRL_SET);
> > +
> > +	clk_disable_unprepare(dev->clk);
> > +
> > +	v4l2_info(&dev->v4l2_dev, "Removing " MEM2MEM_NAME);
> > +	v4l2_m2m_release(dev->m2m_dev);
> > +	video_unregister_device(&dev->vfd);
> 
> Swap these two lines: first unreg the device, Then call m2m_release.

Ok, thank you.

regards
Philipp
