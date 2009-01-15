Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:49387 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751480AbZAOCcV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jan 2009 21:32:21 -0500
Subject: Re: KWorld ATSC 115 all static
From: hermann pitton <hermann-pitton@arcor.de>
To: CityK <cityk@rogers.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	V4L <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
In-Reply-To: <496D6CF6.6030005@rogers.com>
References: <496A9485.7060808@gmail.com> <496AB41E.8020507@rogers.com>
	 <20090112031947.134c29c9@pedra.chehab.org>
	 <200901120840.20194.hverkuil@xs4all.nl>  <496BF812.40102@rogers.com>
	 <1231816664.2680.21.camel@pc10.localdom.local>
	 <496D6CF6.6030005@rogers.com>
Content-Type: text/plain
Date: Thu, 15 Jan 2009 03:32:41 +0100
Message-Id: <1231986761.2896.21.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Dienstag, den 13.01.2009, 23:41 -0500 schrieb CityK:
> hermann pitton wrote:
> > Hi,
> >
> > Am Montag, den 12.01.2009, 21:10 -0500 schrieb CityK:
> >   
> >> Hans Verkuil wrote:
> >>     
> >>> Yes, I can. I'll do saa7134 since I have an empress card anyway. It 
> >>> should be quite easy (the cx18 complication is not an issue here).
> >>>
> >>> Regards,
> >>>
> >>> 	Hans
> >>>       
> >> Thanks Hans!
> >>
> >>     
> >
> > yes, Hans is a very fine guy.
> >   
> 
> He is indeed.
> 
> > But don't hope for too much for DVB/ATSC related stuff soon.
> >
> > We know about the problems caused by switching antenna inputs from a
> > digital demod, it was a famous hack from Chris on cx88xx and Mike did
> > good work to port it to saa713x, but unfortunately there was some
> > ongoing loss on the other side of the planet then later.
> >
> > I doubt that Hans is already aware of it at this stage, 
> 
> Consulting on irc, both Eric and myself can confirm that DVB is working
> fine for the device (I can only test cable currently, but Eric
> successfully checked both QAM and 8-VSB).  I'm using recent Hg and Eric
> is using stock FC10 supplied drivers.  So, I'm not sure why Josh was
> having problems.

for me the same and I can't test on these.
The Pinnacle 310i seems to have the LNA support broken, can't test.

> > these days bugs are fixed from guys without even having hardware, 
> Four letter word.  Starts with A and ends with Y  :p
> 
> > and this is good progress,
> Yes, it was awfully nice of Andy to diagnose and provide a solution. 
> Props to him.

Yes!

> >  likely they will add new devices the same way too soon.
> >   
> 
> This point, however, is not a very good route to go down --- it opens up
> a huge can of worms (<-- silly English expression which essentially
> means that such action creates problems).

If manufacturers would confirm to the Philips/NXP drivers and what
should be in the eeprom, that would be possible on GNU/Linux too.

> > I seem to be far behind currently, all caused by the HDTV hype ;)
> >   
> 
> You mean you haven't upgraded to the latest 92 inch hyper plasma OXD
> display yet!    Crappy broadcast content has never looked so good!

No, trying on HDTV apps and also Nvidia vdpau consumed some time and I
don't have neither a 2.6.28 nor a 2.6.29-rc1 yet.

In that way I might be ranting about myself not at least to have the new
bugs :)

Cheers,
Hermann


