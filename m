Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:50886 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab1IFHiS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 03:38:18 -0400
Date: Tue, 6 Sep 2011 09:38:16 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?ISO-8859-1?B?TEJN?= <lbm9527@qq.com>
cc: =?ISO-8859-1?B?bGludXgtbWVkaWE=?= <linux-media@vger.kernel.org>
Subject: Re: migrate soc-camera  to  V4L2 
In-Reply-To: <tencent_3A0B806D0B9604E629799037@qq.com>
Message-ID: <Pine.LNX.4.64.1109060917280.14818@axis700.grange>
References: <tencent_3A0B806D0B9604E629799037@qq.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 6 Sep 2011, LBM wrote:

> hi Guennadi
>    thank you very much!
>     but,how can i port mt9m111 to work with omap3?can you give me some examples?

I'm hoping to get a fixed version of Hans' patches by the end of the day 
today. After that the use of struct soc_camera_device has to be eliminated 
in the driver, I might be able to do that too. Then you should be able to 
more or less just add mt9m111 platform data to your board file, including 
struct soc_camera_link, and start experimenting.

Thanks
Guennadi

>                         thanks
>                           LEE
>    
>   ------------------ Original ------------------
>   From:  "g.liakhovetski"<g.liakhovetski@gmx.de>;
>  Date:  Tue, Sep 6, 2011 03:00 PM
>  To:  "LBM"<lbm9527@qq.com>; 
>  Cc:  "linux-media"<linux-media@vger.kernel.org>; 
>  Subject:  Re: migrate soc-camera to V4L2 
> 
>   
> Hi Lee
> 
> On Tue, 6 Sep 2011, LBM wrote:
> 
> > hi  Guennadi
> >         I used Hans's codes about "migrate soc-camera to the new V4L2 
> > control framework".There is a problem,the programe can't go to exec the 
> > function "soc_camera_probe()".
> 
> You don't need it.
> 
> > I find some information,that say it need 
> > to use the function "soc_camera_host_register()".
> 
> Nor you need this one.
> 
> > but i don't know why 
> > and how to use it.  My system is "omap3530+mt9m111" and kernel is 
> > linux2.6.32.
> >          And now i find the oamp1_camera.c,maby i must fill codes in the 
> > struct soc_camera_host for my omap3.or if you did this thing already?if 
> > that can you give me the codes?
> 
> You shouldn't need to touch the SoC drivers (omap). omap3isp is the 
> correct driver for you. You only need to port mt9m111 to work with omap3.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
