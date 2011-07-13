Return-path: <mchehab@localhost>
Received: from moutng.kundenserver.de ([212.227.17.8]:54954 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab1GMHO4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 03:14:56 -0400
Date: Wed, 13 Jul 2011 09:14:50 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?ISO-8859-1?B?TEJN?= <lbm9527@qq.com>
cc: =?ISO-8859-1?B?bGludXgtbWVkaWE=?= <linux-media@vger.kernel.org>
Subject: Re: Migrate from soc_camera to v4l2
In-Reply-To: <tencent_0C81805C0261B60E5643A744@qq.com>
Message-ID: <Pine.LNX.4.64.1107130902070.30737@axis700.grange>
References: <tencent_0C81805C0261B60E5643A744@qq.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On Wed, 13 Jul 2011, LBM wrote:

> my dear Guennadi
>      I'm wrong about that "v4l2-int-device",maybe it just "V4L2".  
>        Now i have a board of OMAP3530 and a cmos camera MT9M111,so i want to get the image from the mt9m111.
>  and ,I want to use the V4L2 API. But in the linux kernel 2.6.38,the driver of the mt9m111 is  a soc_camera.I see some thing about how to convert the soc_camera to V4L2,like "soc-camera: (partially) convert to v4l2-(sub)dev API".
>       Can you tell me how to migrate from soc_camera to v4l2,and
>      or do you tell me some experience about that?

Currently there's no standard way to make a driver to work with both 
soc-camera and (pure) v4l2-subdev APIs. It is being worked on:

http://www.spinics.net/lists/linux-media/msg34878.html

and, hopefully, beginning with the next kernel version 3.1 it will become 
at least theoretically possible. For now you just have to hack the driver 
yourself for your local uses by removing all soc-camera specific code and 
replacing it with your own glue, something along these lines:

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/11486/focus=11691

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
