Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-74.mail.aliyun.com ([115.124.20.74]:34216 "EHLO
        out20-74.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751386AbdHGBA3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 6 Aug 2017 21:00:29 -0400
Date: Mon, 7 Aug 2017 09:00:09 +0800
From: Yong <yong.deng@magewell.com>
To: Rob Herring <robh@kernel.org>
Cc: maxime.ripard@free-electrons.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Arnd Bergmann <arnd@arndb.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Benoit Parrot <bparrot@ti.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 2/3] dt-bindings: media: Add Allwinner V3s Camera
 Sensor Interface (CSI)
Message-Id: <20170807090009.4af79df794e881d441c18196@magewell.com>
In-Reply-To: <20170803191415.iyyzjsvlyviftalj@rob-hp-laptop>
References: <1501131697-1359-1-git-send-email-yong.deng@magewell.com>
        <1501131697-1359-3-git-send-email-yong.deng@magewell.com>
        <20170803191415.iyyzjsvlyviftalj@rob-hp-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 3 Aug 2017 14:14:15 -0500
Rob Herring <robh@kernel.org> wrote:

> On Thu, Jul 27, 2017 at 01:01:36PM +0800, Yong Deng wrote:
> > Add binding documentation for Allwinner V3s CSI.
> > 
> > Signed-off-by: Yong Deng <yong.deng@magewell.com>
> > ---
> >  .../devicetree/bindings/media/sun6i-csi.txt        | 49 ++++++++++++++++++++++
> >  1 file changed, 49 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/sun6i-csi.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/media/sun6i-csi.txt b/Documentation/devicetree/bindings/media/sun6i-csi.txt
> > new file mode 100644
> > index 0000000..f8d83f6
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/sun6i-csi.txt
> > @@ -0,0 +1,49 @@
> > +Allwinner V3s Camera Sensor Interface
> > +------------------------------
> > +
> > +Required properties:
> > +  - compatible: value must be "allwinner,sun8i-v3s-csi"
> > +  - reg: base address and size of the memory-mapped region.
> > +  - interrupts: interrupt associated to this IP
> > +  - clocks: phandles to the clocks feeding the CSI
> > +    * ahb: the CSI interface clock
> > +    * mod: the CSI module clock
> > +    * ram: the CSI DRAM clock
> > +  - clock-names: the clock names mentioned above
> > +  - resets: phandles to the reset line driving the CSI
> > +
> > +- ports: A ports node with endpoint definitions as defined in
> > +  Documentation/devicetree/bindings/media/video-interfaces.txt.
> 
> Need to be explicit about how many ports and endpoints and what each one 
> represents.

OK.

> 
> > +
> > +Example:
> > +
> > +	csi1: csi@01cb4000 {
> > +		compatible = "allwinner,sun8i-v3s-csi";
> > +		reg = <0x01cb4000 0x1000>;
> > +		interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
> > +		clocks = <&ccu CLK_BUS_CSI>,
> > +			 <&ccu CLK_CSI1_SCLK>,
> > +			 <&ccu CLK_DRAM_CSI>;
> > +		clock-names = "ahb", "mod", "ram";
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


Thanks,
Yong
