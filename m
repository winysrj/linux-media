Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:41841 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbZBXFE7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 00:04:59 -0500
Date: Mon, 23 Feb 2009 21:04:48 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: David Ellingsworth <david@identd.dyndns.org>
cc: linux-media@vger.kernel.org
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
In-Reply-To: <30353c3d0902230653w419e10c4u73b7f70f135d6663@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0902231842300.24268@shell2.speakeasy.net>
References: <200902221115.01464.hverkuil@xs4all.nl>
 <30353c3d0902230653w419e10c4u73b7f70f135d6663@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 23 Feb 2009, David Ellingsworth wrote:
> On Sun, Feb 22, 2009 at 5:15 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > Optional question:
>
> Why can't we drop support for all but the latest kernel?
>
> >
> > Why:
>
> As others have already pointed out, it is a waste of time for
> developers who volunteer their time to work on supporting prior kernel
> revisions for use by enterprise distributions. The task of
> back-porting driver modifications to earlier kernels lessens the
> amount of time developers can focus on improving the quality and
> stability of new and existing drivers. Furthermore, it deters driver
> development since  there an expectation that they will back-port their
> driver to earlier kernel versions. Finally, as a developer, I have

We don't backport the drivers to older kernels.  That's what drivers kept
in a full kernel tree end up doing.

Generally there is just the code for the newest kernel to think about.
Most of the driver code doesn't have backward compatibility ifdefs.  Most
of the compat issues are handled transparently by compat.h and only those
developers who patch compat.h ever need to know they exist.

When a developer does need to deal with some compat ifdef in a driver,
almost all the time it's something trivial and obvious.  Change the
variable name in both branches.  Copy in a couple lines of boilerplate.

Sometimes a bigger issue comes up.  IIRC, around 2.6.16 there was a major
class_device change in the kernel and backward compat code for it ended up
being a nightmare.  So we didn't do it.  We stopped supporting back to
~2.6.11 and moved up the target past the problem change.

Maybe this has happened again with the changes to i2c?  I don't think
it's that hard, but I've yet to do it myself, so maybe it is.
