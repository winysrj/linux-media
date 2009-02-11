Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:56750 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753480AbZBKEeB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 23:34:01 -0500
Subject: Re: KWorld ATSC 115 all static
From: hermann pitton <hermann-pitton@arcor.de>
To: David Engel <david@istwok.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Isom <jeisom@gmail.com>,
	V4L <video4linux-list@redhat.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Borke <joshborke@gmail.com>, David Lonie <loniedavid@gmail.com>,
	CityK <cityk@rogers.com>, linux-media@vger.kernel.org
In-Reply-To: <20090211035016.GA3258@opus.istwok.net>
References: <20090209004343.5533e7c4@caramujo.chehab.org>
	 <1234226235.2790.27.camel@pc10.localdom.local>
	 <1234227277.3932.4.camel@pc10.localdom.local>
	 <1234229460.3932.27.camel@pc10.localdom.local>
	 <20090210003520.14426415@pedra.chehab.org>
	 <1234235643.2682.16.camel@pc10.localdom.local>
	 <1234237395.2682.22.camel@pc10.localdom.local>
	 <20090210041512.6d684be3@pedra.chehab.org>
	 <1767e6740902100407t6737d9f4j5d9edefef8801e27@mail.gmail.com>
	 <20090210102732.5421a296@pedra.chehab.org>
	 <20090211035016.GA3258@opus.istwok.net>
Content-Type: text/plain
Date: Wed, 11 Feb 2009 05:34:39 +0100
Message-Id: <1234326879.2684.10.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Dienstag, den 10.02.2009, 21:50 -0600 schrieb David Engel:
> On Tue, Feb 10, 2009 at 10:27:32AM -0200, Mauro Carvalho Chehab wrote:
> > On Tue, 10 Feb 2009 06:07:51 -0600
> > Jonathan Isom <jeisom@gmail.com> wrote:
> > > On Tue, Feb 10, 2009 at 12:15 AM, Mauro Carvalho Chehab
> > > > Ah, ok. So, now, we just need CityK (or someone else with ATSC 115) to confirm
> > > > that everything is fine on their side. This patch may also fix other similar
> > > > troubles on a few devices that seem to need some i2c magic before probing the
> > > > tuner.
> > > 
> > > Just tried the latest hg and I can confirm that both an ATSC 110 and
> > > 115 work with tvtime
> > > and ATSC.
> > > 
> > Jonathan,
> > 
> > You tried the latest tree at http://linuxtv.org/hg/v4l-dvb or my saa7134 tree
> > (http://linuxtv.org/hg/~mchehab/saa7134)?
> > 
> > In the first case, could you please confirm that it works fine also with the saa7134 tree?
> 
> I tried both trees with my ATSC 115.  
> 
> The v4l-dvb did not work.  tvtime showed only a blue screen,
> presumably due to lack of a signal.  The last commit in the tree was
> as follows:
> 
>     changeset:   10503:9cb19f080660
>     tag:         tip
>     parent:      10495:d76f0c9b75fd
>     parent:      10502:b1d0225eeec4
>     user:        Mauro Carvalho Chehab <mchehab@redhat.com>
>     date:        Tue Feb 10 05:26:05 2009 -0200
>     summary:     merge: http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-saa7146
> 
> The saa7134 worked.  MythTV eventually worked too, but I had to do the
> "unload/reload modules and run tvtime" procedure I reported earlier
> when I tried Hans' kworld tree.
> 
> David

guess that is why CityK reported already on that always with a _cold_
boot too, as discussed.

Forget about mythtv on such testing.

You likely will never catch a rabbit this way, but it is fine for to
count them all after ...

Cheers,
Hermann




