Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56421 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2INWFN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 18:05:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	brijohn@gmail.com
Subject: Re: Improving ov7670 sensor driver.
Date: Sat, 15 Sep 2012 00:05:45 +0200
Message-ID: <1436194.OkjyqZg1hD@avalon>
In-Reply-To: <CACKLOr22AvmWhXmj2SrMGO4y39ESHfyh_HPnLr6nmQGkUv2+zg@mail.gmail.com>
References: <CACKLOr22AvmWhXmj2SrMGO4y39ESHfyh_HPnLr6nmQGkUv2+zg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Thursday 13 September 2012 11:48:17 javier Martin wrote:
> Hi,
> our new i.MX27 based platform (Visstrim-SM20) uses an ov7675 sensor
> attached to the CSI interface. Apparently, this sensor is fully
> compatible with the old ov7670. For this reason, it seems rather
> sensible that they should share the same driver: ov7670.c
> One of the challenges we have to face is that capture video support
> for our platform is mx2_camera.c, which is a soc-camera host driver;
> while ov7670.c was developed for being used as part of a more complex
> video card.
> 
> Here is the list of current users of ov7670:
> 
> http://lxr.linux.no/#linux+v3.5.3/drivers/media/video/gspca/ov519.c
> http://lxr.linux.no/#linux+v3.5.3/drivers/media/video/gspca/sn9c20x.c
> http://lxr.linux.no/#linux+v3.5.3/drivers/media/video/gspca/vc032x.c
> http://lxr.linux.no/#linux+v3.5.3/drivers/media/video/via-camera.c
> http://lxr.linux.no/#linux+v3.5.3/drivers/media/video/marvell-ccic/mcam-core
> .c
> 
> These are basically the improvements we need to make to this driver in
> order to satisfy our needs:
> 
> 1.- Adapt v4l2 controls to the subvevice control framework, with a
> proper ctrl handler, etc...
> 2.- Add the possibility to bypass PLL and clkrc preescaler.
> 3.- Adjust vstart/vstop in order to remove an horizontal green line.
> 4.- Disable pixclk during horizontal blanking.
> 5.- min_height, min_width should be respected in try_fmt().
> 6.- Pass platform data when used with a soc-camera host driver.
> 7.- Add V4L2_CID_POWER_LINE_FREQUENCY ctrl.

8. Make sure it still works when used with a non soc-camera bridge.

That's the tricky part. I've spent time working on this for the ov772x driver 
(albeit in the other direction, making it usable with a non soc-camera 
bridge). You can find work-in-progress hacks at

http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp-
sensors-board

The basic idea is that the soc-camera platform data structure needs to be 
split into a generic device part (currently called soc_camera_pdtata, which 
should be renamed to something not related to soc-camera), and a soc-camera 
specific structure. The device should only see the device part, and the soc-
camera framework will get the host part. That's currently not implemented.

-- 
Regards,

Laurent Pinchart

