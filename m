Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42145 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab3AHVP2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 16:15:28 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH 1/6 v4] media: V4L2: support asynchronous subdevice registration
Date: Tue, 08 Jan 2013 22:17:04 +0100
Message-ID: <2355561.FXtSNCeHWa@avalon>
In-Reply-To: <20130108131544.GI13641@valkosipuli.retiisi.org.uk>
References: <1356544151-6313-1-git-send-email-g.liakhovetski@gmx.de> <1446871.ydXdxJD4sK@avalon> <20130108131544.GI13641@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday 08 January 2013 15:15:44 Sakari Ailus wrote:
> On Tue, Jan 08, 2013 at 01:41:59PM +0100, Laurent Pinchart wrote:
> > On Tuesday 08 January 2013 12:37:36 Sylwester Nawrocki wrote:
> > > On 01/08/2013 11:35 AM, Laurent Pinchart wrote:
> > > >>>>> If we need a workaround, I'd rather pass the device name in
> > > >>>>> addition to the I2C adapter number and address, instead of
> > > >>>>> embedding the workaround in this new API.
> > > >>>> 
> > > >>>> ...or we can change the I2C subdevice name format. The actual need
> > > >>>> to do
> > > >>>> 
> > > >>>> 	snprintf(clk_name, sizeof(clk_name), "%s %d-%04x",
> > > >>>> 		 asdl->dev->driver->name,
> > > >>>> 		 i2c_adapter_id(client->adapter), client->addr);
> > > >>>> 
> > > >>>> in soc-camera now to exactly match the subdevice name, as created
> > > >>>> by v4l2_i2c_subdev_init(), doesn't make me specifically happy
> > > >>>> either. What if the latter changes at some point? Or what if one
> > > >>>> driver wishes to create several subdevices for one I2C device?
> > > >>> 
> > > >>> The common clock framework uses %d-%04x, maybe we could use that as
> > > >>> well for clock names ?
> > > >> 
> > > >> And preserve the subdevice names? Then matching would be more
> > > >> difficult and less precise. Or change subdevice names too? I think,
> > > >> we can do the latter, since anyway at any time only one driver can be
> > > >> attached to an I2C device.
> > > > 
> > > > That's right. Where else is the subdev name used ?
> > > 
> > > Subdev names are exposed to user space by the media controller API.
> > > So they are really part of an ABI, aren't they ?
> > 
> > They're used to construct the name exposed to userspace, but the media
> > controller core could probably handle that internally by concatenating the
> > driver name and the subdev name.
> > 
> > > Also having I2C bus number or I2C slave address as part of the subdev
> > > name makes it more difficult to write portable applications. Hence
> > > in sensor drivers I used to overwrite subdev name to remove I2C bus
> > > and slave address, as the format used v4l2_i2c_subdev_init() seemed
> > > highly unsuitable..
> > 
> > This clearly shows that we need to discuss the matter and agree on a
> > common mode of operation.
> > 
> > Aren't applications that use the subdev name directly inherently
> > non-portable anyway ? If you want your application to support different
> > boards/sensors/SoCs
>
> Well, the name could come from a configuration file to distinguish e.g.
> between primary and secondary sensors.

In that case having the I2C bus number and address in the name doesn't create 
an extra portability issue, does it ?
 
> For what it's worth, the SMIA++ driver uses the actual name of the sensor
> since there are about 10 sensors supported at the moment, and calling them
> all smiapp-xxxx looks a bit insipid. So one has to talk to the sensor to
> know what it's called.
> 
> This isn't strictly mandatory but a nice feature.
> 
> > you should discover the pipeline and find the sensor by iterating over
> > entities, instead of using the sensor entity name.
> 
> To be fully generic, yes.

-- 
Regards,

Laurent Pinchart

