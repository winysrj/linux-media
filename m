Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59160 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122AbaFEAcQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jun 2014 20:32:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH] [media] mt9v032: Add support for mt9v022 and mt9v024
Date: Thu, 05 Jun 2014 02:32:43 +0200
Message-ID: <2220526.Gex9TTdQJL@avalon>
In-Reply-To: <1401787831.3434.12.camel@paszta.hi.pengutronix.de>
References: <1401112985-32338-1-git-send-email-p.zabel@pengutronix.de> <7046827.ExJCarEAac@avalon> <1401787831.3434.12.camel@paszta.hi.pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Tuesday 03 June 2014 11:30:31 Philipp Zabel wrote:
> Am Mittwoch, den 28.05.2014, 16:44 +0200 schrieb Laurent Pinchart:
> > If you had submitted an entirely new driver for a sensor already supported
> > by an soc-camera sensor driver, I would have told you to fix the problem
> > on soc- camera side. As you're only expanding hardware support for an
> > existing driver, it's hard to nack your patch in all fairness :-) I will
> > thus not veto option 2, even though I would prefer if we fixed the
> > problem once and for all.
> >
> > > > > I'm ok with either 1 or 3, whereas 3 is
> > > > > more difficult than 1.
> > > > 
> > > > This topic has been discussed over and over. It indeed "just" requires
> > > > someone to do it, although it might be more complex than that sounds.
> > > > 
> > > > We need to fix the infrastructure to make sensor drivers completely
> > > > unaware of soc-camera. This isn't about extending the mt9v022 driver
> > > > to work with non soc-camera hosts, it's about fixing soc-camera not to
> > > > require any change to sensor drivers. Philipp, if you have time to
> > > > work on that, we can discuss what needs to be done.
> 
> What steps would need to be taken to make soc_camera work with the
> non-soc_camera drivers in drivers/media/i2c?

Guennadi, what's the status of your work on this ? What remains to be done ?

The soc-camera core provides several helper functions for subdev drivers, and 
expects the subdev drivers to implement bus configuration negotiation with the 
g_mbus_config and s_mbus_config subdev operations.

If you look at the mt9v022 driver, the helper functions used are

- soc_camera_limit_side
- soc_mbus_get_fmtdesc
- soc_camera_set_power
- soc_camera_apply_board_flags

The first two functions are general purpose helpers that could be standardized 
and moved to the v4l core, or even left in soc-camera for now as they don't 
depend on the bridge driver being compatible with soc-camera.

The last two functions are mostly self-contained as well, but depend on the 
I2C sensor device using a soc-camera structure (soc_camera_subdev_desc) for 
its platform data. That structure contains field that are common across many 
sensors, as well as a pointer to a sensor-specific platform data structure. 
The common structure is then passed to various helper functions by the sensor 
driver.

That's something I would like to see being changed, the sensor should use a 
custom structure for its platform data. If the sensor drivers wants to use the 
soc-camera helpers that don't depend on the host-side of soc-camera, it could 
then embed a soc-camera platform data structure inside its own platform data 
structure, and pass a pointer to that embedded structure to the soc-camera 
helpers.

Another point that needs to be fixed is that soc-camera performs several 
initialization steps for the sensor before probing it, such as calling 
devm_regulator_bulk_get() to retrieve the sensor regulators. Those steps 
require the sensor to use the struct soc_camera_subdev_desc as platform data. 
This should be changed as well, sensor drivers should call a soc-camera helper 
function explicitly from their probe function to perform the same task.

I don't remember the details of how soc-camera handles [gs]_mbus_config, but 
changes might be needed there as well.

That's more or less what I see needing to be fixed. Guennadi, please feel free 
to correct me.

> I don't have any soc_camera platform at hand, although I could try to revive
> a PXA270 board.
> 
> > > I don't have a use case for soc_camera. Instead of trying to fix it to
> > > use generic sensor drivers, I'd rather use that time to prepare
> > > non-soc_camera capture host support.
> > 
> > Which host would that be, if you can tell ?
> 
> Yes, i.MX6.
> 
> > > > On the sensor side, we should have a single driver for the mt9v022,
> > > > 024 and 032 sensors. I would vote for merging the two drivers into
> > > > drivers/media/i2c/mt9v032.c, as that one is closer to the goal of not
> > > > being soc-camera specific.

-- 
Regards,

Laurent Pinchart

