Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59344 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbbLRLWa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 06:22:30 -0500
Date: Fri, 18 Dec 2015 09:22:25 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Mason <slash.tmp@free.fr>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: Automatic device driver back-porting with media_build
Message-ID: <20151218092225.387cea22@recife.lan>
In-Reply-To: <20151218090345.623cef4c@recife.lan>
References: <5672A6F0.6070003@free.fr>
	<20151217105543.13599560@recife.lan>
	<5672BE15.9070006@free.fr>
	<20151217120830.0fc27f01@recife.lan>
	<5672C713.6090101@free.fr>
	<20151217125505.0abc4b40@recife.lan>
	<5672D5A6.8090505@free.fr>
	<20151217140943.7048811b@recife.lan>
	<5672EAD6.2000706@free.fr>
	<5673E393.8050309@free.fr>
	<20151218090345.623cef4c@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 18 Dec 2015 09:03:45 -0200
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Em Fri, 18 Dec 2015 11:44:35 +0100
> Mason <slash.tmp@free.fr> escreveu:
> 
> > On 17/12/2015 18:03, Mason wrote:
> > 
> > > The media_build process prints:
> > > 
> > > "Preparing to compile for kernel version 3.4.3913"
> > > 
> > > In fact, the custom kernel's Makefile contains:
> > > 
> > > VERSION = 3
> > > PATCHLEVEL = 4
> > > SUBLEVEL = 39
> > > EXTRAVERSION = 13
> > > NAME = Saber-toothed Squirrel
> > > 
> > > Is it possible that the build process gets confused by the EXTRAVERSION field?
> > 
> > Here's the problem:
> > 
> > v4l/Makefile writes to KERNELRELEASE and v4l/.version
> > 
> > 	-e 'printf ("VERSION=%s\nPATCHLEVEL:=%s\nSUBLEVEL:=%s\nKERNELRELEASE:=%s.%s.%s%s\n",' \
> > 	-e '	$$version,$$level,$$sublevel,$$version,$$level,$$sublevel,$$extra);' \
> > 
> > $ cat v4l/.version 
> > VERSION=3
> > PATCHLEVEL:=4
> > SUBLEVEL:=39
> > KERNELRELEASE:=3.4.3913
> > SRCDIR:=/tmp/sandbox/custom-linux-3.4
> > 
> > Then $(MAKE) -C ../linux apply_patches calls
> > patches_for_kernel.pl 3.4.3913
> > 
> > which computes kernel_version
> > = 3 << 16 + 4 << 8 + 3913 = 0x031349
> > 
> > which is incorrectly interpreted as kernel 3.19.73
> > thus the correct patches are not applied.
> > 
> > Trivial patch follows. Will test right away.
> > 
> > Regards.
> > 
> > diff --git a/v4l/Makefile b/v4l/Makefile
> > index 1542092004fa..9147a98639b7 100644
> > --- a/v4l/Makefile
> > +++ b/v4l/Makefile
> > @@ -233,9 +233,9 @@ ifneq ($(DIR),)
> >         -e '    elsif (/^EXTRAVERSION\s*=\s*(\S+)\n/){ $$extra=$$1; }' \
> >         -e '    elsif (/^KERNELSRC\s*:=\s*(\S.*)\n/ || /^MAKEARGS\s*:=\s*-C\s*(\S.*)\n/)' \
> >         -e '        { $$o=$$d; $$d=$$1; goto S; }' \
> >         -e '};' \
> > -       -e 'printf ("VERSION=%s\nPATCHLEVEL:=%s\nSUBLEVEL:=%s\nKERNELRELEASE:=%s.%s.%s%s\n",' \
> > +       -e 'printf ("VERSION=%s\nPATCHLEVEL:=%s\nSUBLEVEL:=%s\nKERNELRELEASE:=%s.%s.%s.%s\n",' \
> >         -e '    $$version,$$level,$$sublevel,$$version,$$level,$$sublevel,$$extra);' \
> 
> Hmm... that doesn't sound right on upstream Kernels.
> 
> For example, the extra version on the media_build current Kernel is:
> 
> Makefile:EXTRAVERSION = -rc2
> 
> So, I guess we'll need a different regex, like:
> 
>          -e '    elsif (/^EXTRAVERSION\s*=\s*(\d+)\n/){ $$extra=".$$1"; }' \
>          -e '    elsif (/^EXTRAVERSION\s*=\s*(\S+)\n/){ $$extra=$$1; }' \

Yes, this works. Changing a 2.6.32 kernel to:

	VERSION = 2
	PATCHLEVEL = 6
	SUBLEVEL = 32
	EXTRAVERSION = 99

It gets:
	Forcing compiling to version 2.6.32.99
	make[1]: Leaving directory '/devel/v4l/media_build/v4l'

And
	KERNELRELEASE:=2.6.32.99

Changing EXTRAVERSION to:
	EXTRAVERSION = -rc99

It gets:
	Forcing compiling to version 2.6.32-rc99
And
	 KERNELRELEASE:=2.6.32-rc99	

Patch applied.

Regards,
Mauro
