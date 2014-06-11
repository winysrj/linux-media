Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48265 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaFKLid (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jun 2014 07:38:33 -0400
Message-ID: <1402486711.4107.127.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 31/43] ARM: dts: imx6qdl: Flesh out MIPI CSI2 receiver
 node
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Wed, 11 Jun 2014 13:38:31 +0200
In-Reply-To: <1402178205-22697-32-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
	 <1402178205-22697-32-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Samstag, den 07.06.2014, 14:56 -0700 schrieb Steve Longerbeam:
> Add mode device info to the MIPI CSI2 receiver node: compatible string,
> interrupt sources, clocks.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  arch/arm/boot/dts/imx6qdl.dtsi |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
> index d793cd6..00130a8 100644
> --- a/arch/arm/boot/dts/imx6qdl.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl.dtsi
> @@ -1011,8 +1011,13 @@
>  				status = "disabled";
>  			};
>  
> -			mipi_csi: mipi@021dc000 {
> +			mipi_csi2: mipi@021dc000 {
> +				compatible = "fsl,imx6-mipi-csi2";
>  				reg = <0x021dc000 0x4000>;
> +				interrupts = <0 100 0x04>, <0 101 0x04>;
> +				clocks = <&clks 138>, <&clks 208>;

clk 138 is hsi_tx_clk_root, gated by the mipi_core_cfg gate bit.
All MIPI CSI input clocks are also gated by mipi_core_cfg, so this
will work just as well. But maybe add a comment?

> +				clock-names = "dphy_clk", "cfg_clk";

It is a bit confusing, though.

The i.MX6DL and i.MX6Q TRMs lists the following gateable input clocks,
all gated by the mipi_core_cfg bit:
- ac_clk_125m from ahb_clk_root,
- ips_clk and ips_clk_s from ipg_clk_root
- cfg_clk and pll_refclk from video_27m_clk_root

Which one is "dphy_clk"?

regards
Philipp

