Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:34356 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbcARJky (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 04:40:54 -0500
Subject: Re: [PATCH v3 4/8] dt-bindings: Add a binding for Mediatek Video
 Encoder
To: Tiffany Lin <tiffany.lin@mediatek.com>, daniel.thompson@linaro.org,
	Rob Herring <robh+dt@kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mark Rutland <mark.rutland@arm.com>
References: <1451902316-55931-1-git-send-email-tiffany.lin@mediatek.com>
 <1451902316-55931-5-git-send-email-tiffany.lin@mediatek.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, eddie.huang@mediatek.com,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mediatek@lists.infradead.org
From: Matthias Brugger <matthias.bgg@gmail.com>
Message-ID: <569CB321.10206@gmail.com>
Date: Mon, 18 Jan 2016 10:40:49 +0100
MIME-Version: 1.0
In-Reply-To: <1451902316-55931-5-git-send-email-tiffany.lin@mediatek.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 04/01/16 11:11, Tiffany Lin wrote:
> Add a DT binding documentation of Video Encoder for the
> MT8173 SoC from Mediatek.
>
> Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> ---
>   .../devicetree/bindings/media/mediatek-vcodec.txt  |   58 ++++++++++++++++++++
>   1 file changed, 58 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/media/mediatek-vcodec.txt
>
> diff --git a/Documentation/devicetree/bindings/media/mediatek-vcodec.txt b/Documentation/devicetree/bindings/media/mediatek-vcodec.txt
> new file mode 100644
> index 0000000..5cc35ae
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

iommus have only one cell, as in the example below. Please fix the 
binding description accordingly.

Regards,
Matthias

> +- mediatek,vpu : the node of video processor unit
> +
> +Example:
> +vcodec_enc: vcodec@0x18002000 {
> +    compatible = "mediatek,mt8173-vcodec-enc";
> +    reg = <0 0x18002000 0 0x1000>,    /*VENC_SYS*/
> +          <0 0x19002000 0 0x1000>;    /*VENC_LT_SYS*/
> +    interrupts = <GIC_SPI 198 IRQ_TYPE_LEVEL_LOW>,
> +           <GIC_SPI 202 IRQ_TYPE_LEVEL_LOW>;
> +    mediatek,larb = <&larb3>,
> +		    <&larb5>;
> +    iommus = <&iommu M4U_PORT_VENC_RCPU>,
> +             <&iommu M4U_PORT_VENC_REC>,
> +             <&iommu M4U_PORT_VENC_BSDMA>,
> +             <&iommu M4U_PORT_VENC_SV_COMV>,
> +             <&iommu M4U_PORT_VENC_RD_COMV>,
> +             <&iommu M4U_PORT_VENC_CUR_LUMA>,
> +             <&iommu M4U_PORT_VENC_CUR_CHROMA>,
> +             <&iommu M4U_PORT_VENC_REF_LUMA>,
> +             <&iommu M4U_PORT_VENC_REF_CHROMA>,
> +             <&iommu M4U_PORT_VENC_NBM_RDMA>,
> +             <&iommu M4U_PORT_VENC_NBM_WDMA>,
> +             <&iommu M4U_PORT_VENC_RCPU_SET2>,
> +             <&iommu M4U_PORT_VENC_REC_FRM_SET2>,
> +             <&iommu M4U_PORT_VENC_BSDMA_SET2>,
> +             <&iommu M4U_PORT_VENC_SV_COMA_SET2>,
> +             <&iommu M4U_PORT_VENC_RD_COMA_SET2>,
> +             <&iommu M4U_PORT_VENC_CUR_LUMA_SET2>,
> +             <&iommu M4U_PORT_VENC_CUR_CHROMA_SET2>,
> +             <&iommu M4U_PORT_VENC_REF_LUMA_SET2>,
> +             <&iommu M4U_PORT_VENC_REC_CHROMA_SET2>;
> +    mediatek,vpu = <&vpu>;
> +    clocks = <&apmixedsys CLK_APMIXED_VENCPLL>,
> +             <&topckgen CLK_TOP_VENC_LT_SEL>,
> +             <&topckgen CLK_TOP_VCODECPLL_370P5>;
> +    clock-names = "vencpll",
> +                  "venc_lt_sel",
> +                  "vcodecpll_370p5_ck";
> +  };
>
