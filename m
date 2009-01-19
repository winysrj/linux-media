Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34806 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbZASLIw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2009 06:08:52 -0500
Date: Mon, 19 Jan 2009 09:08:19 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: CityK <cityk@rogers.com>, Michael Krufky <mkrufky@linuxtv.org>,
	hermann pitton <hermann-pitton@arcor.de>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
Message-ID: <20090119090819.3f4a1656@pedra.chehab.org>
In-Reply-To: <200901190853.19327.hverkuil@xs4all.nl>
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl>
	<200901182241.10047.hverkuil@xs4all.nl>
	<4973BD03.4060702@rogers.com>
	<200901190853.19327.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 19 Jan 2009 08:53:19 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> On Monday 19 January 2009 00:36:35 CityK wrote:
> > Hans Verkuil wrote:
> > > On Sunday 18 January 2009 22:20:30 CityK wrote:
> > >> The output of dmesg is interesting (two times tuner simple
> > >> initiating):
> > >
> > > Shouldn't there be a tda9887 as well? It's what the card config says,
> > > but I'm not sure whether that is correct.
> > >
> > >> Would you like to see the results of after enabling 12c_scan to see
> > >> what is going on, or is this the behaviour you expected?
> > >
> > > It seems to be OK, although I find it a bit peculiar that the tuner
> > > type is set twice. Or does that have to do with it being a hybrid
> > > tuner, perhaps?
> >
> > The Philips TUV1236D NIM does indeed use a tda9887  (I know, because I
> > was the one who discovered this some four years ago (pats self on
> > head)).  But the module is not loading.  I can make it load, just as
> > Hermann demonstrated to Mike in one of the recent messages for this
> > thread.
> 
> I have no idea why the tda9887 isn't loading. 

Probably, it has something to do with the i2c gate control.

> Note that Mauro merged my saa7134 changes, so these are now in the master 
> repository.

Yes. We need to fix it asap, to avoid regressions. It is time to review also
the other codes that are touching on i2c gates at _init2().

Cheers,
Mauro
