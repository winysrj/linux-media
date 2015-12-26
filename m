Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:39596 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752928AbbLZWcy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Dec 2015 17:32:54 -0500
Date: Sat, 26 Dec 2015 23:32:51 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
cc: Julia Lawall <julia.lawall@lip6.fr>,
	Gilles Muller <Gilles.Muller@lip6.fr>,
	Nicolas Palix <nicolas.palix@imag.fr>,
	Michal Marek <mmarek@suse.com>, cocci@systeme.lip6.fr,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	netdev@vger.kernel.org, linux-i2c@vger.kernel.org,
	linux-spi@vger.kernel.org, dri-devel@lists.freedesktop.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] coccinelle: api: check for propagation of error from
 platform_get_irq
In-Reply-To: <567F141C.8010000@cogentembedded.com>
Message-ID: <alpine.DEB.2.02.1512262330430.2070@localhost6.localdomain6>
References: <1451157891-24881-1-git-send-email-Julia.Lawall@lip6.fr> <567EF188.7020203@cogentembedded.com> <alpine.DEB.2.02.1512262107340.2070@localhost6.localdomain6> <alpine.DEB.2.02.1512262123500.2070@localhost6.localdomain6> <567EF895.6080702@cogentembedded.com>
 <alpine.DEB.2.02.1512262156580.2070@localhost6.localdomain6> <567F141C.8010000@cogentembedded.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 27 Dec 2015, Sergei Shtylyov wrote:

> On 12/26/2015 11:58 PM, Julia Lawall wrote:
> 
> > The error return value of platform_get_irq seems to often get dropped.
> > 
> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> > 
> > ---
> > 
> > v2: Check for the direct return case also.  Added some mailing lists of
> > common offenders.
> > 
> > diff --git a/scripts/coccinelle/api/platform_get_irq_return.cocci
> > b/scripts/coccinelle/api/platform_get_irq_return.cocci
> > new file mode 100644
> > index 0000000..44680d0
> > --- /dev/null
> > +++ b/scripts/coccinelle/api/platform_get_irq_return.cocci
> > @@ -0,0 +1,58 @@
> > +/// Propagate the return value of platform_get_irq.
> > +//# Sometimes the return value of platform_get_irq is tested using <= 0,
> > but 0
> > +//# might not be an appropriate return value in an error case.
> > +///
> > +// Confidence: Moderate
> > +// Copyright: (C) 2015 Julia Lawall, Inria. GPLv2.
> > +// URL: http://coccinelle.lip6.fr/
> > +// Options: --no-includes --include-headers
> > +
> > +virtual context
> > +virtual org
> > +virtual report
> > +
> > +//
> > ----------------------------------------------------------------------------
> > +
> > +@r depends on context || org || report@
> > +constant C;
> > +statement S;
> > +expression e, ret;
> > +position j0, j1;
> > +@@
> > +
> > +* e@j0 = platform_get_irq(...);
> > +(
> > +if@j1 (...) {
> > +  ...
> > +  return -C;
> > +} else S
> > +|
> > +if@j1 (...) {
> > +  ...
> > +  ret = -C;
> > +  ...
> > +  return ret;
> > +} else S
> 
>    Well, this seems to also cover the (e <= 0) checks which do make same sense
> in the light of Linus considering IRQ0 invalid. So I'd be more specific about
> the checks here -- 0 should indeed be overridden with something if it's
> considered invalid.

That's what the limitations section says (lines with #).  This doesn't 
make any changes, it only makes warnings, which should include the 
limitations information, so perhaps people can consider what it is that 
they really intend to do.

If you think this is not a good idea, then I can make the test more 
specific.

julia
