Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:57407 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459AbaKPPIW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Nov 2014 10:08:22 -0500
Date: Sun, 16 Nov 2014 16:08:12 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Yoshihiro Kaneko <ykaneko0929@gmail.com>
cc: linux-media@vger.kernel.org, Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH v3 2/3] media: soc_camera: rcar_vin: Add capture width
 check for NV16 format
In-Reply-To: <1413868229-22205-3-git-send-email-ykaneko0929@gmail.com>
Message-ID: <Pine.LNX.4.64.1411161605490.21527@axis700.grange>
References: <1413868229-22205-1-git-send-email-ykaneko0929@gmail.com>
 <1413868229-22205-3-git-send-email-ykaneko0929@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kaneko-san,

On Tue, 21 Oct 2014, Yoshihiro Kaneko wrote:

> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> 
> At the time of NV16 capture format, the user has to specify the
> capture output width of the multiple of 32 for H/W specification.
> At the time of using NV16 format by ioctl of VIDIOC_S_FMT,
> this patch adds align check and the error handling to forbid
> specification of the capture output width which is not a multiple of 32.
> 
> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> ---
> 
> v3 [Yoshihiro Kaneko]
> * fixes some code-style and remove useless error flag as suggested by
>   Sergei Shtylyov
> 
> v2 [Yoshihiro Kaneko]
> * use u32 instead of unsigned long
> 
>  drivers/media/platform/soc_camera/rcar_vin.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index dd6daab..ecdbd48 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c

[snip]

> @@ -1605,6 +1610,15 @@ static int rcar_vin_set_fmt(struct soc_camera_device *icd,
>  	dev_dbg(dev, "S_FMT(pix=0x%x, %ux%u)\n",
>  		pixfmt, pix->width, pix->height);
>  
> +	/*
> +	 * At the time of NV16 capture format, the user has to specify the
> +	 * width of the multiple of 32 for H/W specification.
> +	 */
> +	if ((pixfmt == V4L2_PIX_FMT_NV16) && (pix->width & 0x1F)) {
> +		dev_err(icd->parent, "Specified width error in NV16 format.\n");
> +		return -EINVAL;
> +	}
> +

Shouldn't these checks go into rcar_vin_try_fmt() and then just adjust the 
width instead of erroring out?

Thanks
Guennadi

>  	switch (pix->field) {
>  	default:
>  		pix->field = V4L2_FIELD_NONE;
> -- 
> 1.9.1
> 
