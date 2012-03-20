Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:56042 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759454Ab2CTXbE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 19:31:04 -0400
Date: Wed, 21 Mar 2012 00:31:01 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Marco Cavallini <koansoftware@gmail.com>
cc: linux-media@vger.kernel.org,
	Marco Cavallini <m.cavallini@koansoftware.com>
Subject: Re: tvp5150: pxa27x-camera pxa27x-camera.0: Field type 9 unsupported.
In-Reply-To: <4F68698A.2070403@gmail.com>
Message-ID: <Pine.LNX.4.64.1203210013290.21870@axis700.grange>
References: <4F68698A.2070403@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marco

On Tue, 20 Mar 2012, Marco Cavallini wrote:

> Hello,
> I am trying to run a tvp5150 driver with a PXA270 based board

This would be an interesting task...

> I am using kernel version: Linux 2.6.35 armv5tel GNU/Linux
> 
> I also did a test with kernel-3.2.5 without success.

Let's concentrate on 3.2.5.

> I started playing with V4L2, and I've never used it, but I built v4l2-utils.
> The problem is something in pxa_camera_try_fmt() related to the settings
> causing the error "pxa27x-camera pxa27x-camera.0: Field type 9 unsupported."
> 
> 
> [   30.005365] Linux video capture interface: v2.00
> [   32.942234] *** PROBE tvp5151 ***
> [   32.945573] tvp5150 0-003a: chip found @ 0x74 (pxa_i2c-i2c.0)
> [   33.281105] pxa27x-camera pxa27x-camera.0: Limiting master clock to
> 26000000
> [   33.288557] camera 0-0: Probing 0-0
> [   33.292170] pxa27x-camera pxa27x-camera.0: PXA Camera driver attached
> to camera 0
> [   33.666535] *** PROBE tvp5151 ***
> [   33.669865] tvp5150 0-005d: chip found @ 0xba (pxa_i2c-i2c.0)
> [   33.811605] tvp5150 0-005d: tvp5150am1 detected.
> [   33.999541] *** tvp5150_g_fmt
> [   34.002776] pxa27x-camera pxa27x-camera.0: PXA Camera driver detached
> from camera 0
> [   34.447069] pxa27x-camera pxa27x-camera.0: PXA Camera driver attached
> to camera 0
> [   34.454755] *** tvp5150_try_fmt 2
> [   34.458053] pxa27x-camera pxa27x-camera.0: Field type 9 unsupported.
> [   34.464393] pxa27x-camera pxa27x-camera.0: PXA Camera driver detached
> from camera 0
> 
> 
> I am completely stuck at this, so I have some questions:
> - is kernel version 2.6.35 good for using tvp5150 driver?

No

> - do I need to have V2L to get out an image from tvp5150?

You mean V4L2? Yes, the pxa_camera is a V4L2 driver (an soc-camera V4L2 
driver, to be more precise, more about this later).

> - which settings are missing in this driver?

Not settings, but support for the V4L2_FIELD_INTERLACED_BT type - type 9 
above. This type is currently not supported by the driver.

> - does anybody have seen a tvp5150 working with a PXA270 earlier?

Don't think so.

> # ./v4l2-ctl --all
> [ 2195.222443] pxa27x-camera pxa27x-camera.0: PXA Camera driver attached
> to camera 0
> [ 2195.230247] *** tvp5150_try_fmt 2
> [ 2195.234032] pxa27x-camera pxa27x-camera.0: Field type 9 unsupported.
> [ 2195.240473] pxa27x-camera pxa27x-camera.0: PXA Camera driver detached
> from camera 0
> Failed to open /dev/video0: Invalid argument
> 
> 
> Any hint would be greatly appreciated, if you need more details please ask.

pxa_camera is an soc-camera driver, which means up to now it has only been 
used with sensor drivers, also originally written for the soc-camera 
framework. At least off the top of my head I cannot remember any reports 
about it being used with other sensor drivers - even less so without any 
modifications. The soc-camera framework has recently undergone a number of 
changes to make it compatible with other (v4l2-subdevice) drivers, and 
there have been several more or less successful attempts to use various 
combinations of soc-camera and generic drivers, but I'm not sure, whether 
any of them have been successful with unmodified mainline drivers.

So, in short, you need two things:

1. Teach the pxa-camera driver to work with the V4L2_FIELD_SEQ_TB 
interlacing type, because that's what the tvp5150 driver is sending. 
There's even a comment currently there:
	/* TODO: support interlaced at least in pass-through mode */
BTW, I don't understand why v4l2-ctl insists on using 
V4L2_FIELD_INTERLACED_BT, maybe there's a parameter to use a different 
type.
2. Verify, whether this combination is working, perform any additionally 
necessary modifications.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
