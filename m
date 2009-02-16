Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50525 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbZBPScT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 13:32:19 -0500
Date: Mon, 16 Feb 2009 15:31:48 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Trent Piepho <xyzzy@speakeasy.org>, e9hack <e9hack@googlemail.com>,
	linux-dvb@linuxtv.org
Cc: linux-media@vger.kernel.org, obi@linuxtv.org
Subject: Re: [BUG] changeset 9029
 (http://linuxtv.org/hg/v4l-dvb/rev/aa3e5cc1d833)
Message-ID: <20090216153148.6f2aa408@pedra.chehab.org>
In-Reply-To: <Pine.LNX.4.58.0902160811340.24268@shell2.speakeasy.net>
References: <4986507C.1050609@googlemail.com>
	<200902151336.17202@orion.escape-edv.de>
	<Pine.LNX.4.58.0902160811340.24268@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 16 Feb 2009 08:19:06 -0800 (PST)
Trent Piepho <xyzzy@speakeasy.org> wrote:

> On Sun, 15 Feb 2009, Oliver Endriss wrote:
> > e9hack wrote:
> > > this change set is wrong. The affected functions cannot be called from an interrupt
> > > context, because they may process large buffers. In this case, interrupts are disabled for
> > > a long time. Functions, like dvb_dmx_swfilter_packets(), could be called only from a
> > > tasklet. This change set does hide some strong design bugs in dm1105.c and au0828-dvb.c.
> > >
> > > Please revert this change set and do fix the bugs in dm1105.c and au0828-dvb.c (and other
> > > files).
> >
> > @Mauro:
> >
> > This changeset _must_ be reverted! It breaks all kernels since 2.6.27
> > for applications which use DVB and require a low interrupt latency.
> >
> > It is a very bad idea to call the demuxer to process data buffers with
> > interrupts disabled!
> 
> I agree, this is bad.  The demuxer is far too much work to be done with
> IRQs off.  IMHO, even doing it under a spin-lock is excessive.  It should
> be a mutex.  Drivers should use a work-queue to feed the demuxer.

Hartmut, Oliver and Trent: Thanks for helping with this issue. I've just
reverted the changeset. We still need a fix at dm1105, au0828-dvb and maybe
other drivers that call the filtering routines inside IRQ's.


Cheers,
Mauro
