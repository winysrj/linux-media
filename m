Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([88.190.12.23]:42115 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab2AGO3S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jan 2012 09:29:18 -0500
Received: from skate (humanoidz.org [82.247.183.72])
	by mail.free-electrons.com (Postfix) with ESMTPA id A028B132
	for <linux-media@vger.kernel.org>; Sat,  7 Jan 2012 15:23:58 +0100 (CET)
Date: Sat, 7 Jan 2012 15:29:08 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: linux-media@vger.kernel.org
Subject: Re: cx231xx: possible circular locking dependency detected on 3.2
Message-ID: <20120107152908.3b8a78d8@skate>
In-Reply-To: <20120106224231.455a9896@skate>
References: <20120106224231.455a9896@skate>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le Fri, 6 Jan 2012 22:42:31 +0100,
Thomas Petazzoni <thomas.petazzoni@free-electrons.com> a écrit :

> Hello,
> 
> I'm running the Hauppauge USB-Live 2 device on an ARM OMAP3 platform.
> After loading the cx231xx driver and launching v4l2grab, I immediately
> get:
> 
> [  407.087158] cx231xx #0:  setPowerMode::mode = 48, No Change req.
> [  407.145477] 
> [  407.147064] ======================================================
> [  407.153533] [ INFO: possible circular locking dependency detected ]
> [  407.160095] 3.2.0-00007-gb928298 #18
> [  407.163848] -------------------------------------------------------

One code path is (mmap_sem taken before, video_device lock taken
afterwards) :

 -> sys_mmap_pgoff()
    grabs current->mm->mmap_sem at
    http://lxr.free-electrons.com/source/mm/mmap.c#L1111

    -> do_mmap_pgoff()

       -> mmap_region()

          -> v4l2_mmap()
             grabs struct video_device->lock at 
             http://lxr.free-electrons.com/source/drivers/media/video/v4l2-dev.c#L396

The other code path is (video_device taken first, mmap_sem taken
afterwards) :

 -> v4l2_ioctl()
    grabs video_device->lock at
    http://lxr.free-electrons.com/source/drivers/media/video/v4l2-dev.c#L327

    -> video_ioctl2()

       -> video_usercopy()

          -> __video_do_ioctl()

             -> videobuf_qbuf()
                grabs current->mm->mmap_sem at
                http://lxr.free-electrons.com/source/drivers/media/video/videobuf-core.c#L537

Regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
