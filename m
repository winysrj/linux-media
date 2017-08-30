Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40929
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750980AbdH3WQD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 18:16:03 -0400
Date: Wed, 30 Aug 2017 19:15:53 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] docs: kernel-doc comments are ASCII
Message-ID: <20170830191553.179a79d6@vento.lan>
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

I suspect that the problem is not related to the version, but to
what you might have set on LANG.

Maybe if we add something like:
	LANG=C.utf-8

to the Documentation/Makefile or adding:

	.. -*- coding: utf-8; mode: rst -*-

as the first line on the *.rst file that include the kernel-doc 
directive would solve the issue.

Regards,
Mauro
