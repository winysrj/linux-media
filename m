Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43568 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731088AbeHNLe0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 07:34:26 -0400
Date: Tue, 14 Aug 2018 11:48:13 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Helmut Grohne <h.grohne@intenta.de>, linux-media@vger.kernel.org
Subject: Re: why does aptina_pll_calculate insist on exact division?
Message-ID: <20180814084813.posuz5slutpjiod5@valkosipuli.retiisi.org.uk>
References: <20180814063538.qxgg6ua5z7ta6pwp@laureti-dev>
 <3810765.IzfK4ck8Uo@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3810765.IzfK4ck8Uo@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tue, Aug 14, 2018 at 10:30:14AM +0300, Laurent Pinchart wrote:
> Hi Helmut,
> 
> (CC'ing Sakari Ailus who is our current PLL expert after spending so much time 
> on the SMIA PLL code)
> 
> On Tuesday, 14 August 2018 09:35:40 EEST Helmut Grohne wrote:
> > Hi,
> > 
> > I tried using the aptina_pll_calculate for a "new" imager and ran into
> > problems. After filling out aptina_pll_limits from the data sheet, I was
> > having a hard time finding a valid pix_clock. Most of the ones I tried
> > are rejected by aptina_pll_calculate for various reasons. In particular,
> > no pix_clock close to pix_clock_max is allowed.

On many systems where such sensors are being used, you generally need to
use known-good link frequencies that have no EMI issues. Therefore the PLL
calculator uses this input, as well as the bits per pixel etc. platform
specific inputs and hardware limits to come up with the pixel rate. At
least for smiapp PLL calculator this is the highest possible rate, taking
the constraints into account.

> 
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
> 
> > Why does the calculation method insist on exact division and avoiding
> > fractional numbers?
> 
> I'm not sure what you mean by avoiding fractional numbers. Could you please 
> elaborate ? Please keep in mind that I last touched the code 6 years, so my 
> memory isn't exactly fresh.
> 
> If you mean using floating point operations to calculate PLL parameters, 
> remember that the code runs in the Linux kernel, where floating point isn't 
> allowed. You would thus have to implement the algorithm using fixed-point 
> calculation.
> 
> > I'm using an ext_clock of 50 MHz. This clock is derived from a 33 MHz
> > clock and the 50 MHz is not attained exactly. Rather it ends up being
> > more like 49.999976 Hz. This raises the question, what value I should
> > put into ext_clock (or the corresponding device tree property). Should I
> > use the requested frequency or the actual frequency?
> 
> There's no such thing as an exact frequency anyway, as it's a physical value. 
> I'd got for 50 MHz for simplicity.
> 
> > Worse, depending on the precise value of the ext_clock, aptina_pll_calculate
> > may or may not be able to compute pll parameters.
> > 
> > On the other hand, the manufacturer provided configuration tool happily
> > computes pll parameters that result in close, but not exactly, the
> > requested pix_clock. In particular, the pll parameters do not
> > necessarily result in a whole number. It appears to merely approximate
> > the requested frequency.
> 
> aptina_pll_calculate() also approximates the requested frequency, but as it 
> appears from your test, fails in some cases. That's certainly an issue in the 
> code and should be fixed. Feel free to convince the manufacturer to release 
> their PLL parameters computation code under the GPL ;-)
> 
> > Can you explain where the requirement to avoid fractional numbers comes
> > from? Would it be reasonable to use a different algorithm that avoids
> > this requirement?
> 
> Again, please elaborate on what you mean by avoiding fractional numbers. I 
> would certainly be open to a different algorithm (or possibly fixes to the 
> existing code), as long as it fulfills the requirements behind the current 
> implementation. In particular the code should compute the optimum PLL 
> parameters when multiple options are possible, and its complexity should be 
> lower than O(n^2) (ideally O(1), if not possible O(n)).
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> 
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
