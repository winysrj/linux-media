Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:37094 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656Ab0JGNw0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Oct 2010 09:52:26 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
CC: Bastian Hecht <hechtb@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Thu, 7 Oct 2010 19:22:02 +0530
Subject: RE: OMAP 3530 camera ISP forks and new media framework
Message-ID: <19F8576C6E063C45BE387C64729E739404AA21D15A@dbde02.ent.ti.com>
References: <AANLkTimyR117ZiHq8GFz4YW5tBtW3k82NzGVZqKoVTbY@mail.gmail.com>
 <4CADA7ED.5020604@maxwell.research.nokia.com>
 <201010071527.41438.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201010071527.41438.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> Sent: Thursday, October 07, 2010 6:58 PM
> To: Sakari Ailus
> Cc: Bastian Hecht; Linux Media Mailing List
> Subject: Re: OMAP 3530 camera ISP forks and new media framework
> 
> Hi Bastian,
> 
> On Thursday 07 October 2010 12:58:53 Sakari Ailus wrote:
> > Bastian Hecht wrote:
> >
> > > I want to write a sensor driver for the mt9p031 (not mt9t031) camera
> > > chip and start getting confused about the different kernel forks and
> > > architectural changes that happen in V4L2.
> > > A similar problem was discussed in this mailing list at
> > > http://www.mail-archive.com/linux-media@vger.kernel.org/msg19084.html.
> > >
> > > Currently I don't know which branch to follow. Either
> > > http://gitorious.org/omap3camera from Sakari Ailus or the branch
> > > media-0004-omap3isp at http://git.linuxtv.org/pinchartl/media.git from
> > > Laurent Pinchart. Both have an folder drivers/media/video/isp and are
> > > written for the new media controller architecture if I am right.
> >
> > Take Laurent's branch it has all the current patches in it. My gitorious
> > tree isn't updated anymore. (I just had forgotten to add a note, it's
> > there now.)
> >
> > > I see in http://gitorious.org/omap3camera/camera-firmware that there
> > > is already an empty placeholder for the mt9t031.
> > > The README of the camera-firmware repository states: "makemodes.pl is
> > > a perl script which converts sensor register lists from FIXME into C
> > > code. dcc-pulautin is a Makefile (mostly) that converts sensor
> > > register lists as C code into binaries understandable to sensor
> > > drivers. The end result is a binary with sensor driver name, sensor
> > > version and bin suffix, for example et8ek8-0002.bin."
> > >
> > > So I think the goal is to provide a script framework for camera
> > > systems. You just script some register tables and it creates a binary
> > > that can be read by a sensor driver made for that framework. If the a
> > > camera bridge driver for your chip exists, you are done. Am I right?
> > > Are drivers/media/video/et8ek8.c and
> > > drivers/staging/dream/camera/mt9p012_* such drivers?
> >
> > et8ek8 and smia-sensor currently use the camera-firmware binaries. The
> > long term goal is to move more things to the sensor driver itself.
> > Register lists related to a set of sensor settings are not an ideal way
> > to handle sensor related settings since they could be controlled the
> > driver instead.
> 
> To be compatible with the OMAP3 ISP driver, sensor drivers need to provide
> a
> v4l2_subdev interface and implement the pad-level operations (see the
> media-0003-subdev-pad branch in the repository).
> 
> I've written such a driver for the MT9T001. I've pushed it to the media-
> mt9t001 branch on http://git.linuxtv.org/pinchartl/media.git. Please note
> that
> the driver is based on a previous version of the subdev pad-level
> operations
> API, so it won't compile out of the box.
> 


Just to add ontop of this, you can find couple of more sensor (MT9V113 & MT9T111) sub-dev driver at 

http://arago-project.org/git/people/vaibhav/ti-psp-omap-video.git?p=people/vaibhav/ti-psp-omap-video.git;a=shortlog;h=refs/heads/omap3cam-mc-devel


Also I have already ported these sensor drivers to latest sub-dev pad level operations but have not tested and pushed to the Repository which I will do by this weekend.

Thanks,
Vaibhav

> As Sakari stated, the camera-firmware system shouldn't be used by new
> drivers.
> The driver should instead compute the register values directly from the
> information supplied by userspace (through the v4l2_subdev API) such as
> the
> frame size and the crop rectangle. Binary lists of register address/value
> pairs are definitely not the way to go.
> 
> > > So do you think it is the right way to go to use your ISP driver,
> > > adapt drivers/staging/dream/camera/mt9p012_* to suit my mt9p031 and
> > > write a register list and create a camera firmware for that sensor
> > > driver with makemodes?
> >
> > I would go with drivers/media/video/et8ek8.c in Laurent's tree instead
> > if you want to write a sensor driver to be used with the OMAP 3 ISP
> > driver. Register lists are not that nice but the v4l2_subdev interface
> > in that one is one of the good parts you get with that.
> 
> Start with the MT9T001 driver, that will be easier.
> 
> > I'd also advice against using camera-firmware if you don't necessarily
> > need that kind of functionality.
> 
> I'd very strongly advice against it as well. Try to forget it even exists,
> it
> was a development mistake :-)
> 
> > > I am still quite confused... if I get something wrong, please give me
> > > some hints.
> >
> > I hope this helped. :-)
> >
> > If you have any further questions feel free to ask.
> 
> Ditto :-)
> 
> --
> Regards,
> 
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
