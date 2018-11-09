Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46638 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727087AbeKIPMV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2018 10:12:21 -0500
Received: by mail-pf1-f195.google.com with SMTP id s9-v6so395274pfm.13
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2018 21:33:25 -0800 (PST)
Subject: Re: [PATCH 2/3] media: imx: set compose rectangle to mbus format
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
References: <20181105152055.31254-1-p.zabel@pengutronix.de>
 <20181105152055.31254-2-p.zabel@pengutronix.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <3614b93e-feeb-a118-efda-e5265af24499@gmail.com>
Date: Thu, 8 Nov 2018 21:33:23 -0800
MIME-Version: 1.0
In-Reply-To: <20181105152055.31254-2-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,


On 11/5/18 7:20 AM, Philipp Zabel wrote:
> Prepare for mbus format being smaller than the written rectangle
> due to burst size.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>   drivers/staging/media/imx/imx-media-capture.c | 55 +++++++++++++------
>   1 file changed, 38 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
> index cace8a51aca8..2d49d9573056 100644
> --- a/drivers/staging/media/imx/imx-media-capture.c
> +++ b/drivers/staging/media/imx/imx-media-capture.c
> @@ -203,21 +203,14 @@ static int capture_g_fmt_vid_cap(struct file *file, void *fh,
>   	return 0;
>   }
>   
> -static int capture_try_fmt_vid_cap(struct file *file, void *fh,
> -				   struct v4l2_format *f)
> +static int __capture_try_fmt_vid_cap(struct capture_priv *priv,
> +				     struct v4l2_subev_format *fmt_src,


typo: struct v4l2_subdev_format *fmt_src,


> +				     struct v4l2_format *f)
>   {
>   	struct capture_priv *priv = video_drvdata(file);
> -	struct v4l2_subdev_format fmt_src;
>   	const struct imx_media_pixfmt *cc, *cc_src;
> -	int ret;
> -
> -	fmt_src.pad = priv->src_sd_pad;
> -	fmt_src.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> -	ret = v4l2_subdev_call(priv->src_sd, pad, get_fmt, NULL, &fmt_src);
> -	if (ret)
> -		return ret;
>   
> -	cc_src = imx_media_find_ipu_format(fmt_src.format.code, CS_SEL_ANY);
> +	cc_src = imx_media_find_ipu_format(fmt_src->format.code, CS_SEL_ANY);
>   	if (cc_src) {
>   		u32 fourcc, cs_sel;
>   
> @@ -231,7 +224,7 @@ static int capture_try_fmt_vid_cap(struct file *file, void *fh,
>   			cc = imx_media_find_format(fourcc, cs_sel, false);
>   		}
>   	} else {
> -		cc_src = imx_media_find_mbus_format(fmt_src.format.code,
> +		cc_src = imx_media_find_mbus_format(fmt_src->format.code,
>   						    CS_SEL_ANY, true);
>   		if (WARN_ON(!cc_src))
>   			return -EINVAL;
> @@ -239,15 +232,32 @@ static int capture_try_fmt_vid_cap(struct file *file, void *fh,
>   		cc = cc_src;
>   	}
>   
> -	imx_media_mbus_fmt_to_pix_fmt(&f->fmt.pix, &fmt_src.format, cc);
> +	imx_media_mbus_fmt_to_pix_fmt(&f->fmt.pix, &fmt_src->format, cc);
>   
>   	return 0;
>   }
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
> +	return __capture_try_fmt(priv, &fmt_src, f);


typo: return __capture_try_fmt_vid_cap(priv, &fmt_src, f);


> +}
> +
>   static int capture_s_fmt_vid_cap(struct file *file, void *fh,
>   				 struct v4l2_format *f)
>   {
>   	struct capture_priv *priv = video_drvdata(file);
> +	struct v4l2_subdev_format fmt_src;
>   	int ret;
>   
>   	if (vb2_is_busy(&priv->q)) {
> @@ -255,7 +265,13 @@ static int capture_s_fmt_vid_cap(struct file *file, void *fh,
>   		return -EBUSY;
>   	}
>   
> -	ret = capture_try_fmt_vid_cap(file, priv, f);
> +	fmt_src.pad = priv->src_sd_pad;
> +	fmt_src.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +	ret = v4l2_subdev_call(priv->src_sd, pad, get_fmt, NULL, &fmt_src);
> +	if (ret)
> +		return ret;
> +
> +	ret = __capture_try_fmt_vid_cap(priv, &fmt_src, f);
>   	if (ret)
>   		return ret;
>   
> @@ -264,8 +280,8 @@ static int capture_s_fmt_vid_cap(struct file *file, void *fh,
>   					      CS_SEL_ANY, true);
>   	priv->vdev.compose.left = 0;
>   	priv->vdev.compose.top = 0;
> -	priv->vdev.compose.width = f->fmt.fmt.pix.width;
> -	priv->vdev.compose.height = f->fmt.fmt.pix.height;
> +	priv->vdev.compose.width = fmt_src.width;
> +	priv->vdev.compose.height = fmt_src.height;
>   
>   	return 0;
>   }
> @@ -307,9 +323,14 @@ static int capture_g_selection(struct file *file, void *fh,
>   	case V4L2_SEL_TGT_COMPOSE:
>   	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
>   	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> -	case V4L2_SEL_TGT_COMPOSE_PADDED:
>   		s->r = priv->vdev.compose;
>   		break;
> +	case V4L2_SEL_TGT_COMPOSE_PADDED:
> +		s->r.left = 0;
> +		s->r.top = 0;
> +		s->r.width = priv->vdev.fmt.fmt.pix.width;
> +		s->r.height = priv->vdev.fmt.fmt.pix.height;
> +		break;
>   	default:
>   		return -EINVAL;
>   	}
