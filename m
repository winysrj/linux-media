Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:59258 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752217AbdATNxN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Jan 2017 08:53:13 -0500
Subject: Re: [PATCH v3 00/24] i.MX Media Driver
To: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c6e98327-7e2c-f34a-2d23-af7b236de441@xs4all.nl>
Date: Fri, 20 Jan 2017 14:52:55 +0100
MIME-Version: 1.0
In-Reply-To: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve, Philipp,

On 01/07/2017 03:11 AM, Steve Longerbeam wrote:
> In version 3:
> 
> Changes suggested by Rob Herring <robh@kernel.org>:
> 
>   - prepended FIM node properties with vendor prefix "fsl,".
> 
>   - make mipi csi-2 receiver compatible string SoC specific:
>     "fsl,imx6-mipi-csi2" instead of "fsl,imx-mipi-csi2".
> 
>   - redundant "_clk" removed from mipi csi-2 receiver clock-names property.
> 
>   - removed board-specific info from the media driver binding doc. These
>     were all related to sensor bindings, which already are (adv7180)
>     or will be (ov564x) covered in separate binding docs. All reference
>     board info not related to DT bindings has been moved to
>     Documentation/media/v4l-drivers/imx.rst.
> 
>   - removed "_mipi" from the OV5640 compatible string.
> 
> Changes suggested by Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>:
> 
>   Mostly cosmetic/non-functional changes which I won't list here, except
>   for the following:
> 
>   - spin_lock_irqsave() changed to spin_lock() in a couple interrupt handlers.
> 
>   - fixed some unnecessary of_node_put()'s in for_each_child_of_node() loops.
> 
>   - check/handle return code from required reg property of CSI port nodes.
> 
>   - check/handle return code from clk_prepare_enable().
> 
> Changes suggested by Fabio Estevam <festevam@gmail.com>:
> 
>   - switch to VGEN3 Analog Vdd supply assuming rev. C SabreSD boards.
> 
>   - finally got around to passing valid IOMUX pin config values to the
>     pin groups.
> 
> Other changes:
> 
>   - removed the FIM properties that overrided the v4l2 FIM control defaults
>     values. This was left-over from a requirement of a customer and is not
>     necessary here.
> 
>   - The FIM must be explicitly enabled in the fim child node under the CSI
>     port nodes, using the status property. If not enabled, FIM v4l2 controls
>     will not appear in the video capture driver.
> 
>   - brought in additional media types patch from Philipp Zabel. Use new
>     MEDIA_ENT_F_VID_IF_BRIDGE in mipi csi-2 receiver subdev.
> 
>   - brought in latest platform generic video multiplexer subdevice driver
>     from Philipp Zabel (squashed with patch that uses new MEDIA_ENT_F_MUX).
> 
>   - removed imx-media-of.h, moved those prototypes into imx-media.h.

Based on the discussion on the mailinglist it seems everyone agrees that this
is the preferred driver, correct?

There are a bunch of review comments, so I will wait for a v4. I plan to merge
that staging driver unless there are major issues with it.

I am not sure if I would merge those sensor drivers in staging, I'll have to
take a closer look at those once v4 is posted.

Regards,

	Hans
