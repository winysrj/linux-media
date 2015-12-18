Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:24542 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbbLRKon (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 05:44:43 -0500
Subject: Re: Automatic device driver back-porting with media_build
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <5672A6F0.6070003@free.fr> <20151217105543.13599560@recife.lan>
 <5672BE15.9070006@free.fr> <20151217120830.0fc27f01@recife.lan>
 <5672C713.6090101@free.fr> <20151217125505.0abc4b40@recife.lan>
 <5672D5A6.8090505@free.fr> <20151217140943.7048811b@recife.lan>
 <5672EAD6.2000706@free.fr>
From: Mason <slash.tmp@free.fr>
Message-ID: <5673E393.8050309@free.fr>
Date: Fri, 18 Dec 2015 11:44:35 +0100
MIME-Version: 1.0
In-Reply-To: <5672EAD6.2000706@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17/12/2015 18:03, Mason wrote:

> The media_build process prints:
> 
> "Preparing to compile for kernel version 3.4.3913"
> 
> In fact, the custom kernel's Makefile contains:
> 
> VERSION = 3
> PATCHLEVEL = 4
> SUBLEVEL = 39
> EXTRAVERSION = 13
> NAME = Saber-toothed Squirrel
> 
> Is it possible that the build process gets confused by the EXTRAVERSION field?

Here's the problem:

v4l/Makefile writes to KERNELRELEASE and v4l/.version

	-e 'printf ("VERSION=%s\nPATCHLEVEL:=%s\nSUBLEVEL:=%s\nKERNELRELEASE:=%s.%s.%s%s\n",' \
	-e '	$$version,$$level,$$sublevel,$$version,$$level,$$sublevel,$$extra);' \

$ cat v4l/.version 
VERSION=3
PATCHLEVEL:=4
SUBLEVEL:=39
KERNELRELEASE:=3.4.3913
SRCDIR:=/tmp/sandbox/custom-linux-3.4

Then $(MAKE) -C ../linux apply_patches calls
patches_for_kernel.pl 3.4.3913

which computes kernel_version
= 3 << 16 + 4 << 8 + 3913 = 0x031349

which is incorrectly interpreted as kernel 3.19.73
thus the correct patches are not applied.

Trivial patch follows. Will test right away.

Regards.

diff --git a/v4l/Makefile b/v4l/Makefile
index 1542092004fa..9147a98639b7 100644
--- a/v4l/Makefile
+++ b/v4l/Makefile
@@ -233,9 +233,9 @@ ifneq ($(DIR),)
        -e '    elsif (/^EXTRAVERSION\s*=\s*(\S+)\n/){ $$extra=$$1; }' \
        -e '    elsif (/^KERNELSRC\s*:=\s*(\S.*)\n/ || /^MAKEARGS\s*:=\s*-C\s*(\S.*)\n/)' \
        -e '        { $$o=$$d; $$d=$$1; goto S; }' \
        -e '};' \
-       -e 'printf ("VERSION=%s\nPATCHLEVEL:=%s\nSUBLEVEL:=%s\nKERNELRELEASE:=%s.%s.%s%s\n",' \
+       -e 'printf ("VERSION=%s\nPATCHLEVEL:=%s\nSUBLEVEL:=%s\nKERNELRELEASE:=%s.%s.%s.%s\n",' \
        -e '    $$version,$$level,$$sublevel,$$version,$$level,$$sublevel,$$extra);' \
        -e 'print "OUTDIR:=$$o\n" if($$o);' \
        -e 'print "SRCDIR:=$$d\n";' > $(obj)/.version
        @cat .version|grep KERNELRELEASE:|sed s,'KERNELRELEASE:=','Forcing compiling to version ',

