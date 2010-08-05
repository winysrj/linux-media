Return-path: <linux-media-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:49404 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757548Ab0HETpM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Aug 2010 15:45:12 -0400
Message-ID: <4C5B14C1.6050503@kolumbus.fi>
Date: Thu, 05 Aug 2010 22:45:05 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: Re: [RFC/PATCH v3 06/10] media: Entities, pads and links enumeration
References: <1280419616-7658-1-git-send-email-laurent.pinchart@ideasonboard.com> <201008031122.55036.laurent.pinchart@ideasonboard.com> <4C59BF56.903@kolumbus.fi> <201008051138.23378.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201008051138.23378.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-6; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  05.08.2010 12:38, Laurent Pinchart wrote:
> Hi Marko,
>
> On Wednesday 04 August 2010 21:28:22 Marko Ristola wrote:
>> Hi Hans and Laurent.
>>
>> I hope my thoughts help you further.
> Thank you for sharing them.
Thank you for taking time to answer for me.

[ snip ]

> There's probably some confusion here.
>
> The media controller aims at giving userspace the ability to discover the
> internal device topology. This includes various information about the
> entities, such as a name, a version number, ...
>
> The I2C data you mention are low-level information required by the kernel to
> talk to the I2C device, but I don't think they're useful to userspace at all.
> That kind of information come either from platform data or from the I2C device
> driver and get used internally in the kernel.
>
> Do you see any need to expose such information to userspace ?
>
I don't see any needs to expose such information into userspace.
I have some thoughts about I2C hardware problems,
but that is of course off topic. I wrote them here only
because I tried to draw some bigger picture how this entity, pads
and links thing relates to the whole driver.

[ snip ]

>> With I2C, an array of I2C slave devices that are reachable via I2C bus
>> would work for controlling the device rather nicely.
>>
>> Higher abstraction level
>>
>> So detailed descriptions and bus knowledge is needed for controlling each
>> entity and pad.
> It's needed to control them inside the kernel, but I don't think it's needed
> in userspace.
>
I agree: The detailed information needs to be internal to the driver,
and userspace needs only the information that is needed for being
able to decide how to configure the streams over many drivers,
and how each driver must be asked to do the configuration for it,
without driver needing knowledge about other related drivers.

Maybe a pad could have a list of pads that it can connect to.
Each destination pad reference could have a link as a property
if the link is mandatory for binding the pads together.

A list of open links without pads might be usable too, enabling binding
different drivers to pass data to each other with pad->link->pad binding.
Driver could be a property of a pad for being able to do binding over 
drivers.

You have of course a better picture and understanding about these,
and you will need to come up with the best solution together on your own.

Maybe I just need to do something else and go and buy another motherboard
from Helsinki Ruoholahti to replace my overheated one, walking by some
Nokia Research Center buildings.

Best regards from the summerish Finland.
Marko Ristola

