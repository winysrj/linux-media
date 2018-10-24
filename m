Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot1-f66.google.com ([209.85.210.66]:38525 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbeJYCJH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Oct 2018 22:09:07 -0400
Date: Wed, 24 Oct 2018 12:40:07 -0500
From: Rob Herring <robh@kernel.org>
To: Luis Oliveira <luis.oliveira@synopsys.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        joao.pinto@synopsys.com, festevam@gmail.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        devicetree@vger.kernel.org
Subject: Re: [V3, 3/4] Documentation: dt-bindings: media: Document bindings
 for DW MIPI CSI-2 Host
Message-ID: <20181024174007.GA2902@bogus>
References: <1539953556-35762-1-git-send-email-lolivei@synopsys.com>
 <1539953556-35762-4-git-send-email-lolivei@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539953556-35762-4-git-send-email-lolivei@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 19, 2018 at 02:52:25PM +0200, Luis Oliveira wrote:
> Add bindings for Synopsys DesignWare MIPI CSI-2 host.
> 
> Signed-off-by: Luis Oliveira <lolivei@synopsys.com>
> ---
> Changelog
> v2-V3
> - removed IPI settings
> 
>  .../devicetree/bindings/media/snps,dw-csi-plat.txt | 52 ++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/snps,dw-csi-plat.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/snps,dw-csi-plat.txt b/Documentation/devicetree/bindings/media/snps,dw-csi-plat.txt
> new file mode 100644
> index 0000000..be3da05
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/snps,dw-csi-plat.txt
> @@ -0,0 +1,52 @@
> +Synopsys DesignWare CSI-2 Host controller
> +
> +Description
> +-----------
> +
> +This HW block is used to receive image coming from an MIPI CSI-2 compatible
> +camera.
> +
> +Required properties:
> +- compatible: shall be "snps,dw-csi-plat"

'plat' is really part of the name of the h/w block?

> +- reg			: physical base address and size of the device memory mapped
> +  registers;
> +- interrupts		: CSI-2 Host interrupt
> +- snps,output-type	: Core output to be used (IPI-> 0 or IDI->1 or BOTH->2)
> +			  These  values choose which of the Core outputs will be used,
> +			  it can be Image Data Interface or Image Pixel Interface.
> +- phys			: List of one PHY specifier (as defined in
> +			  Documentation/devicetree/bindings/phy/phy-bindings.txt).
> +			  This PHY is a MIPI DPHY working in RX mode.
> +- resets		: Reference to a reset controller (optional)
> +
> +The per-board settings:
> + - port sub-node describing a single endpoint connected to the camera as
> +   described in video-interfaces.txt[1].

Need to say 2 ports and what is each port? Why no port #0?

> +
> +Example:
> +
> +	csi2_1: csi2@3000 {
> +		compatible = "snps,dw-csi-plat";
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		reg = < 0x03000 0x7FF>;
> +		interrupts = <2>;
> +		output-type = <2>;
> +		resets = <&dw_rst 1>;
> +		phys = <&mipi_dphy_rx1 0>;
> +		phy-names = "csi2-dphy";

Not documented. Not really needed for a single entry, so I'd just drop 
it.

> +
> +		/* CSI-2 per-board settings */
> +		port@1 {
> +			reg = <1>;
> +			csi1_ep1: endpoint {
> +				remote-endpoint = <&camera_1>;
> +				data-lanes = <1 2>;
> +			};
> +		};
> +		port@2 {
> +			csi1_ep2: endpoint {
> +				remote-endpoint = <&vif1_ep>;
> +			};
> +		};
> +	};
> --
> 2.7.4
> 
