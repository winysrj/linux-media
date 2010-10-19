Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:50598 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559Ab0JSXS6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 19:18:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hal Moroff <halm90@gmail.com>
Subject: Re: soc_camera device
Date: Wed, 20 Oct 2010 01:19:13 +0200
Cc: linux-media@vger.kernel.org
References: <AANLkTin4w=0sheXsfsPve7ivjrdUO-+9mHCCbwCkW=cP@mail.gmail.com> <AANLkTinw9xUPRv=gXM6KtnXEdtdMbz_TJKKV+ojm6+C0@mail.gmail.com>
In-Reply-To: <AANLkTinw9xUPRv=gXM6KtnXEdtdMbz_TJKKV+ojm6+C0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010200119.13551.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hal,

On Tuesday 19 October 2010 23:58:48 Hal Moroff wrote:
> I'm pretty new to Linux video drivers (I do have experience with drivers in
> general) and am trying to get my head around the driver models.  Sorry if
> this is too basic a question for this forum.
> 
> I have an OMAP 3530 running Arago Linux (2.6.32 at the moment),

You should really upgrade to a more recent OMAP3 ISP driver. The driver has 
been (nearly) completely rewritten and has a new userspace API (still V4L2 
compatible of course). If you build your userspace applications for the OMAP3 
ISP driver shipped with the 2.6.32 kernel you will be stuck with the old buggy 
driver.

You can find the latest driver in 
http://git.linuxtv.org/pinchartl/media.git?a=shortlog;h=refs/heads/media-0004-
omap3isp

> and I'm trying to capture images from an Aptina sensor for which there does
> not seem to be a driver.
> 
> There seem to be soc_camera, soc_camera-int, v4l2, omap34xxcam drivers at
> the very least. I'm pretty confused over these and how they do or don't work
> with V4L2 and/or each other.

And you're missing isp-mod.ko :-)

> It seems that some of the driver models are deprecated (but still in
> use), and that soc_camera is current.  Or is it?

In recent driver versions isp-mod.ko and omap34xxcam.ko have been merged into 
omap3-isp.ko. The driver doesn't use the SoC camera framework, so you can 
forget about soc_camera for now.

> 2 things in particular at the moment are giving me a hard time:
>   1. I can't seem to load soc_camera.ko ... I keep getting the error:
>      soc_camera: exports duplicate symbol soc_camera_host_unregister
>      (owned by kernel)
>      I can't seem to resolve this, nor can I find the issue described
>      in any online forum (and so I suspect it's my problem).

That's probably caused by soc_camera being built in your kernel image, and 
then built again as a module. That shouldn't matter as you don't need 
soc_camera anyway.

>   2. There are drivers for the Aptina MT9V022 and the MT9M001 (among
>      others). Both of these are sensors, and not SOC, and yet both of these
>      rely on the soc_camera module.  I'm willing to create the driver for my
>      Aptina sensor, and the easiest way is generally to look at a known
>      driver as a template, however I can't figure out which to look at.

To be compatible with the OMAP3 ISP driver, sensor drivers need to implement 
the V4L2 subdev pad-level API. Look at the MT9T001 driver in 
http://git.linuxtv.org/pinchartl/media.git?a=shortlog;h=refs/heads/media-
mt9t001 for sample code.

Please read the http://www.spinics.net/lists/linux-media/msg23744.html mail 
thread for more information.

-- 
Regards,

Laurent Pinchart
