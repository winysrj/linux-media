Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33612 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbbK0PSt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2015 10:18:49 -0500
Date: Fri, 27 Nov 2015 13:18:43 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-media@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: ->poll() instances shouldn't be indefinitely blocking
Message-ID: <20151127131843.0416fe2b@recife.lan>
In-Reply-To: <20151127050026.GX22011@ZenIV.linux.org.uk>
References: <20151127050026.GX22011@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 27 Nov 2015 05:00:26 +0000
Al Viro <viro@ZenIV.linux.org.uk> escreveu:

> Take a look at this:
> static unsigned int gsc_m2m_poll(struct file *file,
>                                         struct poll_table_struct *wait)
> {
>         struct gsc_ctx *ctx = fh_to_ctx(file->private_data);
>         struct gsc_dev *gsc = ctx->gsc_dev;
>         int ret;
> 
>         if (mutex_lock_interruptible(&gsc->lock))
>                 return -ERESTARTSYS;
> 
>         ret = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
>         mutex_unlock(&gsc->lock);
> 
>         return ret;
> }
> 
> a) ->poll() should not return -E...; callers expect just a bitmap of
> POLL... values.

Yeah. We fixed issues like that on other drivers along the time. I guess
this is a some bad code that people just cut-and-paste from legacy drivers
without looking into it.

The same kind of crap were found (and fixed) on other drivers, like
the fix on this changeset: 45053edc05 ('[media] saa7164: fix poll bugs').

> b) sure, it's nice that if this thing hangs, we'll be able to kill it.
> However, if one's ->poll() can hang indefinitely, it means bad things
> for poll(2), select(2), etc. semantics.  What the hell had been intended
> there?

I guess there was no special intent. It is just a bad driver code that
was replicated from other drivers.

> c) a bunch of v4l2_m2m_poll() callers are also taking some kind of
> mutex; AFAICS, all of those appear bogus (the rest of them do not
> play wiht ERESTARTSYS, just plain mutex_lock() for those).
> 
> What's going on there?
