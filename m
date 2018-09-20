Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:54874 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387418AbeITSyc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 14:54:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Luis Oliveira <Luis.Oliveira@synopsys.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joao.Pinto@synopsys.com, festevam@gmail.com,
        Luis Oliveira <luis.oliveira@synopsys.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Todor Tomov <todor.tomov@linaro.org>,
        devicetree@vger.kernel.org
Subject: Re: [V2, 2/5] Documentation: dt-bindings: Document the Synopsys MIPI DPHY Rx bindings
Date: Thu, 20 Sep 2018 16:11:14 +0300
Message-ID: <1754496.WQhu2lOnZY@avalon>
In-Reply-To: <20180920111648.27000-3-lolivei@synopsys.com>
References: <20180920111648.27000-1-lolivei@synopsys.com> <20180920111648.27000-3-lolivei@synopsys.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Louis,

Thank you for the patch.

On Thursday, 20 September 2018 14:16:40 EEST Luis Oliveira wrote:
> Add device-tree bindings documentation for SNPS DesignWare MIPI D-PHY in
> RX mode.
> 
> Signed-off-by: Luis Oliveira <lolivei@synopsys.com>
> ---
> Changelog
> v2:
> - no changes
> 
>  .../devicetree/bindings/phy/snps,dphy-rx.txt       | 36 +++++++++++++++++++
>  1 file changed, 36 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/snps,dphy-rx.txt
> 
> diff --git a/Documentation/devicetree/bindings/phy/snps,dphy-rx.txt
> b/Documentation/devicetree/bindings/phy/snps,dphy-rx.txt new file mode
> 100644
> index 0000000..9079f4a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/snps,dphy-rx.txt
> @@ -0,0 +1,36 @@
> +Synopsys DesignWare MIPI Rx D-PHY block details
> +
> +Description
> +-----------
> +
> +The Synopsys MIPI D-PHY controller supports MIPI-DPHY in receiver mode.
> +Please refer to phy-bindings.txt for more information.
> +
> +Required properties:
> +- compatible		: Shall be "snps,dphy-rx".
> +- #phy-cells		: Must be 1.
> +- snps,dphy-frequency	: Output frequency of the D-PHY.

If that's the frequency of the clock on the output side of the RX PHY, doesn't 
it depend on the frequency on the CSI-2 (or other) bus ? Can't it vary ? Why 
do you need to have it in DT ?

> +- snps,dphy-te-len	: Size of the communication interface (8 bits->8 or
> 12bits->12).

We have similar properties in various bindings, such as bus-width in video-
interfaces.txt. Couldn't we use a more standard name ?

> +- reg			: Physical base address and size of the device memory mapped
> +		 	  registers;

The example below shows three ranges. Could you document the ranges that are 
expected ?

> +Optional properties:
> +- snps,compat-mode	: Compatibility mode control

What is this ?

> +The per-board settings:
> +- gpios 		: Synopsys testchip used as reference uses this to change 
setup
> +		  	  configurations.

Here too, what is this for ?

> +Example:
> +
> +	mipi_dphy_rx1: dphy@3040 {
> +		compatible = "snps,dphy-rx";
> +		#phy-cells = <1>;
> +		snps,dphy-frequency = <300000>;
> +		snps,dphy-te-len = <12>;
> +		snps,compat-mode = <1>;
> +		reg = < 0x03040 0x20
> +			0x08000 0x100
> +			0x09000 0x100>;

The base addresses are pretty low, what kind of bus does this sit on ?

> +	};
> +

-- 
Regards,

Laurent Pinchart
