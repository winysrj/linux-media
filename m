Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([192.100.105.134]:43287 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab0JGK7q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Oct 2010 06:59:46 -0400
Message-ID: <4CADA7ED.5020604@maxwell.research.nokia.com>
Date: Thu, 07 Oct 2010 13:58:53 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Bastian Hecht <hechtb@googlemail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	laurent.pinchart@ideasonboard.com
Subject: Re: OMAP 3530 camera ISP forks and new media framework
References: <AANLkTimyR117ZiHq8GFz4YW5tBtW3k82NzGVZqKoVTbY@mail.gmail.com>
In-Reply-To: <AANLkTimyR117ZiHq8GFz4YW5tBtW3k82NzGVZqKoVTbY@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Bastian Hecht wrote:
> Hello media team,

Hi Bastian,

> I want to write a sensor driver for the mt9p031 (not mt9t031) camera
> chip and start getting confused about the different kernel forks and
> architectural changes that happen in V4L2.
> A similar problem was discussed in this mailing list at
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg19084.html.
> 
> Currently I don't know which branch to follow. Either
> http://gitorious.org/omap3camera from Sakari Ailus or the branch
> media-0004-omap3isp at http://git.linuxtv.org/pinchartl/media.git from
> Laurent Pinchart. Both have an folder drivers/media/video/isp and are
> written for the new media controller architecture if I am right.

Take Laurent's branch it has all the current patches in it. My gitorious
tree isn't updated anymore. (I just had forgotten to add a note, it's
there now.)

> I see in http://gitorious.org/omap3camera/camera-firmware that there
> is already an empty placeholder for the mt9t031.
> The README of the camera-firmware repository states: "makemodes.pl is
> a perl script which converts sensor register lists from FIXME into C
> code. dcc-pulautin is a Makefile (mostly) that converts sensor
> register lists as C code into binaries understandable to sensor
> drivers. The end result is a binary with sensor driver name, sensor
> version and bin suffix, for example et8ek8-0002.bin."
> 
> So I think the goal is to provide a script framework for camera
> systems. You just script some register tables and it creates a binary
> that can be read by a sensor driver made for that framework. If the a
> camera bridge driver for your chip exists, you are done. Am I right?
> Are drivers/media/video/et8ek8.c and
> drivers/staging/dream/camera/mt9p012_* such drivers?

et8ek8 and smia-sensor currently use the camera-firmware binaries. The
long term goal is to move more things to the sensor driver itself.
Register lists related to a set of sensor settings are not an ideal way
to handle sensor related settings since they could be controlled the
driver instead.

> So do you think it is the right way to go to use your ISP driver,
> adapt drivers/staging/dream/camera/mt9p012_* to suit my mt9p031 and
> write a register list and create a camera firmware for that sensor
> driver with makemodes?

I would go with drivers/media/video/et8ek8.c in Laurent's tree instead
if you want to write a sensor driver to be used with the OMAP 3 ISP
driver. Register lists are not that nice but the v4l2_subdev interface
in that one is one of the good parts you get with that.

I'd also advice against using camera-firmware if you don't necessarily
need that kind of functionality.

> I am still quite confused... if I get something wrong, please give me
> some hints.

I hope this helped. :-)

If you have any further questions feel free to ask.

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
