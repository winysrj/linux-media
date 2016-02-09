Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:34470 "EHLO
	mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933027AbcBIL3s (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2016 06:29:48 -0500
Received: by mail-vk0-f44.google.com with SMTP id e185so114792209vkb.1
        for <linux-media@vger.kernel.org>; Tue, 09 Feb 2016 03:29:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1454585703-42428-5-git-send-email-tiffany.lin@mediatek.com>
References: <1454585703-42428-1-git-send-email-tiffany.lin@mediatek.com>
 <1454585703-42428-2-git-send-email-tiffany.lin@mediatek.com>
 <1454585703-42428-3-git-send-email-tiffany.lin@mediatek.com>
 <1454585703-42428-4-git-send-email-tiffany.lin@mediatek.com> <1454585703-42428-5-git-send-email-tiffany.lin@mediatek.com>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Tue, 9 Feb 2016 19:29:26 +0800
Message-ID: <CAGS+omDQW+yqhixCWPfQb9eaHeufgiEDscrvXGwBTc05+eDGCQ@mail.gmail.com>
Subject: Re: [PATCH v4 4/8] dt-bindings: Add a binding for Mediatek Video Encoder
To: Tiffany Lin <tiffany.lin@mediatek.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, daniel.thompson@linaro.org,
	Rob Herring <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Pawel Osciak <posciak@chromium.org>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	"open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	linux-media@vger.kernel.org,
	"moderated list:ARM/Mediatek SoC support"
	<linux-mediatek@lists.infradead.org>,
	Lin PoChun <PoChun.Lin@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tiffany,

On Thu, Feb 4, 2016 at 7:34 PM, Tiffany Lin <tiffany.lin@mediatek.com> wrote:
> Add a DT binding documentation of Video Encoder for the
> MT8173 SoC from Mediatek.
>
> Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> ---
>  .../devicetree/bindings/media/mediatek-vcodec.txt  |   59 ++++++++++++++++++++
>  1 file changed, 59 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/mediatek-vcodec.txt
>
> diff --git a/Documentation/devicetree/bindings/media/mediatek-vcodec.txt b/Documentation/devicetree/bindings/media/mediatek-vcodec.txt
> new file mode 100644
> index 0000000..572bfdd
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/mediatek-vcodec.txt
> @@ -0,0 +1,59 @@
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
> +  the clock-names property.
> +- clock-names: encoder must contain "vencpll_d2", "venc_sel", "univpll1_d2",
> +  "venc_lt_sel".
> +- iommus : should point to the respective IOMMU block with master port as
> +  argument, see Documentation/devicetree/bindings/iommu/mediatek,iommu.txt
> +  for details.
> +- mediatek,vpu : the node of video processor unit
> +
> +Example:
> +vcodec_enc: vcodec@0x18002000 {
> +    compatible = "mediatek,mt8173-vcodec-enc";
> +    reg = <0 0x18002000 0 0x1000>,    /*VENC_SYS*/
> +          <0 0x19002000 0 0x1000>;    /*VENC_LT_SYS*/

This really looks like two encoder devices combined into a single
device tree node.
There are two register sets, two irqs, two sets of iommus, and two
sets of clocks.

If possible, please split this node into two, one for each encoder.


> +    interrupts = <GIC_SPI 198 IRQ_TYPE_LEVEL_LOW>,
> +           <GIC_SPI 202 IRQ_TYPE_LEVEL_LOW>;
> +    mediatek,larb = <&larb3>,
> +                   <&larb5>;
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
> +    clocks = <&topckgen CLK_TOP_VENCPLL_D2>,
> +             <&topckgen CLK_TOP_VENC_SEL>,
> +             <&topckgen CLK_TOP_UNIVPLL1_D2>,
> +             <&topckgen CLK_TOP_VENC_LT_SEL>;
> +    clock-names = "vencpll_d2",
> +                  "venc_sel",
> +                  "univpll1_d2",
> +                  "venc_lt_sel";

The names of these clocks should be from the perspective of the
encoder, not the clock provider.

-Dan

> +  };
> --
> 1.7.9.5
>
