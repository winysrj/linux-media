Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51730 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755046AbZJLUC2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2009 16:02:28 -0400
Date: Mon, 12 Oct 2009 22:01:23 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] pxa-camera: Fix missing sched.h
In-Reply-To: <4AD37090.4040002@cam.ac.uk>
Message-ID: <Pine.LNX.4.64.0910122159330.4366@axis700.grange>
References: <4AD36D2D.2000202@cam.ac.uk> <4AD36EE5.1060807@cam.ac.uk>
 <4AD37090.4040002@cam.ac.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 12 Oct 2009, Jonathan Cameron wrote:

> linux/sched.h include was removed form linux/poll.h by
> commmit a99bbaf5ee6bad1aca0c88ea65ec6e5373e86184
> 
> Required for wakeup call.
> 
> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Mauro, can you take it from here with my ack for -rc5 or do I have to pull 
it through my tree?

Thanks
Guennadi

> ---
>  drivers/media/video/pxa_camera.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
> index 6952e96..5d01dcf 100644
> --- a/drivers/media/video/pxa_camera.c
> +++ b/drivers/media/video/pxa_camera.c
> @@ -26,6 +26,7 @@
>  #include <linux/device.h>
>  #include <linux/platform_device.h>
>  #include <linux/clk.h>
> +#include <linux/sched.h>
>  
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-dev.h>
> -- 
> 1.6.3.3
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
