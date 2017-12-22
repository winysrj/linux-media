Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-37.mail.aliyun.com ([115.124.20.37]:53764 "EHLO
        out20-37.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753539AbdLVK7J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Dec 2017 05:59:09 -0500
Date: Fri, 22 Dec 2017 18:58:41 +0800
From: Yong <yong.deng@magewell.com>
To: plaes@plaes.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Rick Chang <rick.chang@mediatek.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [linux-sunxi] [PATCH v4 1/2] dt-bindings: media: Add Allwinner
 V3s Camera Sensor Interface (CSI)
Message-Id: <20171222185841.527ce87e9a7aa3d6b5e442d3@magewell.com>
In-Reply-To: <20171222100008.nmmzwhtmputizn7d@plaes.org>
References: <1513935689-35415-1-git-send-email-yong.deng@magewell.com>
        <20171222100008.nmmzwhtmputizn7d@plaes.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 22 Dec 2017 10:00:08 +0000
Priit Laes <plaes@plaes.org> wrote:

> On Fri, Dec 22, 2017 at 05:41:29PM +0800, Yong Deng wrote:
> > Add binding documentation for Allwinner V3s CSI.
> > 
> > Signed-off-by: Yong Deng <yong.deng@magewell.com>
> > ---
> >  .../devicetree/bindings/media/sun6i-csi.txt        | 51 ++++++++++++++++++++++
> >  1 file changed, 51 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/sun6i-csi.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/media/sun6i-csi.txt b/Documentation/devicetree/bindings/media/sun6i-csi.txt
> > new file mode 100644
> > index 0000000..b5bfe3f
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/sun6i-csi.txt
> > @@ -0,0 +1,51 @@
> > +Allwinner V3s Camera Sensor Interface
> > +------------------------------
> 
> Not sure whether syntax for these files is proper reStructuredText/Markdown,
> but the underline-ish style expects the title and underline having same length.

OK.

> 
> > +
> > +Required properties:
> > +  - compatible: value must be "allwinner,sun8i-v3s-csi"
> > +  - reg: base address and size of the memory-mapped region.
> > +  - interrupts: interrupt associated to this IP
> > +  - clocks: phandles to the clocks feeding the CSI
> > +    * bus: the CSI interface clock
> > +    * mod: the CSI module clock
> > +    * ram: the CSI DRAM clock
> > +  - clock-names: the clock names mentioned above
> > +  - resets: phandles to the reset line driving the CSI
> > +
> > +- ports: A ports node with endpoint definitions as defined in
> > +  Documentation/devicetree/bindings/media/video-interfaces.txt.
> > +  Currently, the driver only support the parallel interface. So, a single port
> ^^ supports
> > +  node with one endpoint and parallel bus is supported.
> > +
> > +Example:
> > +
> > +	csi1: csi@1cb4000 {
> > +		compatible = "allwinner,sun8i-v3s-csi";
> > +		reg = <0x01cb4000 0x1000>;
> > +		interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
> > +		clocks = <&ccu CLK_BUS_CSI>,
> > +			 <&ccu CLK_CSI1_SCLK>,
> > +			 <&ccu CLK_DRAM_CSI>;
> > +		clock-names = "bus", "mod", "ram";
> > +		resets = <&ccu RST_BUS_CSI>;
> > +
> > +		port {
> > +			#address-cells = <1>;
> > +			#size-cells = <0>;
> > +
> > +			/* Parallel bus endpoint */
> > +			csi1_ep: endpoint {
> > +				remote-endpoint = <&adv7611_ep>;
> > +				bus-width = <16>;
> > +				data-shift = <0>;
> > +
> > +				/* If hsync-active/vsync-active are missing,
> > +				   embedded BT.656 sync is used */
> > +				hsync-active = <0>; /* Active low */
> > +				vsync-active = <0>; /* Active low */
> > +				data-active = <1>;  /* Active high */
> > +				pclk-sample = <1>;  /* Rising */
> > +			};
> > +		};
> > +	};
> > +
> > -- 
> > 1.8.3.1
> > 
> > -- 
> > You received this message because you are subscribed to the Google Groups "linux-sunxi" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to linux-sunxi+unsubscribe@googlegroups.com.
> > For more options, visit https://groups.google.com/d/optout.
> 
> -- 
> You received this message because you are subscribed to the Google Groups "linux-sunxi" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to linux-sunxi+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/d/optout.


Thanks,
Yong
