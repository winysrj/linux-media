Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41885 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbZBQAoH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 19:44:07 -0500
Date: Mon, 16 Feb 2009 21:43:36 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: wk <handygewinnspiel@gmx.de>,
	Devin Heitmueller <devin.heitmueller@gmail.com>,
	VDR User <user.vdr@gmail.com>, linux-media@vger.kernel.org
Subject: Re: DVB-API v5 questions and no dvb developer answering ?
Message-ID: <20090216214336.4a0643a1@pedra.chehab.org>
In-Reply-To: <200902162301.48049.hverkuil@xs4all.nl>
References: <4999A6DD.7030707@gmx.de>
	<412bdbff0902161133u22febbc7v9ca9173bb547bb99@mail.gmail.com>
	<4999DD20.5080801@gmx.de>
	<200902162301.48049.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 16 Feb 2009 23:01:47 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> On Monday 16 February 2009 22:39:44 wk wrote:
> > Devin Heitmueller wrote:
> > > As always we continue to welcome patches, including for the
> > > documentation.  Instead of bitching and moaning, how about you roll up
> > > your sleeves and actually help out?
> > >
> > > Let's try to remember that pretty much all the developers here are
> > > volunteers, so berating them for not doing things fast enough for your
> > > personal taste is not really very productive.
> > >
> > > Regards,
> > >
> > > Devin
> >
> > Devin,
> >
> > can you please explain, how others should contribute to an dvb api if
> > - the only DVB API file to be found is a pdf file, and therefore not
> > editable. Which files exactly to be edited you are writing of?
> 
> 10 minutes searching revealed that the sources are still available in the 
> old CVS repository:
> 
> http://www.linuxtv.org/cgi-bin/viewcvs.cgi/DVB/doc/dvbapi/
> 
> So we need a volunteer to take this, merge it into the current v4l-dvb 
> master repository (just as I did recently with the v4l2 API spec)

Done. The DVB API specs are under /dvb-spec dir. I've imported the DVB original
changesets by using hg convert extension with cvsps.

It compiles fine but it requires tetex-latex and Xfig packages. I didn't check
if the produced pdf is equal to the one at the linuxtv website.

I didn't bother to recover the original author names when importing from CVS,
so, it will show the author aliases used on CVS.

> and then start updating the docs bit by bit.

Volunteers?

Cheers,
Mauro
