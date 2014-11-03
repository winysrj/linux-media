Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:26177 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaKCUeZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Nov 2014 15:34:25 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NEH00748D5C9YB0@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 03 Nov 2014 15:34:24 -0500 (EST)
Date: Mon, 03 Nov 2014 18:34:19 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
	linux-media@vger.kernel.org
Subject: Re: [linuxtv-media:master 489/499]
 drivers/media/usb/cx231xx/cx231xx-audio.c:445:16-20: ERROR: dev is NULL but
 dereferenced.
Message-id: <20141103183419.2d9323ba.m.chehab@samsung.com>
In-reply-to: <alpine.DEB.2.02.1411032120180.2038@localhost6.localdomain6>
References: <201411040301.F0BzMPnl%fengguang.wu@intel.com>
 <alpine.DEB.2.02.1411032120180.2038@localhost6.localdomain6>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 03 Nov 2014 21:20:42 +0100
Julia Lawall <julia.lawall@lip6.fr> escreveu:

> Clearly a bug.

Actually, this is a bogus test. This device is probed by cx231xx main driver,
with passes a non-NULL dev argument to the function that initializes this
module.

So, it is not possible for it to be NULL.

Thanks for reporting!
I'm sending a patch that removes the bogus check.

Regards,
Mauro

> 
> On Tue, 4 Nov 2014, kbuild test robot wrote:
> 
> > TO: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > CC: linux-media@vger.kernel.org
> > 
> > tree:   git://linuxtv.org/media_tree.git master
> > head:   ed3da2bf2e1800e7c6e31e7d31917dacce599458
> > commit: b7085c08647598aafbf8f6223ebcdd413745449c [489/499] [media] cx231xx: convert from pr_foo to dev_foo
> > :::::: branch date: 81 minutes ago
> > :::::: commit date: 2 hours ago
> > 
> > >> drivers/media/usb/cx231xx/cx231xx-audio.c:445:16-20: ERROR: dev is NULL but dereferenced.
> > 
> > git remote add linuxtv-media git://linuxtv.org/media_tree.git
> > git remote update linuxtv-media
> > git checkout b7085c08647598aafbf8f6223ebcdd413745449c
> > vim +445 drivers/media/usb/cx231xx/cx231xx-audio.c
> > 
> > e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  429  	.buffer_bytes_max = 62720 * 8,	/* just about the value in usbaudio.c */
> > e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  430  	.period_bytes_min = 64,		/* 12544/2, */
> > e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  431  	.period_bytes_max = 12544,
> > e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  432  	.periods_min = 2,
> > e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  433  	.periods_max = 98,		/* 12544, */
> > e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  434  };
> > e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  435  
> > e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  436  static int snd_cx231xx_capture_open(struct snd_pcm_substream *substream)
> > e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  437  {
> > e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  438  	struct cx231xx *dev = snd_pcm_substream_chip(substream);
> > e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  439  	struct snd_pcm_runtime *runtime = substream->runtime;
> > e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  440  	int ret = 0;
> > e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  441  
> > e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  442  	dprintk("opening device and trying to acquire exclusive lock\n");
> > e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  443  
> > e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  444  	if (!dev) {
> > b7085c08 drivers/media/usb/cx231xx/cx231xx-audio.c   Mauro Carvalho Chehab 2014-11-02 @445  		dev_err(&dev->udev->dev,
> > b7085c08 drivers/media/usb/cx231xx/cx231xx-audio.c   Mauro Carvalho Chehab 2014-11-02  446  			"BUG: cx231xx can't find device struct. Can't proceed with open\n");
> > e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  447  		return -ENODEV;
> > e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  448  	}
> > e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  449  
> > 990862a2 drivers/media/video/cx231xx/cx231xx-audio.c Mauro Carvalho Chehab 2012-01-10  450  	if (dev->state & DEV_DISCONNECTED) {
> > b7085c08 drivers/media/usb/cx231xx/cx231xx-audio.c   Mauro Carvalho Chehab 2014-11-02  451  		dev_err(&dev->udev->dev,
> > b7085c08 drivers/media/usb/cx231xx/cx231xx-audio.c   Mauro Carvalho Chehab 2014-11-02  452  			"Can't open. the device was removed.\n");
> > 990862a2 drivers/media/video/cx231xx/cx231xx-audio.c Mauro Carvalho Chehab 2012-01-10  453  		return -ENODEV;
> > 
> > ---
> > 0-DAY kernel test infrastructure                Open Source Technology Center
> > http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
> > 
