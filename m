Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:45526 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbZBQAZD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 19:25:03 -0500
Subject: Re: DVB-API v5 questions and no dvb developer answering ?
From: Andy Walls <awalls@radix.net>
To: VDR User <user.vdr@gmail.com>
Cc: wk <handygewinnspiel@gmx.de>,
	Devin Heitmueller <devin.heitmueller@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
In-Reply-To: <a3ef07920902161603x2c3bea3ar7728677d712197fd@mail.gmail.com>
References: <4999A6DD.7030707@gmx.de>
	 <200902161908.15698.hverkuil@xs4all.nl>
	 <a3ef07920902161037nf02b51dl2b411e33ddc76933@mail.gmail.com>
	 <412bdbff0902161133u22febbc7v9ca9173bb547bb99@mail.gmail.com>
	 <4999DD20.5080801@gmx.de>
	 <a3ef07920902161603x2c3bea3ar7728677d712197fd@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 16 Feb 2009 19:25:59 -0500
Message-Id: <1234830359.3091.45.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-02-16 at 16:03 -0800, VDR User wrote:
> On Mon, Feb 16, 2009 at 1:39 PM, wk <handygewinnspiel@gmx.de> wrote:
> > Devin,
> >
> > can you please explain, how others should contribute to an dvb api if
> > - the only DVB API file to be found is a pdf file, and therefore not
> > editable. Which files exactly to be edited you are writing of?
> > - one doesn't know which ioctls exist for what function, which return codes
> > and arguments, how to understand and to use..?
> >
> > What you suggest is almost impossible to someone not perfectly familiar with
> > the drivers, only for dvb experts who have written at least a bunch of
> > drivers.
> > Its something different than sending patches for one single driver where
> > some bug/improvement was found.
> >
> > On the other hand, in principle a driver without existing api doc is
> > useless. Nobody can use it, the same for drivers with undocumented new
> > features.
> 
> Exactly!  Should be entertaining to hear the answers to everything but
> the first 'what files do you edit', though the rest of the questions
> will likely continue to be ignored.

It's actually not that hard.  I was unfamiliar and looked at the header
file and the code that processed the requests.  I whipped up a little
tuning app in a short time:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg00734.html

(but of course longer than it would have taken if an up to date document
were available.)

>   It seems some think those not
> familiar with s2api technical structure should reverse engineer it and
> write the documentation rather then the people who actually created
> it.

Actually, I had been toying with the idea since it should be a simple
addition to the v3 spec, but I got too busy (day job).

V5 is only a single ioctl() for mucking with the frontend IIRC.  The
rest is the same as the DVB V3 API unmodified, again IIRC.  With V5, you
issue a list of frontend properties to set and/or a command to do the
tune in that list and submit it via ioctl().  This list is returned with
a return status for each item in the list you submitted.  It reminded me
of database transactions.

It was actually more complex to extract the current frontend status with
the DVB V3 API events and whatnot, but the documentation spares some of
the headache there.

Regards,
Andy

> To even suggest such a thing is absurd in my humble opinion.
> Talk about counter-productive...


