Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:54488 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751133AbdAaKbw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 05:31:52 -0500
Date: Tue, 31 Jan 2017 10:30:19 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>
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
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v3 17/24] media: imx: Add CSI subdev driver
Message-ID: <20170131103019.GT27312@n2100.armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-18-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1483755102-24785-18-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 06, 2017 at 06:11:35PM -0800, Steve Longerbeam wrote:
> This is a media entity subdevice for the i.MX Camera
> Serial Interface module.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---

The lack of s_frame_interval/g_frame_interval in this driver means:

media-ctl -v -d /dev/media1 --set-v4l2 '"imx6-mipi-csi2":1[fmt:SGBRG8/512x512@1/30]'

Opening media device /dev/media1
Enumerating entities
Found 29 entities
Enumerating pads and links
Setting up format SGBRG8 512x512 on pad imx6-mipi-csi2/1
Format set: SGBRG8 512x512
Setting up frame interval 1/30 on entity imx6-mipi-csi2
Unable to set frame interval: Inappropriate ioctl for device (-25)Unable to setup formats: Inappropriate ioctl for device (25)

which causes the setup of the next element in the chain to also fail
(because the above media-ctl command doesn't set the sink on the
ipu1 csi0 mux.)

It seems to me that without the frame interval supported throughout the
chain, there's no way for an application to properly negotiate the
capture parameters via the "try" mechanism, since it has no idea whether
the frame rate it wants is supported throughout the subdev chain.  Eg,
the sensor may be able to do 100fps but there could be something in the
pipeline that restricts it due to bandwidth.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
