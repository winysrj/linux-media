Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35445 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756434AbeDZPVw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 11:21:52 -0400
Received: by mail-lf0-f67.google.com with SMTP id r125-v6so31334282lfe.2
        for <linux-media@vger.kernel.org>; Thu, 26 Apr 2018 08:21:51 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Thu, 26 Apr 2018 17:21:49 +0200
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH] rcar-vin: fix null pointer dereference in
 rvin_group_get()
Message-ID: <20180426152149.GF3315@bigcity.dyn.berto.se>
References: <20180424234506.22630-1-niklas.soderlund+renesas@ragnatech.se>
 <CAMuHMdWqW7FGxA8akfS6X2C-3Hm7126+9E7xCpezXfUEwwFWUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdWqW7FGxA8akfS6X2C-3Hm7126+9E7xCpezXfUEwwFWUQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

Thanks for your feedback.

On 2018-04-25 09:25:56 +0200, Geert Uytterhoeven wrote:
> On Wed, Apr 25, 2018 at 1:45 AM, Niklas Söderlund
> <niklas.soderlund+renesas@ragnatech.se> wrote:
> > Store the group pointer before disassociating the VIN from the group.
> 
> s/get/put/ in one-line summary?

Yes, silly copy paste error, must have copied function name from the @@ 
context line and not from the diff itself. Thanks for noticing.

Will send a v2 after I have checked with Simon that the is happy with 
the change itself.

> 
> > Fixes: 3bb4c3bc85bf77a7 ("media: rcar-vin: add group allocator functions")
> > Reported-by: Colin Ian King <colin.king@canonical.com>
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-core.c | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> > index 7bc2774a11232362..d3072e166a1ca24f 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-core.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> > @@ -338,19 +338,21 @@ static int rvin_group_get(struct rvin_dev *vin)
> >
> >  static void rvin_group_put(struct rvin_dev *vin)
> >  {
> > -       mutex_lock(&vin->group->lock);
> > +       struct rvin_group *group = vin->group;
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
