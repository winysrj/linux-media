Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:42475
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750882AbdHaJty (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 05:49:54 -0400
Date: Thu, 31 Aug 2017 06:49:41 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] docs: kernel-doc comments are ASCII
Message-ID: <20170831064941.1fb18d20@vento.lan>
In-Reply-To: <3390facf-69ae-ba18-8abe-09b5695a6b31@infradead.org>
References: <54c23e8e-89c0-5cea-0dcc-e938952c5642@infradead.org>
        <20170830152314.0486fafb@lwn.net>
        <3390facf-69ae-ba18-8abe-09b5695a6b31@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 30 Aug 2017 15:02:59 -0700
Randy Dunlap <rdunlap@infradead.org> escreveu:

> On 08/30/17 14:23, Jonathan Corbet wrote:
> > On Mon, 28 Aug 2017 16:10:09 -0700
> > Randy Dunlap <rdunlap@infradead.org> wrote:
> >   
> >> kernel-doc parsing uses as ASCII codec, so let people know that
> >> kernel-doc comments should be in ASCII characters only.
> >>
> >> WARNING: kernel-doc '../scripts/kernel-doc -rst -enable-lineno ../drivers/media/dvb-core/demux.h' processing failed with: 'ascii' codec can't decode byte 0xe2 in position 6368: ordinal not in range(128)  
> > 
> > So I don't get this error.  What kind of system are you running the docs
> > build on?  I would really rather that the docs system could handle modern
> > text if possible, so it would be better to figure out what's going on
> > here...  
> 
> I'm OK with that. Source files in general don't need to be ASCII (0-127).
> 
> I did this patch based on this (private) comment:
> 
> > Yes, using ASCII should fix the problem.  
> 
> what kind of system?  HP laptop.
> 
> Linux midway.site 4.4.79-18.26-default #1 SMP Thu Aug 10 20:30:05 UTC 2017 (fa5a935) x86_64 x86_64 x86_64 GNU/Linux
> 
> > sphinx-build --version  
> Sphinx (sphinx-build) 1.3.1

I tried hard to reproduce the error here... I even added some Chinese
chars on a kernel-doc markup and changed the language on my system
to LANG=en_US.iso885915.

No luck. 

As Documentation/conf.py has:

	# -*- coding: utf-8 -*-

on its first line, I suspect that the error you're getting is likely
due to the usage of a python version that doesn't recognize this.

It seems that such dialect was introduced on python version 2.3:

	https://docs.python.org/2.3/whatsnew/section-encodings.html

Yet, the documentation there seems to require a line before it,
e. g.:

	#!/usr/bin/env python
	# -*- coding: UTF-8 -*-

I suspect, however, that, if such line is added, on some systems it
may not work, e. g. if both python 2 and 3 are installed, it could
use the python version that doesn't have Sphinx installed.

So, I suspect that the safest way to fix it is with something like the
enclosed patch. Still, it could be useful to know what's happening,
just in case we get other reports.

Randy,

What's your python version?


Thanks,
Mauro


diff --git a/Documentation/Makefile b/Documentation/Makefile
index 85f7856f0092..94eb98031b56 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -55,6 +55,7 @@ quiet_cmd_sphinx = SPHINX  $@ --> file://$(abspath $(BUILDDIR)/$3/$4)
       cmd_sphinx = $(MAKE) BUILDDIR=$(abspath $(BUILDDIR)) $(build)=Documentation/media $2 && \
 	PYTHONDONTWRITEBYTECODE=1 \
 	BUILDDIR=$(abspath $(BUILDDIR)) SPHINX_CONF=$(abspath $(srctree)/$(src)/$5/$(SPHINX_CONF)) \
+	LANG=C.utf8\
 	$(SPHINXBUILD) \
 	-b $2 \
 	-c $(abspath $(srctree)/$(src)) \
