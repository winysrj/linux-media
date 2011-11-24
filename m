Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:53451 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab1KXXqA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 18:46:00 -0500
Date: Fri, 25 Nov 2011 00:45:12 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] V4L: omap1_camera: fix missing <linux/module.h> include
In-Reply-To: <1322176595-31837-1-git-send-email-jkrzyszt@tis.icnet.pl>
Message-ID: <Pine.LNX.4.64.1111250044200.17376@axis700.grange>
References: <1322176595-31837-1-git-send-email-jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Janusz

On Fri, 25 Nov 2011, Janusz Krzysztofik wrote:

> Otherwise compilation breaks with:
> 
> drivers/media/video/omap1_camera.c:1535: error: 'THIS_MODULE' undeclared here (not in a function)
> ...
> 
> after apparently no longer included recursively from other header files.
> 
> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>

Thanks, will push with other 3.2-rc soc-camera fixes, when I find time to 
organise them...

Thanks
Guennadi

> ---
>  drivers/media/video/omap1_camera.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/omap1_camera.c b/drivers/media/video/omap1_camera.c
> index e87ae2f..6a6cf38 100644
> --- a/drivers/media/video/omap1_camera.c
> +++ b/drivers/media/video/omap1_camera.c
> @@ -24,6 +24,7 @@
>  #include <linux/clk.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/interrupt.h>
> +#include <linux/module.h>
>  #include <linux/platform_device.h>
>  #include <linux/slab.h>
>  
> -- 
> 1.7.3.4
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
