Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42905 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754036AbZBQAl7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 19:41:59 -0500
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [BUG] changeset 9029 (http://linuxtv.org/hg/v4l-dvb/rev/aa3e5cc1d833)
Date: Tue, 17 Feb 2009 01:40:52 +0100
Cc: linux-media@vger.kernel.org, e9hack <e9hack@googlemail.com>,
	obi@linuxtv.org, Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-dvb@linuxtv.org
References: <4986507C.1050609@googlemail.com> <200902151336.17202@orion.escape-edv.de> <Pine.LNX.4.58.0902160811340.24268@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0902160811340.24268@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902170140.53617@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Trent Piepho wrote:
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

Agreed, this would be the best solution.

On the other hand, a workqueue handler would be scheduled later, so you
need larger buffers in the driver. Some chipsets have very small
buffers...

Anway, this would be a major change. All drivers must be carefully
modified and tested for an extended period.

Meanwhile I had a look at the changeset, and I do not understand why
spin_lock_irq... should be required everywhere.

Afaics a driver may safely call dvb_dmx_swfilter_packets,
dvb_dmx_swfilter_204 or dvb_dmx_swfilter from process context, tasklet
or interrupt handler 'as is'.

@Andreas:
Could you please explain in more detail what bad things might happen?

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------
