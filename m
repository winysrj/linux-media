Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout-xforward.gmx.net ([82.165.159.12]:50080 "EHLO
	mout-xforward.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbbEYRlF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2015 13:41:05 -0400
Date: Mon, 25 May 2015 19:20:31 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: William Towle <william.towle@codethink.co.uk>
cc: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org,
	sergei.shtylyov@cogentembedded.com, hverkuil@xs4all.nl,
	rob.taylor@codethink.co.uk
Subject: Re: [PATCH 19/20] media: rcar_vin: Clean up format debugging statements
In-Reply-To: <1432139980-12619-20-git-send-email-william.towle@codethink.co.uk>
Message-ID: <Pine.LNX.4.64.1505251916350.26358@axis700.grange>
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
 <1432139980-12619-20-git-send-email-william.towle@codethink.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi William,

On Wed, 20 May 2015, William Towle wrote:

> Pretty print fourcc and code in format debugging statements.
> 
> Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
> Reviewed-by: William Towle <william.towle@codethink.co.uk>
> ---
>  drivers/media/platform/soc_camera/rcar_vin.c |   22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index b530503..0bebca5 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c

[snip]

> @@ -1720,11 +1725,14 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
>  	int width, height;
>  	int ret;
>  
> +	dev_dbg(icd->parent, "TRY_FMT(%c%c%c%c, %ux%u)\n",
> +		pixfmtstr(pix->pixelformat), pix->width, pix->height);
> +

Why is this additional debugging needed? Doesn't an identical call in 
soc_camera_try_fmt() already print the same information just before 
calling rcar_vin_try_fmt()?

Thanks
Guennadi
