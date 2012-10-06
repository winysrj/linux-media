Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:40700 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab2JFPTQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Oct 2012 11:19:16 -0400
Date: Sat, 6 Oct 2012 12:19:08 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
	hverkuil@xs4all.nl
Subject: Re: [PATCH 1/5] media: ov7670: add support for ov7675.
Message-ID: <20121006121908.33709692@infradead.org>
In-Reply-To: <CACKLOr2+cWAgKspq+OKTQOvKcBGDSDZg05tx0mqNV1n=38Lr_g@mail.gmail.com>
References: <1348652877-25816-1-git-send-email-javier.martin@vista-silicon.com>
	<1348652877-25816-2-git-send-email-javier.martin@vista-silicon.com>
	<20120926104007.4de17d19@lwn.net>
	<CACKLOr2+cWAgKspq+OKTQOvKcBGDSDZg05tx0mqNV1n=38Lr_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 27 Sep 2012 08:58:33 +0200
javier Martin <javier.martin@vista-silicon.com> escreveu:

> Hi Jonathan,
> thank you for your time.
> 
> On 26 September 2012 18:40, Jonathan Corbet <corbet@lwn.net> wrote:
> > This is going to have to be quick, sorry...
> >
> > On Wed, 26 Sep 2012 11:47:53 +0200
> > Javier Martin <javier.martin@vista-silicon.com> wrote:
> >
> >> +static struct ov7670_win_size ov7670_win_sizes[2][4] = {
> >> +     /* ov7670 */
> >
> > I must confess I don't like this; now we've got constants in an array that
> > was automatically sized before and ov7670_win_sizes[info->model]
> > everywhere.  I'd suggest a separate array for each device and an
> > ov7670_get_wsizes(model) function.
> >
> >> +             /* CIF - WARNING: not tested for ov7675 */
> >> +             {
> >
> > ...and this is part of why I don't like it.  My experience with this
> > particular sensor says that, if it's not tested, it hasn't yet seen the
> > magic-number tweaking required to actually make it work.  Please don't
> > claim to support formats that you don't know actually work, or I'll get
> > stuck with the bug reports :)
> 
> Your concern makes a lot of sense. In fact, that was one of my doubts
> whether to 'support' not tested formats or not.
> 
> Let me fix that in a new version.

Hi Javier,

I'm assuming that you'll be sending a new version of this entire changeset.
So, I'll just mark this entire series as changes_requested.

Cheers,
Mauro
