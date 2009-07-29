Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:40697 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027AbZG2Xxy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2009 19:53:54 -0400
Date: Wed, 29 Jul 2009 16:53:53 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-media@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org, bugzilla.kernel.org@boris64.net
Subject: Re: [Bugme-new] [Bug 13709] New: b2c2-flexcop: no frontend driver
 found for this B2C2/FlexCop adapter w/ kernel-2.6.31-rc2
In-Reply-To: <20090722005757.54e9b4dd.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0907291649020.11911@shell2.speakeasy.net>
References: <bug-13709-10286@http.bugzilla.kernel.org/>
 <20090720130412.b186e5f1.akpm@linux-foundation.org>
 <Pine.LNX.4.58.0907201318440.11911@shell2.speakeasy.net>
 <20090720134024.274fbb6c.akpm@linux-foundation.org>
 <Pine.LNX.4.58.0907212358510.11911@shell2.speakeasy.net>
 <20090722005757.54e9b4dd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 22 Jul 2009, Andrew Morton wrote:
> > > Also, is there any way of avoiding this?
> > >
> > > +#define FE_SUPPORTED(fe) (defined(CONFIG_DVB_##fe) || \
> > > + (defined(CONFIG_DVB_##fe##_MODULE) && defined(MODULE)))
> > >
> > > That's just way too tricky.  It expects all versions of the
> > > preprocessor to be correctly implemented (unlikely) and there are other
> > > tools like unifdef which want to parse kernel #defines.
> >
> > What's so tricky about it?  A quick grep shows hundreds of uses of
> > ## for concatenation.
>
> Not the concatenation, of course.
>
> The worrisomie thing is the macro which expands to preprocessor
> statements.  It requires that the preprocessor run itself multiple
> times across the same line.  Or something.  I don't recall seeing that
> trick used elsewhere in the kernel and I have vague memories of it
> causing problems in the past.

Well, there is this now:

arch/powerpc/include/asm/cputable.h:#define CLASSIC_PPC (!defined(CONFIG_8xx) && !defined(CONFIG_4xx) && \
include/drm/drmP.h:#define __OS_HAS_AGP (defined(CONFIG_AGP) || (defined(CONFIG_AGP_MODULE) && defined(MODULE)))
include/drm/drmP.h:#define __OS_HAS_MTRR (defined(CONFIG_MTRR))

Though I can't find any macros with arguments that use those arguments in
preprocessor directives.
