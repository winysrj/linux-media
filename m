Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:25768 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755459Ab0GWUxP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jul 2010 16:53:15 -0400
Subject: Re: [RFC] Per-subdev, host-specific data
From: Andy Walls <awalls@md.metrocast.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
In-Reply-To: <201007231631.34967.laurent.pinchart@ideasonboard.com>
References: <201007231501.31170.laurent.pinchart@ideasonboard.com>
	 <201007231546.29691.hverkuil@xs4all.nl>
	 <201007231631.34967.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Jul 2010 16:52:48 -0400
Message-ID: <1279918368.2734.5.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-07-23 at 16:31 +0200, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Friday 23 July 2010 15:46:29 Hans Verkuil wrote:
> > On Friday 23 July 2010 15:01:29 Laurent Pinchart wrote:
> > > Hi everybody,
> > > 
> > > Trying to implement support for multiple sensors connected to the same
> > > OMAP3 ISP input (all but one of the sensors need to be kept in reset
> > > obviously), I need to associate host-specific data to the sensor
> > > subdevs.
> > > 
> > > The terms host and bridge are considered as synonyms in the rest of this
> > > e- mail.
> > > 
> > > The OMAP3 ISP platform data has interface configuration parameters for
> > > the two CSI2 (a and c), CCP2 and parallel interfaces. The parameters are
> > > used to configure the bus when a sensor is selected. To support multiple
> > > sensors on the same input, the parameters need to be specified
> > > per-sensor, and not ISP- wide.
> > > 
> > > No issue in the platform data. Board codes declare an array of structures
> > > that embed a struct v4l2_subdev_i2c_board_info instance and an OMAP3
> > > ISP-specific interface configuration structure.
> > > 
> > > At runtime, when a sensor is selected, I need to access the OMAP3
> > > ISP-specific interface configuration structure for the selected sensor.
> > > At that point all I have is a v4l2_subdev structure pointer, without a
> > > way to get back to the interface configuration structure.
> > > 
> > > The only point in the code where the v4l2_subdev and the interface
> > > configuration data are both known and could be linked together is in the
> > > host driver's probe function, where the v4l2_subdev instances are
> > > created. I have two solutions there:
> > > 
> > > - store the v4l2_subdev pointer and the interface configuration data
> > > pointer in a host-specific array, and perform a an array lookup
> > > operation at runtime with the v4l2_subdev pointer as a key
> > > 
> > > - add a void *host_priv field to the v4l2_subdev structure, store the
> > > interface configuration data pointer in that field, and use the field at
> > > runtime
> > > 
> > > The second solution seems cleaner but requires an additional field in
> > > v4l2_subdev. Opinions and other comments will be appreciated.

Why isn't

	v4l2_set_subdevdata(sd, private_ptr);

sufficient?

The cx18-av-core.[ch] files use that to get a bridge instance pointer
from a v4l2_subdev.

Or is it that the v4l2_subdev infrastructure help functions for I2C
connected devices already claim that?

Regards,
Andy

> > There is a third option: the grp_id field is owned by the host driver, so
> > you could make that an index into a host specific array.



> Good point.
> 
> > That said, I think having a host_priv field isn't a bad idea. Although if
> > we do this, then I think the existing priv field should be renamed to
> > drv_priv to prevent confusion.
> 
> As Guennadi, Sakari and you all agree that the host_priv field is a good idea, 
> I'll submit a patch.
> 
> Thanks.
> 


