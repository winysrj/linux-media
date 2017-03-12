Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:46400 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935308AbdCLT6o (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Mar 2017 15:58:44 -0400
Date: Sun, 12 Mar 2017 19:57:41 +0000
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
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v5 00/39] i.MX Media Driver
Message-ID: <20170312195741.GS21222@n2100.armlinux.org.uk>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <20170310201356.GA21222@n2100.armlinux.org.uk>
 <47542ef8-3e91-b4cd-cc65-95000105f172@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47542ef8-3e91-b4cd-cc65-95000105f172@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Mar 11, 2017 at 04:30:53PM -0800, Steve Longerbeam wrote:
> If it's too difficult to get the imx219 csi-2 transmitter into the
> LP-11 state on power on, perhaps the csi-2 receiver can be a little
> more lenient on the transmitter and make the LP-11 timeout a warning
> instead of error-out.
> 
> Can you try the attached change on top of the version 5 patchset?
> 
> If that doesn't work then you're just going to have to fix the bug
> in imx219.

That patch gets me past that hurdle, only to reveal that there's another
issue:

imx6-mipi-csi2: LP-11 timeout, phy_state = 0x00000200
imx219 0-0010: VT: pixclk 139200000Hz line 80742Hz frame 30.0Hz
imx219 0-0010: VT: line period 12385ns
imx219 0-0010: OP: pixclk 38500000Hz, 2 lanes, 308Mbps peak each
imx219 0-0010: OP: 3288 bits/line/lane act=10675ns lp/idle=1710ns
ipu1_csi0: csi_idmac_setup failed: -22
ipu1_csi0: pipeline start failed with -22
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1860 at /home/rmk/git/linux-rmk/drivers/media/v4l2-core/videobuf2-core.c:1340 vb2_start_streaming+0x124/0x1b4 [videobuf2_core]

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
