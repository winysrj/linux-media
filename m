Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198]:40191 "EHLO
	mta3.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbZGTQiw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2009 12:38:52 -0400
Received: from host143-81.hauppauge.com
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta3.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KN3005E3A8OH350@mta3.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Mon, 20 Jul 2009 12:38:48 -0400 (EDT)
Date: Mon, 20 Jul 2009 12:38:44 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: potential null deref in mpeg_open()
In-reply-to: <alpine.DEB.2.00.0907171457580.12306@bicker>
To: Dan Carpenter <error27@gmail.com>
Cc: mjpeg-users@lists.sourceforge.net, linux-media@vger.kernel.org
Message-id: <4A649D94.6050609@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <alpine.DEB.2.00.0907171457580.12306@bicker>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 7/19/09 7:47 AM, Dan Carpenter wrote:
> Hello,
>
> I am testing a source checker (http://repo.or.cz/w/smatch.git) and it
> found a bug in in mpeg_open() from drivers/media/video/cx23885/cx23885-417.c
>
> "dev" is null on line 1554, so on line 1558 dprintk() will cause a
> kernel oops if it is in debug mode.
>
> drivers/media/video/cx23885/cx23885-417.c
>    1554          struct cx23885_dev *h, *dev = NULL;
>    1555          struct list_head *list;
>    1556          struct cx23885_fh *fh;
>    1557
>    1558          dprintk(2, "%s()\n", __func__);
>
> Here is how dprintk() is defined earlier.
>
> drivers/media/video/cx23885/cx23885-417.c
>      59  #define dprintk(level, fmt, arg...)\
>      60          do { if (v4l_debug>= level) \
>      61                  printk(KERN_DEBUG "%s: " fmt, dev->name , ## arg);\
>      62          } while (0)
>
> regards,
> dan carpenter

Thanks Dan,

I'd actually seen this three weeks ago when addressing another issue, although 
thanks for raising it. We're pushing a fix for this, and a few other fixes, 
later today.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
