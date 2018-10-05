Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:49522 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727179AbeJERAl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 13:00:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/5] dt-bindings: adv748x: make data-lanes property mandatory for CSI-2 endpoints
Date: Fri, 05 Oct 2018 13:02:53 +0300
Message-ID: <4582789.bxBjXKKKhz@avalon>
In-Reply-To: <20181005084945.GL31281@w540>
References: <20181004204138.2784-1-niklas.soderlund@ragnatech.se> <18767245.bJLhzbqhM5@avalon> <20181005084945.GL31281@w540>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Friday, 5 October 2018 11:49:45 EEST jacopo mondi wrote:
> On Fri, Oct 05, 2018 at 01:00:47AM +0300, Laurent Pinchart wrote:
> > On Friday, 5 October 2018 00:42:17 EEST Laurent Pinchart wrote:
> >> On Thursday, 4 October 2018 23:41:34 EEST Niklas S=F6derlund wrote:
> >>> From: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> >>>=20
> >>> The CSI-2 transmitters can use a different number of lanes to transmit
> >>> data. Make the data-lanes mandatory for the endpoints describe the
> >>=20
> >> s/describe/that describe/ ?
> >>=20
> >>> transmitters as no good default can be set to fallback on.
> >>>=20
> >>> Signed-off-by: Niklas S=F6derlund
> >>> <niklas.soderlund+renesas@ragnatech.se>
> >>> ---
> >>>=20
> >>>  Documentation/devicetree/bindings/media/i2c/adv748x.txt | 3 +++
> >>>  1 file changed, 3 insertions(+)
> >>>=20
> >>> diff --git a/Documentation/devicetree/bindings/media/i2c/adv748x.txt
> >>> b/Documentation/devicetree/bindings/media/i2c/adv748x.txt index
> >>> 5dddc95f9cc46084..f9dac01ab795fc28 100644
> >>> --- a/Documentation/devicetree/bindings/media/i2c/adv748x.txt
> >>> +++ b/Documentation/devicetree/bindings/media/i2c/adv748x.txt
> >>> @@ -50,6 +50,9 @@ are numbered as follows.
> >>>=20
> >>>  The digital output port nodes must contain at least one endpoint.
> >>>=20
> >>> +The endpoints described in TXA and TXB ports must if present contain
> >>> +the data-lanes property as described in video-interfaces.txt.
> >>> +
> >>=20
> >> Would it make sense to merge those two paragraphs, as they refer to the
> >> same endpoint ?
> >>=20
> >> "The digital output port nodes, when present, shall contain at least o=
ne
> >> endpoint. Each of those endpoints shall contain the data-lanes property
> >> as described in video-interfaces.txt."
> >>=20
> >> (DT bindings normally use "shall" instead of "must", but that hasn't
> >> really been enforced.)
> >>=20
> >> If you want to keep the paragraphs separate, I would recommend using
> >> "digital output ports" instead of "TXA and TXB" in the second paragraph
> >> for consistency (or the other way around).
> >>=20
> >> I'm fine with any of the above option, so please pick your favourite,
> >> and add
> >>=20
> >> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >=20
> > I just realized that TXB only supports a single data lane, so we may wa=
nt
> > not to have a data-lanes property for TXB.
>=20
> Isn't it better to restrict its value to <1> but make it mandatory
> anyhow? I understand conceptually that property should not be there,
> as it has a single acceptable value, but otherwise we need to traeat
> differently the two output ports, in documentation and code.

The two ports are different, so I wouldn't be shocked if we handled them=20
differently :-) I believe it would actually reduce the code size (and save =
CPU=20
cycles at runtime).

> Why not inserting a paragraph with the required endpoint properties
> description?
>=20
> Eg:
>=20
>  Required endpoint properties:
>  - data-lanes: See "video-interfaces.txt" for description. The property
>    is mandatory for CSI-2 output endpoints and the accepted values
>    depends on which endpoint the property is applied to:
>    - TXA: accepted values are <1>, <2>, <4>
>    - TXB: accepted value is <1>
>=20
> >>>  Ports are optional if they are not connected to anything at the
> >>>  hardware level.
> >>>=20
> >>>  Example:

=2D-=20
Regards,

Laurent Pinchart
