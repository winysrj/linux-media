Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:40083 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754079Ab0ICVcS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Sep 2010 17:32:18 -0400
Date: Fri, 3 Sep 2010 23:32:16 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Poyo VL <poyo_vl@yahoo.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] drivers/media/video/mt9v022.c (2.6.35.4): Fixed compilation
 warning
In-Reply-To: <257277.1946.qm@web45816.mail.sp1.yahoo.com>
Message-ID: <Pine.LNX.4.64.1009032331410.8788@axis700.grange>
References: <666098.4241.qm@web45811.mail.sp1.yahoo.com>
 <Pine.LNX.4.64.1008312227240.25720@axis700.grange> <934905.16227.qm@web45811.mail.sp1.yahoo.com>
 <Pine.LNX.4.64.1009032201180.8788@axis700.grange> <257277.1946.qm@web45816.mail.sp1.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Fri, 3 Sep 2010, Poyo VL wrote:

> From: Ionut Gabriel Popescu <poyo_vl@yahoo.com>
> Kernel: 2.6.35.4
> 
> The drivers/media/video/mt9v022.c file, on line 405, tries a "case 0" o a 
> v4l2_mbus_pixelcode enum which don't have an 0 value element, so I got a compile 
> warning. That "case" is useless so it can be removed. 

This looks much better, thanks! I'll take it from here.

Regards
Guennadi

> 
> 
> Signed-off-by: Ionut Gabriel Popescu <poyo_vl@yahoo.com>
> ---
> 
> --- a/drivers/media/video/mt9v022.c    2010-08-27 02:47:12.000000000 +0300
> +++ b/drivers/media/video/mt9v022.c    2010-09-01 16:12:00.704505851 +0300
> @@ -402,9 +402,6 @@
>          if (mt9v022->model != V4L2_IDENT_MT9V022IX7ATC)
>              return -EINVAL;
>          break;
> -    case 0:
> -        /* No format change, only geometry */
> -        break;
>      default:
>          return -EINVAL;
>      }
> 
> 
>       
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
