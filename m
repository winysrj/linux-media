Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49559 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbaKPKZX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Nov 2014 05:25:23 -0500
Date: Sun, 16 Nov 2014 08:25:18 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/8] rtl2832: implement PIP mode
Message-ID: <20141116082518.2144d9af@recife.lan>
In-Reply-To: <54669210.1070101@iki.fi>
References: <1415766190-24482-1-git-send-email-crope@iki.fi>
	<1415766190-24482-3-git-send-email-crope@iki.fi>
	<20141114173440.427324a8@recife.lan>
	<54669210.1070101@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 15 Nov 2014 01:36:48 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> Moikka!
> 
> On 11/14/2014 09:34 PM, Mauro Carvalho Chehab wrote:
> > Em Wed, 12 Nov 2014 06:23:04 +0200
> > Antti Palosaari <crope@iki.fi> escreveu:
> >
> >> Implement PIP mode to stream from slave demodulator. PIP mode is
> >> enabled when .set_frontend is called with RF frequency 0, otherwise
> >> normal demod mode is enabled.
> >
> > This would be an API change, so, a DocBook patch is required.
> 
> You are wrong. PIP mode is driver/device internal thing and will not be 
> revealed to userspace.
> 
> > Anyway, using frequency=0 for PIP doesn't seem to be a good idea,
> > as a read from GET_PROPERTY should override the cache with the real
> > frequency.
> 
> Yes, it is a hackish solution, used to put demod#0 on certain config 
> when demod#1 is used. When PIP mode is set that demod#0 is totally 
> useless as demod#1 is in use instead. Cache is garbage and no meaning at 
> all.
> 
> > Also, someone came with me with a case where auto-frequency would
> > be interesting, and proposed frequency=0. I was not convinced
> > (and patches weren't sent), but using 0 for AUTO seems more
> > appropriate, as we do the same for bandwidth (and may do the same
> > for symbol_rate).
> 
> I totally agree that is is hackish solution. That is called from 
> rtl28xxu.c driver and I added already comment it is hackish solution, 
> but you didn't apply that commit.
> 
> > So, the best seems to add a new property to enable PIP mode.
> 
> No, no, no. It is like a PIP filter. It is actually special case of PID 
> filter, having mux, to multiplex 2 TS interfaces to one (PIP = Picture 
> in Picture).
> 
> 
> .............................................
> . RTL2832P integrates RTL2832 demodulator   .
> . ____________                ____________  .              ____________
> .|   USB IF   |              |   demod    | .             |   demod    |
> .|------------|              |------------| .             |------------|
> .|  RTL2832P  |              |  RTL2832   | .             |  MN88472   |
> .|            |----TS bus----|-----/ -----|-.---TS bus----|            |
> .|____________|              |____________| .             |____________|
> .............................................
> 
> 
> So the basically both demod PID filters are now implemented in RTL2832 
> demod. Currently PIP mode is configured just to pass all the PIDs from 
> MN88472 and reject RTL2832 PIDs. And when PIP mode is off, at pass all 
> the PIDs from RTL2832, but rejects all PIDs from MN88472.

Oh, I see.

What demod(s) are exposed to userspace? both or just demod#1?

If both are exposed, how userspace knows that demod#0 should not be
used?

Regards,
Mauro
