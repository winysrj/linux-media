Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35700 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750730AbdAaDbX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 22:31:23 -0500
Subject: Re: [PATCH v3 22/24] media: imx: Add MIPI CSI-2 OV5640 sensor subdev
 driver
To: Russell King - ARM Linux <linux@armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-23-git-send-email-steve_longerbeam@mentor.com>
 <20170130232955.GK27312@n2100.armlinux.org.uk>
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
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <12fbe4d6-3e62-53b1-feef-011e1ad7affe@gmail.com>
Date: Mon, 30 Jan 2017 19:31:20 -0800
MIME-Version: 1.0
In-Reply-To: <20170130232955.GK27312@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/30/2017 03:29 PM, Russell King - ARM Linux wrote:
> On Fri, Jan 06, 2017 at 06:11:40PM -0800, Steve Longerbeam wrote:
>> +config IMX_OV5640_MIPI
>> +       tristate "OmniVision OV5640 MIPI CSI-2 camera support"
>> +       depends on GPIOLIB && VIDEO_IMX_CAMERA
>> +       select IMX_MIPI_CSI2
>> +       default y
> Why is this defaulting to y?  New drivers should not default to enabled
> unless they are replacing some already pre-existing functionality.
> Ditto for the other camera driver.

The ov564x sensors are required for the SabreSD and SabreLite/Nitrogen
reference boards (if VIDEO_IMX_CAMERA is enabled that is). But they're not
required for other platforms, so you're right I shouldn't have defaulted 
these
to yes. Fixed.


Steve

