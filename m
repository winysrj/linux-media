Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.intenta.de ([178.249.25.132]:36004 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727689AbeHNL0j (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 07:26:39 -0400
Date: Tue, 14 Aug 2018 10:40:26 +0200
From: Helmut Grohne <helmut.grohne@intenta.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@iki.fi" <sakari.ailus@iki.fi>
Subject: Re: why does aptina_pll_calculate insist on exact division?
Message-ID: <20180814084026.be4fpbhrppdnx2a3@laureti-dev>
References: <20180814063538.qxgg6ua5z7ta6pwp@laureti-dev>
 <3810765.IzfK4ck8Uo@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3810765.IzfK4ck8Uo@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thank you for the quick and helpful answer.

On Tue, Aug 14, 2018 at 09:30:14AM +0200, Laurent Pinchart wrote:
> How do you mean ? The only place where pix_clock_max is used is in the 
> following code:
> 
>         if (pll->pix_clock == 0 || pll->pix_clock > limits->pix_clock_max) {
>                 dev_err(dev, "pll: invalid pixel clock frequency.\n");
>                 return -EINVAL;
>         }
> 
> aptina_pll_calculate() rejects a request pixel clock value higher than the 
> pixel clock frequency higher limit, which is also given by the caller. That 
> shouldn't happen, it would be a bug in the caller.

Of course, I am trying values lower than pix_clock_max. For a number of
imagers, that pix_clock_max is 74.25 MHz. It seems that any pix_clock of
at least 72 MHz is rejected here.

> I'm not sure what you mean by avoiding fractional numbers. Could you please 
> elaborate ? Please keep in mind that I last touched the code 6 years, so my 
> memory isn't exactly fresh.

The first thing the code does is computing the gcd of pix_clock and
ext_clock. Immediately, it conludes that m must be a multiple of
pix_clock / gcd(pix_clock, ext_clock). Varying either clock value
slightly causes large jumps in the computed gcd value (in particular, it
will be 1 whenever either clock happens to be a prime number).

> If you mean using floating point operations to calculate PLL parameters, 
> remember that the code runs in the Linux kernel, where floating point isn't 
> allowed. You would thus have to implement the algorithm using fixed-point 
> calculation.

I'm not after using floating points. In a sense, we are already
fixed-point calculation and the precision is 1 Hz. Rounding errors in
that range look ok to me.

> There's no such thing as an exact frequency anyway, as it's a physical value. 
> I'd got for 50 MHz for simplicity.

That's exactly my point. The exact value should not matter. However, for
the present aptina_pll_calculate, the exact value matters a lot. Were
you to use 49999991 Hz as ext_clock (which happens to be prime, but
reasonably close), aptina_pll_calculate fails entirely as m is deemed to
be a multiple of the pix_clock in Hz. No imager allows for such large m
values and thus aptina_pll_calculate rejects any such configuration with
-EINVAL.

I'm arguing that rather than failing to compute pll parameters, it
should compromise on exactness. Presently, aptina_pll_calculate ensures
that whenever it is successful, the assertion pix_clock = ext_clock / n
* m / p1 holds exactly and all intermediate values are whole numbers.
I'm arguing that having it hold exactly reduces utility of
aptina_pll_calculate, because frequencies are not exact in the real
world. There is no need to have whole numbered frequencies.

> aptina_pll_calculate() also approximates the requested frequency, but as it 
> appears from your test, fails in some cases. That's certainly an issue in the 
> code and should be fixed. Feel free to convince the manufacturer to release 
> their PLL parameters computation code under the GPL ;-)

We both know that the exercise of extracting code from manufacturers is
futile.

However you appear to imply that aptina_pll_calculate should approximate
the requested frequency. That's not what it does today. That's a useful
answer to me already and I'll be looking into doing the work of coming
up with an alternative lifting the requirement.

> Again, please elaborate on what you mean by avoiding fractional numbers. I 
> would certainly be open to a different algorithm (or possibly fixes to the 
> existing code), as long as it fulfills the requirements behind the current 
> implementation. In particular the code should compute the optimum PLL 
> parameters when multiple options are possible, and its complexity should be 
> lower than O(n^2) (ideally O(1), if not possible O(n)).

Beware though that discussing complexities requires more precision as to
what "n" means here. The code interprets it as n = p1_max - p1_min (not
accounting for the gcd computation), which is not the usual
interpretation. What you really want is that it completes in a
reasonable amount of time on slow, embedded devices for any input.

Once you lift the exactness requirement, you optimize multiple aspects
simultaneously. The present code maximizes P1, but we also want to
minimize the difference between the requested pix_clock and the
resulting pix_clock. There has to be some kind of trade-off here. The
trade-off chosen by the present code is to always have that difference
be 0. Once non-zero differences are allowed, optimum is no longer
well-defined.

So could you go into more detail as to what "optimum PLL parameters"
mean to you?

Helmut
