Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38438 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753477AbdA3NIN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 08:08:13 -0500
Date: Mon, 30 Jan 2017 13:06:57 +0000
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
Message-ID: <20170130130657.GR27312@n2100.armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <c6e98327-7e2c-f34a-2d23-af7b236de441@xs4all.nl>
 <1484929911.2897.70.camel@pengutronix.de>
 <3fb68686-9447-2d8a-e2d2-005e4138cd43@gmail.com>
 <5d23d244-aa0e-401c-24a9-07f28acf1563@xs4all.nl>
 <1485169204.2874.57.camel@pengutronix.de>
 <ce2d1851-8a2e-ea0b-25b8-be6649b1ebaf@gmail.com>
 <1485257269.3600.96.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1485257269.3600.96.camel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> The central issue seems to be that I think media pad links / media bus
> formats should describe physical links, such as parallel or serial
> buses, and the formats of pixels flowing through them, whereas Steve
> would like to extend them to describe software transports and in-memory
> formats.

This probably isn't the right place to attach this comment in this
thread, but... the issue of media bus formats matching physical buses
is an argument that I think is already lost.

For example, take the 10-bit bayer formats:

#define MEDIA_BUS_FMT_SBGGR10_1X10              0x3007
#define MEDIA_BUS_FMT_SGBRG10_1X10              0x300e
#define MEDIA_BUS_FMT_SGRBG10_1X10              0x300a
#define MEDIA_BUS_FMT_SRGGB10_1X10              0x300f

These are commonly used on CSI serial buses (see the smiapp driver for
example).  From the description at the top of the file, it says the
1X10 means that one pixel is transferred as one 10-bit sample.

However, the format on wire is somewhat different - four pixels are
transmitted over five bytes:

	P0	P1	P2	P3	P0	P1	P2	P3
	8-bit	8-bit	8-bit	8-bit	2-bit	2-bit	2-bit	2-bit

This gives two problems:
1) it doesn't fit in any sensible kind of "one pixel transferred as
   N M-bit samples" description because the pixel/sample values
   (depending how you look at them) are broken up.

2) changing this will probably be a user visible change, as things
   like smiapp are already in use.

So, I think what we actually have is the media bus formats describing
the _logical_ bus format.  Yes, one pixel is transferred as one 10-bit
sample in this case.

To help illustrate my point, consider the difference between
MEDIA_BUS_FMT_RGB565_1X16 and MEDIA_BUS_FMT_RGB565_2X8_BE or
MEDIA_BUS_FMT_RGB565_2X8_LE.  RGB565_1X16 means 1 pixel over an effective
16-bit wide bus (if it's not 16-bit, then it has to be broken up into
separate "samples".)  RGB565_2X8 means 1 pixel as two 8-bit samples.

So, the 10-bit bayer is 1 pixel as 1.25 bytes.  Or is it, over a serial
bus.  Using the RGB565 case, 10-bit bayer over a 4 lane CSI bus becomes
interesting:

	first byte	2nd	3rd
lane 1	P0 9:2		S0	P7 9:2
lane 2	P1 9:2		P4 9:2	S1
lane 3	P2 9:2		P5 9:2	P8 9:2
lane 4	P3 9:2		P6 9:2	P9 9:2

S0 = P0/P1/P2/P3 least significant two bits
S1 = P4/P5/P6/P7 least significant two bits

or 2 lane CSI:
	first byte	2nd	3rd	4th	5th
lane 1	P0 9:2		P2	S0	P5	P7
lane 2	P1 9:2		P3	P4	P6	S1

or 1 lane CSI:
lane 1	P0 P1 P2 P3 S0 P4 P5 P6 P7 S1 P8 P9 ...

etc.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
