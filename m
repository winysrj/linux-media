Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33252 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751914AbeDJKRj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 06:17:39 -0400
Received: by mail-lf0-f67.google.com with SMTP id x70-v6so10850647lfa.0
        for <linux-media@vger.kernel.org>; Tue, 10 Apr 2018 03:17:38 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Tue, 10 Apr 2018 12:17:36 +0200
To: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>,
        TOMOHARU FUKAWA <tomoharu.fukawa.eb@renesas.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: Re: [PATCH v13 02/33] dt-bindings: media: rcar_vin: add device tree
 support for r8a774[35]
Message-ID: <20180410101736.GQ12256@bigcity.dyn.berto.se>
References: <20180326214456.6655-1-niklas.soderlund+renesas@ragnatech.se>
 <20180326214456.6655-3-niklas.soderlund+renesas@ragnatech.se>
 <TY1PR01MB17703A92A8B0DF3758D00F1BC0BE0@TY1PR01MB1770.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <TY1PR01MB17703A92A8B0DF3758D00F1BC0BE0@TY1PR01MB1770.jpnprd01.prod.outlook.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabrizio,

On 2018-04-10 09:55:29 +0000, Fabrizio Castro wrote:
> Dear All,
> 
> this patch was originally sent on the 16/11/2017, and reposted a few times, does anybody know who is supposed to take it?

Hans have indicated he will take this a respin of this whole patch-set 
sometime next week.

> 
> Thanks,
> Fab
> 
> > -----Original Message-----
> > From: Niklas Söderlund [mailto:niklas.soderlund+renesas@ragnatech.se]
> > Sent: 26 March 2018 22:44
> > To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>; Hans Verkuil <hverkuil@xs4all.nl>; linux-media@vger.kernel.org
> > Cc: linux-renesas-soc@vger.kernel.org; TOMOHARU FUKAWA <tomoharu.fukawa.eb@renesas.com>; Kieran Bingham
> > <kieran.bingham@ideasonboard.com>; Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> > Subject: [PATCH v13 02/33] dt-bindings: media: rcar_vin: add device tree support for r8a774[35]
> >
> > From: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> >
> > Add compatible strings for r8a7743 and r8a7745. No driver change
> > is needed as "renesas,rcar-gen2-vin" will activate the right code.
> > However, it is good practice to document compatible strings for the
> > specific SoC as this allows SoC specific changes to the driver if
> > needed, in addition to document SoC support and therefore allow
> > checkpatch.pl to validate compatible string values.
> >
> > Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> > Reviewed-by: Biju Das <biju.das@bp.renesas.com>
> > Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
> > Acked-by: Rob Herring <robh@kernel.org>
> > Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> >  Documentation/devicetree/bindings/media/rcar_vin.txt | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
> > index d99b6f5dee418056..4c76d82905c9d3b8 100644
> > --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> > +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> > @@ -6,6 +6,8 @@ family of devices. The current blocks are always slaves and suppot one input
> >  channel which can be either RGB, YUYV or BT656.
> >
> >   - compatible: Must be one or more of the following
> > +   - "renesas,vin-r8a7743" for the R8A7743 device
> > +   - "renesas,vin-r8a7745" for the R8A7745 device
> >     - "renesas,vin-r8a7778" for the R8A7778 device
> >     - "renesas,vin-r8a7779" for the R8A7779 device
> >     - "renesas,vin-r8a7790" for the R8A7790 device
> > @@ -14,7 +16,8 @@ channel which can be either RGB, YUYV or BT656.
> >     - "renesas,vin-r8a7793" for the R8A7793 device
> >     - "renesas,vin-r8a7794" for the R8A7794 device
> >     - "renesas,vin-r8a7795" for the R8A7795 device
> > -   - "renesas,rcar-gen2-vin" for a generic R-Car Gen2 compatible device.
> > +   - "renesas,rcar-gen2-vin" for a generic R-Car Gen2 or RZ/G1 compatible
> > +     device.
> >     - "renesas,rcar-gen3-vin" for a generic R-Car Gen3 compatible device.
> >
> >     When compatible with the generic version nodes must list the
> > --
> > 2.16.2
> 
> 
> 
> 
> Renesas Electronics Europe Ltd, Dukes Meadow, Millboard Road, Bourne End, Buckinghamshire, SL8 5FH, UK. Registered in England & Wales under Registered No. 04586709.

-- 
Regards,
Niklas Söderlund
