Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:39943 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550AbbLKRVt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 12:21:49 -0500
Date: Fri, 11 Dec 2015 11:21:43 -0600
From: Rob Herring <robh@kernel.org>
To: Tiffany Lin <tiffany.lin@mediatek.com>
Cc: daniel.thompson@linaro.org, Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Fabien Dessenne <fabien.dessenne@st.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Darren Etheridge <detheridge@ti.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Benoit Parrot <bparrot@ti.com>,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	James Liao <jamesjj.liao@mediatek.com>,
	Hongzhou Yang <hongzhou.yang@mediatek.com>,
	Daniel Hsiao <daniel.hsiao@mediatek.com>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mediatek@lists.infradead.org, PoChun.Lin@mediatek.com
Subject: Re: [PATCH v2 1/8] dt-bindings: Add a binding for Mediatek Video
 Processor
Message-ID: <20151211172143.GA14623@rob-hp-laptop>
References: <1449827743-22895-1-git-send-email-tiffany.lin@mediatek.com>
 <1449827743-22895-2-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1449827743-22895-2-git-send-email-tiffany.lin@mediatek.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 11, 2015 at 05:55:36PM +0800, Tiffany Lin wrote:
> From: Andrew-CT Chen <andrew-ct.chen@mediatek.com>
> 
> Add a DT binding documentation of Video Processor Unit for the
> MT8173 SoC from Mediatek.
> 
> Signed-off-by: Andrew-CT Chen <andrew-ct.chen@mediatek.com>
> Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>

Acked-by: Rob Herring <robh@kernel.org>

> ---
>  .../devicetree/bindings/media/mediatek-vpu.txt     |   27 ++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/mediatek-vpu.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/mediatek-vpu.txt b/Documentation/devicetree/bindings/media/mediatek-vpu.txt
> new file mode 100644
> index 0000000..3c3a424
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/mediatek-vpu.txt
> @@ -0,0 +1,27 @@
> +* Mediatek Video Processor Unit
> +
> +Video Processor Unit is a HW video controller. It controls HW Codec including
> +H.264/VP8/VP9 Decode, H.264/VP8 Encode and Image Processor (scale/rotate/color convert).
> +
> +Required properties:
> +  - compatible: "mediatek,mt8173-vpu"
> +  - reg: Must contain an entry for each entry in reg-names.
> +  - reg-names: Must include the following entries:
> +    "tcm": tcm base
> +    "cfg_reg": Main configuration registers base
> +  - interrupts: interrupt number to the cpu.
> +  - clocks : clock name from clock manager
> +  - clock-names: must be main. It is the main clock of VPU
> +  - iommus : phandle and IOMMU spcifier for the IOMMU that serves the VPU.
> +
> +Example:
> +	vpu: vpu@10020000 {
> +		compatible = "mediatek,mt8173-vpu";
> +		reg = <0 0x10020000 0 0x30000>,
> +		      <0 0x10050000 0 0x100>;
> +		reg-names = "tcm", "cfg_reg";
> +		interrupts = <GIC_SPI 166 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&topckgen TOP_SCP_SEL>;
> +		clock-names = "main";
> +		iommus = <&iommu M4U_PORT_VENC_RCPU>;
> +	};
> -- 
> 1.7.9.5
> 
