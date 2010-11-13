Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:45951 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753301Ab0KMWbw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Nov 2010 17:31:52 -0500
Subject: Re: new_build on ubuntu (dvbdev.c)
From: Andy Walls <awalls@md.metrocast.net>
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <AANLkTimOyNpAatcZb775PPK3uEOXDKXW6-J0kMGis41f@mail.gmail.com>
References: <AANLkTimOyNpAatcZb775PPK3uEOXDKXW6-J0kMGis41f@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Nov 2010 16:33:49 -0500
Message-ID: <1289684029.2426.65.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 2010-11-14 at 09:08 +1100, Vincent McIntyre wrote:
> Hi,
> I'm trying to build on 2.6.32 (ubuntu lucid i386).
> 
> I followed the instructions for building from git[1]

Shouldn't you be building from:

	http://git.linuxtv.org/mchehab/new_build.git

for backward compat builds? (I'm not sure myself.)

> but I get an error I don't understand.
> 
> make -C /lib/modules/2.6.32-25-3dbc39-generic/build
> SUBDIRS=/home/me/git/clones/linuxtv.org/new_build/v4l  modules
> make[3]: Entering directory `/usr/src/linux-headers-2.6.32-25-3dbc39-generic'
>   CC [M]  /home/me/git/clones/linuxtv.org/new_build/v4l/tuner-xc2028.o
>   CC [M]  /home/me/git/clones/linuxtv.org/new_build/v4l/tuner-simple.o
>   CC [M]  /home/me/git/clones/linuxtv.org/new_build/v4l/tuner-types.o
>   CC [M]  /home/me/git/clones/linuxtv.org/new_build/v4l/mt20xx.o
> ...all ok so far...
>   CC [M]  /home/me/git/clones/linuxtv.org/new_build/v4l/flexcop-dma.o
> /home/me/git/clones/linuxtv.org/new_build/v4l/dvbdev.c:108: error:
> 'noop_llseek' undeclared here (not in a function)

noop_llseek() is a newer kernl function that provided a trivial llseek()
implmenetation for drivers that don't support llseek() but still want to
provide a successful return code:

http://lkml.org/lkml/2010/4/9/193
http://lkml.org/lkml/2010/4/9/184


> Is it that an additional backport patch may be needed here?

Yup.  It looks like you need something.  You'll need a patch to
implement the trivial noop_llseek() function available in the links
above.

> The kernel I am running here is Ubuntu 2.6.32-25.43-generic (2.6.32.21+drm33.7)
> with one tiny patch, reverting a bad change to drivers/usb/serial/ftdi_sio.c.
> 
> Any advice appreciated.

Regards,
Andy

> [1] http://git.linuxtv.org/media_tree.git
> --


