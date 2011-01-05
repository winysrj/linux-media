Return-path: <mchehab@gaivota>
Received: from moutng.kundenserver.de ([212.227.17.8]:57976 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab1AEHFY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Jan 2011 02:05:24 -0500
Date: Wed, 5 Jan 2011 08:05:22 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Qing Xu <qingx@marvell.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: SOC-Camera VIDIOC_ENUM_FRAMESIZES interface?
In-Reply-To: <7BAC95F5A7E67643AAFB2C31BEE662D01403F0DE64@SC-VEXCH2.marvell.com>
Message-ID: <Pine.LNX.4.64.1101050803290.5375@axis700.grange>
References: <AANLkTimucMmO8Vb_y4xnhehQt+mamNMmXyY_qfrVOSo7@mail.gmail.com>
 <AANLkTinv64SL4HavFRK-s2Tr4CTGPH4iQ9bz7=40v1Hc@mail.gmail.com>
 <7BAC95F5A7E67643AAFB2C31BEE662D01403F0DE64@SC-VEXCH2.marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi

On Tue, 4 Jan 2011, Qing Xu wrote:

> Hi,
> 
> We are now trying to adapt to soc-camera framework, though we have one 
> question when reviewing the source code about 
> V4L2_VIDIOC_ENUM_FRAMESIZE:
> 
> We find that there is no vidioc_enum_framesizes implementation in 
> soc-camera.c.
> 
> Do you feel it's reasonable to add it into soc-camera about 
> vidioc_enum_framesizes, so that the application knows how many 
> frame-size is supported by camera driver, and then show all the size 
> options in UI, then allow user to choose one size from the list.

So far this has been an optional ioctl() and no soc-camera set up had a 
need to support it. However, if you do need it for some reason, we 
certainly can look into adding it.

Thanks
Guennadi

> Any ideas will be appreciated!
> 
> Thanks!
> Qing Xu
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
