Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59408 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933678AbZE0SlJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2009 14:41:09 -0400
Date: Wed, 27 May 2009 15:41:07 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Matt Doran <matt.doran@papercut.com>
Cc: linux-media@vger.kernel.org
Subject: Re: videodev: Unknown symbol i2c_unregister_device (in kernels
 older than 2.6.26)
Message-ID: <20090527154107.6b79a160@pedra.chehab.org>
In-Reply-To: <4A19D3D9.9010800@papercut.com>
References: <4A19D3D9.9010800@papercut.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 25 May 2009 09:10:17 +1000
Matt Doran <matt.doran@papercut.com> escreveu:

> Hi there,
> 
> I tried using the latest v4l code on an Mythtv box running 2.6.20, but 
> the v4l videodev module fails to load with the following warnings:
> 
>     videodev: Unknown symbol i2c_unregister_device
>     v4l2_common: Unknown symbol v4l2_device_register_subdev
> 
> 
> It seems the "i2c_unregister_device" function was added in 2.6.26.   
> References to this function in v4l2-common.c are enclosed in an ifdef like:
> 
>     #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
> 
> 
> However in "v4l2_device_unregister()" in v4l2-device.c, there is a 
> reference to "i2c_unregister_device" without any ifdefs.   I am running 
> a pretty old kernel, but I'd guess anyone running 2.6.25 or earlier will 
> have this problem.   It seems this code was added by Mauro 3 weeks ago 
> in this rev:
> 
>     http://linuxtv.org/hg/v4l-dvb/rev/87afa7a4ccdf

I've just applied a patch at the tree that should fix this issue. It adds
several tests and the code, but, hopefully, it should be possible even to use
the IR's with kernels starting from 2.6.16.



Cheers,
Mauro
