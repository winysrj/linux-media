Return-path: <linux-media-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:49852 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933427Ab0HDT23 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Aug 2010 15:28:29 -0400
Message-ID: <4C59BF56.903@kolumbus.fi>
Date: Wed, 04 Aug 2010 22:28:22 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: Re: [RFC/PATCH v3 06/10] media: Entities, pads and links enumeration
References: <1280419616-7658-1-git-send-email-laurent.pinchart@ideasonboard.com> <201008021635.57216.laurent.pinchart@ideasonboard.com> <201008022301.55396.hverkuil@xs4all.nl> <201008031122.55036.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201008031122.55036.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-6; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Hans and Laurent.

I hope my thoughts help you further.

03.08.2010 12:22, Laurent Pinchart wrote:
> Hi Hans,
>
> On Monday 02 August 2010 23:01:55 Hans Verkuil wrote:
>> On Monday 02 August 2010 16:35:54 Laurent Pinchart wrote:
>>> On Sunday 01 August 2010 13:58:20 Hans Verkuil wrote:
>>>> On Thursday 29 July 2010 18:06:39 Laurent Pinchart wrote:
>>> [snip]
>>>
[snip]
>> It's a possibility, but it's always a bit of a hassle in an application to
>> work with group IDs. I wonder if there is a more elegant method.
> The problem is a bit broader than just showing relationships between video
> nodes and ALSA devices. We also need to show relationships between lens/flash
> controllers and sensors for instance. Group IDs sound easy, but I'm open to
> suggestions.

Low level example

DVB I2C bus is easy: get all I2C devices from an entity (DVB demuxer).
Some external chip (entity, the tuner) might be behind some I2C bridge 
device.

With I2C you need to know the characteristics, how you talk with
the destination device via the bus (extra sleeps, clock speed,
quiesce the whole bus for 50ms after talking to the slave device).
I'd like that each device would describe how it should be
talked to via the bus.

On i2c_transfer you could hide opening and closing the I2C bridge, and hide
the callbacks for extra sleeps so that the main driver and core 
framework code is free from such ugly details.
By storing entity's special requirements inside of it, you could reuse 
the callbacks with another product variant.

With I2C, an array of I2C slave devices that are reachable via I2C bus 
would work for controlling the device
rather nicely.

Higher abstraction level

So detailed descriptions and bus knowledge is needed for controlling 
each entity and pad.
That hierarchy is a bit different than optimal hierarchy of how the 
streams can flow
into, within and out from the entity (the driver). Buses are the 
gateways for the data stream flows,
shared by two or more entities/pads by links.

Thus I'd suggest to separate these two hierarchies (initialization time 
hierarchy and
stream flow capability hierarchy) at necessary points, and use buses
to bind the entities/pads by links to each other.

A single wire with just two end points can also be thought like a bus.

Regards,
Marko Ristola

[ snip ]

