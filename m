Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46643 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751557Ab0GET6z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Jul 2010 15:58:55 -0400
Date: Mon, 5 Jul 2010 21:58:52 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] V4L/DVB: soc-camera: module_put() fix
In-Reply-To: <20100705101259.23155.79936.sendpatchset@t400s>
Message-ID: <Pine.LNX.4.64.1007052156060.2152@axis700.grange>
References: <20100705101259.23155.79936.sendpatchset@t400s>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 5 Jul 2010, Magnus Damm wrote:

> From: Magnus Damm <damm@opensource.se>
> 
> Avoid calling module_put() if try_module_get() has
> been skipped.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>
> ---
> 
>  drivers/media/video/soc_camera.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- 0001/drivers/media/video/soc_camera.c
> +++ work/drivers/media/video/soc_camera.c	2010-06-23 13:43:05.000000000 +0900
> @@ -1034,7 +1034,8 @@ eiufmt:
>  		soc_camera_free_i2c(icd);
>  	} else {
>  		icl->del_device(icl);
> -		module_put(control->driver->owner);
> +		if (control && control->driver && control->driver->owner)
> +			module_put(control->driver->owner);
>  	}
>  enodrv:
>  eadddev:

Hm, don't understand. I don't see how this can be a problem. Have you hit 
a case, when you enter this path with one of those pointers == NULL? 
Looking at the code, this is only entered from eiufmt or evidstart "if 
(!icl->board_info)" (i.e., only with the soc_camera_platform driver). And 
if you got down to one of those errors, you do have all those pointers in 
place. What am I missing?

Thanks
Guennadi
---
Guennadi Liakhovetski
