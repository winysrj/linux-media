Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:60587 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab1IFHAc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 03:00:32 -0400
Date: Tue, 6 Sep 2011 09:00:29 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?ISO-8859-1?B?TEJN?= <lbm9527@qq.com>
cc: =?ISO-8859-1?B?bGludXgtbWVkaWE=?= <linux-media@vger.kernel.org>
Subject: Re: migrate soc-camera  to  V4L2 
In-Reply-To: <tencent_49AB69CE6334B0340CE14349@qq.com>
Message-ID: <Pine.LNX.4.64.1109060857270.14818@axis700.grange>
References: <tencent_49AB69CE6334B0340CE14349@qq.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lee

On Tue, 6 Sep 2011, LBM wrote:

> hi  Guennadi
>         I used Hans's codes about "migrate soc-camera to the new V4L2 
> control framework".There is a problem,the programe can't go to exec the 
> function "soc_camera_probe()".

You don't need it.

> I find some information,that say it need 
> to use the function "soc_camera_host_register()".

Nor you need this one.

> but i don't know why 
> and how to use it.  My system is "omap3530+mt9m111" and kernel is 
> linux2.6.32.
>          And now i find the oamp1_camera.c,maby i must fill codes in the 
> struct soc_camera_host for my omap3.or if you did this thing already?if 
> that can you give me the codes?

You shouldn't need to touch the SoC drivers (omap). omap3isp is the 
correct driver for you. You only need to port mt9m111 to work with omap3.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
