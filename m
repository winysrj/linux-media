Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36390 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751316AbdGQThJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 15:37:09 -0400
Date: Mon, 17 Jul 2017 14:37:06 -0500
From: Rob Herring <robh@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 1/4] dt-bindings: document the tegra CEC bindings
Message-ID: <20170717193706.2vjxqvyuuewlimqh@rob-hp-laptop>
References: <20170715124753.43714-1-hverkuil@xs4all.nl>
 <20170715124753.43714-2-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170715124753.43714-2-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 15, 2017 at 02:47:50PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This documents the binding for the Tegra CEC module.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  .../devicetree/bindings/media/tegra-cec.txt        | 26 ++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/tegra-cec.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/tegra-cec.txt b/Documentation/devicetree/bindings/media/tegra-cec.txt
> new file mode 100644
> index 000000000000..ba0b6071acaa
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/tegra-cec.txt
> @@ -0,0 +1,26 @@
> +* Tegra HDMI CEC driver

Bindings are for h/w, not drivers...

> +The HDMI CEC module is present in Tegra SoCs and its purpose is to
> +handle communication between HDMI connected devices over the CEC bus.
> +
> +Required properties:
> +  - compatible : value should be one of the following:
> +	"nvidia,tegra114-cec"
> +	"nvidia,tegra124-cec"
> +	"nvidia,tegra210-cec"
> +  - reg : Physical base address of the IP registers and length of memory
> +	  mapped region.
> +  - interrupts : HDMI CEC interrupt number to the CPU.
> +  - clocks : from common clock binding: handle to HDMI CEC clock.
> +  - clock-names : from common clock binding: must contain "cec",
> +		  corresponding to ithe entry in the clocks property.

s/ithe/the/

> +  - hdmi-phandle : phandle to the HDMI controller, see also cec.txt.
> +
> +Example:
> +
> +tegra_cec {

cec@70015000

> +	compatible = "nvidia,tegra124-cec";
> +	reg = <0x0 0x70015000 0x0 0x00001000>;
> +	interrupts = <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>;
> +	clocks = <&tegra_car TEGRA124_CLK_CEC>;
> +	clock-names = "cec";
> -- 
> 2.11.0
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
