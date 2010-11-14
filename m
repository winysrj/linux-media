Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59103 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab0KNJ0Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Nov 2010 04:26:24 -0500
Received: by ywc21 with SMTP id 21so1287125ywc.19
        for <linux-media@vger.kernel.org>; Sun, 14 Nov 2010 01:26:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1289684029.2426.65.camel@localhost>
References: <AANLkTimOyNpAatcZb775PPK3uEOXDKXW6-J0kMGis41f@mail.gmail.com>
	<1289684029.2426.65.camel@localhost>
Date: Sun, 14 Nov 2010 20:26:23 +1100
Message-ID: <AANLkTim+OFLOH=dRERzkHOqtC9dLqJsR2Qy2nb+K9KHx@mail.gmail.com>
Subject: Re: new_build on ubuntu (dvbdev.c)
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Apologies, I replied off-list.

On 11/14/10, Andy Walls <awalls@md.metrocast.net> wrote:
> On Sun, 2010-11-14 at 09:08 +1100, Vincent McIntyre wrote:
>> Hi,
>> I'm trying to build on 2.6.32 (ubuntu lucid i386).
>>
>> I followed the instructions for building from git[1]
>
> Shouldn't you be building from:
>
> 	http://git.linuxtv.org/mchehab/new_build.git
>
> for backward compat builds? (I'm not sure myself.)

Yes, I am using this as described in the README (make tar DIR=foo;
make untar; make).

> noop_llseek() is a newer kernl function that provided a trivial llseek()
> implmenetation for drivers that don't support llseek() but still want to
> provide a successful return code:
>
> http://lkml.org/lkml/2010/4/9/193
> http://lkml.org/lkml/2010/4/9/184
>
Thanks for explaining this.

>> Is it that an additional backport patch may be needed here?
>
> Yup.  It looks like you need something.  You'll need a patch to
> implement the trivial noop_llseek() function available in the links
> above.

This is helpful, indeed.

First dumb question - (I'll try to minimise these)

 * Inspection of the patches new_build/backports shows all the patches
are to things in the v4l/ tree
 * Yet the patch you pointed to is to fs/read_write.c and include/linux/fs.h

So my question: should this function be implemented as a patch to
files outside the v4l/ tree
or as additional .c and .h files within the v4l top level. I guess the
latter would then need to be #included in a bunch of v4l files. I'm
mainly unsure of the convention here.

I checked the mkrufky tree mentioned in README.patches but that didn't help.
I also checked the mercurial tree and could not find any backport of
noop_llseek,
but I may have missed something.

The consumers of the function appear to be:
$ find v4l -exec grep -li noop_llseek {} \;
v4l/dvb_frontend.c
v4l/lirc_imon.c
v4l/lirc_dev.c
v4l/lirc_it87.c
v4l/imon.c
v4l/dvb_ca_en50221.c
v4l/dvb_net.c
v4l/dvbdev.c
v4l/lirc_sasem.c
v4l/av7110_av.c
v4l/av7110.c
v4l/av7110_ir.c
v4l/dst_ca.c
v4l/firedtv-ci.c
