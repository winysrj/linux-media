Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:41379 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbZBPXLE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 18:11:04 -0500
Subject: Re: [linux-dvb] [BUG] changeset 9029
 (http://linuxtv.org/hg/v4l-dvb/rev/aa3e5cc1d833)
From: Andy Walls <awalls@radix.net>
To: Steven Toth <stoth@linuxtv.org>
Cc: linux-media@vger.kernel.org, Trent Piepho <xyzzy@speakeasy.org>,
	e9hack <e9hack@googlemail.com>, linux-dvb@linuxtv.org
In-Reply-To: <4999BB40.3040101@linuxtv.org>
References: <4986507C.1050609@googlemail.com>
	 <200902151336.17202@orion.escape-edv.de>
	 <Pine.LNX.4.58.0902160811340.24268@shell2.speakeasy.net>
	 <20090216153148.6f2aa408@pedra.chehab.org> <4999BADF.6070106@linuxtv.org>
	 <4999BB40.3040101@linuxtv.org>
Content-Type: text/plain
Date: Mon, 16 Feb 2009 18:11:48 -0500
Message-Id: <1234825908.3091.3.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-02-16 at 14:15 -0500, Steven Toth wrote:
> Steven Toth wrote:
> >> Hartmut, Oliver and Trent: Thanks for helping with this issue. I've just
> >> reverted the changeset. We still need a fix at dm1105, au0828-dvb and 
> >> maybe
> >> other drivers that call the filtering routines inside IRQ's.
> > 
> > Fix the demux, add a worker thread and allow drivers to call it directly.
> > 
> > I'm not a big fan of videobuf_dvb or having each driver do it's own 
> > thing as an alternative.
> > 
> > Fixing the demux... Would this require and extra buffer copy? probably, 
> > but it's a trade-off between  the amount of spent during code management 
> > on a driver by driver basis vs wrestling with videobuf_dvb and all of 
> > problems highlighted on the ML over the last 2 years.
> > 
> > demux->register_driver()
> > demux->deliver_payload()
> > demux->unregister_driver()
> > 
> > Then deprecate sw_filter....N() methods.
> > 
> > That would simplify drivers significantly, at the expense of another 
> > buffer copy while deliver-payload() clones the buffer into its internal 
> > state to be more timely.
> 
> I meant to add...
> 
> The cx18 and a few other smaller drivers (flexcop?) dvb drivers also call 
> directly. cx23885/cx88 does not.

cx18 calls it from it's own worker thread.  To keep up with the rate at
which the CX23418 firmware hands over buffers (and times out the cpu2epu
mailbox!) during a dual analog DTV capture, there's no avoiding having a
worker thread in the cx18 driver.

Regards,
Andy


