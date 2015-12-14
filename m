Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:32922 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbbLNSS0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2015 13:18:26 -0500
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Tiffany Lin <tiffany.lin@mediatek.com>
Cc: daniel.thompson@linaro.org, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
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
Subject: Re: [PATCH v2 5/8] arm64: dts: mediatek: Add Video Encoder for MT8173
Date: Mon, 14 Dec 2015 19:18:17 +0100
Message-ID: <1598527.2ooU1eBZYB@linux-gy6r.site>
In-Reply-To: <1449827743-22895-6-git-send-email-tiffany.lin@mediatek.com>
References: <1449827743-22895-1-git-send-email-tiffany.lin@mediatek.com> <1449827743-22895-6-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 11 Dec 2015 17:55:40 Tiffany Lin wrote:
> Add video encoder node for MT8173
> 
> Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> ---
>  arch/arm64/boot/dts/mediatek/mt8173.dtsi |   47
> ++++++++++++++++++++++++++++++ 1 file changed, 47 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/mediatek/mt8173.dtsi
> b/arch/arm64/boot/dts/mediatek/mt8173.dtsi index b8c8ff0..a6b0fcf 100644
> --- a/arch/arm64/boot/dts/mediatek/mt8173.dtsi
> +++ b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
> @@ -545,6 +545,53 @@
>  			#clock-cells = <1>;
>  		};
> 
> +		larb3: larb@18001000 {
> +			compatible = "mediatek,mt8173-smi-larb";
> +			reg = <0 0x18001000 0 0x1000>;
> +			mediatek,smi = <&smi_common>;
> +			power-domains = <&scpsys MT8173_POWER_DOMAIN_VENC>;
> +			clocks = <&vencsys CLK_VENC_CKE1>,
> +				 <&vencsys CLK_VENC_CKE0>;
> +			clock-names = "apb", "smi";
> +		};
> +
> +		vcodec_enc: vcodec@18002000 {
> +			compatible = "mediatek,mt8173-vcodec-enc";
> +			reg = <0 0x18002000 0 0x1000>,	/* VENC_SYS */
> +			      <0 0x19002000 0 0x1000>;	/* VENC_LT_SYS */
> +			interrupts = <GIC_SPI 198 IRQ_TYPE_LEVEL_LOW>,
> +				     <GIC_SPI 202 IRQ_TYPE_LEVEL_LOW>;
> +			larb = <&larb3>,
> +			       <&larb5>;

should be mediatek,larb or just larb for all instances of the larb's.
See my other email about the bindings.

Regards,
Matthias

> +			iommus = <&iommu M4U_LARB3_ID M4U_PORT_VENC_RCPU>,
> +				 <&iommu M4U_LARB3_ID M4U_PORT_VENC_REC>,
> +				 <&iommu M4U_LARB3_ID M4U_PORT_VENC_BSDMA>,
> +				 <&iommu M4U_LARB3_ID M4U_PORT_VENC_SV_COMV>,
> +				 <&iommu M4U_LARB3_ID M4U_PORT_VENC_RD_COMV>,
> +				 <&iommu M4U_LARB3_ID M4U_PORT_VENC_CUR_LUMA>,
> +				 <&iommu M4U_LARB3_ID M4U_PORT_VENC_CUR_CHROMA>,
> +				 <&iommu M4U_LARB3_ID M4U_PORT_VENC_REF_LUMA>,
> +				 <&iommu M4U_LARB3_ID M4U_PORT_VENC_REF_CHROMA>,
> +				 <&iommu M4U_LARB3_ID M4U_PORT_VENC_NBM_RDMA>,
> +				 <&iommu M4U_LARB3_ID M4U_PORT_VENC_NBM_WDMA>,
> +				 <&iommu M4U_LARB5_ID M4U_PORT_VENC_RCPU_SET2>,
> +				 <&iommu M4U_LARB5_ID M4U_PORT_VENC_REC_FRM_SET2>,
> +				 <&iommu M4U_LARB5_ID M4U_PORT_VENC_BSDMA_SET2>,
> +				 <&iommu M4U_LARB5_ID M4U_PORT_VENC_SV_COMA_SET2>,
> +				 <&iommu M4U_LARB5_ID M4U_PORT_VENC_RD_COMA_SET2>,
> +				 <&iommu M4U_LARB5_ID M4U_PORT_VENC_CUR_LUMA_SET2>,
> +				 <&iommu M4U_LARB5_ID M4U_PORT_VENC_CUR_CHROMA_SET2>,
> +				 <&iommu M4U_LARB5_ID M4U_PORT_VENC_REF_LUMA_SET2>,
> +				 <&iommu M4U_LARB5_ID M4U_PORT_VENC_REC_CHROMA_SET2>;
> +			vpu = <&vpu>;
> +			clocks = <&apmixedsys CLK_APMIXED_VENCPLL>,
> +				 <&topckgen CLK_TOP_VENC_LT_SEL>,
> +				 <&topckgen CLK_TOP_VCODECPLL_370P5>;
> +			clock-names = "vencpll",
> +				      "venc_lt_sel",
> +				      "vcodecpll_370p5_ck";
> +		};
> +
>  		vencltsys: clock-controller@19000000 {
>  			compatible = "mediatek,mt8173-vencltsys", "syscon";
>  			reg = <0 0x19000000 0 0x1000>;

