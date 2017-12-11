Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59289 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751400AbdLKQpt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 11:45:49 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jacob Chen <jacob-chen@iotwrt.com>
Cc: linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, mchehab@kernel.org,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, tfiga@chromium.org, zhengsq@rock-chips.com,
        zyc@rock-chips.com, eddie.cai.linux@gmail.com,
        jeffy.chen@rock-chips.com, allon.huang@rock-chips.com,
        devicetree@vger.kernel.org, heiko@sntech.de, robh+dt@kernel.org,
        Joao.Pinto@synopsys.com, Luis.Oliveira@synopsys.com,
        Jose.Abreu@synopsys.com, Jacob Chen <jacob2.chen@rock-chips.com>
Subject: Re: [PATCH v3 07/12] dt-bindings: Document the Rockchip MIPI RX D-PHY bindings
Date: Mon, 11 Dec 2017 18:45:50 +0200
Message-ID: <2576683.vP2aWnt5jG@avalon>
In-Reply-To: <20171206111939.1153-8-jacob-chen@iotwrt.com>
References: <20171206111939.1153-1-jacob-chen@iotwrt.com> <20171206111939.1153-8-jacob-chen@iotwrt.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Jacob,

Thank you for the patch.

On Wednesday, 6 December 2017 13:19:34 EET Jacob Chen wrote:
> From: Jacob Chen <jacob2.chen@rock-chips.com>
> 
> Add DT bindings documentation for Rockchip MIPI D-PHY RX
> 
> Signed-off-by: Jacob Chen <jacob2.chen@rock-chips.com>
> ---
>  .../bindings/media/rockchip-mipi-dphy.txt          | 71 +++++++++++++++++++
>  1 file changed, 71 insertions(+)
>  create mode 100644
> Documentation/devicetree/bindings/media/rockchip-mipi-dphy.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/rockchip-mipi-dphy.txt
> b/Documentation/devicetree/bindings/media/rockchip-mipi-dphy.txt new file
> mode 100644
> index 000000000000..cef9450db051
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/rockchip-mipi-dphy.txt
> @@ -0,0 +1,71 @@
> +Rockchip SoC MIPI RX D-PHY
> +-------------------------------------------------------------
> +
> +Required properties:
> +
> +- compatible: value should be one of the following
> +    "rockchip,rk3288-mipi-dphy";
> +    "rockchip,rk3399-mipi-dphy";
> +- rockchip,grf: GRF regs.
> +- bus-width : maximum number of data lanes supported (SoC specific);

Bus width isn't a standard property, should this be rockchip,data-lanes or 
rockchip,#data-lanes ?

> +- clocks : list of clock specifiers, corresponding to entries in
> +		    clock-names property;
> +- clock-names: required clock name.
> +
> +The device node should contain two 'port' child node, according to the

s/child node/child nodes/

> bindings
> +defined in Documentation/devicetree/bindings/media/video-interfaces.txt.
> +The first port should be connected to sensor nodes, and the second port
> should be
> +connected to isp node. The following are properties specific to those
> nodes.
> +
> +endpoint node
> +-------------
> +
> +- data-lanes : (required) an array specifying active physical MIPI-CSI2
> +		data input lanes and their mapping to logical lanes; the
> +		array's content is unused, only its length is meaningful;

I assume this means that the D-PHY can't reroute lanes. I would mention that 
explicitly, and require that the data-lanes values start at one at are 
consecutive instead of ignoring them.

> +Device node example
> +-------------------
> +
> +    mipi_dphy_rx0: mipi-dphy-rx0 {
> +        compatible = "rockchip,rk3399-mipi-dphy";
> +        clocks = <&cru SCLK_MIPIDPHY_REF>,
> +            <&cru SCLK_DPHY_RX0_CFG>,
> +            <&cru PCLK_VIO_GRF>;
> +        clock-names = "dphy-ref", "dphy-cfg", "grf";
> +        power-domains = <&power RK3399_PD_VIO>;
> +        bus-width = <4>;
> +
> +        ports {
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +
> +            port@0 {
> +                reg = <0>;
> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +
> +                mipi_in_wcam: endpoint@0 {
> +                    reg = <0>;
> +                    remote-endpoint = <&wcam_out>;
> +                    data-lanes = <1 2>;
> +                };
> +                mipi_in_ucam: endpoint@1 {
> +                    reg = <1>;
> +                    remote-endpoint = <&ucam_out>;
> +                    data-lanes = <1>;
> +                };

What do those two camera correspond to ? Can they be active at the same time, 
or do they use the same data lanes ? If they use the same data lanes, how does 
this work, is there a multiplexer on the board ?

> +            };
> +
> +            port@1 {
> +                reg = <1>;
> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +
> +                dphy_rx0_out: endpoint@0 {
> +                    reg = <0>;
> +                    remote-endpoint = <&isp0_mipi_in>;
> +                };
> +            };
> +        };
> +    };
> \ No newline at end of file

-- 
Regards,

Laurent Pinchart
