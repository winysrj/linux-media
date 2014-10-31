Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:40181 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758896AbaJaNkt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 09:40:49 -0400
Received: by mail-lb0-f180.google.com with SMTP id z12so6005782lbi.39
        for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 06:40:48 -0700 (PDT)
Message-ID: <5453915E.3020100@cogentembedded.com>
Date: Fri, 31 Oct 2014 16:40:46 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Yoshihiro Kaneko <ykaneko0929@gmail.com>,
	linux-media@vger.kernel.org
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH] media: soc_camera: rcar_vin: Fix alignment of clipping
 size
References: <1414746610-23194-1-git-send-email-ykaneko0929@gmail.com>
In-Reply-To: <1414746610-23194-1-git-send-email-ykaneko0929@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 10/31/2014 12:10 PM, Yoshihiro Kaneko wrote:

> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

> Since the Start Line Pre-Clip register, the Start Pixel Pre-Clip
> register and the End Line Post-Clip register do not have restriction

    Hm, my R-Car H1 manual says to specify an even number for the Start Pixel 
Pre-Clip Register.

> of H/W to a setting value, the processing of alignment is unnecessary.
> This patch corrects so that processing of alignment is not performed.

> However, the End Pixel Post-Clip register has restriction
> of H/W which must be an even number value at the time of the
> output of YCbCr-422 format. By this patch, the processing of
> alignment to an even number value is added on the above-mentioned
> conditions.

    Well, the R-Car H1/M1A manuals don't specify such restriction.

> The variable set to a register is as follows.

>   - Start Line Pre-Clip register
>     cam->vin_top
>   - Start Pixel Pre-Clip register
>     cam->vin_left
>   - End Line Post-Clip register
>     pix->height
>   - End Pixel Post-Clip register
>     pix->width

> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> ---
>   drivers/media/platform/soc_camera/rcar_vin.c | 18 ++++++++++++++----
>   1 file changed, 14 insertions(+), 4 deletions(-)

> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index d3d2f7d..1934e15 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
[...]
> @@ -1761,8 +1761,18 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
>   	}
>
>   	/* FIXME: calculate using depth and bus width */
> -	v4l_bound_align_image(&pix->width, 2, VIN_MAX_WIDTH, 1,
> -			      &pix->height, 4, VIN_MAX_HEIGHT, 2, 0);
> +	/*
> +	 * When performing a YCbCr-422 format output, even if it performs
> +	 * odd number clipping by pixel post clip processing, it is outputted

    s/outputted/output/ -- it's an irregular verb.

> +	 * to a memory per even pixels.
> +	 */
> +	if ((pixfmt == V4L2_PIX_FMT_NV16) || (pixfmt == V4L2_PIX_FMT_YUYV) ||
> +		(pixfmt == V4L2_PIX_FMT_UYVY))

    This is certainly asking to be a *switch* statement instead...

> +		v4l_bound_align_image(&pix->width, 5, VIN_MAX_WIDTH, 1,
> +				      &pix->height, 2, VIN_MAX_HEIGHT, 0, 0);
> +	else
> +		v4l_bound_align_image(&pix->width, 5, VIN_MAX_WIDTH, 0,
> +				      &pix->height, 2, VIN_MAX_HEIGHT, 0, 0);

WBR, Sergei

