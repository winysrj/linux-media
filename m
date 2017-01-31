Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:45107 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751381AbdAaJur (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 04:50:47 -0500
Message-ID: <1485856168.2932.11.camel@pengutronix.de>
Subject: Re: [PATCH v3 00/24] i.MX Media Driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>,
        robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
Date: Tue, 31 Jan 2017 10:49:28 +0100
In-Reply-To: <951c1a08-c0f2-4333-b4bf-410de8dd863f@gmail.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
         <20170131004510.GQ27312@n2100.armlinux.org.uk>
         <951c1a08-c0f2-4333-b4bf-410de8dd863f@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2017-01-30 at 17:22 -0800, Steve Longerbeam wrote:
> 
> On 01/30/2017 04:45 PM, Russell King - ARM Linux wrote:
> >
> > Hi,
> >
> > Trying this driver with an imx219 camera (which works with Philipp's
> > driver) results in not much happening... no /dev/media* node for it,
> > no subdevs, no nothing.  No clues as to what's missing either.  Only
> > messages from imx-media are from registering the various subdevs.
> >
> > [   37.444877] imx-media: Registered subdev imx6-mipi-csi2
> > [   37.444973] imx-media: Registered subdev imx219 0-0010
> > [   38.868740] imx-media: Registered subdev ipu1_ic_prpenc
> > [   38.869265] imx-media: Registered subdev ipu1_ic_prpvf
> > [   38.869425] imx-media: Registered subdev ipu1_ic_pp0
> > [   38.870086] imx-media: Registered subdev ipu1_ic_pp1
> > [   38.871510] imx-media: Registered subdev ipu2_ic_prpenc
> > [   38.871743] imx-media: Registered subdev ipu1_smfc0
> > [   38.873043] imx-media: Registered subdev ipu1_smfc1
> > [   38.873225] imx-media: Registered subdev ipu2_ic_prpvf
> > [   38.875027] imx-media: Registered subdev ipu2_smfc0
> > [   38.875320] imx-media: Registered subdev ipu2_ic_pp0
> > [   38.877148] imx-media: Registered subdev ipu2_smfc1
> > [   38.877436] imx-media: Registered subdev ipu2_ic_pp1
> > [   38.932089] imx-media: Registered subdev camif0
> > [   38.956538] imx-media: Registered subdev camif1
> > [   38.959148] imx-media: Registered subdev camif2
> > [   38.964353] imx-media: Registered subdev camif3
> > [  206.502077] imx-media: Registered subdev ipu1_csi0
> > [  206.503304] imx-media: Registered subdev ipu1_csi1
> > [  206.503814] imx-media: Registered subdev ipu2_csi0
> > [  206.504281] imx-media: Registered subdev ipu2_csi1
> >
> > I also get:
> >
> > [   37.200072] imx6-mipi-csi2: data lanes: 2
> > [   37.200077] imx6-mipi-csi2: flags: 0x00000200
> >
> > and from what I can see, all modules from drivers/staging/media/imx/ are
> > loaded (had to load imx-csi by hand because of the brokenness in the
> > drivers/gpu/ipu code attaching an device_node pointer after registering
> > the platform device, which changes what userspace sees in the modalias
> > file.)
> >
> > Any clues at what to look at?
> 
> Hi Russell,
> 
> I'm not familiar with IMX219, can you send me the source for the
> imx219 subdev? I don't see it in 4.10-rc1.
> 
> I'm also having trouble finding a datasheet for it, but from what
> I've read, it has a MIPI CSI-2 interface. It should work fine as long
> as it presents a single source pad, registers asynchronously, and
> sets its entity function to MEDIA_ENT_F_CAM_SENSOR.

What about MEDIA_ENT_F_VID_IF_BRIDGE?

regards
Philipp

