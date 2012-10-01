Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894Ab2JATje (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Oct 2012 15:39:34 -0400
Date: Mon, 1 Oct 2012 16:39:16 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Martin Burnicki <martin.burnicki@burnicki.net>
Cc: linux-media@vger.kernel.org
Subject: Re: Current media_build doesn't succeed building on kernel 3.1.10
Message-ID: <20121001163916.1ec33cb2@redhat.com>
In-Reply-To: <201210012131.13441.martin.burnicki@burnicki.net>
References: <201209302052.42723.martin.burnicki@burnicki.net>
	<20121001110241.2f5ab052@redhat.com>
	<201210012131.13441.martin.burnicki@burnicki.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 1 Oct 2012 21:31:12 +0200
Martin Burnicki <martin.burnicki@burnicki.net> escreveu:

> Hi,
> 
> Mauro Carvalho Chehab wrote:
> > Em Sun, 30 Sep 2012 20:52:42 +0200
> >
> > Martin Burnicki <martin.burnicki@burnicki.net> escreveu:
> > > Hi all,
> > >
> > > is anybody out there who can help me with the media_build system? I'm
> > > trying to build the current modules on an openSUSE 12.1 system (kernel
> > > 3.1.10, x86_64), but I'm getting compilation errors because the s5k4ecgx
> > > driver uses function devm_regulator_bulk_get() which AFAICS has been
> > > introduced in kernel 3.4 only. When I run the ./build script compilation
> > > stops with these messages:
> > >
> > >  CC [M]  /root/projects/media_build/v4l/s5k4ecgx.o
> > > media_build/v4l/s5k4ecgx.c: In function 's5k4ecgx_load_firmware':
> > > media_build/v4l/s5k4ecgx.c:346:2: warning: format '%d' expects argument
> > > of \ type 'int', but argument 4 has type 'size_t' [-Wformat]
> > > media_build/v4l/s5k4ecgx.c: In function 's5k4ecgx_probe':
> > > media_build/v4l/s5k4ecgx.c:977:2: error: implicit declaration of \
> > >     function 'devm_regulator_bulk_get'
> > > [-Werror=implicit-function-declaration] cc1: some warnings being treated
> > > as errors
> >
> > Those are warnings. It wil compile if you disable
> > -Werror=implicit-function-declaration.
> 
> Hm, yes. Even though the module would finally not load due to "missing 
> symbols" this won't matter since I don't need this module. So I suppose I 
> need something like
> 
> EXTRA_CFLAGS=-Wno-error=implicit-function-declaration
> 
> to let this be treated like a warning and thus the build process will 
> continue. However, I'm trying to use the ./build script from
> 
> git clone git://linuxtv.org/media_build.git
> 
> which seems to be best practice to get new modules added to an older kernel. 
> Can you or someone else tell me how to pass these EXTRA_CFLAGS to the ./build 
> script?
> 
> I've tried several ways without success.

It likely makes sense to modify the generated Makefile.media to disable the
"warnings being treated as errors" behavior that seems to be default on newer
distros.

Probably, all it needs is to modify this script:
	v4l/scripts/make_makefile.pl 

I'm very busy this week (merge window upstream). So, it is unlikely that
I'll find time to work on that, but feel free to do the changes and submit
us a patch for it.

Thanks!
Mauro
