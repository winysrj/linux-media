Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2075 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617AbZANHhy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jan 2009 02:37:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: CityK <cityk@rogers.com>
Subject: Re: KWorld ATSC 115 all static
Date: Wed, 14 Jan 2009 08:37:43 +0100
Cc: hermann pitton <hermann-pitton@arcor.de>,
	V4L <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
References: <496A9485.7060808@gmail.com> <1231816664.2680.21.camel@pc10.localdom.local> <496D6CF6.6030005@rogers.com>
In-Reply-To: <496D6CF6.6030005@rogers.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901140837.43282.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 14 January 2009 05:41:26 CityK wrote:
> hermann pitton wrote:
> > Hi,
> >
> > Am Montag, den 12.01.2009, 21:10 -0500 schrieb CityK:
> >> Hans Verkuil wrote:
> >>> Yes, I can. I'll do saa7134 since I have an empress card anyway.
> >>> It should be quite easy (the cx18 complication is not an issue
> >>> here).
> >>>
> >>> Regards,
> >>>
> >>> 	Hans
> >>
> >> Thanks Hans!
> >
> > yes, Hans is a very fine guy.
>
> He is indeed.

Absolutely! :-)

FYI: I have a patch, but I won't have time to test it until Friday. You 
should get something from me then. The main change was actually to the 
saa6752hs.c i2c module (it wasn't yet converted to v4l2_subdev), and I 
need to test that first with my empress card.

Regards,

	Hans

> > But don't hope for too much for DVB/ATSC related stuff soon.
> >
> > We know about the problems caused by switching antenna inputs from
> > a digital demod, it was a famous hack from Chris on cx88xx and Mike
> > did good work to port it to saa713x, but unfortunately there was
> > some ongoing loss on the other side of the planet then later.
> >
> > I doubt that Hans is already aware of it at this stage,
>
> Consulting on irc, both Eric and myself can confirm that DVB is
> working fine for the device (I can only test cable currently, but
> Eric successfully checked both QAM and 8-VSB).  I'm using recent Hg
> and Eric is using stock FC10 supplied drivers.  So, I'm not sure why
> Josh was having problems.
>
> > these days bugs are fixed from guys without even having hardware,
>
> Four letter word.  Starts with A and ends with Y  :p
>
> > and this is good progress,
>
> Yes, it was awfully nice of Andy to diagnose and provide a solution.
> Props to him.
>
> >  likely they will add new devices the same way too soon.
>
> This point, however, is not a very good route to go down --- it opens
> up a huge can of worms (<-- silly English expression which
> essentially means that such action creates problems).
>
> > I seem to be far behind currently, all caused by the HDTV hype ;)
>
> You mean you haven't upgraded to the latest 92 inch hyper plasma OXD
> display yet!    Crappy broadcast content has never looked so good!



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
