Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:63718 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751888Ab0KNNKr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Nov 2010 08:10:47 -0500
Subject: Re: new_build on ubuntu (dvbdev.c)
From: Andy Walls <awalls@md.metrocast.net>
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <AANLkTim+OFLOH=dRERzkHOqtC9dLqJsR2Qy2nb+K9KHx@mail.gmail.com>
References: <AANLkTimOyNpAatcZb775PPK3uEOXDKXW6-J0kMGis41f@mail.gmail.com>
	 <1289684029.2426.65.camel@localhost>
	 <AANLkTim+OFLOH=dRERzkHOqtC9dLqJsR2Qy2nb+K9KHx@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Nov 2010 07:12:43 -0500
Message-ID: <1289736763.2431.10.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 2010-11-14 at 20:26 +1100, Vincent McIntyre wrote:
> On 11/14/10, Andy Walls <awalls@md.metrocast.net> wrote:
> > On Sun, 2010-11-14 at 09:08 +1100, Vincent McIntyre wrote:


> > noop_llseek() is a newer kernl function that provided a trivial llseek()
> > implmenetation for drivers that don't support llseek() but still want to
> > provide a successful return code:
> >
> > http://lkml.org/lkml/2010/4/9/193
> > http://lkml.org/lkml/2010/4/9/184
> >
> Thanks for explaining this.


> First dumb question - (I'll try to minimise these)
> 
>  * Inspection of the patches new_build/backports shows all the patches
> are to things in the v4l/ tree
>  * Yet the patch you pointed to is to fs/read_write.c and include/linux/fs.h
> 
> So my question: should this function be implemented as a patch to
> files outside the v4l/ tree

I'm not sure, I haven't looked at the build system.  I'm guessing no.

The build system *should* be using the kernel include files from your
distribution.  Patching up fs.h in the git tree may not have any effect,
and patching up fs/read_write.c in the git tree certainly won't have any
effect.

You also don't want to muck with your installed kernel files.

> or as additional .c and .h files within the v4l top level. I guess the
> latter would then need to be #included in a bunch of v4l files. I'm
> mainly unsure of the convention here.

1. A simple, stupid patch would just a statically defined, non-inline
noop_llseek() function in each affected .c file.

In this particular case I'm not sure adding a special .h file, a new .c
file, a way to build the new .c file, and a bunch of #include's is worth
it.

or

2. I suppose you could have a patch add a .h file that defined a
non-inline static noop_llseek() function and just #include that where
needed.  

or

3.  You could just add

	#define noop_llseek	NULL

instead of a real function in either of 1 or 2 above.

> I checked the mkrufky tree mentioned in README.patches but that didn't help.
> I also checked the mercurial tree and could not find any backport of
> noop_llseek,
> but I may have missed something.
> 
> The consumers of the function appear to be:
> $ find v4l -exec grep -li noop_llseek {} \;
> v4l/dvb_frontend.c
> v4l/lirc_imon.c
> v4l/lirc_dev.c
> v4l/lirc_it87.c
> v4l/imon.c
> v4l/dvb_ca_en50221.c
> v4l/dvb_net.c
> v4l/dvbdev.c
> v4l/lirc_sasem.c
> v4l/av7110_av.c
> v4l/av7110.c
> v4l/av7110_ir.c
> v4l/dst_ca.c
> v4l/firedtv-ci.c

Regards,
Andy

