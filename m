Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:33493 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbZBKDuV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 22:50:21 -0500
Date: Tue, 10 Feb 2009 21:50:16 -0600
From: David Engel <david@istwok.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jonathan Isom <jeisom@gmail.com>,
	V4L <video4linux-list@redhat.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Borke <joshborke@gmail.com>, David Lonie <loniedavid@gmail.com>,
	CityK <cityk@rogers.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
Message-ID: <20090211035016.GA3258@opus.istwok.net>
References: <20090209004343.5533e7c4@caramujo.chehab.org> <1234226235.2790.27.camel@pc10.localdom.local> <1234227277.3932.4.camel@pc10.localdom.local> <1234229460.3932.27.camel@pc10.localdom.local> <20090210003520.14426415@pedra.chehab.org> <1234235643.2682.16.camel@pc10.localdom.local> <1234237395.2682.22.camel@pc10.localdom.local> <20090210041512.6d684be3@pedra.chehab.org> <1767e6740902100407t6737d9f4j5d9edefef8801e27@mail.gmail.com> <20090210102732.5421a296@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090210102732.5421a296@pedra.chehab.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 10, 2009 at 10:27:32AM -0200, Mauro Carvalho Chehab wrote:
> On Tue, 10 Feb 2009 06:07:51 -0600
> Jonathan Isom <jeisom@gmail.com> wrote:
> > On Tue, Feb 10, 2009 at 12:15 AM, Mauro Carvalho Chehab
> > > Ah, ok. So, now, we just need CityK (or someone else with ATSC 115) to confirm
> > > that everything is fine on their side. This patch may also fix other similar
> > > troubles on a few devices that seem to need some i2c magic before probing the
> > > tuner.
> > 
> > Just tried the latest hg and I can confirm that both an ATSC 110 and
> > 115 work with tvtime
> > and ATSC.
> > 
> Jonathan,
> 
> You tried the latest tree at http://linuxtv.org/hg/v4l-dvb or my saa7134 tree
> (http://linuxtv.org/hg/~mchehab/saa7134)?
> 
> In the first case, could you please confirm that it works fine also with the saa7134 tree?

I tried both trees with my ATSC 115.  

The v4l-dvb did not work.  tvtime showed only a blue screen,
presumably due to lack of a signal.  The last commit in the tree was
as follows:

    changeset:   10503:9cb19f080660
    tag:         tip
    parent:      10495:d76f0c9b75fd
    parent:      10502:b1d0225eeec4
    user:        Mauro Carvalho Chehab <mchehab@redhat.com>
    date:        Tue Feb 10 05:26:05 2009 -0200
    summary:     merge: http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-saa7146

The saa7134 worked.  MythTV eventually worked too, but I had to do the
"unload/reload modules and run tvtime" procedure I reported earlier
when I tried Hans' kworld tree.

David
-- 
David Engel
david@istwok.net
