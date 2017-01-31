Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:32785 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750745AbdAaBWG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 20:22:06 -0500
Subject: Re: [PATCH v3 00/24] i.MX Media Driver
To: Russell King - ARM Linux <linux@armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <20170131004510.GQ27312@n2100.armlinux.org.uk>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <951c1a08-c0f2-4333-b4bf-410de8dd863f@gmail.com>
Date: Mon, 30 Jan 2017 17:22:01 -0800
MIME-Version: 1.0
In-Reply-To: <20170131004510.GQ27312@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/30/2017 04:45 PM, Russell King - ARM Linux wrote:
>
> Hi,
>
> Trying this driver with an imx219 camera (which works with Philipp's
> driver) results in not much happening... no /dev/media* node for it,
> no subdevs, no nothing.  No clues as to what's missing either.  Only
> messages from imx-media are from registering the various subdevs.
>
> [   37.444877] imx-media: Registered subdev imx6-mipi-csi2
> [   37.444973] imx-media: Registered subdev imx219 0-0010
> [   38.868740] imx-media: Registered subdev ipu1_ic_prpenc
> [   38.869265] imx-media: Registered subdev ipu1_ic_prpvf
> [   38.869425] imx-media: Registered subdev ipu1_ic_pp0
> [   38.870086] imx-media: Registered subdev ipu1_ic_pp1
> [   38.871510] imx-media: Registered subdev ipu2_ic_prpenc
> [   38.871743] imx-media: Registered subdev ipu1_smfc0
> [   38.873043] imx-media: Registered subdev ipu1_smfc1
> [   38.873225] imx-media: Registered subdev ipu2_ic_prpvf
> [   38.875027] imx-media: Registered subdev ipu2_smfc0
> [   38.875320] imx-media: Registered subdev ipu2_ic_pp0
> [   38.877148] imx-media: Registered subdev ipu2_smfc1
> [   38.877436] imx-media: Registered subdev ipu2_ic_pp1
> [   38.932089] imx-media: Registered subdev camif0
> [   38.956538] imx-media: Registered subdev camif1
> [   38.959148] imx-media: Registered subdev camif2
> [   38.964353] imx-media: Registered subdev camif3
> [  206.502077] imx-media: Registered subdev ipu1_csi0
> [  206.503304] imx-media: Registered subdev ipu1_csi1
> [  206.503814] imx-media: Registered subdev ipu2_csi0
> [  206.504281] imx-media: Registered subdev ipu2_csi1
>
> I also get:
>
> [   37.200072] imx6-mipi-csi2: data lanes: 2
> [   37.200077] imx6-mipi-csi2: flags: 0x00000200
>
> and from what I can see, all modules from drivers/staging/media/imx/ are
> loaded (had to load imx-csi by hand because of the brokenness in the
> drivers/gpu/ipu code attaching an device_node pointer after registering
> the platform device, which changes what userspace sees in the modalias
> file.)
>
> Any clues at what to look at?

Hi Russell,

I'm not familiar with IMX219, can you send me the source for the
imx219 subdev? I don't see it in 4.10-rc1.

I'm also having trouble finding a datasheet for it, but from what
I've read, it has a MIPI CSI-2 interface. It should work fine as long
as it presents a single source pad, registers asynchronously, and
sets its entity function to MEDIA_ENT_F_CAM_SENSOR.

Since I see it was registered asynchronously from the above, it
must have been added to the device tree. But given that there
is no /dev/media? node, the media driver is probably waiting for
another subdev to register, I don't know what that would be.

Can you send me the full patch on top of the v3 driver and I'll
try to find what's missing.

Edit: I see a subdev that is missing: the video mux. Did you enable
CONFIG_VIDEO_MULTIPLEXER?

Finally, what platform does this IMX219 sensor module plug into?


Steve

