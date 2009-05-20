Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50712 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752833AbZETHVI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2009 03:21:08 -0400
Date: Wed, 20 May 2009 09:21:11 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: MT9T031 and other similar sub devices...
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401353CD3D6@dlee06.ent.ti.com>
Message-ID: <Pine.LNX.4.64.0905200909240.4423@axis700.grange>
References: <A69FA2915331DC488A831521EAE36FE401353CD3D6@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Murali

On Tue, 19 May 2009, Karicheri, Muralidharan wrote:

> Hi, Guennadi Liakhovetski,
> 
> Thanks for your effort to migrate the sensor drivers to sub device framework.
> 
> We have interest in mt9t031 and other sensor drivers from Micron since 
> this peripheral is used in our DM355/DM6446 EVMs as well. I have 
> submitted a set of patches for our vpfe_capture driver to the media 
> mailing list for review. This driver runs on DM355/DM6446 EVMs and is 
> developed to use the sub device model to integrate with capture 
> peripheral like TVP5146, MT9T001, MT9T031 etc.

You mean MT9M001, right?

> If you have a version of 
> mt9t031 driver migrated to sub device, I would like to integrate that 
> with our vpfe_capture driver.

Nice, that's what the whole sudev conversion is (largely) about, AFAICS.

> I want to check following with you so as to be on the same page.
> 
> 1) I see that the mt9t001.c still uses struct soc_camera_device and 
> calls soc_camera_video_start() to start the master. This introduces a 
> reverse dependency from the sub device to bridge driver (correct me if I 
> my understanding is wrong). I guess you plan to remove this dependency 
> in your future patch. With this in the driver, it can't work with our 
> driver since we don't have soc_camera_device.

Correct.

> 2) vpfe_capture driver support raw bayer interface as well as raw yuv 
> interface. Raw bayer interface can be 8-16 bits wide along with 
> HD/VD/field lines. So in order for the bridge driver to configure the 
> interface, it needs to know parameters like interface type (BT.656, 
> BT.1120, Raw image data (8-16) etc), polarity of HD, VD, PCLK, field 
> signals etc. Is there a infrastructure for handling this ? I mean, we 
> should have a way of defining this per platform, which some how can be 
> read by bridge driver to configure the interface to work with a specific 
> sub device.

Right, this is one of the pieces still missing in the v4l2-(sub)dev 
framework, which we have in soc_camera, and which we'll have to think 
about bringing over to v4l2-subdev. That's one of the reasons why the 
conversion is not complete yet.

The other (and main) reason is my time. I'm doing this at my free time, 
and I don't know when next time I'll come round to progressing this work. 
So, either you can provide patches to speed up the process, or you can 
wait for me, or someone might want to pay for this work to be done:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
