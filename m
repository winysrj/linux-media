Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59833 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751312AbZJXTez (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Oct 2009 15:34:55 -0400
Date: Sat, 24 Oct 2009 21:35:00 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] pxa_camera: Fix missing include for wake_up
In-Reply-To: <1256398701-7369-1-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.0910242134240.14133@axis700.grange>
References: <1256398701-7369-1-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert

On Sat, 24 Oct 2009, Robert Jarzmik wrote:

> Function wake_up() needs include sched.h.
> Apparently, commit d43c36dc6b357fa1806800f18aa30123c747a6d1
> changed the include chain, removing linux/sched.h
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>

Thanks, but I'm afraid you're a bit late:

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/10947/focus=10949

Regards
Guennadi

> 
> --
> Kernelversion: v2.6.32-rc5
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
> 1.6.0.4
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
