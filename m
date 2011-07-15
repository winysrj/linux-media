Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.tricorecenter.de ([217.6.246.34]:53810 "EHLO
	root.phytec.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849Ab1GONh0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 09:37:26 -0400
Subject: Re: Migrate from soc_camera to v4l2
From: Teresa Gamez <T.Gamez@phytec.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: LBM <lbm9527@qq.com>, linux-media <linux-media@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1107130902070.30737@axis700.grange>
References: <tencent_0C81805C0261B60E5643A744@qq.com>
	 <Pine.LNX.4.64.1107130902070.30737@axis700.grange>
Date: Fri, 15 Jul 2011 15:37:19 +0200
Message-ID: <1310737039.2366.394.camel@lws-gamez>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Guennadi,

Am Mittwoch, den 13.07.2011, 09:14 +0200 schrieb Guennadi Liakhovetski:
> On Wed, 13 Jul 2011, LBM wrote:
> 
> > my dear Guennadi
> >      I'm wrong about that "v4l2-int-device",maybe it just "V4L2".  
> >        Now i have a board of OMAP3530 and a cmos camera MT9M111,so i want to get the image from the mt9m111.
> >  and ,I want to use the V4L2 API. But in the linux kernel 2.6.38,the driver of the mt9m111 is  a soc_camera.I see some thing about how to convert the soc_camera to V4L2,like "soc-camera: (partially) convert to v4l2-(sub)dev API".
> >       Can you tell me how to migrate from soc_camera to v4l2,and
> >      or do you tell me some experience about that?
> 
> Currently there's no standard way to make a driver to work with both 
> soc-camera and (pure) v4l2-subdev APIs. It is being worked on:
> 
> http://www.spinics.net/lists/linux-media/msg34878.html
> 
> and, hopefully, beginning with the next kernel version 3.1 it will become 
> at least theoretically possible. For now you just have to hack the driver 
> yourself for your local uses by removing all soc-camera specific code and 
> replacing it with your own glue, something along these lines:

We are also interested in the support of the MT9M111 and MT9V022 for OMAP-4460/OMAP-4430/OMAP-3525.
I have not taken a deeper look at it yet. But what do you mean by theoretically possible?
Could it work out of the box? Or is there more work to do? 

Regards,
Teresa

> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/11486/focus=11691
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


