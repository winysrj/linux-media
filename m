Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f217.google.com ([209.85.217.217]:37394 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab0DFN7P (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Apr 2010 09:59:15 -0400
Received: by gxk9 with SMTP id 9so3661689gxk.8
        for <linux-media@vger.kernel.org>; Tue, 06 Apr 2010 06:59:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <59e96807eef191ed2c8913139748b655.squirrel@webmail.xs4all.nl>
References: <201004052347.10845.hverkuil@xs4all.nl>
	 <201004060012.48261.hverkuil@xs4all.nl>
	 <201004060837.24770.hverkuil@xs4all.nl> <4BBB341D.2010300@redhat.com>
	 <59e96807eef191ed2c8913139748b655.squirrel@webmail.xs4all.nl>
Date: Tue, 6 Apr 2010 09:59:14 -0400
Message-ID: <v2x829197381004060659u5563952et2d06f7dc876c00a8@mail.gmail.com>
Subject: Re: RFC: exposing controls in sysfs
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, Mike Isely <isely@isely.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 6, 2010 at 9:44 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 1) We don't have that information.
> 2) It would make a simple scheme suddenly a lot more complicated (see
> Andy's comments)
> 3) The main interface is always the application's GUI through ioctls, not
> sysfs.
> 4) Remember that ivtv has an unusually large number of controls. Most
> drivers will just have the usual audio and video controls, perhaps 10 at
> most.
>
> Strife for simplicity. I'm not sure whether we want to have this in sysfs
> at all. While nice there is a danger that people suddenly see it as the
> main API. And Markus' comment regarding permissions was a good one, I
> thought.
>
> I think we should just ditch this for the first implementation of the
> control framework. It can always be added later, but once added it is
> *much* harder to remove again. It's a nice proof-of-concept, though :-)

I tend to agree with Hans.  We've already got *too many* interfaces
that do the same thing.  The testing matrix is already a nightmare -
V4L1 versus V4L2, mmap() versus read(), legacy controls versus
extended controls, and don't get even me started on VBI.

We should be working to make drivers and interfaces simpler, with
*fewer* ways of doing the same thing.  The flexibility of providing
yet another interface via sysfs compared to just calling v4l2-ctl just
isn't worth the extra testing overhead.  We've already got too much
stuff that needs to be fixed and not enough good developers to warrant
making the code more complicated with little tangible benefit.

And nobody I've talked to who writes applications that work with V4L
has been screaming "OMG, if only V4L had a sysfs interface to manage
controls!"

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
