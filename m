Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59180 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbbLQMzs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 07:55:48 -0500
Date: Thu, 17 Dec 2015 10:55:43 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Mason <slash.tmp@free.fr>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: Automatic device driver back-porting with media_build
Message-ID: <20151217105543.13599560@recife.lan>
In-Reply-To: <5672A6F0.6070003@free.fr>
References: <5672A6F0.6070003@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 17 Dec 2015 13:13:36 +0100
Mason <slash.tmp@free.fr> escreveu:

> Hello everyone,
> 
> I have a TechnoTrend TT-TVStick CT2-4400v2 USB tuner, as described here:
> http://linuxtv.org/wiki/index.php/TechnoTrend_TT-TVStick_CT2-4400
> 
> According to the article, the device is supported since kernel 3.19
> and indeed, if I use a 4.1 kernel, I can pick CONFIG_DVB_USB_DVBSKY
> and everything seems to work.
> 
> Unfortunately (for me), I've been asked to make this driver work on
> an ancient 3.4 kernel.
> 
> The linuxtv article mentions:
> 
> "Drivers are included in kernel 3.17 (for version 1) and 3.19 (for version 2).
> They can be built with media_build for older kernels."
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> This seems to imply that I can use the media_build framework to
> automatically (??) back-port a 3.19 driver to a 3.4 kernel?

"automatically" is a complex word ;)

> This sounds too good to be true...
> How far back can I go?

The goal is to allow compilation since 2.6.32, but please notice that
not all drivers will go that far. Basically, when the backport seems too
complex, we just remove the driver from the list of drivers that are
compiled for a given legacy version.

Se the file v4l/versions.txt to double-check if the drivers you need
have such restrictions. I suspect that, in the specific case of
DVB_USB_DVBSKY, it should compile.

That doesn't mean that it was tested there. We don't test those
backports to check against regressions. We only work, at best
effort basis, to make them to build. So, use it with your own
risk. If you find any problems, feel free to send us patches
fixing it.

> 
> http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers
> 
> I find the instructions not very clear.

Feel free to improve them ;)

> 
> I have cloned media_tree and media_build. And I have my 3.4 kernel source
> in a separate "my-linux-3.4" dir.
> 
> How am I supposed to tell media_build: "hey, the latest drivers are in this
> "media_tree" dir, I'd like you to compile this one driver for the kernel in
> this "my-linux-3.4" dir" ?

if the headers for version 3.4 aren't installed, see:

$ make help
...
release		- Allows changing kernel version.
		  Typical usage is:
			make release VER=2.6.12-18mdk
			(to force compiling to 2.6.12-18mdk)
			(This will work only if
			 /lib/modules/2.6.12-18mdk/build/
			 points to that kernel version)
		  Or
			make release DIR=~/linux-git
			(to force using kernel at a specific dir)
		  To use current kernel version instead:
			make release


> 
> Note that media_build/linux has scripts which reference include/uapi which
> did not exist yet in 3.4
> 
> Anyway, my confusion level is at 11. I'd be very grateful if anyone here
> can clear some of it!
> 
> Regards.
