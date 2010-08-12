Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:57083 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1760525Ab0HLUUh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Aug 2010 16:20:37 -0400
Date: Thu, 12 Aug 2010 22:20:34 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Christopher Friedt <chrisfriedt@gmail.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l2-ctrls.c was missing slab.h
In-Reply-To: <1281639851-20984-1-git-send-email-chrisfriedt@gmail.com>
Message-ID: <Pine.LNX.4.64.1008122219060.17224@axis700.grange>
References: <1281639851-20984-1-git-send-email-chrisfriedt@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Thu, 12 Aug 2010, Christopher Friedt wrote:

> Fixed broken compile of drivers/media/video/v4l2-ctrls.c. 
> It failed due to missing #include <linux/slab.h>, and errored-out with 
> "implicit declaration of function kzalloc, kmalloc, ..."
> 
> Signed-off-by: Christopher Friedt <chrisfriedt@gmail.com>
> ---
>  drivers/media/video/v4l2-ctrls.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
> index 84c1a53..1d09804 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -18,6 +18,7 @@
>      Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>   */
>  
> +#include <linux/slab.h>
>  #include <linux/ctype.h>

an alphabetic order is preferred, even if it is not preserved elsewhere in 
the file...

Thanks
Guennadi

>  #include <media/v4l2-ioctl.h>
>  #include <media/v4l2-device.h>
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
