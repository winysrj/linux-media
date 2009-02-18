Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:62645 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbZBRP0P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 10:26:15 -0500
Date: Wed, 18 Feb 2009 09:26:12 -0600
From: David Engel <david@istwok.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	V4L <video4linux-list@redhat.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Borke <joshborke@gmail.com>, David Lonie <loniedavid@gmail.com>,
	CityK <cityk@rogers.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
Message-ID: <20090218152612.GA15359@opus.istwok.net>
References: <20090210041512.6d684be3@pedra.chehab.org> <20090213202811.GB3810@opus.istwok.net> <20090217155329.GA6196@opus.istwok.net> <200902180845.57862.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902180845.57862.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 18, 2009 at 08:45:57AM +0100, Hans Verkuil wrote:
> On Tuesday 17 February 2009 16:53:29 David Engel wrote:
> > On Fri, Feb 13, 2009 at 02:28:11PM -0600, David Engel wrote:
> > > On Fri, Feb 13, 2009 at 09:28:45AM -0200, Mauro Carvalho Chehab wrote:
> > > > Ok, I found the bug. It is inside tuner-simple code. It is caused due
> > > > to a hack for TUV1236.
> > > >
> > > > I've just committed a fix for it:
> > > > 	http://linuxtv.org/hg/v4l-dvb/rev/34ec729ed1a7
> > > >
> > > > Please test.
> > >
> > > In limited, remote testing -- it works!  It also works on my
> > > production MythTV backend with 2 ATSC 115s.  This is the first time
> > > analog has ever worked on both of those cards at the same time.  I'll
> > > do more testing over the weekend.  Thanks very much, Mauro, Hans and
> > > everyone else involved.
> >
> > I didn't get to test as much as I'd hoped but I did do some.  The
> > fixed analog support on my ATSC 115s worked great.  Thanks again.
> >
> > David
> 
> Can I remove my v4l-dvb-kworld tree? I gather that it is now fixed in the 
> master repo?

That would be fine with me.

David
-- 
David Engel
david@istwok.net
