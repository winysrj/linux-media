Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:32821 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750879AbdAaXnZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 18:43:25 -0500
Subject: Re: [PATCH v3 00/24] i.MX Media Driver
To: Russell King - ARM Linux <linux@armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <20170131004510.GQ27312@n2100.armlinux.org.uk>
 <951c1a08-c0f2-4333-b4bf-410de8dd863f@gmail.com>
 <20170131110027.GU27312@n2100.armlinux.org.uk>
Cc: mark.rutland@arm.com, andrew-ct.chen@mediatek.com,
        minghsiu.tsai@mediatek.com, nick@shmanahar.org,
        songjun.wu@microchip.com, hverkuil@xs4all.nl,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        robert.jarzmik@free.fr, devel@driverdev.osuosl.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, geert@linux-m68k.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de, arnd@arndb.de, mchehab@kernel.org,
        bparrot@ti.com, robh+dt@kernel.org, horms+renesas@verge.net.au,
        tiffany.lin@mediatek.com, linux-arm-kernel@lists.infradead.org,
        niklas.soderlund+renesas@ragnatech.se, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, jean-christophe.trotin@st.com,
        p.zabel@pengutronix.de, fabio.estevam@nxp.com, shawnguo@kernel.org,
        sudipm.mukherjee@gmail.com
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <3a673cba-bbf6-5611-5857-4605797bf049@gmail.com>
Date: Tue, 31 Jan 2017 15:43:22 -0800
MIME-Version: 1.0
In-Reply-To: <20170131110027.GU27312@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/31/2017 03:00 AM, Russell King - ARM Linux wrote:
> On Mon, Jan 30, 2017 at 05:22:01PM -0800, Steve Longerbeam wrote:
>> I'm also having trouble finding a datasheet for it, but from what
>> I've read, it has a MIPI CSI-2 interface. It should work fine as long
>> as it presents a single source pad, registers asynchronously, and
>> sets its entity function to MEDIA_ENT_F_CAM_SENSOR.
> Yes, it is MIPI CSI-2, and yes it has a single source pad, registers
> asynchronously, but that's about as far as it goes.
>
> The structure is a camera sensor followed by some processing.  So just
> like the smiapp code, I've ended up with multiple subdevs describing
> each stage of the sensors pipeline.
>
> Just like smiapp, the camera sensor block (which is the very far end
> of the pipeline) is marked with MEDIA_ENT_F_CAM_SENSOR.  However, in
> front of that is the binner, which just like smiapp gets a separate
> entity.  It's this entity which is connected to the mipi-csi2 subdev.

wow, ok got it.

So the sensor pipeline and binner, and the OF graph connecting
them, are described in the device tree I presume.

The OF graph AFAIK, has no information about which ports are sinks
and which are sources, so of_parse_subdev() tries to determine that
based on the compatible string of the device node. So ATM
of_parse_subdev() assumes there is nothing but the imx6-mipi-csi2,
video-multiplexer, and camera sensors upstream from the CSI ports
in the OF graph.

I realize that's not a robust solution, and is the reason for the
"no sensor attached" below.

Is there any way to determine from the OF graph the data-direction
of a port (whether it is a sink or a source)? If so it will make
of_parse_subdev() much more robust.

Steve

>
> Unlike smiapp, which does not set an entity function, I set my binner
> entity as MEDIA_ENT_F_PROC_VIDEO_SCALER on the basis that that is
> what V4L2 documentation recommend:
>
>      -  ..  row 27
>
>         ..  _MEDIA-ENT-F-PROC-VIDEO-SCALER:
>
>         -  ``MEDIA_ENT_F_PROC_VIDEO_SCALER``
>
>         -  Video scaler. An entity capable of video scaling must have
>            at least one sink pad and one source pad, and scale the
>            video frame(s) received on its sink pad(s) to a different
>            resolution output on its source pad(s). The range of
>            supported scaling ratios is entity-specific and can differ
>            between the horizontal and vertical directions (in particular
>            scaling can be supported in one direction only). Binning and
>            skipping are considered as scaling.
>
> This causes attempts to configure the ipu1_csi0 interface to fail:
>
> media-ctl -v -d /dev/media1 --set-v4l2 '"ipu1_csi0":1[fmt:SGBRG8/512x512@1/30]'
> Opening media device /dev/media1
> Enumerating entities
> Found 29 entities
> Enumerating pads and links
> Setting up format SGBRG8 512x512 on pad ipu1_csi0/1
> Unable to set format: No such device (-19)
> Unable to setup formats: No such device (19)
>
> and in the kernel log:
>
> ipu1_csi0: no sensor attached
>
> And yes, I already know that my next problem is going to be that the bayer
> formats are not supported in your driver (just like Philipp's driver) but
> adding them should not be difficult... but only once this issue is resolved.
>

