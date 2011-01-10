Return-path: <mchehab@pedra>
Received: from bar.sig21.net ([80.81.252.164]:40412 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721Ab1AJNGK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 08:06:10 -0500
Date: Mon, 10 Jan 2011 14:05:19 +0100
From: Johannes Stezenbach <js@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: Debug code in HG repositories
Message-ID: <20110110130519.GA4996@linuxtv.org>
References: <201101072053.37211@orion.escape-edv.de>
 <AANLkTinj2NcOcVUPifsNcvbs=Mivwe89+hg8XLsCJnQ7@mail.gmail.com>
 <201101072206.30323.hverkuil@xs4all.nl>
 <alpine.LNX.2.00.1101071656350.11281@banach.math.auburn.edu>
 <4D2AF1A0.3090809@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2AF1A0.3090809@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Jan 10, 2011 at 09:46:40AM -0200, Mauro Carvalho Chehab wrote:
> Em 07-01-2011 21:42, Theodore Kilgore escreveu:
>  
> >> Have you tried Mauro's media_build tree? I had to use it today to test a
> >> driver from git on a 2.6.35 kernel. Works quite nicely. Perhaps we 
> > should
> >> promote this more. 
> > 
> > Probably a good idea. I have been too busy to know about it, myself. And I 
> > even do try to keep up with what is going on.
> > 
> >> I could add backwards compatibility builds to my 
> > daily
> >> build script that uses this in order to check for which kernel versions
> >> this compiles if there is sufficient interest.
...
> I think Hans can enable it. The backport effort on media-build is a way
> easier than with -hg. For example, in order to support kernel 2.6.31 (the oldest
> one on that tree), we need only 10 patches. The patches themself are simple:
> 
> $ wc -l *.patch
>    61 v2.6.31_nodename.patch
>   540 v2.6.32_kfifo.patch
>    42 v2.6.33_input_handlers_are_int.patch
>    70 v2.6.33_pvrusb2_sysfs.patch
>    40 v2.6.34_dvb_net.patch
>    22 v2.6.34_fix_define_warnings.patch
>    16 v2.6.35_firedtv_handle_fcp.patch
>   104 v2.6.35_i2c_new_probed_device.patch
>   145 v2.6.35_work_handler.patch
>   104 v2.6.36_input_getkeycode.patch
>  1144 total
> 
> And almost all patches are trivial.

FWIW, linux-wireless developers maintain a generic compat tree used
for backporting wireless drivers:
http://git.kernel.org/?p=linux/kernel/git/mcgrof/compat.git;a=summary

I suppose it might be useful to share this between linux-wireless
and linux-media?


(It is used together with three other trees to autobuild
the compat-wireless releases.
http://wireless.kernel.org/en/users/Download

It works like that:
- compat.git: generic backporting layer
- compat-wireless-2.6.git: build system
- compat-user.git: autobuild scripts called via cron
- wireless-testing.git: linux-wireless development tree

(wireless-testing.git is based on latest stable kernel but with
the wireless code from linux-next)

compat-wireless releases are not meant for development, but
they can be used as a build system together with a wireless-testing.git
tree and a few symlinks.)


Johannes
