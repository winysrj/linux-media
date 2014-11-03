Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:33362
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752458AbaKCUa0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Nov 2014 15:30:26 -0500
Date: Mon, 3 Nov 2014 21:20:42 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: kbuild test robot <fengguang.wu@intel.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
cc: kbuild@01.org, linux-media@vger.kernel.org
Subject: Re: [linuxtv-media:master 489/499] drivers/media/usb/cx231xx/cx231xx-audio.c:445:16-20:
 ERROR: dev is NULL but dereferenced.
In-Reply-To: <201411040301.F0BzMPnl%fengguang.wu@intel.com>
Message-ID: <alpine.DEB.2.02.1411032120180.2038@localhost6.localdomain6>
References: <201411040301.F0BzMPnl%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clearly a bug.

On Tue, 4 Nov 2014, kbuild test robot wrote:

> TO: Mauro Carvalho Chehab <m.chehab@samsung.com>
> CC: linux-media@vger.kernel.org
> 
> tree:   git://linuxtv.org/media_tree.git master
> head:   ed3da2bf2e1800e7c6e31e7d31917dacce599458
> commit: b7085c08647598aafbf8f6223ebcdd413745449c [489/499] [media] cx231xx: convert from pr_foo to dev_foo
> :::::: branch date: 81 minutes ago
> :::::: commit date: 2 hours ago
> 
> >> drivers/media/usb/cx231xx/cx231xx-audio.c:445:16-20: ERROR: dev is NULL but dereferenced.
> 
> git remote add linuxtv-media git://linuxtv.org/media_tree.git
> git remote update linuxtv-media
> git checkout b7085c08647598aafbf8f6223ebcdd413745449c
> vim +445 drivers/media/usb/cx231xx/cx231xx-audio.c
> 
> e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  429  	.buffer_bytes_max = 62720 * 8,	/* just about the value in usbaudio.c */
> e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  430  	.period_bytes_min = 64,		/* 12544/2, */
> e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  431  	.period_bytes_max = 12544,
> e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  432  	.periods_min = 2,
> e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  433  	.periods_max = 98,		/* 12544, */
> e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  434  };
> e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  435  
> e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  436  static int snd_cx231xx_capture_open(struct snd_pcm_substream *substream)
> e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  437  {
> e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  438  	struct cx231xx *dev = snd_pcm_substream_chip(substream);
> e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  439  	struct snd_pcm_runtime *runtime = substream->runtime;
> e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  440  	int ret = 0;
> e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  441  
> e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  442  	dprintk("opening device and trying to acquire exclusive lock\n");
> e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  443  
> e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  444  	if (!dev) {
> b7085c08 drivers/media/usb/cx231xx/cx231xx-audio.c   Mauro Carvalho Chehab 2014-11-02 @445  		dev_err(&dev->udev->dev,
> b7085c08 drivers/media/usb/cx231xx/cx231xx-audio.c   Mauro Carvalho Chehab 2014-11-02  446  			"BUG: cx231xx can't find device struct. Can't proceed with open\n");
> e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  447  		return -ENODEV;
> e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  448  	}
> e0d3bafd drivers/media/video/cx231xx/cx231xx-audio.c Sri Deevi             2009-03-03  449  
> 990862a2 drivers/media/video/cx231xx/cx231xx-audio.c Mauro Carvalho Chehab 2012-01-10  450  	if (dev->state & DEV_DISCONNECTED) {
> b7085c08 drivers/media/usb/cx231xx/cx231xx-audio.c   Mauro Carvalho Chehab 2014-11-02  451  		dev_err(&dev->udev->dev,
> b7085c08 drivers/media/usb/cx231xx/cx231xx-audio.c   Mauro Carvalho Chehab 2014-11-02  452  			"Can't open. the device was removed.\n");
> 990862a2 drivers/media/video/cx231xx/cx231xx-audio.c Mauro Carvalho Chehab 2012-01-10  453  		return -ENODEV;
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
> 
