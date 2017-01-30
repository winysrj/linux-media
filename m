Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45880 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752659AbdA3WcM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 17:32:12 -0500
Date: Mon, 30 Jan 2017 22:29:59 +0000
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
Subject: Re: [PATCH v3 19/24] media: imx: Add IC subdev drivers
Message-ID: <20170130222959.GD27898@n2100.armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-20-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1483755102-24785-20-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 06, 2017 at 06:11:37PM -0800, Steve Longerbeam wrote:
> This is a set of three media entity subdevice drivers for the i.MX
> Image Converter. The i.MX IC module contains three independent
> "tasks":
> 
> - Pre-processing Encode task: video frames are routed directly from
>   the CSI and can be scaled, color-space converted, and rotated.
>   Scaled output is limited to 1024x1024 resolution. Output frames
>   are routed to the camera interface entities (camif).
> 
> - Pre-processing Viewfinder task: this task can perform the same
>   conversions as the pre-process encode task, but in addition can
>   be used for hardware motion compensated deinterlacing. Frames can
>   come either directly from the CSI or from the SMFC entities (memory
>   buffers via IDMAC channels). Scaled output is limited to 1024x1024
>   resolution. Output frames can be routed to various sinks including
>   the post-processing task entities.
> 
> - Post-processing task: same conversions as pre-process encode. However
>   this entity sends frames to the i.MX IPU image converter which supports
>   image tiling, which allows scaled output up to 4096x4096 resolution.
>   Output frames can be routed to the camera interfaces.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>

Applying: media: imx: Add IC subdev drivers
.git/rebase-apply/patch:3054: new blank line at EOF.
+
warning: 1 line adds whitespace errors.


-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
