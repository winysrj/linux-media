Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755227AbZGVH6I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2009 03:58:08 -0400
Date: Wed, 22 Jul 2009 00:57:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: linux-media@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org, bugzilla.kernel.org@boris64.net
Subject: Re: [Bugme-new] [Bug 13709] New: b2c2-flexcop: no frontend driver
 found for this B2C2/FlexCop adapter w/ kernel-2.6.31-rc2
Message-Id: <20090722005757.54e9b4dd.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.58.0907212358510.11911@shell2.speakeasy.net>
References: <bug-13709-10286@http.bugzilla.kernel.org/>
	<20090720130412.b186e5f1.akpm@linux-foundation.org>
	<Pine.LNX.4.58.0907201318440.11911@shell2.speakeasy.net>
	<20090720134024.274fbb6c.akpm@linux-foundation.org>
	<Pine.LNX.4.58.0907212358510.11911@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 22 Jul 2009 00:19:00 -0700 (PDT) Trent Piepho <xyzzy@speakeasy.org> wrote:

> On Mon, 20 Jul 2009, Andrew Morton wrote:
> > On Mon, 20 Jul 2009 13:21:33 -0700 (PDT)
> > Trent Piepho <xyzzy@speakeasy.org> wrote:
> > > On Mon, 20 Jul 2009, Andrew Morton wrote:
> > > I produced a patch that fixed this problem over a month ago,
> > > http://www.linuxtv.org/hg/~tap/v4l-dvb/rev/748c762fcf3e
> >
> > Where is that patch now?  It isn't present in linux-next.
> 
> Mauro has how pulled it from me and so it will probably show up in his tree
> soon.
> 
> > Also, is there any way of avoiding this?
> >
> > +#define FE_SUPPORTED(fe) (defined(CONFIG_DVB_##fe) || \
> > + (defined(CONFIG_DVB_##fe##_MODULE) && defined(MODULE)))
> >
> > That's just way too tricky.  It expects all versions of the
> > preprocessor to be correctly implemented (unlikely) and there are other
> > tools like unifdef which want to parse kernel #defines.
> 
> What's so tricky about it?  A quick grep shows hundreds of uses of
> ## for concatenation.

Not the concatenation, of course.

The worrisomie thing is the macro which expands to preprocessor
statements.  It requires that the preprocessor run itself multiple
times across the same line.  Or something.  I don't recall seeing that
trick used elsewhere in the kernel and I have vague memories of it
causing problems in the past.


