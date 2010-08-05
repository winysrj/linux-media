Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:45474 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759509Ab0HEJhU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Aug 2010 05:37:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Marko Ristola <marko.ristola@kolumbus.fi>
Subject: Re: [RFC/PATCH v3 06/10] media: Entities, pads and links enumeration
Date: Thu, 5 Aug 2010 11:38:22 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1280419616-7658-1-git-send-email-laurent.pinchart@ideasonboard.com> <201008031122.55036.laurent.pinchart@ideasonboard.com> <4C59BF56.903@kolumbus.fi>
In-Reply-To: <4C59BF56.903@kolumbus.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201008051138.23378.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marko,

On Wednesday 04 August 2010 21:28:22 Marko Ristola wrote:
> Hi Hans and Laurent.
> 
> I hope my thoughts help you further.

Thank you for sharing them.

> 03.08.2010 12:22, Laurent Pinchart wrote:
> > On Monday 02 August 2010 23:01:55 Hans Verkuil wrote:
> >> On Monday 02 August 2010 16:35:54 Laurent Pinchart wrote:
> >>> On Sunday 01 August 2010 13:58:20 Hans Verkuil wrote:
> >>>> On Thursday 29 July 2010 18:06:39 Laurent Pinchart wrote:
> >>> [snip]
> 
> [snip]
> 
> >> It's a possibility, but it's always a bit of a hassle in an application
> >> to work with group IDs. I wonder if there is a more elegant method.
> > 
> > The problem is a bit broader than just showing relationships between
> > video nodes and ALSA devices. We also need to show relationships between
> > lens/flash controllers and sensors for instance. Group IDs sound easy,
> > but I'm open to suggestions.
> 
> Low level example
> 
> DVB I2C bus is easy: get all I2C devices from an entity (DVB demuxer).
> Some external chip (entity, the tuner) might be behind some I2C bridge
> device.
> 
> With I2C you need to know the characteristics, how you talk with
> the destination device via the bus (extra sleeps, clock speed,
> quiesce the whole bus for 50ms after talking to the slave device).
> I'd like that each device would describe how it should be
> talked to via the bus.

There's probably some confusion here.

The media controller aims at giving userspace the ability to discover the 
internal device topology. This includes various information about the 
entities, such as a name, a version number, ...

The I2C data you mention are low-level information required by the kernel to 
talk to the I2C device, but I don't think they're useful to userspace at all. 
That kind of information come either from platform data or from the I2C device 
driver and get used internally in the kernel.

Do you see any need to expose such information to userspace ?

> On i2c_transfer you could hide opening and closing the I2C bridge, and hide
> the callbacks for extra sleeps so that the main driver and core framework
> code is free from such ugly details. By storing entity's special
> requirements inside of it, you could reuse the callbacks with another
> product variant.

The callbacks are implemented by I2C device drivers that should know about the 
specific device requirements (either hardcoded in the driver, or provided 
through platform data). I'm not sure to understand the exact problem here.

> With I2C, an array of I2C slave devices that are reachable via I2C bus
> would work for controlling the device rather nicely.
> 
> Higher abstraction level
> 
> So detailed descriptions and bus knowledge is needed for controlling each
> entity and pad.

It's needed to control them inside the kernel, but I don't think it's needed 
in userspace.

> That hierarchy is a bit different than optimal hierarchy of how the streams
> can flow into, within and out from the entity (the driver). Buses are the
> gateways for the data stream flows, shared by two or more entities/pads by
> links.
> 
> Thus I'd suggest to separate these two hierarchies (initialization time
> hierarchy and stream flow capability hierarchy) at necessary points, and use
> buses to bind the entities/pads by links to each other.

I don't get it, sorry.

> A single wire with just two end points can also be thought like a bus.

-- 
Regards,

Laurent Pinchart
