Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E858BC43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 15:29:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1400206C2
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 15:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404889AbfAPP3D (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 10:29:03 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:52700 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404853AbfAPP3C (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 10:29:02 -0500
Received: from [IPv6:2001:983:e9a7:1:89e8:8b49:35c9:423f] ([IPv6:2001:983:e9a7:1:89e8:8b49:35c9:423f])
        by smtp-cloud8.xs4all.net with ESMTPA
        id jn7igUv48NR5yjn7jgQ0gs; Wed, 16 Jan 2019 16:29:00 +0100
Subject: Re: [PATCH v3 2/3] media: imx: set compose rectangle to mbus format
To:     Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, kernel@pengutronix.de
References: <20190111111053.12551-1-p.zabel@pengutronix.de>
 <20190111111053.12551-2-p.zabel@pengutronix.de>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <25cf4f54-8e2d-1f73-9a6c-2cbdeee94ceb@xs4all.nl>
Date:   Wed, 16 Jan 2019 16:28:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190111111053.12551-2-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfFuqYN3PgCxSwXYwc2s+iAXR57ciJ+jtNuT5t/zmx1l9NK+928r8ym0B+atvYlcyGgjGElhxPUlc3Kz5Ctxc7nSN/voeo9+ru9YhsaspjIYNC317iERF
 VpucqLd7hmpehzxlPmFoa8+XkiP39m7xbU3VJwUZIc8F91dCNzD9LSAoPVhaJwkne5PRzJTuwp8tLpbLUdUqxMN/k7G4uRGfFiSHPnjEfU9LjC9PQtUd9dU2
 UbENtQYcguFj11PfC2y+uXWVZa2Z+AVs684xE6HtiL4qY2/JTYF9EOrpvmfeFiHixVOtzraFOXDY9QZBRdIClTDfpgWfZ8PJb7TKjyhABIOKaW6dXBUtuqDa
 VXsnAAQ7xDuirAECKVvMgDsASj9h5W1qrZnrPUMdFGcfeeP25U00IZ3t6NwNWQRyvSOnHW4H2Kh508vrp9MBotzx/TKBDA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/11/19 12:10 PM, Philipp Zabel wrote:
> Prepare for mbus format being smaller than the written rectangle
> due to burst size.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Reviewed-by: Steve Longerbeam <slongerbeam@gmail.com>
> ---
>  drivers/staging/media/imx/imx-media-capture.c | 56 +++++++++++++------
>  1 file changed, 38 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
> index fb985e68f9ab..614e335fb61c 100644
> --- a/drivers/staging/media/imx/imx-media-capture.c
> +++ b/drivers/staging/media/imx/imx-media-capture.c
> @@ -203,21 +203,13 @@ static int capture_g_fmt_vid_cap(struct file *file, void *fh,
>  	return 0;
>  }
>  
> -static int capture_try_fmt_vid_cap(struct file *file, void *fh,
> -				   struct v4l2_format *f)
> +static int __capture_try_fmt_vid_cap(struct capture_priv *priv,
> +				     struct v4l2_subdev_format *fmt_src,
> +				     struct v4l2_format *f)
>  {
> -	struct capture_priv *priv = video_drvdata(file);
> -	struct v4l2_subdev_format fmt_src;
>  	const struct imx_media_pixfmt *cc, *cc_src;
> -	int ret;
>  
> -	fmt_src.pad = priv->src_sd_pad;
> -	fmt_src.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> -	ret = v4l2_subdev_call(priv->src_sd, pad, get_fmt, NULL, &fmt_src);
> -	if (ret)
> -		return ret;
> -
> -	cc_src = imx_media_find_ipu_format(fmt_src.format.code, CS_SEL_ANY);
> +	cc_src = imx_media_find_ipu_format(fmt_src->format.code, CS_SEL_ANY);
>  	if (cc_src) {
>  		u32 fourcc, cs_sel;
>  
> @@ -231,7 +223,7 @@ static int capture_try_fmt_vid_cap(struct file *file, void *fh,
>  			cc = imx_media_find_format(fourcc, cs_sel, false);
>  		}
>  	} else {
> -		cc_src = imx_media_find_mbus_format(fmt_src.format.code,
> +		cc_src = imx_media_find_mbus_format(fmt_src->format.code,
>  						    CS_SEL_ANY, true);
>  		if (WARN_ON(!cc_src))
>  			return -EINVAL;
> @@ -239,15 +231,32 @@ static int capture_try_fmt_vid_cap(struct file *file, void *fh,
>  		cc = cc_src;
>  	}
>  
> -	imx_media_mbus_fmt_to_pix_fmt(&f->fmt.pix, &fmt_src.format, cc);
> +	imx_media_mbus_fmt_to_pix_fmt(&f->fmt.pix, &fmt_src->format, cc);
>  
>  	return 0;
>  }
>  
> +static int capture_try_fmt_vid_cap(struct file *file, void *fh,
> +				   struct v4l2_format *f)
> +{
> +	struct capture_priv *priv = video_drvdata(file);
> +	struct v4l2_subdev_format fmt_src;
> +	int ret;
> +
> +	fmt_src.pad = priv->src_sd_pad;
> +	fmt_src.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +	ret = v4l2_subdev_call(priv->src_sd, pad, get_fmt, NULL, &fmt_src);
> +	if (ret)
> +		return ret;
> +
> +	return __capture_try_fmt_vid_cap(priv, &fmt_src, f);
> +}
> +
>  static int capture_s_fmt_vid_cap(struct file *file, void *fh,
>  				 struct v4l2_format *f)
>  {
>  	struct capture_priv *priv = video_drvdata(file);
> +	struct v4l2_subdev_format fmt_src;
>  	int ret;
>  
>  	if (vb2_is_busy(&priv->q)) {
> @@ -255,7 +264,13 @@ static int capture_s_fmt_vid_cap(struct file *file, void *fh,
>  		return -EBUSY;
>  	}
>  
> -	ret = capture_try_fmt_vid_cap(file, priv, f);
> +	fmt_src.pad = priv->src_sd_pad;
> +	fmt_src.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +	ret = v4l2_subdev_call(priv->src_sd, pad, get_fmt, NULL, &fmt_src);
> +	if (ret)
> +		return ret;
> +
> +	ret = __capture_try_fmt_vid_cap(priv, &fmt_src, f);
>  	if (ret)
>  		return ret;
>  
> @@ -264,8 +279,8 @@ static int capture_s_fmt_vid_cap(struct file *file, void *fh,
>  					      CS_SEL_ANY, true);
>  	priv->vdev.compose.left = 0;
>  	priv->vdev.compose.top = 0;
> -	priv->vdev.compose.width = f->fmt.pix.width;
> -	priv->vdev.compose.height = f->fmt.pix.height;
> +	priv->vdev.compose.width = fmt_src.format.width;
> +	priv->vdev.compose.height = fmt_src.format.height;
>  
>  	return 0;
>  }
> @@ -306,9 +321,14 @@ static int capture_g_selection(struct file *file, void *fh,
>  	case V4L2_SEL_TGT_COMPOSE:
>  	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
>  	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> -	case V4L2_SEL_TGT_COMPOSE_PADDED:
>  		s->r = priv->vdev.compose;
>  		break;
> +	case V4L2_SEL_TGT_COMPOSE_PADDED:

Shouldn't this be for COMPOSE_BOUNDS as well?

Do you need _PADDED at all? That only makes sense if the DMA writes beyond
the COMPOSE rectangle due to padding requirements. I'm not aware that that's
the case for imx. I may be wrong, this would be correct if the DMA indeed
writes the full buffer, even if the actual image is smaller.

> +		s->r.left = 0;
> +		s->r.top = 0;
> +		s->r.width = priv->vdev.fmt.fmt.pix.width;
> +		s->r.height = priv->vdev.fmt.fmt.pix.height;
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> 

I see that the image is always DMAed to the top-left corner of the buffer.

Is there a need to implement s_selection so you can change the top-left
corner of the compose rectangle within the buffer?

Regards,

	Hans
