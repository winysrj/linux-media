Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34286 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab0JKM7R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 08:59:17 -0400
Received: by ewy20 with SMTP id 20so555726ewy.19
        for <linux-media@vger.kernel.org>; Mon, 11 Oct 2010 05:59:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1010072012280.15141@axis700.grange>
References: <AANLkTimyR117ZiHq8GFz4YW5tBtW3k82NzGVZqKoVTbY@mail.gmail.com>
	<4CADA7ED.5020604@maxwell.research.nokia.com>
	<201010071527.41438.laurent.pinchart@ideasonboard.com>
	<19F8576C6E063C45BE387C64729E739404AA21D15A@dbde02.ent.ti.com>
	<Pine.LNX.4.64.1010072012280.15141@axis700.grange>
Date: Mon, 11 Oct 2010 14:59:15 +0200
Message-ID: <AANLkTinJhywDoZg5F2tvqdW44to-6P4hgNd9Fav9qTv8@mail.gmail.com>
Subject: Re: OMAP 3530 camera ISP forks and new media framework
From: Bastian Hecht <hechtb@googlemail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

So... let's see if i got some things right, please let me now if you disagree:

- I do want to use the omap34xxcam.c driver as it is for the newest
framework and I get most support for it

- The camera sensor driver must implement the v4l2-subdev and the new
pad-level api. As the register list of mt9t031 and mt9p031 sensors are
identical, I could copy the subdev-part. But the existing mt9t031
driver stacks on top of soc_camera. soc_camera creates a v4l2 device.
omap34xxcam also creates a v4l2 dev. Obviously they are competing
architectures.
Guennadi wrote:
> There is already an mt9t031 v4l2-subdev / soc-camera driver, so, if
> mt9t031 and mt9p031 are indeed similar enough, I think, the right way is
> to join efforts to port soc-camera over to the new "pad-level" API and
> re-use the driver.
This confuses me a bit now. Guennadi, is your idea to update the
soc_camera interface for pad-level support and port omap34xxcam to a
soc_camera_omap34xxcam?
I don't think I am capable of writing a new host bridge driver, so I
would prefer touching only the sensor driver part. Or do you think it
is better to remove the soc_camera dependency and fit the camera
sensor driver to omap34xxcam directly?

- If I do the later, I take Laurent's approach and look at his MT9T001
sensor driver for Sakari's omap34xxcam host driver and adapt it for my
needs. I can look for more subdev pad-level examples in Vaibhav's
repository.


So long, thanks for all your help,

Bastian
