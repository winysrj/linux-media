Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:39596 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab0JGN1d (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Oct 2010 09:27:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: OMAP 3530 camera ISP forks and new media framework
Date: Thu, 7 Oct 2010 15:27:40 +0200
Cc: Bastian Hecht <hechtb@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <AANLkTimyR117ZiHq8GFz4YW5tBtW3k82NzGVZqKoVTbY@mail.gmail.com> <4CADA7ED.5020604@maxwell.research.nokia.com>
In-Reply-To: <4CADA7ED.5020604@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010071527.41438.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bastian,

On Thursday 07 October 2010 12:58:53 Sakari Ailus wrote:
> Bastian Hecht wrote:
>
> > I want to write a sensor driver for the mt9p031 (not mt9t031) camera
> > chip and start getting confused about the different kernel forks and
> > architectural changes that happen in V4L2.
> > A similar problem was discussed in this mailing list at
> > http://www.mail-archive.com/linux-media@vger.kernel.org/msg19084.html.
> > 
> > Currently I don't know which branch to follow. Either
> > http://gitorious.org/omap3camera from Sakari Ailus or the branch
> > media-0004-omap3isp at http://git.linuxtv.org/pinchartl/media.git from
> > Laurent Pinchart. Both have an folder drivers/media/video/isp and are
> > written for the new media controller architecture if I am right.
> 
> Take Laurent's branch it has all the current patches in it. My gitorious
> tree isn't updated anymore. (I just had forgotten to add a note, it's
> there now.)
> 
> > I see in http://gitorious.org/omap3camera/camera-firmware that there
> > is already an empty placeholder for the mt9t031.
> > The README of the camera-firmware repository states: "makemodes.pl is
> > a perl script which converts sensor register lists from FIXME into C
> > code. dcc-pulautin is a Makefile (mostly) that converts sensor
> > register lists as C code into binaries understandable to sensor
> > drivers. The end result is a binary with sensor driver name, sensor
> > version and bin suffix, for example et8ek8-0002.bin."
> > 
> > So I think the goal is to provide a script framework for camera
> > systems. You just script some register tables and it creates a binary
> > that can be read by a sensor driver made for that framework. If the a
> > camera bridge driver for your chip exists, you are done. Am I right?
> > Are drivers/media/video/et8ek8.c and
> > drivers/staging/dream/camera/mt9p012_* such drivers?
> 
> et8ek8 and smia-sensor currently use the camera-firmware binaries. The
> long term goal is to move more things to the sensor driver itself.
> Register lists related to a set of sensor settings are not an ideal way
> to handle sensor related settings since they could be controlled the
> driver instead.

To be compatible with the OMAP3 ISP driver, sensor drivers need to provide a 
v4l2_subdev interface and implement the pad-level operations (see the 
media-0003-subdev-pad branch in the repository).

I've written such a driver for the MT9T001. I've pushed it to the media-
mt9t001 branch on http://git.linuxtv.org/pinchartl/media.git. Please note that 
the driver is based on a previous version of the subdev pad-level operations 
API, so it won't compile out of the box.

As Sakari stated, the camera-firmware system shouldn't be used by new drivers. 
The driver should instead compute the register values directly from the 
information supplied by userspace (through the v4l2_subdev API) such as the 
frame size and the crop rectangle. Binary lists of register address/value 
pairs are definitely not the way to go.

> > So do you think it is the right way to go to use your ISP driver,
> > adapt drivers/staging/dream/camera/mt9p012_* to suit my mt9p031 and
> > write a register list and create a camera firmware for that sensor
> > driver with makemodes?
> 
> I would go with drivers/media/video/et8ek8.c in Laurent's tree instead
> if you want to write a sensor driver to be used with the OMAP 3 ISP
> driver. Register lists are not that nice but the v4l2_subdev interface
> in that one is one of the good parts you get with that.

Start with the MT9T001 driver, that will be easier.

> I'd also advice against using camera-firmware if you don't necessarily
> need that kind of functionality.

I'd very strongly advice against it as well. Try to forget it even exists, it 
was a development mistake :-)

> > I am still quite confused... if I get something wrong, please give me
> > some hints.
> 
> I hope this helped. :-)
> 
> If you have any further questions feel free to ask.

Ditto :-)

-- 
Regards,

Laurent Pinchart
