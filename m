Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:44514 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932595AbdBPTKX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Feb 2017 14:10:23 -0500
Date: Thu, 16 Feb 2017 19:09:31 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        mark.rutland@arm.com, andrew-ct.chen@mediatek.com,
        minghsiu.tsai@mediatek.com, sakari.ailus@linux.intel.com,
        nick@shmanahar.org, songjun.wu@microchip.com,
        Steve Longerbeam <steve_longerbeam@mentor.com>, pavel@ucw.cz,
        robert.jarzmik@free.fr, devel@driverdev.osuosl.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, shuah@kernel.org,
        geert@linux-m68k.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de, arnd@arndb.de,
        mchehab@kernel.org, bparrot@ti.com, robh+dt@kernel.org,
        horms+renesas@verge.net.au, tiffany.lin@mediatek.com,
        linux-arm-kernel@lists.infradead.org,
        niklas.soderlund+renesas@ragnatech.se, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, jean-christophe.trotin@st.com,
        p.zabel@pengutronix.de, fabio.estevam@nxp.com, shawnguo@kernel.org,
        sudipm.mukherjee@gmail.com
Subject: Re: [PATCH v4 20/36] media: imx: Add CSI subdev driver
Message-ID: <20170216190931.GV27312@n2100.armlinux.org.uk>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-21-git-send-email-steve_longerbeam@mentor.com>
 <20170216115206.GL27312@n2100.armlinux.org.uk>
 <20170216124027.GM27312@n2100.armlinux.org.uk>
 <fa52c59e-f582-672c-8df0-2b959f880fa1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa52c59e-f582-672c-8df0-2b959f880fa1@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 16, 2017 at 10:44:16AM -0800, Steve Longerbeam wrote:
> On 02/16/2017 04:40 AM, Russell King - ARM Linux wrote:
> >[    8.012191] imx_media_common: module is from the staging directory, the quality is unknown, you have been warned.
> >[    8.018175] imx_media: module is from the staging directory, the quality is unknown, you have been warned.
> >[    8.748345] imx-media: Registered subdev ipu1_csi0_mux
> >[    8.753451] imx-media: Registered subdev ipu2_csi1_mux
> >[    9.055196] imx219 0-0010: detected IMX219 sensor
> >[    9.090733] imx6_mipi_csi2: module is from the staging directory, the quality is unknown, you have been warned.
> >[    9.092247] imx-media: Registered subdev imx219 0-0010
> >[    9.334338] imx-media: Registered subdev imx6-mipi-csi2
> >[    9.372452] imx_media_capture: module is from the staging directory, the quality is unknown, you have been warned.
> >[    9.378163] imx_media_capture: module is from the staging directory, the quality is unknown, you have been warned.
> >[    9.390033] imx_media_csi: module is from the staging directory, the quality is unknown, you have been warned.
> >[    9.394362] imx-media: Received unknown subdev ipu1_csi0
> 
> The root problem is here. I don't know why the CSI entities are not
> being recognized. Can you share the changes you made?

No, it's not the root problem that's causing the BUG/etc, but it is
_a_ problem.  Nevertheless, it's something I fixed - disconnecting
the of_node from the struct device needed one other change in the
imx-media code that was missing at this time.

However, that's no excuse what so ever for the BUG_ON() and lack of
error cleanup (causing use-after-free, which is just another way of
saying "data corruption waiting to happen") that I identified.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
