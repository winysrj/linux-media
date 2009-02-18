Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:57511 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbZBRUpL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 15:45:11 -0500
Date: Wed, 18 Feb 2009 12:45:09 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Steven Toth <stoth@linuxtv.org>
cc: linux-media@vger.kernel.org, e9hack <e9hack@googlemail.com>,
	linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [BUG] changeset 9029 (http://linuxtv.org/hg/v4l-dvb/rev/aa3e5cc1d833)
In-Reply-To: <499C2439.5040102@linuxtv.org>
Message-ID: <Pine.LNX.4.58.0902181225170.24268@shell2.speakeasy.net>
References: <4986507C.1050609@googlemail.com> <200902151336.17202@orion.escape-edv.de>
 <Pine.LNX.4.58.0902160811340.24268@shell2.speakeasy.net>
 <20090216153148.6f2aa408@pedra.chehab.org> <4999BADF.6070106@linuxtv.org>
 <Pine.LNX.4.58.0902161611300.24268@shell2.speakeasy.net> <499AD4E7.1030306@linuxtv.org>
 <Pine.LNX.4.58.0902171820320.24268@shell2.speakeasy.net> <499C2439.5040102@linuxtv.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 18 Feb 2009, Steven Toth wrote:
> Trent Piepho wrote:
> > On Tue, 17 Feb 2009, Steven Toth wrote:
> >> Trent Piepho wrote:
> >>> On Mon, 16 Feb 2009, Steven Toth wrote:
> >>>> Fixing the demux... Would this require and extra buffer copy? probably, but it's
> >>>> a trade-off between  the amount of spent during code management on a driver by
> >>>> driver basis vs wrestling with videobuf_dvb and all of problems highlighted on
> >>>> the ML over the last 2 years.
> >>> Have the driver copy the data into the demuxer from the interrupt handler
> >>> with irqs disabled?  That's still too much.
> >>>
> >>> The right way to do it is to have a queue of DMA buffers.  In the interrupt
> >>> handler the driver takes the completed DMA buffer off the "to DMA" queue
> >>> and puts it in the "to process" queue.  The driver should not copy and
> >>> cetainly not demux the data from the interrupt handler.
> >> I know what the right way is Trent (see cx23885) although thank you for
> >> reminding me. videobuf_dvb hasn't convinced people like me to bury myself in its
> >> mess or complexity during retro fits cases. Retro fitting videobuf_dvb into cx18
> >> (at the time) was way too much effort.
> >>
> >> Retro fitting it into existing drivers can be painful and I haven't seen any
> >> volunteers stand up over the last 24 months to get this done.
> >>
> >> My suggestion? For the most part we're talking about very low data rates for
> >> DVB, coupled with fast memory buses for memcpy's. If the group doesn't want
> >> calls to the sw_filter methods then implement a half-way-house replacement for
> >> those drivers - as I mentioned above - with the memcpy. Either this approach, or
> >
> > The problem is holding a spin lock with irqs disabled for a long amount of
> > time.  What exactly is your plan that will remove this, yet allow drivers
> > to process their buffers from an irq handler?
>
> That's not what I was suggesting. I was suggesting adding some ring buffer code
> and a worker thread for each driver context (done in a mythical demux->register
> func). This means that each driver get's it's own worker and ringbuffer. Driver

But won't this new ringbuffer be fed from interrupt context?  So instead of
feeding the demuxer from an irq, you are feeding the pre-demuxer ringbuffer
from an irq.  Isn't that going to have the same long term lock holding with
irqs disabled problem?

> >> A general question to the group: Who wants to volunteer to retro fit
> >> videobuf_dvb into the current drivers so we can avoid calls to sw_filter_...n()
> >> directly?
> >
> > I don't see why videobuf_dvb is needed.
>
> That was the point I was trying to make. IE. Push videobuf_dvb like behavior
> into the demux core, having drivers register, give each driver it's own worker
> thread and have that thread, running not in the interrupt context, feed the
> existing sw_filter_n() functions. The price is the cost of doing a memcpy of a

If you look at the pluto2 fix I did, the code to create a work queue is
very simple.  I don't think moving that to the demuxer would make the patch
to the driver much simpler.

The difficulty comes from not using a single buffer so the driver doesn't
need to hold a spin lock while it copies data out.
