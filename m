Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:45340 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751617AbZAOBnF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jan 2009 20:43:05 -0500
Subject: Re: KWorld ATSC 115 all static
From: hermann pitton <hermann-pitton@arcor.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: CityK <cityk@rogers.com>, V4L <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
In-Reply-To: <200901141924.41026.hverkuil@xs4all.nl>
References: <496A9485.7060808@gmail.com> <496D6CF6.6030005@rogers.com>
	 <200901140837.43282.hverkuil@xs4all.nl>
	 <200901141924.41026.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Thu, 15 Jan 2009 02:43:17 +0100
Message-Id: <1231983797.2896.8.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Mittwoch, den 14.01.2009, 19:24 +0100 schrieb Hans Verkuil:
> On Wednesday 14 January 2009 08:37:43 Hans Verkuil wrote:
> > On Wednesday 14 January 2009 05:41:26 CityK wrote:
> > > hermann pitton wrote:
> > > > Hi,
> > > >
> > > > Am Montag, den 12.01.2009, 21:10 -0500 schrieb CityK:
> > > >> Hans Verkuil wrote:
> > > >>> Yes, I can. I'll do saa7134 since I have an empress card
> > > >>> anyway. It should be quite easy (the cx18 complication is not
> > > >>> an issue here).
> > > >>>
> > > >>> Regards,
> > > >>>
> > > >>> 	Hans
> > > >>
> > > >> Thanks Hans!
> > > >
> > > > yes, Hans is a very fine guy.
> > >
> > > He is indeed.
> >
> > Absolutely! :-)
> >
> > FYI: I have a patch, but I won't have time to test it until Friday.
> > You should get something from me then. The main change was actually
> > to the saa6752hs.c i2c module (it wasn't yet converted to
> > v4l2_subdev), and I need to test that first with my empress card.
> 
> OK, I couldn't help myself and went ahead and tested it. It seems fine, 
> so please test my tree: 
> 
> http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-saa7134
> 
> Let me know if it works. If it does, then I'll ask Mauro to pull from my 
> tree.

Just found your email a few hours back after a PC and internet free day,
but so far all seems to be fine and no new issues are visible. DVB-T and
DVB-S are OK too.

Just for the record, we still have the issue on FMD1216ME MK3 hybrid
tuners that the tda9887 is not loaded on boot. This still needs user
intervention.

Thanks!

Cheers,
Hermann


