Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35247 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751544AbdDMQkv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Apr 2017 12:40:51 -0400
Subject: Re: [PATCH 40/40] media: imx: set and propagate empty field,
 colorimetry params
To: Philipp Zabel <p.zabel@pengutronix.de>
References: <7d836723-dc01-2cea-f794-901b632ce46e@gmail.com>
 <1492044337-11324-1-git-send-email-steve_longerbeam@mentor.com>
 <1492078154.2383.21.camel@pengutronix.de>
Cc: gregkh@linuxfoundation.org, mchehab@kernel.org,
        rmk+kernel@armlinux.org.uk, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <3dc391ff-685e-8d76-1e9c-9725c397bee2@gmail.com>
Date: Thu, 13 Apr 2017 09:40:48 -0700
MIME-Version: 1.0
In-Reply-To: <1492078154.2383.21.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 04/13/2017 03:09 AM, Philipp Zabel wrote:
> Hi Steve,
>
> thanks for cleaning this up. Apart from the comments below, this looks
> good to me.
>
> On Wed, 2017-04-12 at 17:45 -0700, Steve Longerbeam wrote:
>> This patch adds a call to imx_media_fill_empty_mbus_fields() in the
>> *_try_fmt() functions at the sink pads, to set empty field order and
>> colorimetry parameters.
>>
>> If the field order is set to ANY, choose the currently set field order
>> at the sink pad. If the colorspace is set to DEFAULT, choose the
>> current colorspace at the sink pad.  If any of xfer_func, ycbcr_enc
>> or quantization are set to DEFAULT, either choose the current sink pad
>> setting, or the default setting for the new colorspace, if non-DEFAULT
>> colorspace was given.
>>
>> Colorimetry is also propagated from sink to source pads anywhere
>> this has not already been done. The exception is ic-prpencvf at the
>> source pad, since the Image Converter outputs fixed quantization and
>> Y`CbCr encoding.
>>
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>> ---
>>  drivers/staging/media/imx/imx-ic-prp.c      |  5 ++-
>>  drivers/staging/media/imx/imx-ic-prpencvf.c | 25 +++++++++++---
>>  drivers/staging/media/imx/imx-media-csi.c   | 12 +++++--
>>  drivers/staging/media/imx/imx-media-utils.c | 53 +++++++++++++++++++++++++++++
>>  drivers/staging/media/imx/imx-media-vdic.c  |  7 ++--
>>  drivers/staging/media/imx/imx-media.h       |  3 +-
>>  6 files changed, 95 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/staging/media/imx/imx-ic-prp.c b/drivers/staging/media/imx/imx-ic-prp.c
>> index b4d4e48..8baa0d5 100644
>> --- a/drivers/staging/media/imx/imx-ic-prp.c
>> +++ b/drivers/staging/media/imx/imx-ic-prp.c
>> @@ -180,6 +180,8 @@ static int prp_set_fmt(struct v4l2_subdev *sd,
>>  		goto out;
>>  	}
>>
>> +	fmt = __prp_get_fmt(priv, cfg, PRP_SINK_PAD, sdformat->which);
>> +
>
> Should this be changed to infmt for consistency?

sure, will do.

>
>>  	switch (sdformat->pad) {
>>  	case PRP_SINK_PAD:
>>  		v4l_bound_align_image(&sdformat->format.width, MIN_W, MAX_W,
>> @@ -193,11 +195,12 @@ static int prp_set_fmt(struct v4l2_subdev *sd,
>>  			cc = imx_media_find_ipu_format(code, CS_SEL_ANY);
>>  			sdformat->format.code = cc->codes[0];
>>  		}
>> +
>> +		imx_media_fill_empty_mbus_fields(&sdformat->format, fmt);
>>  		break;
>>  	case PRP_SRC_PAD_PRPENC:
>>  	case PRP_SRC_PAD_PRPVF:
>>  		/* Output pads mirror input pad */
>> -		fmt = __prp_get_fmt(priv, cfg, PRP_SINK_PAD, sdformat->which);
>>  		sdformat->format = *fmt;
>>  		break;
>>  	}
>> diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
>> index 860b406..cdfb51a 100644
>> --- a/drivers/staging/media/imx/imx-ic-prpencvf.c
>> +++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
>> @@ -772,6 +772,8 @@ static void prp_try_fmt(struct prp_priv *priv,
>>  			struct v4l2_subdev_format *sdformat,
>>  			const struct imx_media_pixfmt **cc)
>>  {
>> +	struct v4l2_mbus_framefmt *infmt;
>> +
>>  	*cc = imx_media_find_ipu_format(sdformat->format.code, CS_SEL_ANY);
>>  	if (!*cc) {
>>  		u32 code;
>> @@ -781,11 +783,9 @@ static void prp_try_fmt(struct prp_priv *priv,
>>  		sdformat->format.code = (*cc)->codes[0];
>>  	}
>>
>> -	if (sdformat->pad == PRPENCVF_SRC_PAD) {
>> -		struct v4l2_mbus_framefmt *infmt =
>> -			__prp_get_fmt(priv, cfg, PRPENCVF_SINK_PAD,
>> -				      sdformat->which);
>> +	infmt = __prp_get_fmt(priv, cfg, PRPENCVF_SINK_PAD, sdformat->which);
>>
>> +	if (sdformat->pad == PRPENCVF_SRC_PAD) {
>>  		if (sdformat->format.field != V4L2_FIELD_NONE)
>>  			sdformat->format.field = infmt->field;
>>
>> @@ -804,12 +804,29 @@ static void prp_try_fmt(struct prp_priv *priv,
>>  					      &sdformat->format.height,
>>  					      infmt->height / 4, MAX_H_SRC,
>>  					      H_ALIGN_SRC, S_ALIGN);
>> +
>> +		/*
>> +		 * The Image Converter produces fixed quantization
>> +		 * (full range for RGB, limited range for YUV), and
>> +		 * uses a fixed Y`CbCr encoding (V4L2_YCBCR_ENC_601).
>> +		 * For colorspace and transfer func, just propagate
>> +		 * from the sink.
>> +		 */
>> +		sdformat->format.quantization =
>> +			((*cc)->cs != IPUV3_COLORSPACE_YUV) ?
>> +			V4L2_QUANTIZATION_FULL_RANGE :
>> +			V4L2_QUANTIZATION_LIM_RANGE;
>> +		sdformat->format.ycbcr_enc = V4L2_YCBCR_ENC_601;
>
> Support for V4L2_YCBCR_ENC_709 and quantization options could be added
> to the IPUv3 core code, so this limitation could be relaxed later.

Yes, I was going to mention that too. We can add coefficient tables
to ipu-ic for all the encodings enumerated in enum v4l2_ycbcr_encoding.

I know that quantization is programmable in the DP, but is it in the
IC? AFAICT there is none.

>
>> +		sdformat->format.colorspace = infmt->colorspace;
>> +		sdformat->format.xfer_func = infmt->xfer_func;
>>  	} else {
>>  		v4l_bound_align_image(&sdformat->format.width,
>>  				      MIN_W_SINK, MAX_W_SINK, W_ALIGN_SINK,
>>  				      &sdformat->format.height,
>>  				      MIN_H_SINK, MAX_H_SINK, H_ALIGN_SINK,
>>  				      S_ALIGN);
>> +
>> +		imx_media_fill_empty_mbus_fields(&sdformat->format, infmt);
>
> So we should limit quantization and ycbcr_enc here as well. Right now
> there is no way to convert from limited range RGB to full range RGB, for
> example.

True, yes, I was scratching my head about that. I'll move the above to
apply to all pads.

>
>>  	}
>>  }
>>
>> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
>> index b11e80f..730d1aa 100644
>> --- a/drivers/staging/media/imx/imx-media-csi.c
>> +++ b/drivers/staging/media/imx/imx-media-csi.c
>> @@ -1220,11 +1220,11 @@ static void csi_try_fmt(struct csi_priv *priv,
>>  	struct v4l2_mbus_framefmt *infmt;
>>  	u32 code;
>>
>> +	infmt = __csi_get_fmt(priv, cfg, CSI_SINK_PAD, sdformat->which);
>> +
>>  	switch (sdformat->pad) {
>>  	case CSI_SRC_PAD_DIRECT:
>>  	case CSI_SRC_PAD_IDMAC:
>> -		infmt = __csi_get_fmt(priv, cfg, CSI_SINK_PAD,
>> -				      sdformat->which);
>>  		incc = imx_media_find_mbus_format(infmt->code,
>>  						  CS_SEL_ANY, true);
>>
>> @@ -1260,6 +1260,12 @@ static void csi_try_fmt(struct csi_priv *priv,
>>  			sdformat->format.field =  (infmt->height == 480) ?
>>  				V4L2_FIELD_SEQ_TB : V4L2_FIELD_SEQ_BT;
>>  		}
>> +
>> +		/* propagate colorimetry from sink */
>> +		sdformat->format.colorspace = infmt->colorspace;
>> +		sdformat->format.xfer_func = infmt->xfer_func;
>> +		sdformat->format.quantization = infmt->quantization;
>> +		sdformat->format.ycbcr_enc = infmt->ycbcr_enc;
>>  		break;
>>  	case CSI_SINK_PAD:
>>  		v4l_bound_align_image(&sdformat->format.width, MIN_W, MAX_W,
>> @@ -1286,6 +1292,8 @@ static void csi_try_fmt(struct csi_priv *priv,
>>  							CS_SEL_ANY, false);
>>  			sdformat->format.code = (*cc)->codes[0];
>>  		}
>> +
>> +		imx_media_fill_empty_mbus_fields(&sdformat->format, infmt);
>>  		break;
>>  	}
>>  }
>> diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
>> index 7b2f92d..b07d0ae 100644
>> --- a/drivers/staging/media/imx/imx-media-utils.c
>> +++ b/drivers/staging/media/imx/imx-media-utils.c
>> @@ -464,6 +464,59 @@ int imx_media_init_mbus_fmt(struct v4l2_mbus_framefmt *mbus,
>>  }
>>  EXPORT_SYMBOL_GPL(imx_media_init_mbus_fmt);
>>
>> +/*
>> + * Check whether the field or colorimetry params in tryfmt are
>> + * uninitialized, and if so fill them with the values from fmt.
>> + * The exception is when tryfmt->colorspace has been initialized,
>> + * if so all the further default colorimetry params can be derived
>> + * from tryfmt->colorspace.
>> + */
>> +void imx_media_fill_empty_mbus_fields(struct v4l2_mbus_framefmt *tryfmt,
>> +				      struct v4l2_mbus_framefmt *fmt)
>> +{
>> +	/* fill field if necessary */
>> +	if (tryfmt->field == V4L2_FIELD_ANY)
>> +		tryfmt->field = fmt->field;
>> +
>> +	/* fill colorimetry if necessary */
>> +	if (tryfmt->colorspace == V4L2_COLORSPACE_DEFAULT) {
>> +		tryfmt->colorspace = fmt->colorspace;
>> +		if (tryfmt->xfer_func == V4L2_XFER_FUNC_DEFAULT)
>> +			tryfmt->xfer_func = fmt->xfer_func;
>> +		if (tryfmt->ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT)
>> +			tryfmt->ycbcr_enc = fmt->ycbcr_enc;
>> +		if (tryfmt->quantization == V4L2_QUANTIZATION_DEFAULT)
>> +			tryfmt->quantization = fmt->quantization;
>> +	} else {
>> +		const struct imx_media_pixfmt *cc;
>> +		bool is_rgb = false;
>> +
>> +		cc = imx_media_find_mbus_format(tryfmt->code,
>> +						CS_SEL_ANY, false);
>> +		if (!cc)
>> +			cc = imx_media_find_ipu_format(tryfmt->code,
>> +						       CS_SEL_ANY);
>> +		if (cc && cc->cs != IPUV3_COLORSPACE_YUV)
>> +			is_rgb = true;
>> +
>> +		if (tryfmt->xfer_func == V4L2_XFER_FUNC_DEFAULT) {
>> +			tryfmt->xfer_func =
>> +				V4L2_MAP_XFER_FUNC_DEFAULT(tryfmt->colorspace);
>> +		}
>> +		if (tryfmt->ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT) {
>> +			tryfmt->ycbcr_enc =
>> +				V4L2_MAP_YCBCR_ENC_DEFAULT(tryfmt->colorspace);
>> +		}
>> +		if (tryfmt->quantization == V4L2_QUANTIZATION_DEFAULT) {
>> +			tryfmt->quantization =
>> +				V4L2_MAP_QUANTIZATION_DEFAULT(
>> +					is_rgb, tryfmt->colorspace,
>> +					tryfmt->ycbcr_enc);
>> +		}
>> +	}
>> +}
>> +EXPORT_SYMBOL_GPL(imx_media_fill_empty_mbus_fields);
>> +
>
> I'd s/empty/default/ in the function name.

sounds good.

>
> After we agree on and write down some guidelines on expected behaviour
> in the spec, this could be lifted into v4l2-core.

Agreed.

Steve
