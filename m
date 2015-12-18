Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59334 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbbLRKhR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 05:37:17 -0500
Date: Fri, 18 Dec 2015 08:37:11 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Mason <slash.tmp@free.fr>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: Automatic device driver back-porting with media_build
Message-ID: <20151218083711.69d59233@recife.lan>
In-Reply-To: <5672E779.9080505@free.fr>
References: <5672A6F0.6070003@free.fr>
	<20151217105543.13599560@recife.lan>
	<5672BE15.9070006@free.fr>
	<20151217120830.0fc27f01@recife.lan>
	<5672C713.6090101@free.fr>
	<20151217125505.0abc4b40@recife.lan>
	<5672D5A6.8090505@free.fr>
	<20151217140943.7048811b@recife.lan>
	<5672E779.9080505@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 17 Dec 2015 17:48:57 +0100
Mason <slash.tmp@free.fr> escreveu:

> On 17/12/2015 17:09, Mauro Carvalho Chehab wrote:
> > Em Thu, 17 Dec 2015 16:32:54 +0100
> > Mason <slash.tmp@free.fr> escreveu:
> > 
> >> I wanted to fix the NEED_WRITEL_RELAXED warning, but I don't know Perl.
> >>
> >> v4l/scripts/make_config_compat.pl
> >>
> >> check_files_for_func("writel_relaxed", "NEED_WRITEL_RELAXED", "include/asm-generic/io.h");
> >> incorrectly outputs
> >> #define NEED_WRITEL_RELAXED 1
> >>
> >>
> >> In file included from <command-line>:0:0:
> >> /tmp/sandbox/media_build/v4l/compat.h:1568:0: warning: "writel_relaxed" redefined
> >>  #define writel_relaxed writel
> >>  ^
> >> In file included from include/linux/scatterlist.h:10:0,
> >>                  from /tmp/sandbox/media_build/v4l/compat.h:1255,
> >>                  from <command-line>:0:
> >> /tmp/sandbox/custom-linux-3.4/arch/arm/include/asm/io.h:235:0: note: this is the location of the previous definition
> >>  #define writel_relaxed(v,c) ((void)__raw_writel((__force u32) \
> >>  ^
> >>
> >> Shouldn't the script examine arch/$ARCH/include/asm/io.h instead of
> >> include/asm-generic/io.h ? (Or perhaps both?)
> >>
> >> Does make_config_compat.pl know about ARCH?
> > 
> > No to both. When you do a "make init" on the Kernel repository, it
> > will evaluate the ARCH vars.
> > 
> > This is also needed for the media build to work, as it needs to
> > check what CONFIG vars are enabled on the targeted Kernel.
> 
> I downloaded the vanilla version of my custom kernel: linux-3.4.39.tar.xz
> 
> Even then, NEED_WRITEL_RELAXED is incorrectly defined.

did you run a:
	make allmodconfig
	make init

for the vanilla version? Without that, the symlinks won't appear.

> How do you propose to fix this bug?
> 
> $ grep writel_relaxed arch/arm/include/asm/io.h
> #define writel_relaxed(v,c)	((void)__raw_writel((__force u32) \
> #define writel(v,c)		({ __iowmb(); writel_relaxed(v,c); })
> 
> $ grep writel_relaxed arch/x86/include/asm/io.h
> $ grep -r writel_relaxed include
> 
> > As I said before, heavily patched Kernel. It seems that the network stack
> > was updated to some newer version. The media_build backport considers
> > only the upstream Kernels. In the specific case of 3.4, it is known
> > to build fine with Kernel linux-3.4.27. See:
> > 	http://hverkuil.home.xs4all.nl/logs/Wednesday.log
> 
> I will keep trying to get something to compile.
> 
> Regards.
> 
