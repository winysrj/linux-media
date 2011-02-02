Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:65143 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab1BBRoH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Feb 2011 12:44:07 -0500
Date: Wed, 2 Feb 2011 18:44:04 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Anatolij Gustschin <agust@denx.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Markus Niebel <Markus.Niebel@tqs.de>
Subject: Re: [PATCH] v4l: mx3_camera: fix NULL pointer dereference if debug
 output enabled
In-Reply-To: <1296478181-10838-1-git-send-email-agust@denx.de>
Message-ID: <Pine.LNX.4.64.1102021843030.20841@axis700.grange>
References: <1296478181-10838-1-git-send-email-agust@denx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 31 Jan 2011, Anatolij Gustschin wrote:

> Running with enabled debug output in the mx3_camera driver results
> in a kernel crash:
> ...
> mx3-camera mx3-camera.0: Providing format Bayer BGGR (sRGB) 8 bit using code 11
> Unable to handle kernel NULL pointer dereference at virtual address 00000004
> ...
> 
> Fix it by incrementing 'xlate' after usage.
> 
> Signed-off-by: Anatolij Gustschin <agust@denx.de>
> ---
>  drivers/media/video/mx3_camera.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
> index b9cb4a4..7bcaaf7 100644
> --- a/drivers/media/video/mx3_camera.c
> +++ b/drivers/media/video/mx3_camera.c
> @@ -734,9 +734,9 @@ static int mx3_camera_get_formats(struct soc_camera_device *icd, unsigned int id
>  	if (xlate) {
>  		xlate->host_fmt	= fmt;
>  		xlate->code	= code;
> -		xlate++;
>  		dev_dbg(dev, "Providing format %x in pass-through mode\n",
>  			xlate->host_fmt->fourcc);
> +		xlate++;

Let's take an even easier path:

-			xlate->host_fmt->fourcc);
+			fmt->fourcc);


>  	}
>  
>  	return formats;
> -- 
> 1.7.1

Thanks
Guennadi
---
Guennadi Liakhovetski
