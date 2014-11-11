Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate15.nvidia.com ([216.228.121.64]:10223 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaKKWrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 17:47:17 -0500
From: Andrew Chew <AChew@nvidia.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "Pawel Osciak (posciak@google.com)" <posciak@google.com>,
	Bryan Wu <pengw@nvidia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: RE: soc-camera and focuser vcm devices
Date: Tue, 11 Nov 2014 22:47:16 +0000
Message-ID: <aa7f6152c4a7416eb8b7f374f69a6ef4@HQMAIL103.nvidia.com>
References: <804f809f79cf4e5ca24ec02be61402bd@HQMAIL103.nvidia.com>
 <Pine.LNX.4.64.1411062304450.25946@axis700.grange>
 <c0b17f2320f74b0f96b2618a2d9e15d4@HQMAIL103.nvidia.com>
 <Pine.LNX.4.64.1411072143470.4252@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1411072143470.4252@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> > I think I get it, but just to clarify...currently, I'm going with the
> > patch in [1], and I currently have multiple subdevs (sensors) hooked
> > up and working with my soc-camera host driver.  [2] was an alternate
> > implementation, right? (as in, I don't need it).
> 
> No. [1] you don't need, it is already in the mainline, resp. its slightly updated
> version. I only quoted that thread for you above to read explanations about
> why that implementation didn't support multiple subdevices per host. To fix
> that support for multiple devices should be added to the current soc-camera
> mainline. To help with this task I quoted [2], which is my very early
> implementation attempt. [3] is just some more reading for general
> understanding.
> 
> > So I understand that I can just hook up the focuser and flash subdevs
> > to the camera host via device tree, in the same exact way of using the
> > of_graph stuff to hook up the sensor subdev.  My question is, is it
> > then left up to the camera host driver to make sense of which subdevs
> > do what?  Or should/will there be a common mechanism to bind ports on
> > a camera host to a sensor, focuser, and flash under a common group
> > which makes up an image pipeline?
> 
> Exactly, that's why you need multiple subdevices in groups, to have the
> whole pipeline probe only after all subdevices are available.

Thanks, Guennadi.  I think I'm still misunderstanding something, since I basically took
[1], and am now (with a tiny modification of removing the hardcoded snippet of code
that explicitly prevented multiple subdevs from getting probed) able to instantiate
two sensors, both going through the camera host driver (i.e. I have /dev/video0 and
/dev/video1 both able to capture from each sensor, going through the same camera
host).

The part I don't understand is specifically how subdevs like focusers and flash
devices are supposed to work.  In examining the behavior of soc-camera more
closely after I add my focuser subdev, it seems that there is this general assumption
that all subdevs are image capture devices (because the subdev probe process
finishes around soc_camera_probe_finish(), which tries (and fails with the focuser)
to get supported capture formats.

But maybe I'm misunderstanding how focuser and flash devices are intended to be
Implemented?  I was under the impression that a focuser driver looks pretty much like
a sensor driver (as in, it eventually calls v4l2_i2c_subdev_init() and
v4l2_async_register_subdev().  In my case, the focuser's v4l2_async_register_subdev()
call fails because soc_camera_probe_finish() failed its soc_camera_init_user_formats().

Soc_camera_init_user_formats() calls into the camera host driver's get_formats(), which
tries to call the subdev's enum_mbus_fmt method.  Of course, the focuser subdev
doesn't implement this method, so it fails.  Even if I changed the camera host driver so
that it does something special with this subdev, the end result seems to me that we'll
get a /dev/video2 for the focuser, which isn't the behavior we want (we want the focuser
subdev to be available to the camera host, but it doesn't represent its own image
capture entity).

So what is the proper thing to do with the focuser driver to get it somehow aggregated
with a particular sensor subdev?  Or is this something that the soc-camera framework
doesn't define?  I don't see any example focuser drivers to go by, so this is all new to me.
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
