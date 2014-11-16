Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:61621 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459AbaKPPRY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Nov 2014 10:17:24 -0500
Date: Sun, 16 Nov 2014 16:17:13 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Yoshihiro Kaneko <ykaneko0929@gmail.com>
cc: linux-media@vger.kernel.org, Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH v3 3/3] media: soc_camera: rcar_vin: Add NV16 horizontal
 scaling-up support
In-Reply-To: <1413868229-22205-4-git-send-email-ykaneko0929@gmail.com>
Message-ID: <Pine.LNX.4.64.1411161609420.21527@axis700.grange>
References: <1413868229-22205-1-git-send-email-ykaneko0929@gmail.com>
 <1413868229-22205-4-git-send-email-ykaneko0929@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kaneko-san,

On Tue, 21 Oct 2014, Yoshihiro Kaneko wrote:

> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> 
> Up until now scaling has been forbidden for the NV16 capture format.
> This patch adds support for horizontal scaling-up for NV16. Vertical
> scaling-up for NV16 is forbidden by the H/W specification.

Here and also in the subject - what do you mean by "scaling-up?" Do you 
really mean increasing sizes, i.e. scaling from smaller sizes to larger 
ones? Is down-scaling not supported? Maybe someone with a better English 
knowledge, then myself, could advise - is "add scaling-up support" ok or 
would "add up-scaling support" or, if we don't really mean increasing, 
just "add scaling support" be better?

> 
> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> ---
> v3 [Yoshihiro Kaneko]
> * no changes
> 
> v2 [Yoshihiro Kaneko]
> * Updated change log text from Simon Horman
> * Code-style fixes as suggested by Sergei Shtylyov
> 
>  drivers/media/platform/soc_camera/rcar_vin.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index ecdbd48..fd2207a 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -644,7 +644,7 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
>  	/* output format */
>  	switch (icd->current_fmt->host_fmt->fourcc) {
>  	case V4L2_PIX_FMT_NV16:
> -		iowrite32(ALIGN(ALIGN(cam->width, 0x20) * cam->height, 0x80),
> +		iowrite32(ALIGN((cam->out_width * cam->out_height), 0x80),
>  			  priv->base + VNUVAOF_REG);
>  		dmr = VNDMR_DTMD_YCSEP;
>  		output_is_yuv = true;
> @@ -1614,9 +1614,17 @@ static int rcar_vin_set_fmt(struct soc_camera_device *icd,
>  	 * At the time of NV16 capture format, the user has to specify the
>  	 * width of the multiple of 32 for H/W specification.
>  	 */
> -	if ((pixfmt == V4L2_PIX_FMT_NV16) && (pix->width & 0x1F)) {
> -		dev_err(icd->parent, "Specified width error in NV16 format.\n");
> -		return -EINVAL;
> +	if (pixfmt == V4L2_PIX_FMT_NV16) {
> +		if (pix->width & 0x1F) {
> +			dev_err(icd->parent,
> +				"Specified width error in NV16 format. Please specify the multiple of 32.\n");
> +			return -EINVAL;
> +		}
> +		if (pix->height != cam->height) {
> +			dev_err(icd->parent,
> +				"Vertical scaling-up error in NV16 format. Please specify input height size.\n");
> +			return -EINVAL;
> +		}

Similar to the previous patch - shouldn't this new test be added to 
_try_fmt() and there you would just fix the size instead of erroring out?

Thanks
Guennadi

>  	}
>  
>  	switch (pix->field) {
> @@ -1661,6 +1669,7 @@ static int rcar_vin_set_fmt(struct soc_camera_device *icd,
>  	case V4L2_PIX_FMT_YUYV:
>  	case V4L2_PIX_FMT_RGB565:
>  	case V4L2_PIX_FMT_RGB555X:
> +	case V4L2_PIX_FMT_NV16: /* horizontal scaling-up only is supported */
>  		can_scale = true;
>  		break;
>  	default:
> -- 
> 1.9.1
> 
