Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:58468 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751488AbdBEPjJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 5 Feb 2017 10:39:09 -0500
Date: Sun, 5 Feb 2017 15:37:55 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarit.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v3 06/24] ARM: dts: imx6-sabrelite: add OV5642 and OV5640
 camera sensors
Message-ID: <20170205153754.GJ27312@n2100.armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-7-git-send-email-steve_longerbeam@mentor.com>
 <20170130225133.GF27898@n2100.armlinux.org.uk>
 <23975350.L90NWivx6X@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23975350.L90NWivx6X@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Feb 05, 2017 at 05:24:30PM +0200, Laurent Pinchart wrote:
> Hi Russell,
> 
> On Monday 30 Jan 2017 22:51:33 Russell King - ARM Linux wrote:
> > > +			ov5640_to_mipi_csi: endpoint@1 {
> > > +				reg = <1>;
> > > +				remote-endpoint = 
> <&mipi_csi_from_mipi_sensor>;
> > > +				data-lanes = <0 1>;
> > > +				clock-lanes = <2>;
> > 
> > How do you envision a four-lane sensor being described?
> > 
> > 	data-lanes = <0 1 3 4>;
> > 	clock-lanes = <2>;
> > 
> > ?
> > 
> > The binding document for video-interfaces.txt says:
> > 
> > - clock-lanes: an array of physical clock lane indexes. Position of an entry
> > determines the logical lane number, while the value of an entry indicates
> > physical lane, e.g. for a MIPI CSI-2 bus we could have "clock-lanes =
> > <0>;", which places the clock lane on hardware lane 0. This property is
> > valid for serial busses only (e.g. MIPI CSI-2). Note that for the MIPI
> > CSI-2 bus this array contains only one entry.
> > 
> > So I think you need to have a good reason to make the clock lane non-zero.
> 
> The purpose of the data-lanes and clock-lanes properties is to describe lane 
> assignment for hardware that supports lane routing. As far as I know the 
> OV5640 doesn't support lane routing and has dedicated pins for the clock and 
> data lanes. The data-lanes and clock-lanes properties should probably not be 
> specified at all.

You need at least data-lanes so you know how many data lanes are wired
between the camera and the mipi csi2 receiver.  Just because a camera
has (eg) four lanes does not mean you need to wire all four, and in
some cases less than four will be wired.

If data-lanes does not describe that, then all existing users of the
binding are abusing it:

$ grep data_lanes drivers/media/i2c -r
drivers/media/i2c/s5k5baf.c:                state->nlanes = ep.bus.mipi_csi2.num_data_lanes;
drivers/media/i2c/s5c73m3/s5c73m3-core.c:   if (ep.bus.mipi_csi2.num_data_lanes != S5C73M3_MIPI_DATA_LANES)
drivers/media/i2c/tc358743.c:           endpoint->bus.mipi_csi2.num_data_lanes == 0 ||
drivers/media/i2c/smiapp/smiapp-core.c:     hwcfg->lanes = bus_cfg->bus.mipi_csi2.num_data_lanes;

So all those drivers are using it for the _number_ of CSI2 lanes, and
are not touching the mapping in any way (not even checking that it is
an identity mapping.)  You could specify any mapping to these drivers,
as long as num_data_lanes came out right.

And... there's no point having a property in a binding if no one is
using it... and even more silly not to have a property that everyone
needs...

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
