Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36365 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934053AbdBQS1F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 13:27:05 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH v4 23/36] media: imx: Add MIPI CSI-2 Receiver subdev
 driver
To: Philipp Zabel <p.zabel@pengutronix.de>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-24-git-send-email-steve_longerbeam@mentor.com>
 <1487328479.3107.21.camel@pengutronix.de>
 <1487340970.3107.73.camel@pengutronix.de>
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
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <c858831f-6ce3-54b7-ef03-857129edb0bf@gmail.com>
Date: Fri, 17 Feb 2017 10:27:01 -0800
MIME-Version: 1.0
In-Reply-To: <1487340970.3107.73.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/17/2017 06:16 AM, Philipp Zabel wrote:
> On Fri, 2017-02-17 at 11:47 +0100, Philipp Zabel wrote:
>> On Wed, 2017-02-15 at 18:19 -0800, Steve Longerbeam wrote:
>>> +static void csi2_dphy_init(struct csi2_dev *csi2)
>>> +{
>>> +	/*
>>> +	 * FIXME: 0x14 is derived from a fixed D-PHY reference
>>> +	 * clock from the HSI_TX PLL, and a fixed target lane max
>>> +	 * bandwidth of 300 Mbps. This value should be derived
>>
>> If the table in https://community.nxp.com/docs/DOC-94312 is correct,
>> this should be 850 Mbps. Where does this 300 Mbps value come from?
>
> I got it, the dptdin_map value for 300 Mbps is 0x14 in the Rockchip DSI
> driver. But that value is written to the register as HSFREQRANGE_SEL(x):
>
> #define HSFREQRANGE_SEL(val)    (((val) & 0x3f) << 1)

Ah you are right, 0x14 would be a "testdin" value of 0x0a, which from
the Rockchip table would be 950 MHz per lane.

But thanks for pointing the table at
https://community.nxp.com/docs/DOC-94312. That table is what
should be referenced in the above comment (850 MHz per lane
for a 27MHz reference clock). I will update the comment based
on that table.

Steve



>
> which is 0x28. Further, the Rockchip D-PHY probably is another version,
> as its max_mbps goes up to 1500.
>
>
