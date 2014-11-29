Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38403 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbaK2LEO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Nov 2014 06:04:14 -0500
Date: Sat, 29 Nov 2014 09:04:08 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: David Liontooth <lionteeth@cogweb.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: ISDB caption support
Message-ID: <20141129090408.1b52c9ea@recife.lan>
In-Reply-To: <CAGoCfix11OiF5_kojJ4jKZadz3XYdYJccPGtivtzDepFfn4Rnw@mail.gmail.com>
References: <5478D31E.5000402@cogweb.net>
	<CAGoCfizK4kN5QnmFs_trAk2w3xuSVtXYVF2wSmdXDazxbhk=yQ@mail.gmail.com>
	<547934E1.3050609@cogweb.net>
	<CAGoCfix11OiF5_kojJ4jKZadz3XYdYJccPGtivtzDepFfn4Rnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 28 Nov 2014 22:23:13 -0500
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> > I realize captions is an application-layer function, and intend to work with
> > the CCExtractor team. Do any other applications already have ISDB caption
> > support?

I never actually checked how CC works on ISDB-T. On the MPEG-TS
tables I worked so far, ISDB-T is very close to DVB, so I would
expect that CC would also be close to the DVB descriptors for it,
but, as I said, I never actually read that part of the ARIB/ABNT
specs.

> Based on a Google search, it looks like dvbviewer can decode them:
> 
> http://www.dvbviewer.tv/forum/topic/41933-brazilian-terrestrial-isdb-tb-subtitles-closed-caption/
> http://www.dvbviewer.com/en/index.php
> 
> It's not open source, and it's not Linux, but at least it may give you
> something to compare against if you want to build the functionality
> yourself.
> 
> > For DVB and ATSC there's quite a bit of code written by several people for
> > teletext and captions -- has anything at all been done for ISDB captions?
> 
> Not to my knowledge.  I've done a ton of work with CC decoding in VLC,
> but haven't poked around at the other formats.
> 
> > It's used in nearly all of Central and South America, plus the Philippines
> > and of course Japan -- you would have thought someone has started on the
> > task?
> 
> From what I understand, most terrestrial TV in Japan is encrypted, so
> you're likely to not find many open source solutions which targeted at
> that market.  Presumably there is less of that in Brazil (why else
> would Mauro be doing all that ISDB-T work if there was no way to watch
> the actual video?).
> 
> > We're looking for a good solution for capturing television in Brazil, when
> > the signal is encrypted -- are there set-top boxes or tv capture cards that
> > handle the decryption so that the decoded signal is passed on with the
> > ISDB-Tb caption stream intact?

I'm not aware of any device that handles encryption in Brazil. Cryptography
is used only in Japan standard, as far as I know.

All channels here are in clear, at least for video/audio streams, but,
as I said, I never tried to work with CC for ISDB-T. Yet, I would find really
weird if just CC is encrypted.

> 
> This would be very unusual.  Satellite captioning often has the same
> issues - the decoders only support overlaying the captions over the
> video and provide no means to access the underlying data.
> 
> Devin
> 
