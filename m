Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47130 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbZBJGQM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 01:16:12 -0500
Date: Tue, 10 Feb 2009 04:15:12 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: CityK <cityk@rogers.com>, V4L <video4linux-list@redhat.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Borke <joshborke@gmail.com>, David Lonie <loniedavid@gmail.com>,
	David Engel <david@istwok.net>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
Message-ID: <20090210041512.6d684be3@pedra.chehab.org>
In-Reply-To: <1234237395.2682.22.camel@pc10.localdom.local>
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl>
	<496FE555.7090405@rogers.com>
	<496FFCE2.8010902@rogers.com>
	<200901171720.03890.hverkuil@xs4all.nl>
	<49737088.7060800@rogers.com>
	<20090202235820.GA9781@opus.istwok.net>
	<4987DE4E.2090902@rogers.com>
	<20090209004343.5533e7c4@caramujo.chehab.org>
	<1234226235.2790.27.camel@pc10.localdom.local>
	<1234227277.3932.4.camel@pc10.localdom.local>
	<1234229460.3932.27.camel@pc10.localdom.local>
	<20090210003520.14426415@pedra.chehab.org>
	<1234235643.2682.16.camel@pc10.localdom.local>
	<1234237395.2682.22.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 10 Feb 2009 04:43:15 +0100
hermann pitton <hermann-pitton@arcor.de> wrote:

> 
> Am Dienstag, den 10.02.2009, 04:14 +0100 schrieb hermann pitton:
> > Am Dienstag, den 10.02.2009, 00:35 -0200 schrieb Mauro Carvalho Chehab:
> > > On Tue, 10 Feb 2009 02:31:00 +0100
> > > hermann pitton <hermann-pitton@arcor.de> wrote:
> 
> > > > > 
> > > > > BTW, just to remember.
> > > > > 
> > > > > Tvtime with signal detection on shows a blue screen without signal.
> > > > > With signal detection off, just good old snow.
> > > 
> > > So, the tda9887 or the PLL are configured wrongly.
> > > 
> 
> Urgh, not to add more confusion here at least.
> 
> Good old snow means the analog signal is perfect.
> 
> I stopped since long to connect a real signal to it surfing the grounds
> on my stomach, but it is for sure working then and the pll is always
> fine.

Ah, ok. So, now, we just need CityK (or someone else with ATSC 115) to confirm
that everything is fine on their side. This patch may also fix other similar
troubles on a few devices that seem to need some i2c magic before probing the
tuner.

Cheers,
Mauro
