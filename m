Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:58018 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbZCRUss (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2009 16:48:48 -0400
Date: Wed, 18 Mar 2009 13:48:45 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: REVIEW: bttv conversion to v4l2_subdev
In-Reply-To: <200903151953.06835.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.58.0903181314410.28292@shell2.speakeasy.net>
References: <200903151324.00784.hverkuil@xs4all.nl> <200903151753.52663.hverkuil@xs4all.nl>
 <Pine.LNX.4.58.0903151001040.28292@shell2.speakeasy.net>
 <200903151953.06835.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 15 Mar 2009, Hans Verkuil wrote:
> On Sunday 15 March 2009 18:28:42 Trent Piepho wrote:
> > On Sun, 15 Mar 2009, Hans Verkuil wrote:
> > > On Sunday 15 March 2009 17:04:43 Trent Piepho wrote:
> > > > On Sun, 15 Mar 2009, Hans Verkuil wrote:
> > > > > Hi Mauro,
> > > > >
> > > > > Can you review my ~hverkuil/v4l-dvb-bttv2 tree?
> > > >
> > > > It would be a lot easier if you would provide patch descriptions.
> > >
> > > Here it is:
> > >
> > > - bttv: convert to v4l2_subdev.
> >
> > You aren't even trying.  I could easily write two pages on this patch.
>
> You are right. Mauro already knew about all this, but since I posted it to
> linux-media as well I should have given a more detailed explanation.

The problem is that these changes are going into the kernel with NO
documentation what so ever.  Which is I feel is completely unacceptable.

What will happens is that 6 months to two years from now the number of
people who use this code will increase by orders of magnitude as the
distros switch their stock kernels to ones that have it.

Module options that people have been using for years will disappear.  All
the various distro's hardware auto-configuration programs will need to be
changed.  The way the helper modules are loaded and unloaded has completely
changed.  Someone's obscure card is going to break.  People with out of
tree modifications for specialized hardware will find their patches no
longer apply.

So, two years from now, someone is going to wonder WTF happened to bttv and
they will check the change log.  And they'll find "convert to v4l2_subdev."
Which tells them *nothing*!  YOU will wonder two years from now why you did
something a certain way in the bttv driver, but since you didn't bother to
document anything when you did it, you'll just gave to figure it out all
over again.  Someone is going to want to fix a bug in the bttv driver years
from now and they are going to look at the changelog to see how the driver
works.  If they wonder what the MUXSEL() macro is for, my changelog entry
describes how and why it's there.  If they wonder why the unused
has_saa6588 field is there, your changelog entry tells them nothing at all
about it.

Proper documentation of patches isn't just for *before* they go into the
kernel, out of consideration for developers who will review the patch and
out respect to other developers who also need to understand what is going
on in the code *we all* work on.  It is also there for after the patch is
in the kernel, to provide documentation about how the driver works, why
things are they way they are, the user visible affects of driver changes,
and so on for users, developers who will look at the code in the future,
and even to refresh the memory of the author of the patch themselves.
