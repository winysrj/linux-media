Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:50046 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729459AbeHNKPW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 06:15:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Helmut Grohne <h.grohne@intenta.de>
Cc: linux-media@vger.kernel.org, sakari.ailus@iki.fi
Subject: Re: why does aptina_pll_calculate insist on exact division?
Date: Tue, 14 Aug 2018 10:30:14 +0300
Message-ID: <3810765.IzfK4ck8Uo@avalon>
In-Reply-To: <20180814063538.qxgg6ua5z7ta6pwp@laureti-dev>
References: <20180814063538.qxgg6ua5z7ta6pwp@laureti-dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helmut,

(CC'ing Sakari Ailus who is our current PLL expert after spending so much time 
on the SMIA PLL code)

On Tuesday, 14 August 2018 09:35:40 EEST Helmut Grohne wrote:
> Hi,
> 
> I tried using the aptina_pll_calculate for a "new" imager and ran into
> problems. After filling out aptina_pll_limits from the data sheet, I was
> having a hard time finding a valid pix_clock. Most of the ones I tried
> are rejected by aptina_pll_calculate for various reasons. In particular,
> no pix_clock close to pix_clock_max is allowed.

How do you mean ? The only place where pix_clock_max is used is in the 
following code:

        if (pll->pix_clock == 0 || pll->pix_clock > limits->pix_clock_max) {
                dev_err(dev, "pll: invalid pixel clock frequency.\n");
                return -EINVAL;
        }

aptina_pll_calculate() rejects a request pixel clock value higher than the 
pixel clock frequency higher limit, which is also given by the caller. That 
shouldn't happen, it would be a bug in the caller.

> Why does the calculation method insist on exact division and avoiding
> fractional numbers?

I'm not sure what you mean by avoiding fractional numbers. Could you please 
elaborate ? Please keep in mind that I last touched the code 6 years, so my 
memory isn't exactly fresh.

If you mean using floating point operations to calculate PLL parameters, 
remember that the code runs in the Linux kernel, where floating point isn't 
allowed. You would thus have to implement the algorithm using fixed-point 
calculation.

> I'm using an ext_clock of 50 MHz. This clock is derived from a 33 MHz
> clock and the 50 MHz is not attained exactly. Rather it ends up being
> more like 49.999976 Hz. This raises the question, what value I should
> put into ext_clock (or the corresponding device tree property). Should I
> use the requested frequency or the actual frequency?

There's no such thing as an exact frequency anyway, as it's a physical value. 
I'd got for 50 MHz for simplicity.

> Worse, depending on the precise value of the ext_clock, aptina_pll_calculate
> may or may not be able to compute pll parameters.
> 
> On the other hand, the manufacturer provided configuration tool happily
> computes pll parameters that result in close, but not exactly, the
> requested pix_clock. In particular, the pll parameters do not
> necessarily result in a whole number. It appears to merely approximate
> the requested frequency.

aptina_pll_calculate() also approximates the requested frequency, but as it 
appears from your test, fails in some cases. That's certainly an issue in the 
code and should be fixed. Feel free to convince the manufacturer to release 
their PLL parameters computation code under the GPL ;-)

> Can you explain where the requirement to avoid fractional numbers comes
> from? Would it be reasonable to use a different algorithm that avoids
> this requirement?

Again, please elaborate on what you mean by avoiding fractional numbers. I 
would certainly be open to a different algorithm (or possibly fixes to the 
existing code), as long as it fulfills the requirements behind the current 
implementation. In particular the code should compute the optimum PLL 
parameters when multiple options are possible, and its complexity should be 
lower than O(n^2) (ideally O(1), if not possible O(n)).

-- 
Regards,

Laurent Pinchart
