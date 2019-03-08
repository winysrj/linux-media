Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 035DAC43381
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 11:46:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C28C320851
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 11:46:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfCHLqh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 06:46:37 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:37133 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbfCHLqg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2019 06:46:36 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1h2DxT-0001wN-3h; Fri, 08 Mar 2019 12:46:35 +0100
Message-ID: <1552045591.4009.4.camel@pengutronix.de>
Subject: Re: [PATCH v6 3/7] gpu: ipu-v3: ipu-ic: Fully describe colorspace
 conversions
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "open list:DRM DRIVERS FOR FREESCALE IMX" 
        <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>
Date:   Fri, 08 Mar 2019 12:46:31 +0100
In-Reply-To: <20190307233356.23748-4-slongerbeam@gmail.com>
References: <20190307233356.23748-1-slongerbeam@gmail.com>
         <20190307233356.23748-4-slongerbeam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, 2019-03-07 at 15:33 -0800, Steve Longerbeam wrote:
> Only providing the input and output RGB/YUV space to the IC task init
> functions is not sufficient. To fully characterize a colorspace
> conversion, the colorspace (chromaticities), Y'CbCr encoding standard,
> and quantization also need to be specified.
> 
> Define a 'struct ipu_ic_colorspace' that includes all the above, and pass
> the input and output ipu_ic_colorspace to the IC task init functions.
> 
> This allows to actually enforce the fact that the IC:
> 
> - can only encode to/from YUV full range (follow-up patch will remove
>   this restriction).
> - can only encode to/from RGB full range.
> - can only encode using BT.601 standard (follow-up patch will add
>   Rec.709 encoding support).
> - cannot convert colorspaces from input to output, the
>   input and output colorspace chromaticities must be the same.
> 
> The determination of the CSC coefficients based on the input/output
> colorspace parameters are moved to a new function calc_csc_coeffs(),
> called by init_csc().
> 
> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> ---
>  drivers/gpu/ipu-v3/ipu-ic.c                 | 136 +++++++++++++-------
>  drivers/gpu/ipu-v3/ipu-image-convert.c      |  27 ++--
>  drivers/staging/media/imx/imx-ic-prpencvf.c |  22 +++-
>  include/video/imx-ipu-v3.h                  |  37 +++++-
>  4 files changed, 154 insertions(+), 68 deletions(-)
> 
> diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
> index b63a2826b629..c4048c921801 100644
> --- a/drivers/gpu/ipu-v3/ipu-ic.c
> +++ b/drivers/gpu/ipu-v3/ipu-ic.c
> @@ -146,8 +146,10 @@ struct ipu_ic {
>  	const struct ic_task_regoffs *reg;
>  	const struct ic_task_bitfields *bit;
>  
> -	enum ipu_color_space in_cs, g_in_cs;
> -	enum ipu_color_space out_cs;
> +	struct ipu_ic_colorspace in_cs;
> +	struct ipu_ic_colorspace g_in_cs;
> +	struct ipu_ic_colorspace out_cs;
> +
>  	bool graphics;
>  	bool rotation;
>  	bool in_use;
> @@ -235,42 +237,83 @@ static const struct ic_encode_coeff ic_encode_ycbcr2rgb_601 = {
>  	.scale = 2,
>  };
>  
> +static int calc_csc_coeffs(struct ipu_ic_priv *priv,
> +			   struct ic_encode_coeff *coeff_out,
> +			   const struct ipu_ic_colorspace *in,
> +			   const struct ipu_ic_colorspace *out)
> +{
> +	bool inverse_encode;
> +
> +	if (in->colorspace != out->colorspace) {
> +		dev_err(priv->ipu->dev, "Cannot convert colorspaces\n");
> +		return -ENOTSUPP;
> +	}

I don't think this is useful enough to warrant having the colorspace
field in ipu_ic_colorspace. Let the caller make sure of this, same as
for xfer_func.

> +	if (out->enc != V4L2_YCBCR_ENC_601) {
> +		dev_err(priv->ipu->dev, "Only BT.601 encoding supported\n");
> +		return -ENOTSUPP;
> +	}

This is only important if out->cs is IPUV3_COLORSPACE_YUV, right? If the
output is RGB this field shouldn't matter.

> +
> +	if ((in->cs == IPUV3_COLORSPACE_YUV &&
> +	     in->quant != V4L2_QUANTIZATION_FULL_RANGE) ||
> +	    (out->cs == IPUV3_COLORSPACE_YUV &&
> +	     out->quant != V4L2_QUANTIZATION_FULL_RANGE)) {
> +		dev_err(priv->ipu->dev, "Limited range YUV not supported\n");
> +		return -ENOTSUPP;
> +	}
> +
> +	if ((in->cs == IPUV3_COLORSPACE_RGB &&
> +	     in->quant != V4L2_QUANTIZATION_FULL_RANGE) ||
> +	    (out->cs == IPUV3_COLORSPACE_RGB &&
> +	     out->quant != V4L2_QUANTIZATION_FULL_RANGE)) {
> +		dev_err(priv->ipu->dev, "Limited range RGB not supported\n");
> +		return -ENOTSUPP;
> +	}
> +
> +	if (in->cs == out->cs) {
> +		*coeff_out = ic_encode_identity;
> +
> +		return 0;
> +	}
> +
> +	inverse_encode = (in->cs == IPUV3_COLORSPACE_YUV);

What does inverse_encode mean in this context?

> +
> +	*coeff_out = inverse_encode ?
> +		ic_encode_ycbcr2rgb_601 : ic_encode_rgb2ycbcr_601;
> +
> +	return 0;
> +}
> +
>  static int init_csc(struct ipu_ic *ic,
> -		    enum ipu_color_space inf,
> -		    enum ipu_color_space outf,
> +		    const struct ipu_ic_colorspace *in,
> +		    const struct ipu_ic_colorspace *out,
>  		    int csc_index)
>  {
>  	struct ipu_ic_priv *priv = ic->priv;
> -	const struct ic_encode_coeff *coeff;
> +	struct ic_encode_coeff coeff;

I understand this is a preparation for patch 5, but on its own this
introduces an unnecessary copy.

>  	u32 __iomem *base;
>  	const u16 (*c)[3];
>  	const u16 *a;
>  	u32 param;
> +	int ret;
> +
> +	ret = calc_csc_coeffs(priv, &coeff, in, out);
> +	if (ret)
> +		return ret;
>  
>  	base = (u32 __iomem *)
>  		(priv->tpmem_base + ic->reg->tpmem_csc[csc_index]);
>  
> -	if (inf == IPUV3_COLORSPACE_YUV && outf == IPUV3_COLORSPACE_RGB)
> -		coeff = &ic_encode_ycbcr2rgb_601;
> -	else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_YUV)
> -		coeff = &ic_encode_rgb2ycbcr_601;
> -	else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_RGB)
> -		coeff = &ic_encode_identity;
> -	else {
> -		dev_err(priv->ipu->dev, "Unsupported color space conversion\n");
> -		return -EINVAL;
> -	}
> -
>  	/* Cast to unsigned */
> -	c = (const u16 (*)[3])coeff->coeff;
> -	a = (const u16 *)coeff->offset;
> +	c = (const u16 (*)[3])coeff.coeff;
> +	a = (const u16 *)coeff.offset;
>  
>  	param = ((a[0] & 0x1f) << 27) | ((c[0][0] & 0x1ff) << 18) |
>  		((c[1][1] & 0x1ff) << 9) | (c[2][2] & 0x1ff);
>  	writel(param, base++);
>  
> -	param = ((a[0] & 0x1fe0) >> 5) | (coeff->scale << 8) |
> -		(coeff->sat << 10);
> +	param = ((a[0] & 0x1fe0) >> 5) | (coeff.scale << 8) |
> +		(coeff.sat << 10);
>  	writel(param, base++);
>  
>  	param = ((a[1] & 0x1f) << 27) | ((c[0][1] & 0x1ff) << 18) |
> @@ -357,14 +400,14 @@ void ipu_ic_task_enable(struct ipu_ic *ic)
>  	if (ic->rotation)
>  		ic_conf |= ic->bit->ic_conf_rot_en;
>  
> -	if (ic->in_cs != ic->out_cs)
> +	if (ic->in_cs.cs != ic->out_cs.cs)
>  		ic_conf |= ic->bit->ic_conf_csc1_en;
>  
>  	if (ic->graphics) {
>  		ic_conf |= ic->bit->ic_conf_cmb_en;
>  		ic_conf |= ic->bit->ic_conf_csc1_en;
>  
> -		if (ic->g_in_cs != ic->out_cs)
> +		if (ic->g_in_cs.cs != ic->out_cs.cs)
>  			ic_conf |= ic->bit->ic_conf_csc2_en;
>  	}
>  
> @@ -399,7 +442,7 @@ void ipu_ic_task_disable(struct ipu_ic *ic)
>  EXPORT_SYMBOL_GPL(ipu_ic_task_disable);
>  
>  int ipu_ic_task_graphics_init(struct ipu_ic *ic,
> -			      enum ipu_color_space in_g_cs,
> +			      const struct ipu_ic_colorspace *g_in_cs,

What made you decide not to expose the task parameter structure?

I was hoping we could eventually move the V4L2 colorimetry settings to
conversion matrix translation into imx-media.

Btw, do you have any plans for using IC composition?
ipu_ic_task_graphics_init() is currently unused...

>  			      bool galpha_en, u32 galpha,
>  			      bool colorkey_en, u32 colorkey)
>  {
> @@ -416,20 +459,25 @@ int ipu_ic_task_graphics_init(struct ipu_ic *ic,
>  	ic_conf = ipu_ic_read(ic, IC_CONF);
>  
>  	if (!(ic_conf & ic->bit->ic_conf_csc1_en)) {
> +		struct ipu_ic_colorspace rgb_cs;
> +
> +		ipu_ic_fill_colorspace(&rgb_cs,
> +				       V4L2_COLORSPACE_SRGB,
> +				       V4L2_YCBCR_ENC_601,
> +				       V4L2_QUANTIZATION_FULL_RANGE,
> +				       IPUV3_COLORSPACE_RGB);
> +
>  		/* need transparent CSC1 conversion */
> -		ret = init_csc(ic, IPUV3_COLORSPACE_RGB,
> -			       IPUV3_COLORSPACE_RGB, 0);
> +		ret = init_csc(ic, &rgb_cs, &rgb_cs, 0);
>  		if (ret)
>  			goto unlock;
>  	}
>  
> -	ic->g_in_cs = in_g_cs;
> +	ic->g_in_cs = *g_in_cs;
>  
> -	if (ic->g_in_cs != ic->out_cs) {
> -		ret = init_csc(ic, ic->g_in_cs, ic->out_cs, 1);
> -		if (ret)
> -			goto unlock;
> -	}
> +	ret = init_csc(ic, &ic->g_in_cs, &ic->out_cs, 1);
> +	if (ret)
> +		goto unlock;

I had to look twice, but this is fine. If ic->g_in_cs == ic->out_cs,
ipu_ic_task_enable() won't enable CSC2 in IC_CONF, and these TPMEM
values will be ignored.

>  
>  	if (galpha_en) {
>  		ic_conf |= IC_CONF_IC_GLB_LOC_A;
> @@ -456,10 +504,10 @@ int ipu_ic_task_graphics_init(struct ipu_ic *ic,
>  EXPORT_SYMBOL_GPL(ipu_ic_task_graphics_init);
>  
>  int ipu_ic_task_init_rsc(struct ipu_ic *ic,
> +			 const struct ipu_ic_colorspace *in_cs,
> +			 const struct ipu_ic_colorspace *out_cs,
>  			 int in_width, int in_height,
>  			 int out_width, int out_height,
> -			 enum ipu_color_space in_cs,
> -			 enum ipu_color_space out_cs,
>  			 u32 rsc)
>  {
>  	struct ipu_ic_priv *priv = ic->priv;
> @@ -491,28 +539,24 @@ int ipu_ic_task_init_rsc(struct ipu_ic *ic,
>  	ipu_ic_write(ic, rsc, ic->reg->rsc);
>  
>  	/* Setup color space conversion */
> -	ic->in_cs = in_cs;
> -	ic->out_cs = out_cs;
> +	ic->in_cs = *in_cs;
> +	ic->out_cs = *out_cs;
>  
> -	if (ic->in_cs != ic->out_cs) {
> -		ret = init_csc(ic, ic->in_cs, ic->out_cs, 0);
> -		if (ret)
> -			goto unlock;
> -	}
> +	ret = init_csc(ic, &ic->in_cs, &ic->out_cs, 0);

Same as above for CSC1.
 
> -unlock:
>  	spin_unlock_irqrestore(&priv->lock, flags);
>  	return ret;
>  }
>  
>  int ipu_ic_task_init(struct ipu_ic *ic,
> +		     const struct ipu_ic_colorspace *in_cs,
> +		     const struct ipu_ic_colorspace *out_cs,
>  		     int in_width, int in_height,
> -		     int out_width, int out_height,
> -		     enum ipu_color_space in_cs,
> -		     enum ipu_color_space out_cs)
> +		     int out_width, int out_height)
>  {
> -	return ipu_ic_task_init_rsc(ic, in_width, in_height, out_width,
> -				    out_height, in_cs, out_cs, 0);
> +	return ipu_ic_task_init_rsc(ic, in_cs, out_cs,
> +				    in_width, in_height,
> +				    out_width, out_height, 0);
>  }
>  EXPORT_SYMBOL_GPL(ipu_ic_task_init);
>  
> diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
> index 13103ab86050..ccbc8f4d95d7 100644
> --- a/drivers/gpu/ipu-v3/ipu-image-convert.c
> +++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
> @@ -1317,7 +1317,7 @@ static int convert_start(struct ipu_image_convert_run *run, unsigned int tile)
>  	struct ipu_image_convert_priv *priv = chan->priv;
>  	struct ipu_image_convert_image *s_image = &ctx->in;
>  	struct ipu_image_convert_image *d_image = &ctx->out;
> -	enum ipu_color_space src_cs, dest_cs;
> +	struct ipu_ic_colorspace src_cs, dest_cs;
>  	unsigned int dst_tile = ctx->out_tile_map[tile];
>  	unsigned int dest_width, dest_height;
>  	unsigned int col, row;
> @@ -1327,8 +1327,16 @@ static int convert_start(struct ipu_image_convert_run *run, unsigned int tile)
>  	dev_dbg(priv->ipu->dev, "%s: task %u: starting ctx %p run %p tile %u -> %u\n",
>  		__func__, chan->ic_task, ctx, run, tile, dst_tile);
>  
> -	src_cs = ipu_pixelformat_to_colorspace(s_image->fmt->fourcc);
> -	dest_cs = ipu_pixelformat_to_colorspace(d_image->fmt->fourcc);
> +	ipu_ic_fill_colorspace(&src_cs,
> +			s_image->base.pix.colorspace,
> +			s_image->base.pix.ycbcr_enc,
> +			s_image->base.pix.quantization,
> +			ipu_pixelformat_to_colorspace(s_image->fmt->fourcc));
> +	ipu_ic_fill_colorspace(&dest_cs,
> +			d_image->base.pix.colorspace,
> +			d_image->base.pix.ycbcr_enc,
> +			d_image->base.pix.quantization,
> +			ipu_pixelformat_to_colorspace(d_image->fmt->fourcc));

If ipu_ic_task_init(_rsc) could be passed the task parameter structure,
it could be calculated once in ipu_image_convert_prepare and stored in
ipu_image_convert_ctx for repeated use.

regards
Philipp
