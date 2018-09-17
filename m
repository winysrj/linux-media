Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43989 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726795AbeIQX1K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 19:27:10 -0400
Received: by mail-pl1-f193.google.com with SMTP id 38-v6so2067368plc.10
        for <linux-media@vger.kernel.org>; Mon, 17 Sep 2018 10:58:44 -0700 (PDT)
MIME-Version: 1.0
References: <20180915054739.14117-1-natechancellor@gmail.com>
In-Reply-To: <20180915054739.14117-1-natechancellor@gmail.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 17 Sep 2018 10:58:32 -0700
Message-ID: <CAKwvOdmQ4pbbPuvYrVYB9myD8ap36h6nLjEdL-mSbYjM37UJ_g@mail.gmail.com>
Subject: Re: [PATCH] [media] dib7000p: Remove dead code
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 14, 2018 at 10:47 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Clang warns that 'interleaving' is assigned to itself in this function.
>
> drivers/media/dvb-frontends/dib7000p.c:1874:15: warning: explicitly
> assigning value of variable of type 'int' to itself [-Wself-assign]
>         interleaving = interleaving;
>         ~~~~~~~~~~~~ ^ ~~~~~~~~~~~~
> 1 warning generated.
>
> It's correct. Just removing the self-assignment would sufficiently hide
> the warning but all of this code is dead because 'tmp' is zero due to
> being multiplied by zero. This doesn't appear to be an issue with
> dib8000, which this code was copied from in commit 041ad449683b
> ("[media] dib7000p: Add DVBv5 stats support").
>
> Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  drivers/media/dvb-frontends/dib7000p.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
> index 58387860b62d..25843658fc68 100644
> --- a/drivers/media/dvb-frontends/dib7000p.c
> +++ b/drivers/media/dvb-frontends/dib7000p.c
> @@ -1800,9 +1800,8 @@ static u32 dib7000p_get_time_us(struct dvb_frontend *demod)

Something looks wrong here (with this function).  The patch is no
functional change, since as you point out `interleaving` is
initialized to 0, then never updated before read, but I think there's
an underlying bug here that should be fixed differently.  Thanks for
the patch though, as it does raise the question.

dib7000p_get_time_us has this comment above it:

  1798 /* FIXME: may require changes - this one was borrowed from
dib8000 */

Wondering if it has the same bug, it seems it does not:
drivers/media/dvb-frontends/dib8000.c#dib8000_get_time_us():3986

dib8000_get_time_us() seems to loop over multiple layers, and then
assigns interleaving to the final layers interleaving (that looks like
loop invariant code to me).

Mauro, should dib7000p_get_time_us() use c->layer[???].interleaving?
I don't see a single reference to `layer` in
drivers/media/dvb-frontends/dib7000p.c.

>  {
>         struct dtv_frontend_properties *c = &demod->dtv_property_cache;
>         u64 time_us, tmp64;
> -       u32 tmp, denom;
> -       int guard, rate_num, rate_denum = 1, bits_per_symbol;
> -       int interleaving = 0, fft_div;
> +       u32 denom;
> +       int guard, rate_num, rate_denum = 1, bits_per_symbol, fft_div;
>
>         switch (c->guard_interval) {
>         case GUARD_INTERVAL_1_4:
> @@ -1871,8 +1870,6 @@ static u32 dib7000p_get_time_us(struct dvb_frontend *demod)
>                 break;
>         }
>
> -       interleaving = interleaving;
> -
>         denom = bits_per_symbol * rate_num * fft_div * 384;
>
>         /* If calculus gets wrong, wait for 1s for the next stats */
> @@ -1887,9 +1884,6 @@ static u32 dib7000p_get_time_us(struct dvb_frontend *demod)
>         time_us += denom / 2;
>         do_div(time_us, denom);
>
> -       tmp = 1008 * 96 * interleaving;
> -       time_us += tmp + tmp / guard;
> -
>         return time_us;
>  }
>
> --
> 2.18.0
>


-- 
Thanks,
~Nick Desaulniers
