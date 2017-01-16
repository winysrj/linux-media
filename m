Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:33689 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751043AbdAPM4a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jan 2017 07:56:30 -0500
Message-ID: <1484571323.8415.98.camel@pengutronix.de>
Subject: Re: [PATCH v3 06/24] ARM: dts: imx6-sabrelite: add OV5642 and
 OV5640 camera sensors
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
Date: Mon, 16 Jan 2017 13:55:23 +0100
In-Reply-To: <1bb64209-7c58-fe10-3db9-c5b8103eda90@gmail.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
         <1483755102-24785-7-git-send-email-steve_longerbeam@mentor.com>
         <1484309021.31475.29.camel@pengutronix.de>
         <1bb64209-7c58-fe10-3db9-c5b8103eda90@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2017-01-13 at 15:04 -0800, Steve Longerbeam wrote:
>
> On 01/13/2017 04:03 AM, Philipp Zabel wrote:
> > Am Freitag, den 06.01.2017, 18:11 -0800 schrieb Steve Longerbeam:
> >> Enables the OV5642 parallel-bus sensor, and the OV5640 MIPI CSI-2 sensor.
> >> Both hang off the same i2c2 bus, so they require different (and non-
> >> default) i2c slave addresses.
> >>
> >> The OV5642 connects to the parallel-bus mux input port on ipu1_csi0_mux.
> >>
> >> The OV5640 connects to the input port on the MIPI CSI-2 receiver on
> >> mipi_csi. It is set to transmit over MIPI virtual channel 1.
> >>
> >> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> >> ---
> >>   arch/arm/boot/dts/imx6dl-sabrelite.dts   |   5 ++
> >>   arch/arm/boot/dts/imx6q-sabrelite.dts    |   6 ++
> >>   arch/arm/boot/dts/imx6qdl-sabrelite.dtsi | 118 +++++++++++++++++++++++++++++++
> >>   3 files changed, 129 insertions(+)
> >>
> >> diff --git a/arch/arm/boot/dts/imx6dl-sabrelite.dts b/arch/arm/boot/dts/imx6dl-sabrelite.dts
> >> index 0f06ca5..fec2524 100644
> >> --- a/arch/arm/boot/dts/imx6dl-sabrelite.dts
> >> +++ b/arch/arm/boot/dts/imx6dl-sabrelite.dts
[...]
> >> @@ -299,6 +326,52 @@
> >>   	pinctrl-names = "default";
> >>   	pinctrl-0 = <&pinctrl_i2c2>;
> >>   	status = "okay";
> >> +
> >> +	ov5640: camera@40 {
> >> +		compatible = "ovti,ov5640";
> >> +		pinctrl-names = "default";
> >> +		pinctrl-0 = <&pinctrl_ov5640>;
> >> +		clocks = <&mipi_xclk>;
> >> +		clock-names = "xclk";
> >> +		reg = <0x40>;
> >> +		xclk = <22000000>;
> > This is superfluous, you can use clk_get_rate on mipi_xclk.
> 
> This property is actually there to tell the driver what to set the
> rate to, with clk_set_rate(). So you are saying it would be better
> to set the rate in the device tree and the driver should only
> retrieve the rate?

Yes. Given that this is a reference clock input that is constant on a
given board and never changes during runtime, I think this is the
correct way. The clock will be fixed rate on most boards, I assume.

regards
Philipp

