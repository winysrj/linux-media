Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:23487 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752175AbcHLJW3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2016 05:22:29 -0400
Message-ID: <1470993703.12736.6.camel@mtksdaap41>
Subject: Re: [PATCH v4 9/9] arm64: dts: mediatek: Add Video Decoder for
 MT8173
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	<daniel.thompson@linaro.org>, "Rob Herring" <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	"Pawel Osciak" <posciak@chromium.org>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>
Date: Fri, 12 Aug 2016 17:21:43 +0800
In-Reply-To: <de51caf8-6db5-4754-0683-d3390dd2ac09@gmail.com>
References: <1470840534-4788-1-git-send-email-tiffany.lin@mediatek.com>
	 <1470840534-4788-2-git-send-email-tiffany.lin@mediatek.com>
	 <1470840534-4788-3-git-send-email-tiffany.lin@mediatek.com>
	 <1470840534-4788-4-git-send-email-tiffany.lin@mediatek.com>
	 <1470840534-4788-5-git-send-email-tiffany.lin@mediatek.com>
	 <1470840534-4788-6-git-send-email-tiffany.lin@mediatek.com>
	 <1470840534-4788-7-git-send-email-tiffany.lin@mediatek.com>
	 <1470840534-4788-8-git-send-email-tiffany.lin@mediatek.com>
	 <1470840534-4788-9-git-send-email-tiffany.lin@mediatek.com>
	 <1470840534-4788-10-git-send-email-tiffany.lin@mediatek.com>
	 <de51caf8-6db5-4754-0683-d3390dd2ac09@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matthias,

On Thu, 2016-08-11 at 17:44 +0200, Matthias Brugger wrote:
> 
> On 10/08/16 16:48, Tiffany Lin wrote:
> > Add video decoder node for MT8173
> >
> > Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> > ---
> >  arch/arm64/boot/dts/mediatek/mt8173.dtsi |   44 ++++++++++++++++++++++++++++++
> >  1 file changed, 44 insertions(+)
> >
> > diff --git a/arch/arm64/boot/dts/mediatek/mt8173.dtsi b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
> > index 10f638f..2872cd7 100644
> > --- a/arch/arm64/boot/dts/mediatek/mt8173.dtsi
> > +++ b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
> > @@ -974,6 +974,50 @@
> >  			#clock-cells = <1>;
> >  		};
> >
> > +		vcodec_dec: vcodec@16000000 {
> > +			compatible = "mediatek,mt8173-vcodec-dec";
> > +			reg = <0 0x16000000 0 0x100>,	/* VDEC_SYS */
> > +			      <0 0x16020000 0 0x1000>,	/* VDEC_MISC */
> > +			      <0 0x16021000 0 0x800>,	/* VDEC_LD */
> > +			      <0 0x16021800 0 0x800>,	/* VDEC_TOP */
> > +			      <0 0x16022000 0 0x1000>,	/* VDEC_CM */
> > +			      <0 0x16023000 0 0x1000>,	/* VDEC_AD */
> > +			      <0 0x16024000 0 0x1000>,	/* VDEC_AV */
> > +			      <0 0x16025000 0 0x1000>,	/* VDEC_PP */
> > +			      <0 0x16026800 0 0x800>,	/* VDEC_HWD */
> > +			      <0 0x16027000 0 0x800>,	/* VDEC_HWQ */
> > +			      <0 0x16027800 0 0x800>,	/* VDEC_HWB */
> > +			      <0 0x16028400 0 0x400>;	/* VDEC_HWG */
> > +			interrupts = <GIC_SPI 204 IRQ_TYPE_LEVEL_LOW>;
> > +			mediatek,larb = <&larb1>;
> > +			iommus = <&iommu M4U_PORT_HW_VDEC_MC_EXT>,
> > +				 <&iommu M4U_PORT_HW_VDEC_PP_EXT>,
> > +				 <&iommu M4U_PORT_HW_VDEC_AVC_MV_EXT>,
> > +				 <&iommu M4U_PORT_HW_VDEC_PRED_RD_EXT>,
> > +				 <&iommu M4U_PORT_HW_VDEC_PRED_WR_EXT>,
> > +				 <&iommu M4U_PORT_HW_VDEC_UFO_EXT>,
> > +				 <&iommu M4U_PORT_HW_VDEC_VLD_EXT>,
> > +				 <&iommu M4U_PORT_HW_VDEC_VLD2_EXT>;
> > +			mediatek,vpu = <&vpu>;
> > +			power-domains = <&scpsys MT8173_POWER_DOMAIN_VDEC>;
> > +			clocks = <&apmixedsys CLK_APMIXED_VCODECPLL>,
> > +				 <&topckgen CLK_TOP_UNIVPLL_D2>,
> > +				 <&topckgen CLK_TOP_CCI400_SEL>,
> > +				 <&topckgen CLK_TOP_VDEC_SEL>,
> > +				 <&topckgen CLK_TOP_VCODECPLL>,
> > +				 <&apmixedsys CLK_APMIXED_VENCPLL>,
> > +				 <&topckgen CLK_TOP_VENC_LT_SEL>,
> > +				 <&topckgen CLK_TOP_VCODECPLL_370P5>;
> > +			clock-names = "vcodecpll",
> > +				      "univpll_d2",
> > +				      "clk_cci400_sel",
> > +				      "vdec_sel",
> > +				      "vdecpll",
> > +				      "vencpll",
> > +				      "venc_lt_sel",
> > +				      "vdec_bus_clk_src";
> > +		};
> > +
> 
> Shouldn't we set here:
> status = "disabled";
> 
> To save power on headless systems?
> 
We only power on when there is at least one decode instance created.
In this case, do we need "status = "disabled";" here?
I see some other device nodes in dtsi do not add this.
Sorry, I am just confused when should we add status for device node.


best regards,
Tiffany

> Regards,
> Matthias
> 
> >  		larb1: larb@16010000 {
> >  			compatible = "mediatek,mt8173-smi-larb";
> >  			reg = <0 0x16010000 0 0x1000>;
> >


