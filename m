Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:50521 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbZBRJP7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 04:15:59 -0500
Date: Wed, 18 Feb 2009 01:15:57 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Andreas Oberritter <obi@linuxtv.org>
cc: linux-media@vger.kernel.org, e9hack <e9hack@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-dvb@linuxtv.org
Subject: Re: [BUG] changeset 9029 (http://linuxtv.org/hg/v4l-dvb/rev/aa3e5cc1d833)
In-Reply-To: <499A36CD.4070209@linuxtv.org>
Message-ID: <Pine.LNX.4.58.0902180044380.24268@shell2.speakeasy.net>
References: <4986507C.1050609@googlemail.com> <200902151336.17202@orion.escape-edv.de>
 <Pine.LNX.4.58.0902160811340.24268@shell2.speakeasy.net>
 <200902170140.53617@orion.escape-edv.de> <499A36CD.4070209@linuxtv.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 17 Feb 2009, Andreas Oberritter wrote:
> Oliver Endriss wrote:
> > Trent Piepho wrote:
> >> I agree, this is bad.  The demuxer is far too much work to be done with
> >> IRQs off.  IMHO, even doing it under a spin-lock is excessive.  It should
> >> be a mutex.  Drivers should use a work-queue to feed the demuxer.
> >
> > Agreed, this would be the best solution.
> >
> > On the other hand, a workqueue handler would be scheduled later, so you
> > need larger buffers in the driver. Some chipsets have very small
> > buffers...
> >
> > Anway, this would be a major change. All drivers must be carefully
> > modified and tested for an extended period.

Don't most drivers already feed the demuxer from process context and not
the irq handler?  What drivers _do_ have a problem?  I see pluto2 is one.
Anyone have documentation for this chip?

> So, if the assumtions above are correct, then spin_lock_irq must be
> used by all functions called from process context and
> spin_lock_irqsave must be used by all functions called from an unknown
> context.

I agree, to be correct that's what's necessary.  Some drivers call the
demuxer functions from interrupt context, so we have to use the irq
disabling functions everywhere.

But disabling irqs for demuxing causes too much latency.  The proper fix is
to not call the demuxer from interrupt context.
