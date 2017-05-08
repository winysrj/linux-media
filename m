Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:57931 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751727AbdEHJlx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 May 2017 05:41:53 -0400
Message-ID: <1494236507.3029.69.camel@pengutronix.de>
Subject: Re: [PATCH 40/40] media: imx: set and propagate empty field,
 colorimetry params
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: gregkh@linuxfoundation.org, mchehab@kernel.org,
        rmk+kernel@armlinux.org.uk, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Mon, 08 May 2017 11:41:47 +0200
In-Reply-To: <1492044337-11324-1-git-send-email-steve_longerbeam@mentor.com>
References: <7d836723-dc01-2cea-f794-901b632ce46e@gmail.com>
         <1492044337-11324-1-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Wed, 2017-04-12 at 17:45 -0700, Steve Longerbeam wrote:
> This patch adds a call to imx_media_fill_empty_mbus_fields() in the
> *_try_fmt() functions at the sink pads, to set empty field order and
> colorimetry parameters.
> 
> If the field order is set to ANY, choose the currently set field order
> at the sink pad. If the colorspace is set to DEFAULT, choose the
> current colorspace at the sink pad.  If any of xfer_func, ycbcr_enc
> or quantization are set to DEFAULT, either choose the current sink pad
> setting, or the default setting for the new colorspace, if non-DEFAULT
> colorspace was given.
> 
> Colorimetry is also propagated from sink to source pads anywhere
> this has not already been done. The exception is ic-prpencvf at the
> source pad, since the Image Converter outputs fixed quantization and
> Y`CbCr encoding.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/staging/media/imx/imx-ic-prp.c      |  5 ++-
>  drivers/staging/media/imx/imx-ic-prpencvf.c | 25 +++++++++++---
>  drivers/staging/media/imx/imx-media-csi.c   | 12 +++++--
>  drivers/staging/media/imx/imx-media-utils.c | 53 +++++++++++++++++++++++++++++
>  drivers/staging/media/imx/imx-media-vdic.c  |  7 ++--
>  drivers/staging/media/imx/imx-media.h       |  3 +-
>  6 files changed, 95 insertions(+), 10 deletions(-)
> 
[...]
> diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
> index 7b2f92d..b07d0ae 100644
> --- a/drivers/staging/media/imx/imx-media-utils.c
> +++ b/drivers/staging/media/imx/imx-media-utils.c
> @@ -464,6 +464,59 @@ int imx_media_init_mbus_fmt(struct v4l2_mbus_framefmt *mbus,
>  }
>  EXPORT_SYMBOL_GPL(imx_media_init_mbus_fmt);
>  
> +/*
> + * Check whether the field or colorimetry params in tryfmt are
> + * uninitialized, and if so fill them with the values from fmt.
> + * The exception is when tryfmt->colorspace has been initialized,
> + * if so all the further default colorimetry params can be derived
> + * from tryfmt->colorspace.
> + */
> +void imx_media_fill_empty_mbus_fields(struct v4l2_mbus_framefmt *tryfmt,
> +				      struct v4l2_mbus_framefmt *fmt)
> +{
> +	/* fill field if necessary */
> +	if (tryfmt->field == V4L2_FIELD_ANY)
> +		tryfmt->field = fmt->field;
> +
> +	/* fill colorimetry if necessary */
> +	if (tryfmt->colorspace == V4L2_COLORSPACE_DEFAULT) {
> +		tryfmt->colorspace = fmt->colorspace;
> +		if (tryfmt->xfer_func == V4L2_XFER_FUNC_DEFAULT)
> +			tryfmt->xfer_func = fmt->xfer_func;
> +		if (tryfmt->ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT)
> +			tryfmt->ycbcr_enc = fmt->ycbcr_enc;
> +		if (tryfmt->quantization == V4L2_QUANTIZATION_DEFAULT)
> +			tryfmt->quantization = fmt->quantization;

According to Hans' latest comments, this could be changed to:

----------8<----------
>From cca3cda9effcaca0891eb8044a79137023fed1c2 Mon Sep 17 00:00:00 2001
From: Philipp Zabel <p.zabel@pengutronix.de>
Date: Mon, 8 May 2017 11:38:05 +0200
Subject: [PATCH] fixup! media: imx: set and propagate default field,
 colorimetry

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/media/imx/imx-media-utils.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
index a8766489e8a18..ec2abd618cc44 100644
--- a/drivers/staging/media/imx/imx-media-utils.c
+++ b/drivers/staging/media/imx/imx-media-utils.c
@@ -497,12 +497,9 @@ void imx_media_fill_default_mbus_fields(struct v4l2_mbus_framefmt *tryfmt,
 	/* fill colorimetry if necessary */
 	if (tryfmt->colorspace == V4L2_COLORSPACE_DEFAULT) {
 		tryfmt->colorspace = fmt->colorspace;
-		if (tryfmt->xfer_func == V4L2_XFER_FUNC_DEFAULT)
-			tryfmt->xfer_func = fmt->xfer_func;
-		if (tryfmt->ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT)
-			tryfmt->ycbcr_enc = fmt->ycbcr_enc;
-		if (tryfmt->quantization == V4L2_QUANTIZATION_DEFAULT)
-			tryfmt->quantization = fmt->quantization;
+		tryfmt->xfer_func = fmt->xfer_func;
+		tryfmt->ycbcr_enc = fmt->ycbcr_enc;
+		tryfmt->quantization = fmt->quantization;
 	} else {
 		if (tryfmt->xfer_func == V4L2_XFER_FUNC_DEFAULT) {
 			tryfmt->xfer_func =
-- 
2.11.0
---------->8----------

> +	} else {
> +		const struct imx_media_pixfmt *cc;
> +		bool is_rgb = false;
> +
> +		cc = imx_media_find_mbus_format(tryfmt->code,
> +						CS_SEL_ANY, false);
> +		if (!cc)
> +			cc = imx_media_find_ipu_format(tryfmt->code,
> +						       CS_SEL_ANY);
> +		if (cc && cc->cs != IPUV3_COLORSPACE_YUV)
> +			is_rgb = true;
> +
> +		if (tryfmt->xfer_func == V4L2_XFER_FUNC_DEFAULT) {
> +			tryfmt->xfer_func =
> +				V4L2_MAP_XFER_FUNC_DEFAULT(tryfmt->colorspace);
> +		}
> +		if (tryfmt->ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT) {
> +			tryfmt->ycbcr_enc =
> +				V4L2_MAP_YCBCR_ENC_DEFAULT(tryfmt->colorspace);
> +		}
> +		if (tryfmt->quantization == V4L2_QUANTIZATION_DEFAULT) {
> +			tryfmt->quantization =
> +				V4L2_MAP_QUANTIZATION_DEFAULT(
> +					is_rgb, tryfmt->colorspace,
> +					tryfmt->ycbcr_enc);
> +		}
> +	}

I'm not sure about removing this part yet.

regards
Philipp
