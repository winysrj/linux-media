Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47152 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751107AbcK3VtQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Nov 2016 16:49:16 -0500
Date: Wed, 30 Nov 2016 23:48:36 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Rob Herring <robh@kernel.org>
Cc: Kevin Hilman <khilman@baylibre.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>,
        Axel Haslam <ahaslam@baylibre.com>,
        Bartosz =?utf-8?Q?Go=C5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>, g.liakhovetski@gmx.de,
        laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v3 4/4] [media] dt-bindings: add TI VPIF documentation
Message-ID: <20161130214835.GN16630@valkosipuli.retiisi.org.uk>
References: <20161122155244.802-1-khilman@baylibre.com>
 <20161122155244.802-5-khilman@baylibre.com>
 <20161128213822.26oeyzkht5jz5gd3@rob-hp-laptop>
 <m2shqbs0eu.fsf@baylibre.com>
 <CAL_JsqJ3wJnNa=bVN+UT4A-J5XC0jdyGAgWzROScRDLy6T8xHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqJ3wJnNa=bVN+UT4A-J5XC0jdyGAgWzROScRDLy6T8xHw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob and Kevin,

On Tue, Nov 29, 2016 at 08:41:44AM -0600, Rob Herring wrote:
> On Mon, Nov 28, 2016 at 4:30 PM, Kevin Hilman <khilman@baylibre.com> wrote:
> > Hi Rob,
> >
> > Rob Herring <robh@kernel.org> writes:
> >
> >> On Tue, Nov 22, 2016 at 07:52:44AM -0800, Kevin Hilman wrote:
> >>> Signed-off-by: Kevin Hilman <khilman@baylibre.com>
> >>> ---
> >>>  .../bindings/media/ti,da850-vpif-capture.txt       | 65 ++++++++++++++++++++++
> >>>  .../devicetree/bindings/media/ti,da850-vpif.txt    |  8 +++
> >>>  2 files changed, 73 insertions(+)
> >>>  create mode 100644 Documentation/devicetree/bindings/media/ti,da850-vpif-capture.txt
> >>>  create mode 100644 Documentation/devicetree/bindings/media/ti,da850-vpif.txt
> >>>
> >>> diff --git a/Documentation/devicetree/bindings/media/ti,da850-vpif-capture.txt b/Documentation/devicetree/bindings/media/ti,da850-vpif-capture.txt
> >>> new file mode 100644
> >>> index 000000000000..c447ac482c1d
> >>> --- /dev/null
> >>> +++ b/Documentation/devicetree/bindings/media/ti,da850-vpif-capture.txt
> >>> @@ -0,0 +1,65 @@
> >>> +Texas Instruments VPIF Capture
> >>> +------------------------------
> >>> +
> >>> +The TI Video Port InterFace (VPIF) capture component is the primary
> >>> +component for video capture on the DA850 family of TI DaVinci SoCs.
> >>> +
> >>> +TI Document number reference: SPRUH82C
> >>> +
> >>> +Required properties:
> >>> +- compatible: must be "ti,da850-vpif-capture"
> >>> +- reg: physical base address and length of the registers set for the device;
> >>> +- interrupts: should contain IRQ line for the VPIF
> >>> +
> >>> +VPIF capture has a 16-bit parallel bus input, supporting 2 8-bit
> >>> +channels or a single 16-bit channel.  It should contain at least one
> >>> +port child node with child 'endpoint' node. Please refer to the
> >>> +bindings defined in
> >>> +Documentation/devicetree/bindings/media/video-interfaces.txt.
> >>> +
> >>> +Example using 2 8-bit input channels, one of which is connected to an
> >>> +I2C-connected TVP5147 decoder:
> >>> +
> >>> +    vpif_capture: video-capture@0x00217000 {
> >>> +            reg = <0x00217000 0x1000>;
> >>> +            interrupts = <92>;
> >>> +
> >>> +            port {
> >>> +                    vpif_ch0: endpoint@0 {
> >>> +                              reg = <0>;
> >>> +                              bus-width = <8>;
> >>> +                              remote-endpoint = <&composite>;
> >>> +                    };
> >>> +
> >>> +                    vpif_ch1: endpoint@1 {
> >>
> >> I think probably channels here should be ports rather than endpoints.
> >> AIUI, having multiple endpoints is for cases like a mux or 1 to many
> >> connections. There's only one data flow, but multiple sources or sinks.
> >
> > Looking at this closer... , I used an endpoint because it's bascially a
> > 16-bit parallel bus, that can be configured as (up to) 2 8-bit
> > "channels.  So, based on the video-interfaces.txt doc, I configured this
> > as a single port, with (up to) 2 endpoints.  That also allows me to
> > connect output of the decoder directly, using the remote-endpoint
> > property.
> >
> > So I guess I'm not fully understanding your suggestion.
> 
> NM, looks like video-interfaces.txt actually spells out this case and
> defines doing it as you did.

It's actually the first time I read that portion (at least so that I could
remember) of video-interfaces.txt. I'm not sure if anyone has implemented
that previously, nor how we ended up with the text. The list archive could
probably tell. Cc Guennadi who wrote it. :-) I couldn't immediately find DT
source with this arrangement.

In case of splitting the port into two parallel interfaces, how do you
determine which wires belong to which endpoint? I guess they'd be particular
sets of wires but as there's just a single port it isn't defined by the
port.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
