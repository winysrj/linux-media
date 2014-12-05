Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:37701 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbaLEXXb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Dec 2014 18:23:31 -0500
Date: Sat, 6 Dec 2014 00:23:27 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Felipe Balbi <balbi@ti.com>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH] usb: hcd: get/put device and hcd for hcd_buffers()
Message-ID: <20141205232327.GB4854@linutronix.de>
References: <20141205200357.GA1586@linutronix.de>
 <Pine.LNX.4.44L0.1412051543510.1032-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1412051543510.1032-100000@iolanthe.rowland.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Alan Stern | 2014-12-05 16:21:02 [-0500]:

>On Fri, 5 Dec 2014, Sebastian Andrzej Siewior wrote:
>> So instead, I hold the device struct in the HCD and the HCD struct on
>> every USB-buf-alloc. That means after a disconnect we still have a
>> refcount on usb_hcd and device and it will be cleaned "later" once the
>> last USB-buffer is released.
>
>This is not a valid solution.  Notice that your _hcd_buffer_free still 
>dereferences hcd->driver; that will not point to anything useful if you 
>rmmod the HCD.
Hmm. You're right, that one is gone.

>Also, you neglected to move the calls to hcd_buffer_destroy from 
>usb_remove_hcd to hcd_release.
I add them, I didn't move them.

>On the whole, it would be easier if the UVC driver could release its 
>coherent DMA buffers during the disconnect callback.  If that's not 
>feasible we'll have to find some other solution.

I had one patch doing that. Let me grab it out on Monday.

>Alan Stern
>
Sebastian
