Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:51533 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390293AbeKWS4T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 13:56:19 -0500
Date: Fri, 23 Nov 2018 09:13:00 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Yong <yong.deng@magewell.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Todor Tomov <todor.tomov@linaro.org>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v12 1/2] dt-bindings: media: Add Allwinner V3s Camera
 Sensor Interface (CSI)
Message-ID: <20181123081300.GC6788@w540>
References: <1540887143-27904-1-git-send-email-yong.deng@magewell.com>
 <308184907.pMD7ZDI2dr@avalon>
 <20181123074514.GB6788@w540>
 <20181123160117.7eed41aac3e7e31e4e6d98be@magewell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="y2zxS2PfCDLh6JVG"
Content-Disposition: inline
In-Reply-To: <20181123160117.7eed41aac3e7e31e4e6d98be@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--y2zxS2PfCDLh6JVG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Yong,

On Fri, Nov 23, 2018 at 04:01:17PM +0800, Yong wrote:
> Hi jacopo,
>
> On Fri, 23 Nov 2018 08:45:14 +0100
> jacopo mondi <jacopo@jmondi.org> wrote:
>
> > Hi Yong,
> >
> > On Tue, Oct 30, 2018 at 03:06:24PM +0200, Laurent Pinchart wrote:
> > > Hi Yong,
> > >
> > > Thank you for the patch.
> > >
> > > On Tuesday, 30 October 2018 10:12:23 EET Yong Deng wrote:
> > > > Add binding documentation for Allwinner V3s CSI.
> > > >
> > > > Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > > > Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > > Reviewed-by: Rob Herring <robh@kernel.org>
> > > > Signed-off-by: Yong Deng <yong.deng@magewell.com>
> > >
> > > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > >
> > > > ---
> > > >  .../devicetree/bindings/media/sun6i-csi.txt        | 56 +++++++++++++++++++
> > > >  1 file changed, 56 insertions(+)
> > > >  create mode 100644 Documentation/devicetree/bindings/media/sun6i-csi.txt
> > > >
> > > > diff --git a/Documentation/devicetree/bindings/media/sun6i-csi.txt
> > > > b/Documentation/devicetree/bindings/media/sun6i-csi.txt new file mode
> > > > 100644
> > > > index 000000000000..443e18c181b3
> > > > --- /dev/null
> > > > +++ b/Documentation/devicetree/bindings/media/sun6i-csi.txt
> > > > @@ -0,0 +1,56 @@
> > > > +Allwinner V3s Camera Sensor Interface
> > > > +-------------------------------------
> > > > +
> > > > +Allwinner V3s SoC features a CSI module(CSI1) with parallel interface.
> > > > +
> > > > +Required properties:
> > > > +  - compatible: value must be "allwinner,sun8i-v3s-csi"
> > > > +  - reg: base address and size of the memory-mapped region.
> > > > +  - interrupts: interrupt associated to this IP
> > > > +  - clocks: phandles to the clocks feeding the CSI
> > > > +    * bus: the CSI interface clock
> > > > +    * mod: the CSI module clock
> > > > +    * ram: the CSI DRAM clock
> > > > +  - clock-names: the clock names mentioned above
> > > > +  - resets: phandles to the reset line driving the CSI
> > > > +
> > > > +The CSI node should contain one 'port' child node with one child 'endpoint'
> > > > +node, according to the bindings defined in
> > > > +Documentation/devicetree/bindings/media/video-interfaces.txt.
> > > > +
> > > > +Endpoint node properties for CSI
> > > > +---------------------------------
> > > > +See the video-interfaces.txt for a detailed description of these
> > > > properties. +- remote-endpoint	: (required) a phandle to the bus receiver's
> > > > endpoint +			   node
> > > > +- bus-width:		: (required) must be 8, 10, 12 or 16
> > > > +- pclk-sample		: (optional) (default: sample on falling edge)
> > > > +- hsync-active		: (required; parallel-only)
> > > > +- vsync-active		: (required; parallel-only)
> > > > +
> > > > +Example:
> > > > +
> > > > +csi1: csi@1cb4000 {
> > > > +	compatible = "allwinner,sun8i-v3s-csi";
> > > > +	reg = <0x01cb4000 0x1000>;
> > > > +	interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
> > > > +	clocks = <&ccu CLK_BUS_CSI>,
> > > > +		 <&ccu CLK_CSI1_SCLK>,
> > > > +		 <&ccu CLK_DRAM_CSI>;
> > > > +	clock-names = "bus", "mod", "ram";
> > > > +	resets = <&ccu RST_BUS_CSI>;
> > > > +
> > > > +	port {
> > > > +		/* Parallel bus endpoint */
> > > > +		csi1_ep: endpoint {
> > > > +			remote-endpoint = <&adv7611_ep>;
> > > > +			bus-width = <16>;
> > > > +
> > > > +			/* If hsync-active/vsync-active are missing,
> > > > +			   embedded BT.656 sync is used */
> >
> > Am I confused? The properties description defines [v|h]sync-active as
> > required, but the example reports that they can be omitted to use
> > BT.656 synchronization.
> >
> > Which one of the following is correct?
> > 1) [h|v]sync-active are mandatory: no BT.656 support can be selected.
> > 2) [h|v]sync-active are optional, and if not specified BT.656 is
> >    selected.
> > 3) I am confused.
> >
>
> hsync-active		: (required; parallel-only)
> vsync-active		: (required; parallel-only)
>
> Here, parallel means seperate sync signal, BT.656 means embedded sync
> signal. Kernel use these two properties to detect if the bus type is
> parallel or Bt656. So [h|v]sync-active are mandatory only if your bus
> type is parallel and must not be specified if your bus type is Bt656.

Well, BT.565 sync mode applies to parallel data transmission busses as
BT.601 sync mode does... I don't want to bikeshed on terms though, I'm
sorry...

I would have write here:

hsync-active		: Required when using explicit HSYNC synchronism
                          signal. Default valuse is "high"/"low".
vsync-active		: Required when using explicit VSYNC synchronism
                          signal. Default valuse is "high"/"low".
When both vsync-active and hsync-active are omitted BT.565 implicit
synchronization mode is used.

To avoid confusing people already confused as I am :)

I got this patch is already in, right? Feel free to ignore my comment or
either send an incremental patch if you think it is appropriate.

Thanks
  j

> Thanks,
> Yong

--y2zxS2PfCDLh6JVG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJb97aMAAoJEHI0Bo8WoVY8oQIP/j+gd5kc5HL3Ivb0Vl3Ktb90
lqsCvDsouLqcTf14FY4okYTwpUciIt9YKI4Jt6AcrVr0qWbyKiicSlaLkd+aJp80
kq+PtKrpWQXBOpXzlujXVowi9+/trJ7M2rMLqRwFN6cFnA4agGTMys/m4lQAusJT
sQH/gclBD18tAyllflM3xmGfgjvvZZbZuZ/8Y4z7fC1kpllAeMLdCOnWBR1IVdBe
Bfm8HFCQCLSo0uq94eqGRzKnxRUcJ8TND2tZNa9nAtOXkxB0BnvnfycHxNTLJi09
Dx7MFa6Y64ydl+JAp6beJs2JaU9Eb3jLAAH3jPVQtvH2GdRRiGuvSarNXGsyls27
2UjBjTT8dck4JbZEQIpSPrdWUYcTp1iMTfX+wvpQDA61MQ17blaTSSdYh0FTV7z+
CO1/8SN3thaUTFA8jBIF6S87XUPlWcJI5SU9RGNegUdHbZHLVR6jfxzyk9pSe8tJ
bBVkR4v55au5/tHFOxye50u+yrRBxDkZzGi2BA8XPDjBRn9kvKEmXWIxKO6F3dRf
pSYrXCsWTLbqnTzn5OA+y7zUKolybwjawskG8Q/kynTqMD15yXo2tEBieZkJc9zq
3PyGM8Jwovw87PtFaBeBmLXlhycEt4BhFJBf/yZ+NfP81hEsJXs0a0LoT9dSt6h9
uXPNoJh8cG9qtmWtjuxU
=aYBN
-----END PGP SIGNATURE-----

--y2zxS2PfCDLh6JVG--
