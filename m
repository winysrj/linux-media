Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57330 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752030AbdAaOGk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 09:06:40 -0500
Date: Tue, 31 Jan 2017 14:04:12 +0000
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
Message-ID: <20170131140411.GY27312@n2100.armlinux.org.uk>
References: <1484929911.2897.70.camel@pengutronix.de>
 <3fb68686-9447-2d8a-e2d2-005e4138cd43@gmail.com>
 <5d23d244-aa0e-401c-24a9-07f28acf1563@xs4all.nl>
 <1485169204.2874.57.camel@pengutronix.de>
 <ce2d1851-8a2e-ea0b-25b8-be6649b1ebaf@gmail.com>
 <1485257269.3600.96.camel@pengutronix.de>
 <20170130130657.GR27312@n2100.armlinux.org.uk>
 <1485857364.2932.27.camel@pengutronix.de>
 <20170131131436.GW27312@n2100.armlinux.org.uk>
 <1485869700.2932.57.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1485869700.2932.57.camel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 31, 2017 at 02:35:00PM +0100, Philipp Zabel wrote:
> On Tue, 2017-01-31 at 13:14 +0000, Russell King - ARM Linux wrote:
> > This isn't limited to the serial side - the parallel bus side between
> > the CSI2 interface and CSI2IPU wrapper, and the CSI2IPU wrapper and
> > the CS0/1 interfaces is much the same with 10-bit bayer.
> > 
> > Think of the CSI2 <-> CSI2IPU bit as the 4-lane case, lane 0 ending
> > up on the least significant 8 bits of the 32-bit bus, lane 3 on the
> > top 8-bits.
> > 
> > Post CSI2IPU, it talks about a 16-bit bus in the diagrams, so that's
> > kind of the 2-lane case above...
> 
> You are right, on the parallel buses the format most definitely is not
> MEDIA_BUS_FMT_SBGGR10_1X10. We don't have any representation of the
> 32-bit bus between CSI2 host and CSI2IPU gasket because we model the two
> as a single entity, but the four 16-bit parallel buses between the
> CSI2IPU gasket and the IPU1/2 CSI0/1 probably should be set to a custom
> format describing this accurately.

Yep.  I should also point out that there's a very odd transformation
going on somewhere, and I don't yet know where.

The sensor is definitely outputting GBRG format, but what seems to get
written into memory is RGGB format.  It's somewhere post CSI, because
when I was using the (broken) CSI compander with 10 bit bayer, the red
compander channel affected the red channel output from the camera, but
changed the green component written to memory... it's very much like
either the first line gets lost somewhere, or the odd/even lines are
transposed.  It could also be a gstreamer bug.  As I say, it's not
something I've looked into deeply enough yet... too many other issues
to chase down!

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
