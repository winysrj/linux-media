Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4334 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbZBRHpw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 02:45:52 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: David Engel <david@istwok.net>
Subject: Re: KWorld ATSC 115 all static
Date: Wed, 18 Feb 2009 08:45:57 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	V4L <video4linux-list@redhat.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Borke <joshborke@gmail.com>, David Lonie <loniedavid@gmail.com>,
	CityK <cityk@rogers.com>, linux-media@vger.kernel.org
References: <20090210041512.6d684be3@pedra.chehab.org> <20090213202811.GB3810@opus.istwok.net> <20090217155329.GA6196@opus.istwok.net>
In-Reply-To: <20090217155329.GA6196@opus.istwok.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902180845.57862.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 17 February 2009 16:53:29 David Engel wrote:
> On Fri, Feb 13, 2009 at 02:28:11PM -0600, David Engel wrote:
> > On Fri, Feb 13, 2009 at 09:28:45AM -0200, Mauro Carvalho Chehab wrote:
> > > Ok, I found the bug. It is inside tuner-simple code. It is caused due
> > > to a hack for TUV1236.
> > >
> > > I've just committed a fix for it:
> > > 	http://linuxtv.org/hg/v4l-dvb/rev/34ec729ed1a7
> > >
> > > Please test.
> >
> > In limited, remote testing -- it works!  It also works on my
> > production MythTV backend with 2 ATSC 115s.  This is the first time
> > analog has ever worked on both of those cards at the same time.  I'll
> > do more testing over the weekend.  Thanks very much, Mauro, Hans and
> > everyone else involved.
>
> I didn't get to test as much as I'd hoped but I did do some.  The
> fixed analog support on my ATSC 115s worked great.  Thanks again.
>
> David

Can I remove my v4l-dvb-kworld tree? I gather that it is now fixed in the 
master repo?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
