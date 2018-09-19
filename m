Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37406 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387591AbeITAet (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Sep 2018 20:34:49 -0400
Received: by mail-pf1-f195.google.com with SMTP id h69-v6so3134580pfd.4
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2018 11:55:34 -0700 (PDT)
MIME-Version: 1.0
References: <20180915054739.14117-1-natechancellor@gmail.com>
 <CAKwvOdmQ4pbbPuvYrVYB9myD8ap36h6nLjEdL-mSbYjM37UJ_g@mail.gmail.com> <20180917193936.33e90d5a@coco.lan>
In-Reply-To: <20180917193936.33e90d5a@coco.lan>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Wed, 19 Sep 2018 11:55:21 -0700
Message-ID: <CAKwvOdne+wYiK7Zek5teGz5JsAjQq+i8g+rjf2-L05c_AuXKEg@mail.gmail.com>
Subject: Re: [PATCH] [media] dib7000p: Remove dead code
To: mchehab+samsung@kernel.org
Cc: Nathan Chancellor <natechancellor@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 17, 2018 at 3:39 PM Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
>
> Em Mon, 17 Sep 2018 10:58:32 -0700
> Nick Desaulniers <ndesaulniers@google.com> escreveu:
>
> > On Fri, Sep 14, 2018 at 10:47 PM Nathan Chancellor
> > <natechancellor@gmail.com> wrote:
> > >
> > > Clang warns that 'interleaving' is assigned to itself in this function.
> > >
> > > drivers/media/dvb-frontends/dib7000p.c:1874:15: warning: explicitly
> > > assigning value of variable of type 'int' to itself [-Wself-assign]
> > >         interleaving = interleaving;
> > >         ~~~~~~~~~~~~ ^ ~~~~~~~~~~~~
> > > 1 warning generated.
> > >
> > > It's correct. Just removing the self-assignment would sufficiently hide
> > > the warning but all of this code is dead because 'tmp' is zero due to
> > > being multiplied by zero. This doesn't appear to be an issue with
> > > dib8000, which this code was copied from in commit 041ad449683b
> > > ("[media] dib7000p: Add DVBv5 stats support").
> > >
> > > Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> > > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > > ---
> > >  drivers/media/dvb-frontends/dib7000p.c | 10 ++--------
> > >  1 file changed, 2 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
> > > index 58387860b62d..25843658fc68 100644
> > > --- a/drivers/media/dvb-frontends/dib7000p.c
> > > +++ b/drivers/media/dvb-frontends/dib7000p.c
> > > @@ -1800,9 +1800,8 @@ static u32 dib7000p_get_time_us(struct dvb_frontend *demod)
> >
> > Something looks wrong here (with this function).  The patch is no
> > functional change, since as you point out `interleaving` is
> > initialized to 0, then never updated before read, but I think there's
> > an underlying bug here that should be fixed differently.  Thanks for
> > the patch though, as it does raise the question.
> >
> > dib7000p_get_time_us has this comment above it:
> >
> >   1798 /* FIXME: may require changes - this one was borrowed from
> > dib8000 */
>
> The goal of dib7000p_get_time_us() is to estimate how much time it
> takes, with current tuning parameters, to have a certain number of
> DVB-T packets. This is used for block error count. That's said,
> on a quick look, it seems that the code is not right on many ways.
>
> It should be aligned with the amount of data it is required for
> dib7000 to update the block/bit error counters. There are two kinds
> of implementation:
>
> 1) the frontend has an internal counter that it is shifted and made
>    available to the driver after a certain amount of received data
>    (usually in the order of 10^5 to 10^7 bits);
>
> 2) the frontend has an internal timer that shifts the data from its
>    internal counter after a certain amount of time (usually at the
>    seconds range).
>
> Different vendors opt for either one of the strategy. Some updates
> a counter with the amount of bits taken. Unfortunately, this is not
> the case of those dib* frontends. So, the Kernel has to estimate
> it, based on the tuning parameters.
>
> From the code, it seems that, for block errors, it waits for 1,250,000
> bits to arrive (e. g. about 766 packets), so, it uses type (1) strategy:
>
>                 /* Estimate the number of packets based on bitrate */
>                 if (!time_us)
>                         time_us = dib7000p_get_time_us(demod);
>
>                 if (time_us) {
>                         blocks = 1250000ULL * 1000000ULL;       // the multiply here is to convert to microsseconds...
>                         do_div(blocks, time_us * 8 * 204);      // As here it divides by the time in microsseconds
>                         c->block_count.stat[0].scale = FE_SCALE_COUNTER;
>                         c->block_count.stat[0].uvalue += blocks;
>                 }
>
> For BER, the logic assumes that the bit error count should be divided
> by 10^-8:
>
>                 c->post_bit_count.stat[0].uvalue += 100000000;
>
> and the counter is updated every second. So, it uses (2).
>
> >
> > Wondering if it has the same bug, it seems it does not:
> > drivers/media/dvb-frontends/dib8000.c#dib8000_get_time_us():3986
> >
> > dib8000_get_time_us() seems to loop over multiple layers, and then
> > assigns interleaving to the final layers interleaving (that looks like
> > loop invariant code to me).
> >
> > Mauro, should dib7000p_get_time_us() use c->layer[???].interleaving?
>
> I don't think that time interleaving would affect the bit rate.
> I suspect that the dead code on dib8000 is just a dead code.
>
> > I don't see a single reference to `layer` in
> > drivers/media/dvb-frontends/dib7000p.c.
>
> Layers are specific for ISDB-T, but I think DVB-T (or at least DVB-T2)
> may use time interleaving.
>
> Yet, as I said, the goal is to estimate the streaming bit rate.
>
> I don't remember anymore from where the dib8000 formula came.
>
> My guts tell that time interleaving shouldn't do much changes (if any)
> to the bit rate. I suspect that removing the dead code is likely
> OK, but I'll try to see if I can find something related to where this
> formula came.

Thanks for the detailed feedback.  If you find no other references,
then I assume this version of the patch is good to go.

>
> >
> > >  {
> > >         struct dtv_frontend_properties *c = &demod->dtv_property_cache;
> > >         u64 time_us, tmp64;
> > > -       u32 tmp, denom;
> > > -       int guard, rate_num, rate_denum = 1, bits_per_symbol;
> > > -       int interleaving = 0, fft_div;
> > > +       u32 denom;
> > > +       int guard, rate_num, rate_denum = 1, bits_per_symbol, fft_div;
> > >
> > >         switch (c->guard_interval) {
> > >         case GUARD_INTERVAL_1_4:
> > > @@ -1871,8 +1870,6 @@ static u32 dib7000p_get_time_us(struct dvb_frontend *demod)
> > >                 break;
> > >         }
> > >
> > > -       interleaving = interleaving;
> > > -
> > >         denom = bits_per_symbol * rate_num * fft_div * 384;
> > >
> > >         /* If calculus gets wrong, wait for 1s for the next stats */
> > > @@ -1887,9 +1884,6 @@ static u32 dib7000p_get_time_us(struct dvb_frontend *demod)
> > >         time_us += denom / 2;
> > >         do_div(time_us, denom);
> > >
> > > -       tmp = 1008 * 96 * interleaving;
> > > -       time_us += tmp + tmp / guard;
> > > -
> > >         return time_us;
> > >  }
> > >
> > > --
> > > 2.18.0
> > >
> >
> >
>
>
>
> Thanks,
> Mauro



-- 
Thanks,
~Nick Desaulniers
