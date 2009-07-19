Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f184.google.com ([209.85.210.184]:61667 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbZGSMpP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 08:45:15 -0400
Received: by yxe14 with SMTP id 14so2910004yxe.33
        for <linux-media@vger.kernel.org>; Sun, 19 Jul 2009 05:45:14 -0700 (PDT)
Date: Sun, 19 Jul 2009 14:47:04 +0300 (EAT)
From: Dan Carpenter <error27@gmail.com>
To: stoth@linuxtv.org
cc: mjpeg-users@lists.sourceforge.net, linux-media@vger.kernel.org
Subject: potential null deref in mpeg_open()
Message-ID: <alpine.DEB.2.00.0907171457580.12306@bicker>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I am testing a source checker (http://repo.or.cz/w/smatch.git) and it 
found a bug in in mpeg_open() from drivers/media/video/cx23885/cx23885-417.c

"dev" is null on line 1554, so on line 1558 dprintk() will cause a 
kernel oops if it is in debug mode.

drivers/media/video/cx23885/cx23885-417.c
  1554          struct cx23885_dev *h, *dev = NULL;
  1555          struct list_head *list;
  1556          struct cx23885_fh *fh;
  1557  
  1558          dprintk(2, "%s()\n", __func__);

Here is how dprintk() is defined earlier.

drivers/media/video/cx23885/cx23885-417.c
    59  #define dprintk(level, fmt, arg...)\
    60          do { if (v4l_debug >= level) \
    61                  printk(KERN_DEBUG "%s: " fmt, dev->name , ## arg);\
    62          } while (0)

regards,
dan carpenter
