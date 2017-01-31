Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56636 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752329AbdAaNP4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 08:15:56 -0500
Date: Tue, 31 Jan 2017 13:14:36 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, mchehab@kernel.org, nick@shmanahar.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v3 00/24] i.MX Media Driver
Message-ID: <20170131131436.GW27312@n2100.armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <c6e98327-7e2c-f34a-2d23-af7b236de441@xs4all.nl>
 <1484929911.2897.70.camel@pengutronix.de>
 <3fb68686-9447-2d8a-e2d2-005e4138cd43@gmail.com>
 <5d23d244-aa0e-401c-24a9-07f28acf1563@xs4all.nl>
 <1485169204.2874.57.camel@pengutronix.de>
 <ce2d1851-8a2e-ea0b-25b8-be6649b1ebaf@gmail.com>
 <1485257269.3600.96.camel@pengutronix.de>
 <20170130130657.GR27312@n2100.armlinux.org.uk>
 <1485857364.2932.27.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1485857364.2932.27.camel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 31, 2017 at 11:09:24AM +0100, Philipp Zabel wrote:
> On Mon, 2017-01-30 at 13:06 +0000, Russell King - ARM Linux wrote:
> > To help illustrate my point, consider the difference between
> > MEDIA_BUS_FMT_RGB565_1X16 and MEDIA_BUS_FMT_RGB565_2X8_BE or
> > MEDIA_BUS_FMT_RGB565_2X8_LE.  RGB565_1X16 means 1 pixel over an effective
> > 16-bit wide bus (if it's not 16-bit, then it has to be broken up into
> > separate "samples".)  RGB565_2X8 means 1 pixel as two 8-bit samples.
> > 
> > So, the 10-bit bayer is 1 pixel as 1.25 bytes.  Or is it, over a serial
> > bus.  Using the RGB565 case, 10-bit bayer over a 4 lane CSI bus becomes
> > interesting:
> > 
> > 	first byte	2nd	3rd
> > lane 1	P0 9:2		S0	P7 9:2
> > lane 2	P1 9:2		P4 9:2	S1
> > lane 3	P2 9:2		P5 9:2	P8 9:2
> > lane 4	P3 9:2		P6 9:2	P9 9:2
> > 
> > S0 = P0/P1/P2/P3 least significant two bits
> > S1 = P4/P5/P6/P7 least significant two bits
> > 
> > or 2 lane CSI:
> > 	first byte	2nd	3rd	4th	5th
> > lane 1	P0 9:2		P2	S0	P5	P7
> > lane 2	P1 9:2		P3	P4	P6	S1
> > 
> > or 1 lane CSI:
> > lane 1	P0 P1 P2 P3 S0 P4 P5 P6 P7 S1 P8 P9 ...
> 
> These do look like three different media bus formats to me.

This isn't limited to the serial side - the parallel bus side between
the CSI2 interface and CSI2IPU wrapper, and the CSI2IPU wrapper and
the CS0/1 interfaces is much the same with 10-bit bayer.

Think of the CSI2 <-> CSI2IPU bit as the 4-lane case, lane 0 ending
up on the least significant 8 bits of the 32-bit bus, lane 3 on the
top 8-bits.

Post CSI2IPU, it talks about a 16-bit bus in the diagrams, so that's
kind of the 2-lane case above...

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
