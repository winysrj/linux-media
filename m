Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:57171 "EHLO foss.arm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832AbbKQONc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 09:13:32 -0500
Date: Tue, 17 Nov 2015 14:13:20 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Tiffany Lin <tiffany.lin@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Hongzhou Yang <hongzhou.yang@mediatek.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
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
	Daniel Hsiao <daniel.hsiao@mediatek.com>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [RESEND RFC/PATCH 1/8] dt-bindings: Add a binding for Mediatek
 Video Processor Unit
Message-ID: <20151117141320.GJ12586@leverpostej>
References: <1447764885-23100-1-git-send-email-tiffany.lin@mediatek.com>
 <1447764885-23100-2-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1447764885-23100-2-git-send-email-tiffany.lin@mediatek.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 17, 2015 at 08:54:38PM +0800, Tiffany Lin wrote:
> From: Andrew-CT Chen <andrew-ct.chen@mediatek.com>
> 
> Add a DT binding documentation of Video Processor Unit for the
> MT8173 SoC from Mediatek.
> 
> Signed-off-by: Andrew-CT Chen <andrew-ct.chen@mediatek.com>
> ---
>  .../devicetree/bindings/media/mediatek-vpu.txt     |   27 ++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/mediatek-vpu.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/mediatek-vpu.txt b/Documentation/devicetree/bindings/media/mediatek-vpu.txt
> new file mode 100644
> index 0000000..99a4e5e
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
> +    "sram": SRAM base
> +    "cfg_reg": Main configuration registers base
> +  - interrupts: interrupt number to the cpu.
> +  - clocks : clock name from clock manager
> +  - clock-names: the clocks of the VPU H/W

You need to explicitly define the set of clock-names you expect here.

Mark.

> +  - iommus : phandle and IOMMU spcifier for the IOMMU that serves the VPU.
> +
> +Example:
> +	vpu: vpu@10020000 {
> +		compatible = "mediatek,mt8173-vpu";
> +		reg = <0 0x10020000 0 0x30000>,
> +		      <0 0x10050000 0 0x100>;
> +		reg-names = "sram", "cfg_reg";
> +		interrupts = <GIC_SPI 166 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&topckgen TOP_SCP_SEL>;
> +		clock-names = "main";
> +		iommus = <&iommu M4U_PORT_VENC_RCPU>;
> +	};
> -- 
> 1.7.9.5
> 
