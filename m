Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:34165 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751146AbdCPJR5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Mar 2017 05:17:57 -0400
Received: by mail-lf0-f49.google.com with SMTP id z15so17419080lfd.1
        for <linux-media@vger.kernel.org>; Thu, 16 Mar 2017 02:17:55 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Thu, 16 Mar 2017 10:17:53 +0100
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Fukawa <tomoharu.fukawa.eb@renesas.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v3 27/27] rcar-vin: enable support for r8a7796
Message-ID: <20170316091753.GW20587@bigcity.dyn.berto.se>
References: <20170314190308.25790-1-niklas.soderlund+renesas@ragnatech.se>
 <20170314190308.25790-28-niklas.soderlund+renesas@ragnatech.se>
 <CAMuHMdUWeWoDHSqH5i_KT_LHhH2dhq29tQeranPNjG=UORdajA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdUWeWoDHSqH5i_KT_LHhH2dhq29tQeranPNjG=UORdajA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

Thanks for your comments.

On 2017-03-16 09:36:01 +0100, Geert Uytterhoeven wrote:
> Hi Niklas,
> 
> On Tue, Mar 14, 2017 at 8:03 PM, Niklas Söderlund
> <niklas.soderlund+renesas@ragnatech.se> wrote:
> > Add the SoC specific information for Renesas r8a7796.
> >
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  .../devicetree/bindings/media/rcar_vin.txt         |  1 +
> >  drivers/media/platform/rcar-vin/rcar-core.c        | 64 ++++++++++++++++++++++
> >  2 files changed, 65 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
> > index ffdfa97ac37753f9..7e36ebe5c89b7dfd 100644
> > --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> > +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> > @@ -10,6 +10,7 @@ always slaves and support multiple input channels which can be either RGB,
> >  YUVU, BT656 or CSI-2.
> >
> >   - compatible: Must be one or more of the following
> > +   - "renesas,vin-r8a7796" for the R8A7796 device
> >     - "renesas,vin-r8a7795" for the R8A7795 device
> >     - "renesas,vin-r8a7794" for the R8A7794 device
> >     - "renesas,vin-r8a7793" for the R8A7793 device
> > diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> > index c30040c42ce588a9..8930189638473f37 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-core.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> > @@ -1119,6 +1119,66 @@ static const struct rvin_info rcar_info_r8a7795 = {
> >         },
> >  };
> >
> > +static const struct rvin_info rcar_info_r8a7796 = {
> > +       .chip = RCAR_GEN3,
> 
> [...]
> 
> The R-Car Gen3 entries are inserted in between Gen1 and Gen2?

Thanks for spotting this, this is obviously not correct sorting order. I 
don't know how it ended up like this, was the same in v2 so mush have 
been due to some mistake on my part prior to that.

Will fix for v4.

> 
> > +};
> > +
> >  static const struct rvin_info rcar_info_gen2 = {
> >         .chip = RCAR_GEN2,
> >         .use_mc = false,
> > @@ -1132,6 +1192,10 @@ static const struct of_device_id rvin_of_id_table[] = {
> >                 .data = &rcar_info_r8a7795,
> >         },
> >         {
> > +               .compatible = "renesas,vin-r8a7796",
> > +               .data = &rcar_info_r8a7796,
> > +       },
> > +       {
> 
> Shouldn't this be inserted above the r8a7795 entry?
> All other entries in this table are sorted in reverse alphabetical order.

Will fix.

> 
> >                 .compatible = "renesas,vin-r8a7794",
> >                 .data = &rcar_info_gen2,
> >         },
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds

-- 
Regards,
Niklas Söderlund
