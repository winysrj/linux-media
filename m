Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35674 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933833AbdBVXlz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Feb 2017 18:41:55 -0500
Subject: Re: [PATCH v4 23/36] media: imx: Add MIPI CSI-2 Receiver subdev
 driver
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-24-git-send-email-steve_longerbeam@mentor.com>
 <1487328479.3107.21.camel@pengutronix.de>
 <20170217110616.GD21222@n2100.armlinux.org.uk>
 <1487331500.3107.43.camel@pengutronix.de>
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
Message-ID: <4f75e016-839a-3c19-0b28-d229faf25357@gmail.com>
Date: Wed, 22 Feb 2017 15:38:57 -0800
MIME-Version: 1.0
In-Reply-To: <1487331500.3107.43.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/17/2017 03:38 AM, Philipp Zabel wrote:
> On Fri, 2017-02-17 at 11:06 +0000, Russell King - ARM Linux wrote:
>> On Fri, Feb 17, 2017 at 11:47:59AM +0100, Philipp Zabel wrote:
>>> On Wed, 2017-02-15 at 18:19 -0800, Steve Longerbeam wrote:
>>>> +static void csi2_dphy_init(struct csi2_dev *csi2)
>>>> +{
>>>> +	/*
>>>> +	 * FIXME: 0x14 is derived from a fixed D-PHY reference
>>>> +	 * clock from the HSI_TX PLL, and a fixed target lane max
>>>> +	 * bandwidth of 300 Mbps. This value should be derived
>>>
>>> If the table in https://community.nxp.com/docs/DOC-94312 is correct,
>>> this should be 850 Mbps. Where does this 300 Mbps value come from?
>>
>> I thought you had some code to compute the correct value, although
>> I guess we've lost the ability to know how fast the sensor is going
>> to drive the link.
>
> I had code to calculate the number of needed lanes from the bit rate and
> link frequency. I did not actually change the D-PHY register value.
> And as you pointed out, calculating the number of lanes is not useful
> without input from the sensor driver, as some lane configurations might
> not be supported.
>
>> Note that the IMX219 currently drives the data lanes at 912Mbps almost
>> exclusively, as I've yet to finish working out how to derive the PLL
>> parameters.  (I have something that works, but it currently takes on
>> the order of 100k iterations to derive the parameters.  gcd() doesn't
>> help you in this instance.)
>
> The tc358743 also currently only implements a fixed rate (of 594 Mbps).

I've analyzed the OV5640 video modes, and they generate the following
"sysclk"'s in Mhz:

210
280
420
560
840

But I don't know whether this is equivalent to bit rate. Is it the same
as Mbps-per-lane? If so, this could be indicated to the sink by
implementing V4L2_CID_LINK_FREQ in the ov5640.c sensor driver.

The Mbps-per-lane value would then be link_freq * 2, and then
Mbps-per-lane could be used to lookup the correct "hsfreqsel"
value to program the D-PHY.

I've added this to imx6-mipi-csi2.c. If the source didn't implement
V4L2_CID_LINK_FREQ then it uses a default 849 Mbps-per-lane.


Steve
