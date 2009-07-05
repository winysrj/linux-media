Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:17182 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbZGEIfQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jul 2009 04:35:16 -0400
Date: Sun, 5 Jul 2009 10:35:13 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: LMML <linux-media@vger.kernel.org>,
	Andrzej Hajda <andrzej.hajda@wp.pl>
Subject: Re: [PATCH 1/2] Compatibility layer for hrtimer API
Message-ID: <20090705103513.7ad1abc6@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.58.0907050131220.6411@shell2.speakeasy.net>
References: <20090703224652.339a63e7@hyperion.delvare>
	<Pine.LNX.4.58.0907050109420.6411@shell2.speakeasy.net>
	<20090705102720.07e08c3b@hyperion.delvare>
	<Pine.LNX.4.58.0907050131220.6411@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 5 Jul 2009 01:32:42 -0700 (PDT), Trent Piepho wrote:
> On Sun, 5 Jul 2009, Jean Delvare wrote:
> 
> > Hi Trent,
> >
> > On Sun, 5 Jul 2009 01:13:14 -0700 (PDT), Trent Piepho wrote:
> > > On Fri, 3 Jul 2009, Jean Delvare wrote:
> > > > Kernels 2.6.22 to 2.6.24 (inclusive) need some compatibility quirks
> > > > for the hrtimer API. For older kernels, some required functions were
> > > > not exported so there's nothing we can do. This means that drivers
> > > > using the hrtimer infrastructure will no longer work for kernels older
> > > > than 2.6.22.
> > > >
> > > > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > > > ---
> > > >  v4l/compat.h |   18 ++++++++++++++++++
> > > >  1 file changed, 18 insertions(+)
> > > >
> > > > --- a/v4l/compat.h
> > > > +++ b/v4l/compat.h
> > > > @@ -480,4 +480,22 @@ static inline unsigned long v4l_compat_f
> > > >  }
> > > >  #endif
> > > >
> > > > +/*
> > > > + * Compatibility code for hrtimer API
> > > > + * This will make hrtimer usable for kernels 2.6.22 and later.
> > > > + * For earlier kernels, not all required functions are exported
> > > > + * so there's nothing we can do.
> > > > + */
> > > > +
> > > > +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 25) && \
> > > > +	LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 22)
> > > > +#include <linux/hrtimer.h>
> > >
> > > Instead of including hrtimer.h from compat.h it's better if you check if it
> > > has already been included and only enable the compat code in that case.
> > > That way hrtimer doesn't get included for files that don't need it and
> > > might define something that conflicts with something from hrtimer.  And it
> > > prevents someone from forgetting to include hrtimer when they needed it,
> > > but having the error masked because compat.h is doing it for them.
> >
> > I see. But this will only work if compat.h is included after all
> > headers. If it always the case? I see for example that cx88-input
> > includes <media/ir-common.h> after "compat.h".
> 
> Headers that come from the kernel come before compat.h and headers that
> come from the v4l-dvb tree come after compat.h.

Ah, OK. I'll send an updated patch as soon as I am done with testing it.

Thanks,
-- 
Jean Delvare
