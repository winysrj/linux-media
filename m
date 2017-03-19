Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33733 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752446AbdCSWKa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Mar 2017 18:10:30 -0400
Subject: Re: [PATCH 2/4] media: imx: allow bayer pixel formats to be looked up
To: Russell King <rmk+kernel@armlinux.org.uk>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
References: <20170319103801.GQ21222@n2100.armlinux.org.uk>
 <E1cpYOP-0006Eg-RQ@rmk-PC.armlinux.org.uk>
Cc: sakari.ailus@linux.intel.com, hverkuil@xs4all.nl,
        linux-media@vger.kernel.org, kernel@pengutronix.de,
        mchehab@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <c747d3d8-7730-d537-4432-47fa431addab@gmail.com>
Date: Sun, 19 Mar 2017 15:02:08 -0700
MIME-Version: 1.0
In-Reply-To: <E1cpYOP-0006Eg-RQ@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is good too, but if it's all right with you I would prefer to
squash this with the "redo  pixel format enumeration and
negotiation" patch, to keep the patch count down.

Steve


On 03/19/2017 03:48 AM, Russell King wrote:
> Allow imx_media_find_format() to look up bayer formats, which is
> required to support frame size and interval enumeration.
>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>   drivers/staging/media/imx/imx-media-capture.c | 11 ++++++-----
>   drivers/staging/media/imx/imx-media-utils.c   |  6 +++---
>   drivers/staging/media/imx/imx-media.h         |  2 +-
>   3 files changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
> index ee914396080f..cdeb2cd8b1d7 100644
> --- a/drivers/staging/media/imx/imx-media-capture.c
> +++ b/drivers/staging/media/imx/imx-media-capture.c
> @@ -164,10 +164,10 @@ static int capture_try_fmt_vid_cap(struct file *file, void *fh,
>   			CS_SEL_YUV : CS_SEL_RGB;
>   		fourcc = f->fmt.pix.pixelformat;
>   
> -		cc = imx_media_find_format(fourcc, cs_sel);
> +		cc = imx_media_find_format(fourcc, cs_sel, false);
>   		if (!cc) {
>   			imx_media_enum_format(&fourcc, 0, cs_sel);
> -			cc = imx_media_find_format(fourcc, cs_sel);
> +			cc = imx_media_find_format(fourcc, cs_sel, false);
>   		}
>   	}
>   
> @@ -193,7 +193,7 @@ static int capture_s_fmt_vid_cap(struct file *file, void *fh,
>   
>   	priv->vdev.fmt.fmt.pix = f->fmt.pix;
>   	priv->vdev.cc = imx_media_find_format(f->fmt.pix.pixelformat,
> -					      CS_SEL_ANY);
> +					      CS_SEL_ANY, false);
>   
>   	return 0;
>   }
> @@ -505,7 +505,8 @@ void imx_media_capture_device_set_format(struct imx_media_video_dev *vdev,
>   
>   	mutex_lock(&priv->mutex);
>   	priv->vdev.fmt.fmt.pix = *pix;
> -	priv->vdev.cc = imx_media_find_format(pix->pixelformat, CS_SEL_ANY);
> +	priv->vdev.cc = imx_media_find_format(pix->pixelformat, CS_SEL_ANY,
> +					      false);
>   	mutex_unlock(&priv->mutex);
>   }
>   EXPORT_SYMBOL_GPL(imx_media_capture_device_set_format);
> @@ -614,7 +615,7 @@ int imx_media_capture_device_register(struct imx_media_video_dev *vdev)
>   	imx_media_mbus_fmt_to_pix_fmt(&vdev->fmt.fmt.pix,
>   				      &fmt_src.format, NULL);
>   	vdev->cc = imx_media_find_format(vdev->fmt.fmt.pix.pixelformat,
> -					 CS_SEL_ANY);
> +					 CS_SEL_ANY, false);
>   
>   	v4l2_info(sd, "Registered %s as /dev/%s\n", vfd->name,
>   		  video_device_node_name(vfd));
> diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
> index 6eb7e3c5279e..d048e4a080d0 100644
> --- a/drivers/staging/media/imx/imx-media-utils.c
> +++ b/drivers/staging/media/imx/imx-media-utils.c
> @@ -329,9 +329,9 @@ static int enum_format(u32 *fourcc, u32 *code, u32 index,
>   }
>   
>   const struct imx_media_pixfmt *
> -imx_media_find_format(u32 fourcc, enum codespace_sel cs_sel)
> +imx_media_find_format(u32 fourcc, enum codespace_sel cs_sel, bool allow_bayer)
>   {
> -	return find_format(fourcc, 0, cs_sel, true, false);
> +	return find_format(fourcc, 0, cs_sel, true, allow_bayer);
>   }
>   EXPORT_SYMBOL_GPL(imx_media_find_format);
>   
> @@ -524,7 +524,7 @@ int imx_media_ipu_image_to_mbus_fmt(struct v4l2_mbus_framefmt *mbus,
>   {
>   	const struct imx_media_pixfmt *fmt;
>   
> -	fmt = imx_media_find_format(image->pix.pixelformat, CS_SEL_ANY);
> +	fmt = imx_media_find_format(image->pix.pixelformat, CS_SEL_ANY, false);
>   	if (!fmt)
>   		return -EINVAL;
>   
> diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
> index 234242271a13..d8c9536bf1f8 100644
> --- a/drivers/staging/media/imx/imx-media.h
> +++ b/drivers/staging/media/imx/imx-media.h
> @@ -178,7 +178,7 @@ enum codespace_sel {
>   };
>   
>   const struct imx_media_pixfmt *
> -imx_media_find_format(u32 fourcc, enum codespace_sel cs_sel);
> +imx_media_find_format(u32 fourcc, enum codespace_sel cs_sel, bool allow_bayer);
>   int imx_media_enum_format(u32 *fourcc, u32 index, enum codespace_sel cs_sel);
>   const struct imx_media_pixfmt *
>   imx_media_find_mbus_format(u32 code, enum codespace_sel cs_sel,
