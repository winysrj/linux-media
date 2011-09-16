Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:59277 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab1IPV1h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Sep 2011 17:27:37 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 22487189B83
	for <linux-media@vger.kernel.org>; Fri, 16 Sep 2011 23:27:35 +0200 (CEST)
Date: Fri, 16 Sep 2011 23:27:35 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [Q] video configuration order
Message-ID: <Pine.LNX.4.64.1109162112120.16135@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

I've been re-thinking (yes, again...) our classical 2-step geometry 
configuration (let's leave COMPOSE and friends aside for now) per S_FMT 
and S_CROP, and came to the conclusion, that passing the pixel format with 
the scaling configuration (S_FMT) is a bad idea.

Let's take CAPTURE as an example, and let's use the "sensor" terminology, 
even though the same basically applies to other video data sources.

Considering just the two geometries - a cropped window on the sensor and 
an output frame, it is logical to first configure the input, and then the 
output, because at least on the hardware, where you have to write scaling 
factors into registers, and not just output sizes, you would have to 
recalculate those factors, if cropping were to be applied after scaling. 
In other words, output depends on the input, but not the other way 
round:-)

But S_FMT also passes the pixel format with it, and if you change the 
pixel format, your cropping capabilities might change too. This might not 
be very obvious for raw sensors, but it is quite possible for various 
video data processing devices, like resizers, etc.

Therefore, I think, the best order would be:

(1) set pixel format (fourcc / mediabus code)
(2) set crop
(3) set scale

I know we cannot change this in V4L2 anymore, so, this might be something 
for V4L3;-) But what we could do is at least redesign our subdevice APIs 
to separate the .s_fmt() method into two operations.

Below is the specific example, that brought me to this, it might be 
helpful for those, wishing to even better understand the sources of this 
problem, others can skip the rest:-)

The problem occurred to me, when I was working on the 
sh_mobile_ceu_camera.c driver. The CEU can scale some pixel formats 
(several YUV / NV1x formats), and cannot scale others (this actually holds 
for all bridges), but it can crop anything. As I'm extending soc-camera to 
work in both "V4L2" and "MC" modes, I want to still be able to configure 
the sensor behind the CEU from just the classical S_FMT / S_CROP ioctl()s. 
In this mode I have to decide, where to do the cropping and scaling - on 
the sensor or on the CEU. One thing I want to avoid, is applying CEU 
cropping on top of sensor scaling - this gets messy very quickly.

So, I only consider CEU cropping, when the sensor is not scaling. Given 
this, if the user has requested one of pixel codes, that the CEU cannot 
scale (e.g., a Bayer format), and I have configured sensor 1:1 scaling and 
crop on the CEU, and then the user issues an S_FMT, I now also lose the 
ability to ask the sensor to scale, because for that I would have to drop 
the CEU cropping and the resulting cropping rectangle can change _a lot_ 
as a result of an S_FMT ioctl(), which, as we know, is not something, that 
the user expects;-) This leads me to the conclusion, that I also should 
not do CEU cropping for those, not natively supported by the CEU, formats.

This is where we come to cropping behaviour depending on the pixel format 
and the need to set that format before cropping and before scaling.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
