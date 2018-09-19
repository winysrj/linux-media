Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45147 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727983AbeITAnH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Sep 2018 20:43:07 -0400
Date: Wed, 19 Sep 2018 12:03:45 -0700
From: Nathan Chancellor <natechancellor@gmail.com>
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: prabhakar.csengg@gmail.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media: davinci: Fix implicit enum conversion warning
Message-ID: <20180919190345.GA31549@flashbox>
References: <20180915061615.25308-1-natechancellor@gmail.com>
 <CAKwvOd=FY9_F=yDOPaesM1VmYW0jTaAAYcMTmG6TFwa=ACu62w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOd=FY9_F=yDOPaesM1VmYW0jTaAAYcMTmG6TFwa=ACu62w@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 17, 2018 at 10:39:05AM -0700, Nick Desaulniers wrote:
> On Fri, Sep 14, 2018 at 11:16 PM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
> >
> > Clang warns when one enumerated type is implicitly converted to another.
> >
> > drivers/media/platform/davinci/vpbe_display.c:524:24: warning: implicit
> > conversion from enumeration type 'enum osd_v_exp_ratio' to different
> > enumeration type 'enum osd_h_exp_ratio' [-Wenum-conversion]
> >                         layer_info->h_exp = V_EXP_6_OVER_5;
> >                                           ~ ^~~~~~~~~~~~~~
> > 1 warning generated.
> >
> > This appears to be a copy and paste error judging from the couple of
> > lines directly above this statement and the way that height is handled
> > in the if block above this one.
> 
> 
> The above code for reference looks like:
>    492                 if (h_exp)
>    493                         layer_info->h_exp = H_EXP_9_OVER_8;
> 
> so it makes sense to me that:
> if (h_exp) layer_info->h_exp = H_EXP_...;
> then
> if (v_exp) layer_info->v_exp = V_EXP_...;
> 
> Thanks for this patch Nathan, looks like an actual bug has been fixed.
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> 
> We should send this to stable if/when it lands.  Maybe the maintainers
> could apply it with:
> Cc: stable@vger.kernel.org
> 

Yes, I think this qualifies as stable material. Should I need to send a
v2, I will add it; otherwise, it can be added by the maintainers at
their discretion.

Thanks for the review!
Nathan

> 
> >
> > Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > ---
> >  drivers/media/platform/davinci/vpbe_display.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
> > index d6bf96ad474c..5c235898af7b 100644
> > --- a/drivers/media/platform/davinci/vpbe_display.c
> > +++ b/drivers/media/platform/davinci/vpbe_display.c
> > @@ -521,7 +521,7 @@ vpbe_disp_calculate_scale_factor(struct vpbe_display *disp_dev,
> >                 else if (v_scale == 4)
> >                         layer_info->v_zoom = ZOOM_X4;
> >                 if (v_exp)
> > -                       layer_info->h_exp = V_EXP_6_OVER_5;
> > +                       layer_info->v_exp = V_EXP_6_OVER_5;
> >         } else {
> >                 /* no scaling, only cropping. Set display area to crop area */
> >                 cfg->ysize = expected_ysize;
> > --
> > 2.18.0
> >
> 
> 
> -- 
> Thanks,
> ~Nick Desaulniers
