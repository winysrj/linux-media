Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34299 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750803AbdAPRPS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jan 2017 12:15:18 -0500
Subject: Re: [PATCH v3 06/24] ARM: dts: imx6-sabrelite: add OV5642 and OV5640
 camera sensors
To: Philipp Zabel <p.zabel@pengutronix.de>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-7-git-send-email-steve_longerbeam@mentor.com>
 <1484309021.31475.29.camel@pengutronix.de>
 <1bb64209-7c58-fe10-3db9-c5b8103eda90@gmail.com>
 <1484571323.8415.98.camel@pengutronix.de>
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
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <83a5f605-2bdb-76a1-28c8-620e829226f3@gmail.com>
Date: Mon, 16 Jan 2017 09:15:15 -0800
MIME-Version: 1.0
In-Reply-To: <1484571323.8415.98.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/16/2017 04:55 AM, Philipp Zabel wrote:
> On Fri, 2017-01-13 at 15:04 -0800, Steve Longerbeam wrote:
>
>>>> @@ -299,6 +326,52 @@
>>>>    	pinctrl-names = "default";
>>>>    	pinctrl-0 = <&pinctrl_i2c2>;
>>>>    	status = "okay";
>>>> +
>>>> +	ov5640: camera@40 {
>>>> +		compatible = "ovti,ov5640";
>>>> +		pinctrl-names = "default";
>>>> +		pinctrl-0 = <&pinctrl_ov5640>;
>>>> +		clocks = <&mipi_xclk>;
>>>> +		clock-names = "xclk";
>>>> +		reg = <0x40>;
>>>> +		xclk = <22000000>;
>>> This is superfluous, you can use clk_get_rate on mipi_xclk.
>> This property is actually there to tell the driver what to set the
>> rate to, with clk_set_rate(). So you are saying it would be better
>> to set the rate in the device tree and the driver should only
>> retrieve the rate?
> Yes. Given that this is a reference clock input that is constant on a
> given board and never changes during runtime, I think this is the
> correct way. The clock will be fixed rate on most boards, I assume.

Ok, that makes sense, I'll make that change.

Steve

