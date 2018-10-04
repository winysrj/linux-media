Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:52798 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727732AbeJEEzz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 00:55:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/5] dt-bindings: adv748x: make data-lanes property mandatory for CSI-2 endpoints
Date: Fri, 05 Oct 2018 01:00:47 +0300
Message-ID: <18767245.bJLhzbqhM5@avalon>
In-Reply-To: <2082037.FqgpqPMGh4@avalon>
References: <20181004204138.2784-1-niklas.soderlund@ragnatech.se> <20181004204138.2784-2-niklas.soderlund@ragnatech.se> <2082037.FqgpqPMGh4@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello again,

On Friday, 5 October 2018 00:42:17 EEST Laurent Pinchart wrote:
> On Thursday, 4 October 2018 23:41:34 EEST Niklas S=F6derlund wrote:
> > From: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> >=20
> > The CSI-2 transmitters can use a different number of lanes to transmit
> > data. Make the data-lanes mandatory for the endpoints describe the
>=20
> s/describe/that describe/ ?
>=20
> > transmitters as no good default can be set to fallback on.
> >=20
> > Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.s=
e>
> > ---
> >=20
> >  Documentation/devicetree/bindings/media/i2c/adv748x.txt | 3 +++
> >  1 file changed, 3 insertions(+)
> >=20
> > diff --git a/Documentation/devicetree/bindings/media/i2c/adv748x.txt
> > b/Documentation/devicetree/bindings/media/i2c/adv748x.txt index
> > 5dddc95f9cc46084..f9dac01ab795fc28 100644
> > --- a/Documentation/devicetree/bindings/media/i2c/adv748x.txt
> > +++ b/Documentation/devicetree/bindings/media/i2c/adv748x.txt
> > @@ -50,6 +50,9 @@ are numbered as follows.
> >=20
> >  The digital output port nodes must contain at least one endpoint.
> >=20
> > +The endpoints described in TXA and TXB ports must if present contain
> > +the data-lanes property as described in video-interfaces.txt.
> > +
>=20
> Would it make sense to merge those two paragraphs, as they refer to the s=
ame
> endpoint ?
>=20
> "The digital output port nodes, when present, shall contain at least one
> endpoint. Each of those endpoints shall contain the data-lanes property as
> described in video-interfaces.txt."
>=20
> (DT bindings normally use "shall" instead of "must", but that hasn't real=
ly
> been enforced.)
>=20
> If you want to keep the paragraphs separate, I would recommend using
> "digital output ports" instead of "TXA and TXB" in the second paragraph f=
or
> consistency (or the other way around).
>=20
> I'm fine with any of the above option, so please pick your favourite, and
> add
>=20
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I just realized that TXB only supports a single data lane, so we may want n=
ot=20
to have a data-lanes property for TXB.

> >  Ports are optional if they are not connected to anything at the hardwa=
re
> >=20
> > level.
> >=20
> >  Example:

=2D-=20
Regards,

Laurent Pinchart
