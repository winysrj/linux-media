Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47206 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbZKRHEn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 02:04:43 -0500
Message-ID: <4B039C6A.8090907@infradead.org>
Date: Wed, 18 Nov 2009 05:04:10 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Help in adding documentation
References: <A69FA2915331DC488A831521EAE36FE401559C59A2@dlee06.ent.ti.com> <20091117142820.1e62a362@pedra.chehab.org> <A69FA2915331DC488A831521EAE36FE401559C5A38@dlee06.ent.ti.com> <4B02E444.3020707@infradead.org> <A69FA2915331DC488A831521EAE36FE401559C5D80@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401559C5D80@dlee06.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Karicheri, Muralidharan escreveu:
> Mauro,
> 
> Thanks to your help, I could finish my documentation today.
> 
> But I have another issue with the v4l2-apps.
> 
> When I do make apps, it doesn't seem to build. I get the following error
> logs... Is this broken?

Well... no, it is not really broken, but the build system for v4l2-apps
needs serious improvements. There are some know issues on it:
	- It doesn't check/warn if you don't have all the dependencies
	  (qv4l2 and v4l2-sysfs-path require some development libraries
	   that aren't available per default when gcc is installed - I
	   think the other files there are ok);
	- make only works fine when calling on certain directories (it used to work
	  fine if you call it from /v4l2-apps/*) - but, since some patch, it now requires
	  that you call make from /v4l2-apps, in order to create v4l2-apps/include.
	  After having it created, make can be called from a /v4l2-apps subdir;
	- for some places (libv4l - maybe there are other places?), you need to
	  have the latest headers installed, as it doesn't use the one at the tree.
	- qv4l2 only compiles with qt3.

Patches are welcome to fix those issues and improve the v4l2-apps building system.

> make[3]: Entering directory `/local/mkaricheri/davinci_git/video_timing/new_v4l2-dvb/v4l-dvb-aba823ecaea6/v4l2-apps/libv4l'
> make -C libv4lconvert V4L2_LIB_VERSION=0.6.2-test all
> make[4]: Entering directory `/local/mkaricheri/davinci_git/video_timing/new_v4l2-dvb/v4l-dvb-aba823ecaea6/v4l2-apps/libv4l/libv4lconvert'
> cc -Wp,-MMD,"libv4lconvert.d",-MQ,"libv4lconvert.o",-MP -c -I../include -I../../../include -fvisibility=hidden -fPIC -DLIBDIR=\"/usr/local/lib\" -DLIBSUBDIR=\"libv4l\" -g -O1 -Wall -Wno-unused -Wpointer-arith -Wstrict-prototypes -Wmissing-prototypes -o libv4lconvert.o libv4lconvert.c
> In file included from libv4lconvert.c:25:
> ../include/libv4lconvert.h:100: warning: "struct v4l2_frmsizeenum" declared inside parameter list
> ../include/libv4lconvert.h:100: warning: its scope is only this definition or declaration, which is probably not what you want
> ../include/libv4lconvert.h:105: warning: "struct v4l2_frmivalenum" declared inside parameter list

In this specific case, it is trying to compile against /usr/include/linux/videodev2.h, instead of using
the in-tree header file.

Cheers,
Mauro.
