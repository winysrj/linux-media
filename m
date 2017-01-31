Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:54870 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751452AbdAaLBS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 06:01:18 -0500
Date: Tue, 31 Jan 2017 11:00:27 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>
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
Subject: Re: [PATCH v3 00/24] i.MX Media Driver
Message-ID: <20170131110027.GU27312@n2100.armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <20170131004510.GQ27312@n2100.armlinux.org.uk>
 <951c1a08-c0f2-4333-b4bf-410de8dd863f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <951c1a08-c0f2-4333-b4bf-410de8dd863f@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 30, 2017 at 05:22:01PM -0800, Steve Longerbeam wrote:
> I'm also having trouble finding a datasheet for it, but from what
> I've read, it has a MIPI CSI-2 interface. It should work fine as long
> as it presents a single source pad, registers asynchronously, and
> sets its entity function to MEDIA_ENT_F_CAM_SENSOR.

Yes, it is MIPI CSI-2, and yes it has a single source pad, registers
asynchronously, but that's about as far as it goes.

The structure is a camera sensor followed by some processing.  So just
like the smiapp code, I've ended up with multiple subdevs describing
each stage of the sensors pipeline.

Just like smiapp, the camera sensor block (which is the very far end
of the pipeline) is marked with MEDIA_ENT_F_CAM_SENSOR.  However, in
front of that is the binner, which just like smiapp gets a separate
entity.  It's this entity which is connected to the mipi-csi2 subdev.

Unlike smiapp, which does not set an entity function, I set my binner
entity as MEDIA_ENT_F_PROC_VIDEO_SCALER on the basis that that is
what V4L2 documentation recommend:

    -  ..  row 27

       ..  _MEDIA-ENT-F-PROC-VIDEO-SCALER:

       -  ``MEDIA_ENT_F_PROC_VIDEO_SCALER``

       -  Video scaler. An entity capable of video scaling must have
          at least one sink pad and one source pad, and scale the
          video frame(s) received on its sink pad(s) to a different
          resolution output on its source pad(s). The range of
          supported scaling ratios is entity-specific and can differ
          between the horizontal and vertical directions (in particular
          scaling can be supported in one direction only). Binning and
          skipping are considered as scaling.

This causes attempts to configure the ipu1_csi0 interface to fail:

media-ctl -v -d /dev/media1 --set-v4l2 '"ipu1_csi0":1[fmt:SGBRG8/512x512@1/30]'
Opening media device /dev/media1
Enumerating entities
Found 29 entities
Enumerating pads and links
Setting up format SGBRG8 512x512 on pad ipu1_csi0/1
Unable to set format: No such device (-19)
Unable to setup formats: No such device (19)

and in the kernel log:

ipu1_csi0: no sensor attached

And yes, I already know that my next problem is going to be that the bayer
formats are not supported in your driver (just like Philipp's driver) but
adding them should not be difficult... but only once this issue is resolved.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
