Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:62534 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaJROrM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Oct 2014 10:47:12 -0400
Received: by mail-lb0-f177.google.com with SMTP id w7so1981977lbi.36
        for <linux-media@vger.kernel.org>; Sat, 18 Oct 2014 07:47:11 -0700 (PDT)
Message-ID: <54427D5D.70603@cogentembedded.com>
Date: Sat, 18 Oct 2014 18:46:53 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Yoshihiro Kaneko <ykaneko0929@gmail.com>,
	linux-media@vger.kernel.org
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH v2 2/3] media: soc_camera: rcar_vin: Add capture width
 check for NV16 format
References: <1413439968-6349-1-git-send-email-ykaneko0929@gmail.com> <1413439968-6349-3-git-send-email-ykaneko0929@gmail.com>
In-Reply-To: <1413439968-6349-3-git-send-email-ykaneko0929@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 10/16/2014 10:12 AM, Yoshihiro Kaneko wrote:

> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

> At the time of NV16 capture format, the user has to specify the
> capture output width of the multiple of 32 for H/W specification.
> At the time of using NV16 format by ioctl of VIDIOC_S_FMT,
> this patch adds align check and the error handling to forbid
> specification of the capture output width which is not a multiple of 32.

> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> ---

> v2 [Yoshihiro Kaneko]
> * use u32 instead of unsigned long

>   drivers/media/platform/soc_camera/rcar_vin.c | 24 ++++++++++++++++++++++--
>   1 file changed, 22 insertions(+), 2 deletions(-)

> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 34d5b80..ff5f80a 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
[...]
> @@ -1087,6 +1091,7 @@ static int rcar_vin_set_rect(struct soc_camera_device *icd)
>   	unsigned char dsize = 0;
>   	struct v4l2_rect *cam_subrect = &cam->subrect;
>   	u32 value;
> +	u32 imgstr;

    Quite strange name, given the variable's use... what does it stands for?

>
>   	dev_dbg(icd->parent, "Crop %ux%u@%u:%u\n",
>   		icd->user_width, icd->user_height, cam->vin_left, cam->vin_top);
> @@ -1164,7 +1169,11 @@ static int rcar_vin_set_rect(struct soc_camera_device *icd)
>   		break;
>   	}
>
> -	iowrite32(ALIGN(cam->out_width, 0x10), priv->base + VNIS_REG);
> +	if (icd->current_fmt->host_fmt->fourcc == V4L2_PIX_FMT_NV16)
> +		imgstr = ALIGN(cam->out_width, 0x20);
> +	else
> +		imgstr = ALIGN(cam->out_width, 0x10);
> +	iowrite32(imgstr, priv->base + VNIS_REG);

    I'd call the variable 'vnis' as it gets written to the VNIS register...

>
>   	return 0;
>   }
> @@ -1606,6 +1615,17 @@ static int rcar_vin_set_fmt(struct soc_camera_device *icd,
>   	dev_dbg(dev, "S_FMT(pix=0x%x, %ux%u)\n",
>   		pixfmt, pix->width, pix->height);
>
> +	/* At the time of NV16 capture format, the user has to specify the
> +	   width of the multiple of 32 for H/W specification. */

    The preferred multi-line comment format is this:

/*
  * bla
  * bla
  */

> +	if (priv->error_flag == false)
> +		priv->error_flag = true;

    I don't see where else you check this flag, it seems rather useless. I 
also don't see where you clear it, other than the "add/remove device" paths.

> +	else {
> +		if ((pixfmt == V4L2_PIX_FMT_NV16) && (pix->width & 0x1F)) {
> +			dev_err(icd->parent, "Specified width error in NV16 format.\n");
> +			return -EINVAL;
> +		}
> +	}
> +

WBR, Sergei

