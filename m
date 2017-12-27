Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40574 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751871AbdL0Vr2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Dec 2017 16:47:28 -0500
Date: Wed, 27 Dec 2017 23:47:23 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Yong <yong.deng@magewell.com>
Cc: maxime.ripard@free-electrons.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
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
Message-ID: <20171227214723.rcssyay2lqqjf6ty@valkosipuli.retiisi.org.uk>
References: <1501131697-1359-1-git-send-email-yong.deng@magewell.com>
 <1501131697-1359-3-git-send-email-yong.deng@magewell.com>
 <20171219115327.ofs5xwwimpn7x72n@valkosipuli.retiisi.org.uk>
 <20171221104935.663812085b616935ca3046de@magewell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171221104935.663812085b616935ca3046de@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Thu, Dec 21, 2017 at 10:49:35AM +0800, Yong wrote:
> Hi,
> 
> On Tue, 19 Dec 2017 13:53:28 +0200
> Sakari Ailus <sakari.ailus@iki.fi> wrote:
> 
> > Hi Yong,
> > 
> > On Thu, Jul 27, 2017 at 01:01:36PM +0800, Yong Deng wrote:
> > > Add binding documentation for Allwinner V3s CSI.
> > > 
> > > Signed-off-by: Yong Deng <yong.deng@magewell.com>
> > 
> > DT bindings should precede the driver.
> 
> OK.
> 
> > 
> > > ---
> > >  .../devicetree/bindings/media/sun6i-csi.txt        | 49 ++++++++++++++++++++++
> > >  1 file changed, 49 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/media/sun6i-csi.txt
> > > 
> > > diff --git a/Documentation/devicetree/bindings/media/sun6i-csi.txt b/Documentation/devicetree/bindings/media/sun6i-csi.txt
> > > new file mode 100644
> > > index 0000000..f8d83f6
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/media/sun6i-csi.txt
> > > @@ -0,0 +1,49 @@
> > > +Allwinner V3s Camera Sensor Interface
> > > +------------------------------
> > > +
> > > +Required properties:
> > > +  - compatible: value must be "allwinner,sun8i-v3s-csi"
> > 
> > What are sun6i and sun8i? Is this device first present in sun6i SoCs,
> > whereas you have only defined bindings for sun8i?
> 
> Yes, some sun6i SoCs has the almost same CSI module.
> There is only V3s on my hand. So, I only tested it on V3s. But
> some people work on the others.

Ack.

> 
> > 
> > > +  - reg: base address and size of the memory-mapped region.
> > > +  - interrupts: interrupt associated to this IP
> > > +  - clocks: phandles to the clocks feeding the CSI
> > > +    * ahb: the CSI interface clock
> > > +    * mod: the CSI module clock
> > > +    * ram: the CSI DRAM clock
> > > +  - clock-names: the clock names mentioned above
> > > +  - resets: phandles to the reset line driving the CSI
> > > +
> > > +- ports: A ports node with endpoint definitions as defined in
> > > +  Documentation/devicetree/bindings/media/video-interfaces.txt.
> > 
> > Please document mandatory and optional endpoint properties relevant for the
> > hardware.
> 
> I have added below commit in my v3:
> Currently, the driver only support the parallel interface. So, a single port
> node with one endpoint and parallel bus is supported.

Please specify the exact properties that are relevant for the hardware. No
references should be made to the driver, the bindings are entirely
separate.

Are the non-parallel (CSI-2?) and parallel bus on the same interface? If
yes, they should probably use different endpoints, if not, then different
ports.

You could document the other bus or omit it now altogether, in which case
you'd only detail the parallel bus properties here.

> 
> > 
> > > +
> > > +Example:
> > > +
> > > +	csi1: csi@01cb4000 {
> > > +		compatible = "allwinner,sun8i-v3s-csi";
> > > +		reg = <0x01cb4000 0x1000>;
> > > +		interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
> > > +		clocks = <&ccu CLK_BUS_CSI>,
> > > +			 <&ccu CLK_CSI1_SCLK>,
> > > +			 <&ccu CLK_DRAM_CSI>;
> > > +		clock-names = "ahb", "mod", "ram";
> > > +		resets = <&ccu RST_BUS_CSI>;
> > > +
> > > +		port {
> > > +			#address-cells = <1>;
> > > +			#size-cells = <0>;
> > > +
> > > +			/* Parallel bus endpoint */
> > > +			csi1_ep: endpoint {
> > > +				remote-endpoint = <&adv7611_ep>;
> > > +				bus-width = <16>;
> > > +				data-shift = <0>;
> > > +
> > > +				/* If hsync-active/vsync-active are missing,
> > > +				   embedded BT.656 sync is used */
> > > +				hsync-active = <0>; /* Active low */
> > > +				vsync-active = <0>; /* Active low */
> > > +				data-active = <1>;  /* Active high */
> > > +				pclk-sample = <1>;  /* Rising */
> > > +			};
> > > +		};
> > > +	};
> > > +
> > 
> > -- 
> > Kind regards,
> > 
> > Sakari Ailus
> > e-mail: sakari.ailus@iki.fi
> 
> 
> Thanks,
> Yong

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
