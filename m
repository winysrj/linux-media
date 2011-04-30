Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:36541 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752778Ab1D3QJO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Apr 2011 12:09:14 -0400
Subject: Re: Build Failure
From: Andy Walls <awalls@md.metrocast.net>
To: Colin Minihan <colin.minihan@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <BANLkTim9vtBAE1dbOXAwW2Crh7aiMucD3w@mail.gmail.com>
References: <BANLkTikBm0gmNd8oQ6CN+cAEbYhWEGvWPA@mail.gmail.com>
	 <BANLkTim9vtBAE1dbOXAwW2Crh7aiMucD3w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Apr 2011 12:10:14 -0400
Message-ID: <1304179815.2434.10.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 2011-04-30 at 10:31 -0400, Colin Minihan wrote:
> On Ubuntu 10.04 attempting to run
> 
> git clone git://linuxtv.org/media_build.git
> cd media_build
> ./check_needs.pl
> make -C linux/ download
> make -C linux/ untar
> make stagingconfig
> make
> 
>  results in the following failure
> ...
>   CC [M]  /home/colm/media_build/v4l/lirc_zilog.o
> /home/colm/media_build/v4l/lirc_zilog.c: In function 'destroy_rx_kthread':
> /home/colm/media_build/v4l/lirc_zilog.c:238: error: implicit
> declaration of function 'IS_ERR_OR_NULL'

Well, IS_ERR_OR_NULL() went into the kernel in December 2009:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=603c4ba96be998a8dd7a6f9b23681c49acdf4b64

so it should be in kernel version 2.6.33 and later.

If you don't want to generate a patch for the media_build backward
compatability build system, you can probably just patch your kernel
header file or trivially hack the function it into 

	drivers/staging/lirc/lirc_zilog.c

to get past your current build error.  But I suspect you'll run into
more errors.  When I make changes to a module (like lirc_zilog.c), I
tend to use the latest kernel interfaces at the time of the changes.

If you don't need lirc_zilog.ko built, then configure the build system
to not build the module.

Regards,
Andy

> make[3]: *** [/home/colm/media_build/v4l/lirc_zilog.o] Error 1
> make[2]: *** [_module_/home/colm/media_build/v4l] Error 2
> make[2]: Leaving directory `/usr/src/linux-headers-2.6.32-31-generic'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/home/colm/media_build/v4l'
> make: *** [all] Error 2
> --


