Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor2.renesas.com ([210.160.252.172]:38790 "EHLO
        relmlie1.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752646AbeDJLFH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 07:05:07 -0400
From: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
To: =?iso-8859-1?Q?Niklas_S=F6derlund?= <niklas.soderlund@ragnatech.se>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>,
        TOMOHARU FUKAWA <tomoharu.fukawa.eb@renesas.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Simon Horman <horms@verge.net.au>,
        "Geert Uytterhoeven" <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [PATCH v13 02/33] dt-bindings: media: rcar_vin: add device tree
 support for r8a774[35]
Date: Tue, 10 Apr 2018 11:04:58 +0000
Message-ID: <TY1PR01MB1770CD1189E70C5BC7A73F15C0BE0@TY1PR01MB1770.jpnprd01.prod.outlook.com>
References: <20180326214456.6655-1-niklas.soderlund+renesas@ragnatech.se>
 <20180326214456.6655-3-niklas.soderlund+renesas@ragnatech.se>
 <TY1PR01MB17703A92A8B0DF3758D00F1BC0BE0@TY1PR01MB1770.jpnprd01.prod.outlook.com>
 <20180410101736.GQ12256@bigcity.dyn.berto.se>
In-Reply-To: <20180410101736.GQ12256@bigcity.dyn.berto.se>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Niklas,

> Subject: Re: [PATCH v13 02/33] dt-bindings: media: rcar_vin: add device t=
ree support for r8a774[35]
>
> Hi Fabrizio,
>
> On 2018-04-10 09:55:29 +0000, Fabrizio Castro wrote:
> > Dear All,
> >
> > this patch was originally sent on the 16/11/2017, and reposted a few ti=
mes, does anybody know who is supposed to take it?
>
> Hans have indicated he will take this a respin of this whole patch-set
> sometime next week.

fantastic, thanks a lot for the information.

Cheers,
Fab

>
> >
> > Thanks,
> > Fab
> >
> > > -----Original Message-----
> > > From: Niklas S=F6derlund [mailto:niklas.soderlund+renesas@ragnatech.s=
e]
> > > Sent: 26 March 2018 22:44
> > > To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>; Hans Verkui=
l <hverkuil@xs4all.nl>; linux-media@vger.kernel.org
> > > Cc: linux-renesas-soc@vger.kernel.org; TOMOHARU FUKAWA <tomoharu.fuka=
wa.eb@renesas.com>; Kieran Bingham
> > > <kieran.bingham@ideasonboard.com>; Fabrizio Castro <fabrizio.castro@b=
p.renesas.com>
> > > Subject: [PATCH v13 02/33] dt-bindings: media: rcar_vin: add device t=
ree support for r8a774[35]
> > >
> > > From: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> > >
> > > Add compatible strings for r8a7743 and r8a7745. No driver change
> > > is needed as "renesas,rcar-gen2-vin" will activate the right code.
> > > However, it is good practice to document compatible strings for the
> > > specific SoC as this allows SoC specific changes to the driver if
> > > needed, in addition to document SoC support and therefore allow
> > > checkpatch.pl to validate compatible string values.
> > >
> > > Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> > > Reviewed-by: Biju Das <biju.das@bp.renesas.com>
> > > Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
> > > Acked-by: Rob Herring <robh@kernel.org>
> > > Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > > Acked-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> > > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > ---
> > >  Documentation/devicetree/bindings/media/rcar_vin.txt | 5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/D=
ocumentation/devicetree/bindings/media/rcar_vin.txt
> > > index d99b6f5dee418056..4c76d82905c9d3b8 100644
> > > --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> > > +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> > > @@ -6,6 +6,8 @@ family of devices. The current blocks are always slav=
es and suppot one input
> > >  channel which can be either RGB, YUYV or BT656.
> > >
> > >   - compatible: Must be one or more of the following
> > > +   - "renesas,vin-r8a7743" for the R8A7743 device
> > > +   - "renesas,vin-r8a7745" for the R8A7745 device
> > >     - "renesas,vin-r8a7778" for the R8A7778 device
> > >     - "renesas,vin-r8a7779" for the R8A7779 device
> > >     - "renesas,vin-r8a7790" for the R8A7790 device
> > > @@ -14,7 +16,8 @@ channel which can be either RGB, YUYV or BT656.
> > >     - "renesas,vin-r8a7793" for the R8A7793 device
> > >     - "renesas,vin-r8a7794" for the R8A7794 device
> > >     - "renesas,vin-r8a7795" for the R8A7795 device
> > > -   - "renesas,rcar-gen2-vin" for a generic R-Car Gen2 compatible dev=
ice.
> > > +   - "renesas,rcar-gen2-vin" for a generic R-Car Gen2 or RZ/G1 compa=
tible
> > > +     device.
> > >     - "renesas,rcar-gen3-vin" for a generic R-Car Gen3 compatible dev=
ice.
> > >
> > >     When compatible with the generic version nodes must list the
> > > --
> > > 2.16.2
> >
> >
> >
> >
> > Renesas Electronics Europe Ltd, Dukes Meadow, Millboard Road, Bourne En=
d, Buckinghamshire, SL8 5FH, UK. Registered in England
> & Wales under Registered No. 04586709.
>
> --
> Regards,
> Niklas S=F6derlund



Renesas Electronics Europe Ltd, Dukes Meadow, Millboard Road, Bourne End, B=
uckinghamshire, SL8 5FH, UK. Registered in England & Wales under Registered=
 No. 04586709.
