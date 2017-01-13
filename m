Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:44165 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751521AbdAML77 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jan 2017 06:59:59 -0500
Message-ID: <1484308772.31475.25.camel@pengutronix.de>
Subject: Re: [PATCH v3 05/24] ARM: dts: imx6qdl-sabrelite: remove erratum
 ERR006687 workaround
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Fri, 13 Jan 2017 12:59:32 +0100
In-Reply-To: <1483755102-24785-6-git-send-email-steve_longerbeam@mentor.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
         <1483755102-24785-6-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, den 06.01.2017, 18:11 -0800 schrieb Steve Longerbeam:
> There is a pin conflict with GPIO_6. This pin functions as a power
> input pin to the OV5642 camera sensor, but ENET uses it as the h/w
> workaround for erratum ERR006687, to wake-up the ARM cores on normal
> RX and TX packet done events. So we need to remove the h/w workaround
> to support the OV5642. The result is that the CPUidle driver will no
> longer allow entering the deep idle states on the sabrelite.
> 
> This is a partial revert of
> 
> commit 6261c4c8f13e ("ARM: dts: imx6qdl-sabrelite: use GPIO_6 for FEC
> 			interrupt.")
> commit a28eeb43ee57 ("ARM: dts: imx6: tag boards that have the HW workaround
> 			for ERR006687")
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>

Pity this has to be removed for all, Nitrogen6X should really use DT
overlays for the add-on boards / cameras.

regards
Philipp

