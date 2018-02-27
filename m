Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-3.mail.aliyun.com ([115.124.20.3]:47978 "EHLO
        out20-3.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751530AbeB0IbZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 03:31:25 -0500
Date: Tue, 27 Feb 2018 16:31:00 +0800
From: Yong <yong.deng@magewell.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v8 1/2] dt-bindings: media: Add Allwinner V3s Camera
 Sensor Interface (CSI)
Message-Id: <20180227163100.af7828ff4930b91cda54fd46@magewell.com>
In-Reply-To: <1519719639.3402.2.camel@pengutronix.de>
References: <1519697256-32472-1-git-send-email-yong.deng@magewell.com>
        <1519719639.3402.2.camel@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 27 Feb 2018 09:20:39 +0100
Philipp Zabel <p.zabel@pengutronix.de> wrote:

> On Tue, 2018-02-27 at 10:07 +0800, Yong Deng wrote:
> > Add binding documentation for Allwinner V3s CSI.
> > 
> > Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Reviewed-by: Rob Herring <robh@kernel.org>
> > Signed-off-by: Yong Deng <yong.deng@magewell.com>
> > ---
> >  .../devicetree/bindings/media/sun6i-csi.txt        | 59 ++++++++++++++++++++++
> >  1 file changed, 59 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/sun6i-csi.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/media/sun6i-csi.txt b/Documentation/devicetree/bindings/media/sun6i-csi.txt
> > new file mode 100644
> > index 000000000000..2ff47a9507a6
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/sun6i-csi.txt
> > @@ -0,0 +1,59 @@
> > +Allwinner V3s Camera Sensor Interface
> > +-------------------------------------
> > +
> > +Allwinner V3s SoC features two CSI module. CSI0 is used for MIPI CSI-2
> > +interface and CSI1 is used for parallel interface.
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
> > +Each CSI node should contain one 'port' child node with one child 'endpoint'
> > +node, according to the bindings defined in
> > +Documentation/devicetree/bindings/media/video-interfaces.txt. As mentioned
> > +above, the endpoint's bus type should be MIPI CSI-2 for CSI0 and parallel or
> > +Bt656 for CSI1.
> > +
> > +Endpoint node properties for CSI1
> > +---------------------------------
> > +
> > +- remote-endpoint	: (required) a phandle to the bus receiver's endpoint
> > +			   node
> > +- bus-width:		: (required) must be 8, 10, 12 or 16
> > +- pclk-sample		: (optional) (default: sample on falling edge)
> 
> It would be helpful to state that 1 is rising edge and 0 is falling
> edge, see for example ov5640.txt

I think this is already documented at 
Documentation/devicetree/bindings/media/video-interfaces.txt.

> 
> regards
> Philipp


Thanks,
Yong
