Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34552 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933547AbdBPW1p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Feb 2017 17:27:45 -0500
Subject: Re: [PATCH v4 00/36] i.MX Media Driver
To: Russell King - ARM Linux <linux@armlinux.org.uk>,
        p.zabel@pengutronix.de
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <20170216222006.GA21222@n2100.armlinux.org.uk>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <923326d6-43fe-7328-d959-14fd341e47ae@gmail.com>
Date: Thu, 16 Feb 2017 14:27:41 -0800
MIME-Version: 1.0
In-Reply-To: <20170216222006.GA21222@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/16/2017 02:20 PM, Russell King - ARM Linux wrote:
> On Wed, Feb 15, 2017 at 06:19:02PM -0800, Steve Longerbeam wrote:
>> In version 4:
>
> With this version, I get:
>
> [28762.892053] imx6-mipi-csi2: LP-11 timeout, phy_state = 0x00000000
> [28762.899409] ipu1_csi0: pipeline_set_stream failed with -110
>

Right, in the imx219, on exit from s_power(), the clock and data lanes
must be placed in the LP-11 state. This has been done in the ov5640 and
tc358743 subdevs.

If we want to bring in the patch that adds a .prepare_stream() op,
the csi-2 bus would need to be placed in LP-11 in that op instead.

Philipp, should I go ahead and add your .prepare_stream() patch?

Steve
