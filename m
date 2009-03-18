Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41087 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750782AbZCRIFF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2009 04:05:05 -0400
Date: Wed, 18 Mar 2009 09:05:08 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: soc-camera -> v4l2-device: possible API extension requirements
Message-ID: <Pine.LNX.4.64.0903180830190.4262@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

I am doing the first step of the soc-camera integration with your 
v4l2-device API. As discussed on IRC, this first step changes the probing 
/ releasing procedures in soc-camera to match v4l2-device expectations. 
While at it I came across a few points in your current API, which might 
need to be changed to be used with soc-camera, or maybe I just 
misunderstand something and you will be able to resolve my questions:

1. this can be kept, maybe, just it doesn't seem very comfortable to me: 
the fact that v4l2_i2c_new_subdev() relies on loading of the i2c driver 
for the subdevice. First, you put the call to request_module() under 
#ifdef MODULE
which means, if v4l2-common.c is compiled as a module, it will also assume 
that the i2c subdevice driver is a module, which doesn't have to be the 
case. Secondly, this means manual unloading and loading of the module at a 
later time will be impossible. No, I do not know why one would need this - 
apart from during development. But even the inability to do this during 
driver development already makes this questionable, IMHO. The only way I 
see possible so far, is, for example, if I have the pxa-camera driver and 
a sensor driver, then I can first unload the pxa-camera driver, which 
should cause v4l2_device_unregister_subdev() to be called, then unload the 
sensor driver, then load the pxa-camera driver again, which should then 
auto-load the sensor driver.

2. In a comment you write to v4l2_i2c_new_subdev():
/* Load an i2c sub-device. It assumes that i2c_get_adapdata(adapter)
   returns the v4l2_device and that i2c_get_clientdata(client)
   returns the v4l2_subdev. */
I don't think this is possible with generic SoC i2c adapters. On 
soc-camera systems v4l2 subdevices are connected to generic i2c busses, 
so, you cannot require, that "i2c_get_adapdata(adapter) returns the 
v4l2_device."

3. Currently soc-camera works in a way, that during probing of an i2c 
(sub)device, the Master Clock of the host camera interface is turned on, 
after the probing it is turned off again. Then it is turned on at first 
open() and off at last close(). This should also be possible with the 
module autoloading in v4l2_i2c_new_subdev(), but this adds even more 
fragileness to the system.

I think, a simple addition to the v4l2-device API could solve this 
problems and make the API more transparent:

1. "hi, I am driver X's probing routine, going to probe device Y, please, 
turn it on" (action: master clock on)

2. "probing for device Y completed (un)successfully" (action: master clock 
off, if successful - create /dev/videoY)

3. "driver X is being unloaded, I am releasing device Y" (action: rip 
/dev/videoY)

We could agree on keeping /dev/videoY even when no sensor driver is 
present and just return -ENODEV on open(), and thus simplify the above but 
I am not sure if this is desired.

I am sure I will have more questions or suggestions, I will keep posting 
to this thread as they appear.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
