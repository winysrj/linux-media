Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:36098 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755567AbdLONe6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 08:34:58 -0500
Subject: Re: [PATCH v10 1/4] dt-bindings: media: Document Synopsys DesignWare
 HDMI RX
To: Jose Abreu <Jose.Abreu@synopsys.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1513013948.git.joabreu@synopsys.com>
 <befe90fc55bfa4d1dc599270bc0372cf8691247a.1513013948.git.joabreu@synopsys.com>
Cc: Joao Pinto <Joao.Pinto@synopsys.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        devicetree@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a3aac12a-e519-f9de-1c6d-b8fae393895d@xs4all.nl>
Date: Fri, 15 Dec 2017 14:34:55 +0100
MIME-Version: 1.0
In-Reply-To: <befe90fc55bfa4d1dc599270bc0372cf8691247a.1513013948.git.joabreu@synopsys.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/12/17 18:41, Jose Abreu wrote:
> Document the bindings for the Synopsys DesignWare HDMI RX.
> 
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
> Acked-by: Rob Herring <robh@kernel.org> (v8)
> Cc: Joao Pinto <jpinto@synopsys.com>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sylwester Nawrocki <snawrocki@kernel.org>
> Cc: devicetree@vger.kernel.org

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
> Changes from v7:
> 	- Remove SoC specific bindings (Rob)
> Changes from v6:
> 	- Document which properties are required/optional (Sylwester)
> 	- Drop compatible string for SoC (Sylwester)
> 	- Reword edid-phandle property (Sylwester)
> 	- Typo fixes (Sylwester)
> Changes from v4:
> 	- Use "cfg" instead of "cfg-clk" (Rob)
> 	- Change node names (Rob)
> Changes from v3:
> 	- Document the new DT bindings suggested by Sylwester
> Changes from v2:
> 	- Document edid-phandle property
> ---
>  .../devicetree/bindings/media/snps,dw-hdmi-rx.txt  | 58 ++++++++++++++++++++++
>  1 file changed, 58 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/snps,dw-hdmi-rx.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/snps,dw-hdmi-rx.txt b/Documentation/devicetree/bindings/media/snps,dw-hdmi-rx.txt
> new file mode 100644
> index 0000000..1dc09c6
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/snps,dw-hdmi-rx.txt
> @@ -0,0 +1,58 @@
> +Synopsys DesignWare HDMI RX Decoder
> +===================================
> +
> +This document defines device tree properties for the Synopsys DesignWare HDMI
> +RX Decoder (DWC HDMI RX).
> +
> +The properties bellow belong to the Synopsys DesignWare HDMI RX Decoder node.
> +
> +Required properties:
> +
> +- compatible: Shall be "snps,dw-hdmi-rx".
> +- reg: Memory mapped base address and length of the DWC HDMI RX registers.
> +- interrupts: Reference to the DWC HDMI RX interrupt and the HDMI 5V sense
> +interrupt.
> +- clocks: Reference to the config clock.
> +- clock-names: Shall be "cfg".
> +- #address-cells: Shall be 1.
> +- #size-cells: Shall be 0.
> +
> +Optional properties:
> +
> +- edid-phandle: Reference to the EDID handler block; if this property is not
> +specified it is assumed that EDID is handled by device described by parent
> +node of the HDMI RX node. You should not specify this property if your HDMI RX
> +controller does not have CEC.
> +
> +You also have to create a subnode for the PHY device. PHY node properties are
> +as follows.
> +
> +Required properties:
> +
> +- compatible: Shall be "snps,dw-hdmi-phy-e405".
> +- reg: Shall be the JTAG address of the PHY.
> +- clocks: Reference to the config clock.
> +- clock-names: Shall be "cfg".
> +
> +Example:
> +
> +hdmi_rx: hdmi-rx@0 {
> +	compatible = "snps,dw-hdmi-rx";
> +	reg = <0x0 0x10000>;
> +	interrupts = <1 2>;
> +	edid-phandle = <&dw_hdmi_edid>;
> +
> +	clocks = <&dw_hdmi_refclk>;
> +	clock-names = "cfg";
> +
> +	#address-cells = <1>;
> +	#size-cells = <0>;
> +
> +	hdmi-phy@fc {
> +		compatible = "snps,dw-hdmi-phy-e405";
> +		reg = <0xfc>;
> +
> +		clocks = <&dw_hdmi_refclk>;
> +		clock-names = "cfg";
> +	};
> +};
> 
