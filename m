Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:42189 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbZELVuc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 17:50:32 -0400
Date: Tue, 12 May 2009 14:50:31 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	akpm@linux-foundation.org, linux-media@vger.kernel.org,
	roel.kluin@gmail.com, hverkuil@xs4all.nl, mchehab@redhat.com
Subject: Re: [patch 4/4] zoran: fix &&/|| error
In-Reply-To: <20090512183507.5967f336@pedra.chehab.org>
Message-ID: <Pine.LNX.4.58.0905121445010.7837@shell2.speakeasy.net>
References: <200905122058.n4CKwj2I004399@imap1.linux-foundation.org>
 <829197380905121418o5e86d474n3ef38e91850ff818@mail.gmail.com>
 <20090512183507.5967f336@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 12 May 2009, Mauro Carvalho Chehab wrote:
> Em Tue, 12 May 2009 17:18:20 -0400
> Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:
>
> > On Tue, May 12, 2009 at 4:39 PM,  <akpm@linux-foundation.org> wrote:
> > > From: Roel Kluin <roel.kluin@gmail.com>
> > >
> > > Fix &&/|| typo. `default_norm' can be 0 (PAL), 1 (NTSC) or 2 (SECAM),
> > > the condition tested was impossible.
> > >
> > > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> > > Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> > > Cc: Hans Verkuil <hverkuil@xs4all.nl>
> > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > ---
> >
> > Hello,
> >
> > Was the patch actually tested against the hardware in question?  While
> > I agree that it looks ok, it can result in the default logic being
> > inverted in some cases, which could expose other bugs and result in a
> > regression.
> >
> > I just want to be confident that this patch was tested by somebody
> > with the hardware and it isn't going into the codebase because "it
> > obviously cannot be right".
>
> Hans and Jean worked on it. Both are at PAL area, so they won't notice such
> error without a standards generator, since the default is to assume that the
> signal is PAL.
>
> With this patch, PAL should keep working, but I can't see how NTSC or SECAM
> would work without it.

NTSC works fine without it.  The code with the bug was supposed to check
for an out of range module parameter and fix it, but it was broken and did
nothing.  There is no problem if default_norm was set to an ok value, but
if someone specified default_norm=42 then the driver wouldn't fix it and
something bad might happen.  Maybe it would read off the end of the norms
array and crash?
