Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40653 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbbLKR30 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 12:29:26 -0500
Date: Fri, 11 Dec 2015 11:29:19 -0600
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
Subject: Re: [PATCH v2 4/8] dt-bindings: Add a binding for Mediatek Video
 Encoder
Message-ID: <20151211172919.GA2896@rob-hp-laptop>
References: <1449827743-22895-1-git-send-email-tiffany.lin@mediatek.com>
 <1449827743-22895-5-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1449827743-22895-5-git-send-email-tiffany.lin@mediatek.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 11, 2015 at 05:55:39PM +0800, Tiffany Lin wrote:
> Add a DT binding documentation of Video Encoder for the
> MT8173 SoC from Mediatek.
> 
> Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>

A question and minor issue below, otherwise:

Acked-by: Rob Herring <robh@kernel.org>

> ---
>  .../devicetree/bindings/media/mediatek-vcodec.txt  |   58 ++++++++++++++++++++
>  1 file changed, 58 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/mediatek-vcodec.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/mediatek-vcodec.txt b/Documentation/devicetree/bindings/media/mediatek-vcodec.txt
> new file mode 100644
> index 0000000..510cd81
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/mediatek-vcodec.txt
> @@ -0,0 +1,58 @@
> +Mediatek Video Codec
> +
> +Mediatek Video Codec is the video codec hw present in Mediatek SoCs which
> +supports high resolution encoding functionalities.
> +
> +Required properties:
> +- compatible : "mediatek,mt8173-vcodec-enc" for encoder
> +- reg : Physical base address of the video codec registers and length of
> +  memory mapped region.
> +- interrupts : interrupt number to the cpu.
> +- mediatek,larb : must contain the local arbiters in the current Socs.
> +- clocks : list of clock specifiers, corresponding to entries in
> +  the clock-names property;
> +- clock-names: must contain "vencpll", "venc_lt_sel", "vcodecpll_370p5_ck"
> +- iommus : list of iommus specifiers should be enabled for hw encode.
> +  There are 2 cells needed to enable/disable iommu.
> +  The first one is local arbiter index(larbid), and the other is port
> +  index(portid) within local arbiter. Specifies the larbid and portid
> +  as defined in dt-binding/memory/mt8173-larb-port.h.
> +- mediatek,vpu : the node of video processor unit
> +
> +Example:
> +vcodec_enc: vcodec@0x18002000 {
> +    compatible = "mediatek,mt8173-vcodec-enc";
> +    reg = <0 0x18002000 0 0x1000>,    /*VENC_SYS*/
> +          <0 0x19002000 0 0x1000>;    /*VENC_LT_SYS*/
> +    interrupts = <GIC_SPI 198 IRQ_TYPE_LEVEL_LOW>,
> +           <GIC_SPI 202 IRQ_TYPE_LEVEL_LOW>;
> +    larb = <&larb3>,
> +           <&larb5>;
> +    iommus = <&iommu M4U_LARB3_ID M4U_PORT_VENC_RCPU>,

Is this the same iommu as the VPU? If so, you can't have a mixed number 
of cells.

> +             <&iommu M4U_LARB3_ID M4U_PORT_VENC_REC>,
> +             <&iommu M4U_LARB3_ID M4U_PORT_VENC_BSDMA>,
> +             <&iommu M4U_LARB3_ID M4U_PORT_VENC_SV_COMV>,
> +             <&iommu M4U_LARB3_ID M4U_PORT_VENC_RD_COMV>,
> +             <&iommu M4U_LARB3_ID M4U_PORT_VENC_CUR_LUMA>,
> +             <&iommu M4U_LARB3_ID M4U_PORT_VENC_CUR_CHROMA>,
> +             <&iommu M4U_LARB3_ID M4U_PORT_VENC_REF_LUMA>,
> +             <&iommu M4U_LARB3_ID M4U_PORT_VENC_REF_CHROMA>,
> +             <&iommu M4U_LARB3_ID M4U_PORT_VENC_NBM_RDMA>,
> +             <&iommu M4U_LARB3_ID M4U_PORT_VENC_NBM_WDMA>,
> +             <&iommu M4U_LARB5_ID M4U_PORT_VENC_RCPU_SET2>,
> +             <&iommu M4U_LARB5_ID M4U_PORT_VENC_REC_FRM_SET2>,
> +             <&iommu M4U_LARB5_ID M4U_PORT_VENC_BSDMA_SET2>,
> +             <&iommu M4U_LARB5_ID M4U_PORT_VENC_SV_COMA_SET2>,
> +             <&iommu M4U_LARB5_ID M4U_PORT_VENC_RD_COMA_SET2>,
> +             <&iommu M4U_LARB5_ID M4U_PORT_VENC_CUR_LUMA_SET2>,
> +             <&iommu M4U_LARB5_ID M4U_PORT_VENC_CUR_CHROMA_SET2>,
> +             <&iommu M4U_LARB5_ID M4U_PORT_VENC_REF_LUMA_SET2>,
> +             <&iommu M4U_LARB5_ID M4U_PORT_VENC_REC_CHROMA_SET2>;
> +    vpu = <&vpu>;

Need to update the example.

> +    clocks = <&apmixedsys CLK_APMIXED_VENCPLL>,
> +             <&topckgen CLK_TOP_VENC_LT_SEL>,
> +             <&topckgen CLK_TOP_VCODECPLL_370P5>;
> +    clock-names = "vencpll",
> +                  "venc_lt_sel",
> +                  "vcodecpll_370p5_ck";
> +  };
> -- 
> 1.7.9.5
> 
