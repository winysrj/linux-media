Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:57332 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212Ab0ARUXh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 15:23:37 -0500
Date: Mon, 18 Jan 2010 14:18:19 -0600 (CST)
From: Mike Isely <isely@isely.net>
To: Andy Walls <awalls@radix.net>
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	stoth@kernellabs.com, Hans Verkuil <hverkuil@xs4all.nl>,
	Mike Isely <isely@isely.net>
Subject: Re: Do any drivers access the cx25840 module in an atomic context?
In-Reply-To: <1263791968.5220.87.camel@palomino.walls.org>
Message-ID: <alpine.DEB.1.10.1001181407470.13307@cnc.isely.net>
References: <1263791968.5220.87.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


See below...

On Mon, 18 Jan 2010, Andy Walls wrote:

> Hi,
> 
> I am going to add locking to the cx25840 module register reads and
> writes because I now have a case where a workqueue, a userpace, and/or
> the cx25840 firmware loading workqueue could contend for access to the
> CX2584x or equivalent device.
> 
> I have identiifed the following drivers that actually use this module:
> 
> 	cx231xx, pvrusb2, ivtv, cx23885
> 
> Now here's where I need help, since I don't understand the USB stuff too
> well and there's a lot of code to audit:
> 
> Do any of these modules call the cx25840 routines with either:

For the pvrusb2 driver:

> 
> a. call the cx25840 module subdev functions with a spinlock held ? or

No.  The pvrusb2 driver generally NEVER calls outside of itself with a 
spinlock held and IIRC the places where a spinlock might even be used at 
all are very very short.  (I think the only spot using spinlocks at all 
is where USB streaming transfer buffers are managed which requires 
synchronization with URB completion callbacks.)


> b. call the cx25840 module subdev functions from an interrupt context:
> i.e. a hard irq or tasklet ? or

Nope.  The pvrusb2 driver tries hard to ensure that all calls into 
sub-devices come from the same thread, so locks requirements like that 
are generally avoided.


> c. bypass the normal cx25840_read/write calls with direct I2C access to
> the client address of 0x44 (0x88 >> 1) ?

No, the pvrusb2 driver never autonomously tries to access the chip 
hardware itself.  It wouldn't know what to do with it :-)


> 
> Any definitive confirmation anyone can give on any of these drivers
> would be helpful and would save me some time.
> 

In general with a driver that operates through USB, our "interrupt 
context" is the callback from the URB when it completes or fails.  The 
pvrusb2 driver is designed not to have to call into other things from 
such a callback context.  Other sources of concurrency which might 
require locks would be from multiple userspace clients calling into the 
driver, but even in those cases, the requested actions are handled 
through a work queue so all calls out of the driver into other things 
(like cx25840) should all source from a single common thread context per 
hardware instance.

  -Mike


-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
