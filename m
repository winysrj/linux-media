Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42168 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab3AHVTV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 16:19:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH 1/6 v4] media: V4L2: support asynchronous subdevice registration
Date: Tue, 08 Jan 2013 22:20:59 +0100
Message-ID: <1416814.gcsa1Dy9v8@avalon>
In-Reply-To: <50EC2CBD.3080102@gmail.com>
References: <1356544151-6313-1-git-send-email-g.liakhovetski@gmx.de> <1446871.ydXdxJD4sK@avalon> <50EC2CBD.3080102@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Tuesday 08 January 2013 15:27:09 Sylwester Nawrocki wrote:
> On 01/08/2013 01:41 PM, Laurent Pinchart wrote:
> >> Subdev names are exposed to user space by the media controller API.
> >> So they are really part of an ABI, aren't they ?
> > 
> > They're used to construct the name exposed to userspace, but the media
> > controller core could probably handle that internally by concatenating the
> > driver name and the subdev name.
> > 
> >> Also having I2C bus number or I2C slave address as part of the subdev
> >> name makes it more difficult to write portable applications. Hence
> >> in sensor drivers I used to overwrite subdev name to remove I2C bus
> >> and slave address, as the format used v4l2_i2c_subdev_init() seemed
> >> highly unsuitable..
> > 
> > This clearly shows that we need to discuss the matter and agree on a
> > common mode of operation.
> > 
> > Aren't applications that use the subdev name directly inherently
> > non-portable anyway ? If you want your application to support different
> > boards/sensors/SoCs you should discover the pipeline and find the sensor
> > by iterating over entities, instead of using the sensor entity name.
> 
> It depends on how we define the entity names :) It the names change from
> board to board and are completely unreliable then user space applications
> using them have no any chance to be generic. Nevertheless, struct
> media_entity_desc::name [1] has currently no specific semantics defined,
> e.g. for V4L2.
> 
> It's likely way better for the kernel space to be no constrained by the
> subdev user space name requirement. But having no clear definition of the
> entity names brings more trouble to user space. E.g. when a sensor exposes
> multiple subdevs. User space library/application could then reference them
> by entity name. It seems difficult to me to handle such multiple subdev
> devices without somehow reliable subdev names.

I agree, I think naming rules are required.

> I imagine a system with multiple sensors of same type sitting on different
> I2C busses, then appending I2C bus number/slave address to the name would be
> useful.

And an application can always strip off the I2C bus number and address and use 
the sensor name only if needed (or use the sensor name in addition to the I2C 
information).

> And is it always possible to discover the pipeline, as opposite to e.g.
> using configuration file to activate all required links ? Configurations
> could be of course per board file, but then at least we should keep subdev
> names constant through the kernel releases.

I'm fine with applications more or less hardcoding the pipeline, and I agree 
that subdev names need to be kept constant across kernel releases (and, very 
importantly, well-defined). Now we "just" need to agree on naming rules :-)

> [1] http://linuxtv.org/downloads/v4l-dvb-apis/media-ioc-enum-entities.html

-- 
Regards,

Laurent Pinchart

