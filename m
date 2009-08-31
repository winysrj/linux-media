Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4974 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbZHaRXF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 13:23:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: bus configuration setup for sub-devices
Date: Mon, 31 Aug 2009 19:23:00 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@skynet.be>
References: <200908291631.13696.hverkuil@xs4all.nl> <A69FA2915331DC488A831521EAE36FE40154EDC3D5@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40154EDC3D5@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908311923.00585.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 31 August 2009 16:42:28 Karicheri, Muralidharan wrote:
> Hans,
> >
> >My last proposal merged subdev and bridge parameters into one struct, thus
> >completely describing the bus setup. I realized that there is a problem
> >with
> >that if you have to define the bus for sub-devices that are in the middle
> >of
> >a chain: e.g. a sensor sends its video to a image processing subdev and
> >from
> >there it goes to the bridge. You have to be able to specify both the source
> >and
> >sink part of each bus for that image processing subdev.
> 
> In the above, what you mean by image processing subdev? In the case of DM6446/DM355/DM365, here is the connection
> 
> Image sensor/ video decoder -> ccdc -> ipipe/preview engine/resizer -> SDRAM. 
> In this scenario, ipipe, preview engine and resizer are image processing hardware which are managed by bridge device. So we have just source sub device and bridge device. Which hardware supports the image processing sub device?

We actually do have image processing subdevs: upd64031a.c and upd64083.c.
These are only used on TV capture cards, though. It is probably more likely
to see fpgas between a sensor and a bridge where the fpga does the image
processing. So yes, they do exist and I want to be at least prepared for this.

> 
> >
> >Eagle-eyed observers will note that the bus type field has disappeared from
> >this proposal. The problem with that is that I have no clue what it is
> >supposed
> >to do. Is there more than one bus that can be set up? In that case it is
> >not a
> >bus type but a bus ID. Or does it determine that type of data that is being
> >transported over the bus? In that case it does not belong here, since that
> >is
> 
> At the bridge device, for configuring CCDC, the hardware needs to know if the bus is having raw bayer data or YCbCr data. Similarly, if the bus is YCbCr, the data bus can carry Y and CbCr muxed over 8 lines or dedicated Y lines and CbCr muxed over other 8 lines. Also Y and CbCr can be swapped. How do we convey this information without bus type? May be another field is required in addition to bus type to convey swapped state.

That is part of the proposal that Guennadi is working on: setting up the
format of the data being transferred over the bus. This bus config proposal
deals with the bus itself, not what is being transported over the bus.

One very valid question is whether these two shouldn't be combined. I don't
know the answer to that question, though.

> 
> For raw data processing, for example, MT9T031 sensor output 10 bits and MT9P031 outputs 12 bits. DM365 IPIPE handles 12 bits and DM365 IPIPE 10 bits. So in EVM the 10 bits (upper 10 bits for MT9P031)are connected to data 11-2. so bits 0-1 are pulled low. It is required to specify this information in the bus structure. If offset is suggested for this, it could be used to specify it. So in this case offset is related to LSB? So for the above case it is 2 meaning bit2 starts with real data and bit 0 - 1 are zeros. Please confirm.

That was the idea, but I see no point in specifying this. Why would the DM365
care about that? I have yet to see a use-case where you really need this info.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
