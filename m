Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:33567 "EHLO
	mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887AbcGZSyg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2016 14:54:36 -0400
Date: Tue, 26 Jul 2016 13:54:34 -0500
From: Rob Herring <robh@kernel.org>
To: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, daniel.thompson@linaro.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	srv_heupstream@mediatek.com,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v2 2/4] dt-bindings: Add a binding for Mediatek MDP
Message-ID: <20160726185433.GA14609@rob-hp-laptop>
References: <1469176383-35210-1-git-send-email-minghsiu.tsai@mediatek.com>
 <1469176383-35210-3-git-send-email-minghsiu.tsai@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1469176383-35210-3-git-send-email-minghsiu.tsai@mediatek.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 22, 2016 at 04:33:01PM +0800, Minghsiu Tsai wrote:
> Add a DT binding documentation of MDP for the MT8173 SoC
> from Mediatek
> 
> Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
> ---
>  .../devicetree/bindings/media/mediatek-mdp.txt     |   96 ++++++++++++++++++++
>  1 file changed, 96 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/mediatek-mdp.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/mediatek-mdp.txt b/Documentation/devicetree/bindings/media/mediatek-mdp.txt
> new file mode 100644
> index 0000000..2dad031
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/mediatek-mdp.txt
> @@ -0,0 +1,96 @@
> +* Mediatek Media Data Path
> +
> +Media Data Path is used for scaling and color space conversion.
> +
> +Required properties (all function blocks):
> +- compatible: "mediatek,<chip>-mdp"

What is this, ...

> +        "mediatek,<chip>-mdp-<function>", one of

and this?

> +        "mediatek,<chip>-mdp-rdma"  - read DMA
> +        "mediatek,<chip>-mdp-rsz"   - resizer
> +        "mediatek,<chip>-mdp-wdma"  - write DMA
> +        "mediatek,<chip>-mdp-wrot"  - write DMA with rotation

List what are valid values of <chip>.

> +- reg: Physical base address and length of the function block register space
> +- clocks: device clocks
> +- power-domains: a phandle to the power domain.
> +- mediatek,vpu: the node of video processor unit
> +
> +Required properties (DMA function blocks):
> +- compatible: Should be one of
> +        "mediatek,<chip>-mdp-rdma"
> +        "mediatek,<chip>-mdp-wdma"
> +        "mediatek,<chip>-mdp-wrot"
> +- iommus: should point to the respective IOMMU block with master port as
> +  argument, see Documentation/devicetree/bindings/iommu/mediatek,iommu.txt
> +  for details.
> +- mediatek,larb: must contain the local arbiters in the current Socs.

It is still not clear which properties apply to which compatible 
strings.

> +
> +Example:
> +	mdp_rdma0: rdma@14001000 {
> +		compatible = "mediatek,mt8173-mdp-rdma",
> +			     "mediatek,mt8173-mdp";
> +		reg = <0 0x14001000 0 0x1000>;
> +		clocks = <&mmsys CLK_MM_MDP_RDMA0>,
> +			 <&mmsys CLK_MM_MUTEX_32K>;
> +		power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
> +		iommus = <&iommu M4U_PORT_MDP_RDMA0>;
> +		mediatek,larb = <&larb0>;
> +		mediatek,vpu = <&vpu>;
> +	};
> +
> +	mdp_rdma1: rdma@14002000 {
> +		compatible = "mediatek,mt8173-mdp-rdma";
> +		reg = <0 0x14002000 0 0x1000>;
> +		clocks = <&mmsys CLK_MM_MDP_RDMA1>,
> +			 <&mmsys CLK_MM_MUTEX_32K>;
> +		power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
> +		iommus = <&iommu M4U_PORT_MDP_RDMA1>;
> +		mediatek,larb = <&larb4>;
> +	};
> +
> +	mdp_rsz0: rsz@14003000 {
> +		compatible = "mediatek,mt8173-mdp-rsz";
> +		reg = <0 0x14003000 0 0x1000>;
> +		clocks = <&mmsys CLK_MM_MDP_RSZ0>;
> +		power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
> +	};
> +
> +	mdp_rsz1: rsz@14004000 {
> +		compatible = "mediatek,mt8173-mdp-rsz";
> +		reg = <0 0x14004000 0 0x1000>;
> +		clocks = <&mmsys CLK_MM_MDP_RSZ1>;
> +		power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
> +	};
> +
> +	mdp_rsz2: rsz@14005000 {
> +		compatible = "mediatek,mt8173-mdp-rsz";
> +		reg = <0 0x14005000 0 0x1000>;
> +		clocks = <&mmsys CLK_MM_MDP_RSZ2>;
> +		power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
> +	};
> +
> +	mdp_wdma0: wdma@14006000 {
> +		compatible = "mediatek,mt8173-mdp-wdma";
> +		reg = <0 0x14006000 0 0x1000>;
> +		clocks = <&mmsys CLK_MM_MDP_WDMA>;
> +		power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
> +		iommus = <&iommu M4U_PORT_MDP_WDMA>;
> +		mediatek,larb = <&larb0>;
> +	};
> +
> +	mdp_wrot0: wrot@14007000 {
> +		compatible = "mediatek,mt8173-mdp-wrot";
> +		reg = <0 0x14007000 0 0x1000>;
> +		clocks = <&mmsys CLK_MM_MDP_WROT0>;
> +		power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
> +		iommus = <&iommu M4U_PORT_MDP_WROT0>;
> +		mediatek,larb = <&larb0>;
> +	};
> +
> +	mdp_wrot1: wrot@14008000 {
> +		compatible = "mediatek,mt8173-mdp-wrot";
> +		reg = <0 0x14008000 0 0x1000>;
> +		clocks = <&mmsys CLK_MM_MDP_WROT1>;
> +		power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
> +		iommus = <&iommu M4U_PORT_MDP_WROT1>;
> +		mediatek,larb = <&larb4>;
> +	};
> -- 
> 1.7.9.5
> 
