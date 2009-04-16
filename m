Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43898 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757687AbZDPTUk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2009 15:20:40 -0400
Date: Thu, 16 Apr 2009 21:20:38 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: soc-camera to v4l2-subdev conversion
Message-ID: <Pine.LNX.4.64.0904071122511.5155@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

I have so far partially converted a couple of example setups, namely the 
i.MX31-based pcm037/pcm970 and PXA270-based pcm027/pcm990 boards.

Partially means, that I use v4l2_i2c_new_subdev() to register new cameras 
and v4l2_device_register() to register hosts, I use some core and video 
operations, but there are still quite a few extra bonds that tie camera 
drivers and soc-camera core, that have to be broken. The current diff is 
at http://download.open-technology.de/testing/20090416-4.gitdiff, 
although, you, probably, don't want to look at it:-)

A couple of minor general remarks first:

Shouldn't v4l2_device_call_until_err() return an error if the call is 
unimplemented?

There's no counterpart to v4l2_i2c_new_subdev() in the API, so one is 
supposed to call i2c_unregister_device() directly?

We'll have to extend v4l2_subdev_video_ops with [gs]_crop.

Now I'm thinking about how best to break those remaining ties in 
soc-camera. The remaining bindings that have to be torn are in 
struct soc_camera_device. Mostly these are:

1. current geometry and geometry limits - as seen on the canera host - 
camera client interfase. I think, these are common to all video devices, 
so, maybe we could put them meaningfully in a struct video_data, 
accessible for both v4l2 subdevices and devices - one per subdevice?

2. current exposure and gain. There are of course other video parameters 
similar to these, like gamma, saturation, hue... Actually, these are only 
needed in the sensor driver, the only reason why I keep them globally 
available it to reply to V4L2_CID_GAIN and V4L2_CID_EXPOSURE G_CTRL 
requests. So, if I pass these down to the sensor drivers just like all 
other control requests, they can be removed from soc_camera_device.

3. format negotiation. This is a pretty important part of the soc-camera 
framework. Currently, sensor drivers provide a list of supported pixel 
formats, based on it camera host drivers build translation tables and 
calculate user pixel formats. I'd like to preserve this functionality in 
some form. I think, we could make an optional common data block, which, if 
available, can be used also for the format negotiation and conversion. If 
it is not available, I could just pass format requests one-to-one down to 
sensor drivers.

Maybe a more universal approach would be to just keep "synthetic" formats 
in each camera host driver. Then, on any format request first just request 
it from the sensor trying to pass it one-to-one to the user. If this 
doesn't work, look through the possible conversion table, if the requested 
format is found among output formats, try to request all input formats, 
that can be converted to it, one by one from the sensor. Hm...

4. bus parameter negotiation. Also an important thing. Should do the same: 
if available - use it, if not - use platform-provided defaults.

I think, I just finalise this partial conversion and we commit it, because 
if I keep it locally for too long, I'll be getting multiple merge 
conflicts, because this conversion also touches platform code... Then, 
when the first step is in the tree we can work on breaking the remaining 
bonds.

Ideas? Comments?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
