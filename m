Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:52839 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756878Ab0GBJJv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Jul 2010 05:09:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Samuel Xu <samuel.xu.tech@gmail.com>
Subject: Re: Question on newly build uvcvideo.ko
Date: Fri, 2 Jul 2010 11:10:24 +0200
Cc: linux-media@vger.kernel.org
References: <AANLkTilsMviOOwo1IWpyfNkd5jeSMU9SozqvgcamBdF_@mail.gmail.com> <201006251132.52431.laurent.pinchart@ideasonboard.com> <AANLkTikn3OCc7V2IiwQaetoVmt1flFaVN5zHQz_7S_ri@mail.gmail.com>
In-Reply-To: <AANLkTikn3OCc7V2IiwQaetoVmt1flFaVN5zHQz_7S_ri@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007021110.25211.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Samuel,

On Friday 25 June 2010 12:01:42 Samuel Xu wrote:
> One correction: After make and make install, uvcvideo module can't
> auto loaded any more. I must manually "insmod uvcvideo.ko" to load it.
> 
> Here is lsmod result, I never have chance to make uvcvideo module used
> bit to 1 :(
> [root@user-desktop uvc]# lsmod
> Module                  Size  Used by
> uvcvideo               46182  0
> rt2860sta             406917  1
> battery                 7968  0
> 
> After 2 questions, there is dmesg from uvcvideo after my manually
> insmod, any idea?
> Another question is: If newest v4l code tree has been advanced much
> than src tree inside 2.6.33 kernel, which v4l src label is nearest
> from src tree inside 2.6.33 kernel?
> 3rdd question is: if I want to build v4l driver from src inside 2.6.33
> kernel directly. How should I do? (I tried to make menuconfig and make
> modules from a clean kernel, while insmod the newly build uvcvideo.ko
> reports: insmod: error inserting './uvcvideo.ko': -1 Invalid module
> format

You can checkout the latest v4l-dvb source from mercurial (or download a 
snapshot), and run

make SRCDIR=/path/to/your/kernel/2.6.33/source/tree

Make sure your kernel source tree has been configured (you might need to 
compile it as well, not sure about that).

> [   78.446109] uvcvideo: Found UVC 1.00 device CNF7129 (04f2:b071)
> [   78.462540] ------------[ cut here ]------------
> [   78.462569] WARNING: at drivers/media/video/v4l2-dev.c:420
> __video_register_device+0x44/0x3d7()

[snip]

I'm pretty sure this is a mismatch between the uvcvideo and videodev kernel 
modules. Please reinstall the whole v4l-dvb subsystem, either from your 
distribution packages or from the v4l-dvb repository. Make sure both the 
uvcvideo driver and the v4l-dvb core come from the same source.

-- 
Regards,

Laurent Pinchart
