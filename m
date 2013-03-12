Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:56506 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab3CLRAF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Mar 2013 13:00:05 -0400
Date: Tue, 12 Mar 2013 17:59:57 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: V4L2 subdevice naming (was Re: [PATCH 1/6 v4] media: V4L2: support
 asynchronous subdevice registration)
In-Reply-To: <2355561.FXtSNCeHWa@avalon>
Message-ID: <Pine.LNX.4.64.1303121723470.680@axis700.grange>
References: <1356544151-6313-1-git-send-email-g.liakhovetski@gmx.de>
 <1446871.ydXdxJD4sK@avalon> <20130108131544.GI13641@valkosipuli.retiisi.org.uk>
 <2355561.FXtSNCeHWa@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

(this is a _conscious_ case of top-posting, hopefully a justified one :-) )

The discussion, I'd like to continue here is pretty old (2 months), so, 
instead of asking everyone to go and re-read the thread, I'll try to 
summarise the problem here and encourage everyone to contribute to a final 
solution :-)

The last version of my "asynchronous V4L2 subdevice registration" patch 
stumbled upon a problem of V4L2 clock naming, which has to match a 
subdevice name. Currently on I2C subdevice names are produced per

	snprintf(clk_name, sizeof(clk_name), "%s %d-%04x",
		 client->dev.driver->name,
		 i2c_adapter_id(client->adapter), client->addr);

The problem with this is, that to match this name in a V4L2 clock, the 
clock provider (typically a V4L2 bridge driver) has to know the name of a 
driver, that is going to bind to the I2C device. Normally bridge drivers 
don't have that information, so, it either has to be provided to them 
additionally beforehand, or they have to wait until an I2C driver has 
been bound to the I2C device. Both these options are inconvenient.

We can now decide to drop the driver name from the subdevice name, but 
subdevice names are exposed to the user-space. It is possible, that 
user-space software exists, that relies on specific subdevice names. If we 
change them, that software can break. A possible solution would be to 
remove the driver name from the subdevice name for internal purposes, but 
to re-add it, when exposing to the user-space.

We can also leave the name as is and relax the clock matching criteria: 
instead of a full string match we can match a substring and verify, that 
the matching part is at the end of the name. We could even actually 
produce the complete name by prepending the driver name in the V4L2 clock 
helpers, but that would make the helpers aware of V4L2 subdevice 
internals, which isn't very good either.

Also note, that non-standard subdevice names are possible, there are also 
non-I2C subdevices, multiple subdevices per I2C device are also a 
possibility. So, maybe explicitly passing a device name from board data, 
similarly to how the clock API does that, is indeed the best option.

I'll keep an original message quoted below for now, in case someone wants 
to through a glance, but feel free to remove it when replying.

Thanks
Guennadi

On Tue, 8 Jan 2013, Laurent Pinchart wrote:

> Hi Sakari,
> 
> On Tuesday 08 January 2013 15:15:44 Sakari Ailus wrote:
> > On Tue, Jan 08, 2013 at 01:41:59PM +0100, Laurent Pinchart wrote:
> > > On Tuesday 08 January 2013 12:37:36 Sylwester Nawrocki wrote:
> > > > On 01/08/2013 11:35 AM, Laurent Pinchart wrote:
> > > > >>>>> If we need a workaround, I'd rather pass the device name in
> > > > >>>>> addition to the I2C adapter number and address, instead of
> > > > >>>>> embedding the workaround in this new API.
> > > > >>>> 
> > > > >>>> ...or we can change the I2C subdevice name format. The actual need
> > > > >>>> to do
> > > > >>>> 
> > > > >>>> 	snprintf(clk_name, sizeof(clk_name), "%s %d-%04x",
> > > > >>>> 		 asdl->dev->driver->name,
> > > > >>>> 		 i2c_adapter_id(client->adapter), client->addr);
> > > > >>>> 
> > > > >>>> in soc-camera now to exactly match the subdevice name, as created
> > > > >>>> by v4l2_i2c_subdev_init(), doesn't make me specifically happy
> > > > >>>> either. What if the latter changes at some point? Or what if one
> > > > >>>> driver wishes to create several subdevices for one I2C device?
> > > > >>> 
> > > > >>> The common clock framework uses %d-%04x, maybe we could use that as
> > > > >>> well for clock names ?
> > > > >> 
> > > > >> And preserve the subdevice names? Then matching would be more
> > > > >> difficult and less precise. Or change subdevice names too? I think,
> > > > >> we can do the latter, since anyway at any time only one driver can be
> > > > >> attached to an I2C device.
> > > > > 
> > > > > That's right. Where else is the subdev name used ?
> > > > 
> > > > Subdev names are exposed to user space by the media controller API.
> > > > So they are really part of an ABI, aren't they ?
> > > 
> > > They're used to construct the name exposed to userspace, but the media
> > > controller core could probably handle that internally by concatenating the
> > > driver name and the subdev name.
> > > 
> > > > Also having I2C bus number or I2C slave address as part of the subdev
> > > > name makes it more difficult to write portable applications. Hence
> > > > in sensor drivers I used to overwrite subdev name to remove I2C bus
> > > > and slave address, as the format used v4l2_i2c_subdev_init() seemed
> > > > highly unsuitable..
> > > 
> > > This clearly shows that we need to discuss the matter and agree on a
> > > common mode of operation.
> > > 
> > > Aren't applications that use the subdev name directly inherently
> > > non-portable anyway ? If you want your application to support different
> > > boards/sensors/SoCs
> >
> > Well, the name could come from a configuration file to distinguish e.g.
> > between primary and secondary sensors.
> 
> In that case having the I2C bus number and address in the name doesn't create 
> an extra portability issue, does it ?
>  
> > For what it's worth, the SMIA++ driver uses the actual name of the sensor
> > since there are about 10 sensors supported at the moment, and calling them
> > all smiapp-xxxx looks a bit insipid. So one has to talk to the sensor to
> > know what it's called.
> > 
> > This isn't strictly mandatory but a nice feature.
> > 
> > > you should discover the pipeline and find the sensor by iterating over
> > > entities, instead of using the sensor entity name.
> > 
> > To be fully generic, yes.
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
