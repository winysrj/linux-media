Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:42177 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728479AbeJEPrf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 11:47:35 -0400
Date: Fri, 5 Oct 2018 10:49:45 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/5] dt-bindings: adv748x: make data-lanes property
 mandatory for CSI-2 endpoints
Message-ID: <20181005084945.GL31281@w540>
References: <20181004204138.2784-1-niklas.soderlund@ragnatech.se>
 <20181004204138.2784-2-niklas.soderlund@ragnatech.se>
 <2082037.FqgpqPMGh4@avalon>
 <18767245.bJLhzbqhM5@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="j3olVFx0FsM75XyV"
Content-Disposition: inline
In-Reply-To: <18767245.bJLhzbqhM5@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--j3olVFx0FsM75XyV
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Laurent, Niklas,

On Fri, Oct 05, 2018 at 01:00:47AM +0300, Laurent Pinchart wrote:
> Hello again,
>
> On Friday, 5 October 2018 00:42:17 EEST Laurent Pinchart wrote:
> > On Thursday, 4 October 2018 23:41:34 EEST Niklas S=C3=B6derlund wrote:
> > > From: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.se>
> > >
> > > The CSI-2 transmitters can use a different number of lanes to transmit
> > > data. Make the data-lanes mandatory for the endpoints describe the
> >
> > s/describe/that describe/ ?
> >
> > > transmitters as no good default can be set to fallback on.
> > >
> > > Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnat=
ech.se>
> > > ---
> > >
> > >  Documentation/devicetree/bindings/media/i2c/adv748x.txt | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/Documentation/devicetree/bindings/media/i2c/adv748x.txt
> > > b/Documentation/devicetree/bindings/media/i2c/adv748x.txt index
> > > 5dddc95f9cc46084..f9dac01ab795fc28 100644
> > > --- a/Documentation/devicetree/bindings/media/i2c/adv748x.txt
> > > +++ b/Documentation/devicetree/bindings/media/i2c/adv748x.txt
> > > @@ -50,6 +50,9 @@ are numbered as follows.
> > >
> > >  The digital output port nodes must contain at least one endpoint.
> > >
> > > +The endpoints described in TXA and TXB ports must if present contain
> > > +the data-lanes property as described in video-interfaces.txt.
> > > +
> >
> > Would it make sense to merge those two paragraphs, as they refer to the=
 same
> > endpoint ?
> >
> > "The digital output port nodes, when present, shall contain at least one
> > endpoint. Each of those endpoints shall contain the data-lanes property=
 as
> > described in video-interfaces.txt."
> >
> > (DT bindings normally use "shall" instead of "must", but that hasn't re=
ally
> > been enforced.)
> >
> > If you want to keep the paragraphs separate, I would recommend using
> > "digital output ports" instead of "TXA and TXB" in the second paragraph=
 for
> > consistency (or the other way around).
> >
> > I'm fine with any of the above option, so please pick your favourite, a=
nd
> > add
> >
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
> I just realized that TXB only supports a single data lane, so we may want=
 not
> to have a data-lanes property for TXB.
>

Isn't it better to restrict its value to <1> but make it mandatory
anyhow? I understand conceptually that property should not be there,
as it has a single acceptable value, but otherwise we need to traeat
differently the two output ports, in documentation and code.

Why not inserting a paragraph with the required endpoint properties
description?

Eg:

 Required endpoint properties:
 - data-lanes: See "video-interfaces.txt" for description. The property
   is mandatory for CSI-2 output endpoints and the accepted values
   depends on which endpoint the property is applied to:
   - TXA: accepted values are <1>, <2>, <4>
   - TXB: accepted value is <1>

> > >  Ports are optional if they are not connected to anything at the hard=
ware
> > >
> > > level.
> > >
> > >  Example:
>
> --
> Regards,
>
> Laurent Pinchart
>
>
>

--j3olVFx0FsM75XyV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbtyWpAAoJEHI0Bo8WoVY8NWQP/AwHy565Abbcd35+Drcgnev9
9AyXKWPdSxeiS3ZZNe0FAz76BEMEAGu5Ko4CMEpNg+eDI696+y8tna0QGLwqpY8q
mJJ/X0dxpcEb/3CB9mJnn86NdFUuWqcxPrbWKVlMS3h/4rClH5spB2YBXFkmnnD4
AHKwPFcjTDB/qKn2xS3wRhauRZ+HGfv/M0QQW79rNCfvS3c2x+dEWMfbbPyCcp/3
t0N8ySlsVxeVsjNJ2zCTy/8kHzC7Nx7OnbKeIJxiF+2sDZ/HcL5fwU1gH4IrqpoF
IyngWNXOEvkGhaUofN7RPcLy03HdvORU5YsnhwUBMsL7af3po5UhmDx9iHm88HmC
9OGW2awak+3vlbPtKN2eLZdMSpBKyKiNKGYTv0agKZU4h+x89icDWVGgHV+1On31
G4Hm9HY7lEAbLLG3BKt1Juu156VCanHtYmsz7VCLelOnMD5XxxIHwe3zVLNiMAa1
XoYuDrATyXDBkXOSmn60k9YqwfKdWMVj9SGihNsyRotsAvED4/qLzQ2gsn8i7MJz
zOM4oqAQms9/iGxsnq80jniOlut9xqDep8mDHVhIdrcOSFvPCi1OGmfnjwEmKCT2
Txu1FhNO4UR312c/ksjUVxqN/tZbf/CizRNPRuSeZDCNQX8rVxl/NW7a7imQ+ML4
CyWTSAC0zUlrBiS56qVQ
=HlTB
-----END PGP SIGNATURE-----

--j3olVFx0FsM75XyV--
