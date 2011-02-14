Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35453 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab1BNPPM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 10:15:12 -0500
MIME-Version: 1.0
In-Reply-To: <20110214131829.GC2549@legolas.emea.dhcp.ti.com>
References: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<1297686097-9804-4-git-send-email-laurent.pinchart@ideasonboard.com>
	<20110214123430.GX2549@legolas.emea.dhcp.ti.com>
	<201102141407.09449.laurent.pinchart@ideasonboard.com>
	<20110214131829.GC2549@legolas.emea.dhcp.ti.com>
Date: Mon, 14 Feb 2011 17:15:10 +0200
Message-ID: <AANLkTikm3jHwCJnQTz4yRRRUj_ar6WgHLEerxEBDEO0g@mail.gmail.com>
Subject: Re: [PATCH v6 03/10] omap3: Add function to register omap3isp
 platform device structure
From: David Cohen <dacohen@gmail.com>
To: balbi@ti.com
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Feb 14, 2011 at 3:18 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,

Hi

>
> On Mon, Feb 14, 2011 at 02:07:08PM +0100, Laurent Pinchart wrote:
>> > > diff --git a/arch/arm/mach-omap2/devices.h
>> > > b/arch/arm/mach-omap2/devices.h new file mode 100644
>> > > index 0000000..12ddb8a
>> > > --- /dev/null
>> > > +++ b/arch/arm/mach-omap2/devices.h
>> > > @@ -0,0 +1,17 @@
>> > > +/*
>> > > + * arch/arm/mach-omap2/devices.h
>> > > + *
>> > > + * OMAP2 platform device setup/initialization
>> > > + *
>> > > + * This program is free software; you can redistribute it and/or modify
>> > > + * it under the terms of the GNU General Public License as published by
>> > > + * the Free Software Foundation; either version 2 of the License, or
>> > > + * (at your option) any later version.
>> > > + */
>> > > +
>> > > +#ifndef __ARCH_ARM_MACH_OMAP_DEVICES_H
>> > > +#define __ARCH_ARM_MACH_OMAP_DEVICES_H
>> > > +
>> > > +int omap3_init_camera(void *pdata);
>> >
>> > missing extern ?
>>
>> Is that mandatory ? Many (most ?) headers in the kernel don't use the extern
>> keyword when declaring functions.
>
> maybe not mandatory, worth checking what sparse would say though :-p

sparse is not complaining.

Br,

David

>
> --
> balbi
> --
