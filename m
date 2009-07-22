Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:37946 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbZGVHTB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2009 03:19:01 -0400
Date: Wed, 22 Jul 2009 00:19:00 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-media@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org, bugzilla.kernel.org@boris64.net
Subject: Re: [Bugme-new] [Bug 13709] New: b2c2-flexcop: no frontend driver
 found for this B2C2/FlexCop adapter w/ kernel-2.6.31-rc2
In-Reply-To: <20090720134024.274fbb6c.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0907212358510.11911@shell2.speakeasy.net>
References: <bug-13709-10286@http.bugzilla.kernel.org/>
 <20090720130412.b186e5f1.akpm@linux-foundation.org>
 <Pine.LNX.4.58.0907201318440.11911@shell2.speakeasy.net>
 <20090720134024.274fbb6c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 20 Jul 2009, Andrew Morton wrote:
> On Mon, 20 Jul 2009 13:21:33 -0700 (PDT)
> Trent Piepho <xyzzy@speakeasy.org> wrote:
> > On Mon, 20 Jul 2009, Andrew Morton wrote:
> > I produced a patch that fixed this problem over a month ago,
> > http://www.linuxtv.org/hg/~tap/v4l-dvb/rev/748c762fcf3e
>
> Where is that patch now?  It isn't present in linux-next.

Mauro has how pulled it from me and so it will probably show up in his tree
soon.

> Also, is there any way of avoiding this?
>
> +#define FE_SUPPORTED(fe) (defined(CONFIG_DVB_##fe) || \
> + (defined(CONFIG_DVB_##fe##_MODULE) && defined(MODULE)))
>
> That's just way too tricky.  It expects all versions of the
> preprocessor to be correctly implemented (unlikely) and there are other
> tools like unifdef which want to parse kernel #defines.

What's so tricky about it?  A quick grep shows hundreds of uses of
## for concatenation.

> otoh the trick does produce a nice result and doing it any other way
> (which I can think of) would make a mess.

This particular kind of test is something that is used many times in the
dvb code.  This isn't the first time someone has gotten it wrong by a long
shot.  Mauro suggested, and I agree, that for the next kernel we should put
FE_SUPPORTED into a dvb header file and convert the many existing tests to
use it.  Maybe this will reduce the number of mistakes.

> Or just revert whichever patch broke things.  Your changelog describes
> this as simply "A recent patch" (bad changelog!) so I am unable to judge this.

It was commit d66b94b4aa2f40e134f8c07c58ae74ef3d523ee0, but it was not
committed until five days after I made my patch, so there was no hash to
reference yet.  I suppose I should have used the patch title.
