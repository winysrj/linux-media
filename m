Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34374 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932731AbdCJXUj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 18:20:39 -0500
Subject: Re: [PATCH v5 00/39] i.MX Media Driver
To: Russell King - ARM Linux <linux@armlinux.org.uk>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <20170310201356.GA21222@n2100.armlinux.org.uk>
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
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <26d4a31f-f9d3-8b2b-391e-fc4b44cc8e5d@gmail.com>
Date: Fri, 10 Mar 2017 15:20:34 -0800
MIME-Version: 1.0
In-Reply-To: <20170310201356.GA21222@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/10/2017 12:13 PM, Russell King - ARM Linux wrote:
> Version 5 gives me no v4l2 controls exposed through the video device
> interface.
>
> Just like with version 4, version 5 is completely useless with IMX219:
>
> imx6-mipi-csi2: LP-11 timeout, phy_state = 0x00000200
> ipu1_csi0: pipeline start failed with -110
> imx6-mipi-csi2: LP-11 timeout, phy_state = 0x00000200
> ipu1_csi0: pipeline start failed with -110
> imx6-mipi-csi2: LP-11 timeout, phy_state = 0x00000200
> ipu1_csi0: pipeline start failed with -110
>
> So, like v4, I can't do any further testing.
>

Is the imx219 placing the csi-2 bus in LP-11 state on exit
from s_power(ON)?

I realize that probably means bringing the chip up to a
completely operational state and then setting it to stream
OFF in the s_power() op.

The same had to be done for the OV5640.

Steve
