Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:3795 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab0ARKQO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 05:16:14 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Subject: Re: Do any drivers access the cx25840 module in an atomic context?
Date: Mon, 18 Jan 2010 11:16:59 +0100
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely <isely@isely.net>, stoth@kernellabs.com
References: <1263791968.5220.87.camel@palomino.walls.org>
In-Reply-To: <1263791968.5220.87.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201001181116.59377.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 18 January 2010 06:19:28 Andy Walls wrote:
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
> 
> a. call the cx25840 module subdev functions with a spinlock held ? or
> b. call the cx25840 module subdev functions from an interrupt context:
> i.e. a hard irq or tasklet ? or
> c. bypass the normal cx25840_read/write calls with direct I2C access to
> the client address of 0x44 (0x88 >> 1) ?
> 
> Any definitive confirmation anyone can give on any of these drivers
> would be helpful and would save me some time.

For ivtv:

a. no
b. no
c. no

BTW: b should never happen. i2c reads/writes are very slow and so it is a
very bad idea to do that in interrupt context. Since there is some low-level
locking in the i2c stack as well I think it will probably not even work
correctly if called from interrupt context.

Note that AFAIK the i2c stack will already serialize i2c commands for you.
So are you sure you need to serialize access on the higher levels as well?

Firmware load should be already serialized in the bridge driver. That leaves
a possible call to cx25840_reset() which can trigger a fw load at any time,
but I believe that can be removed as well since it is only used by the IR
reset code which is obsolete.

At least in ivtv I have never seen any issues with cx25840 and atomic contexts.

Regards,

	Hans

> 
> 
> 
> For the cx23885 driver I think these are the answers:
> 
> 	a. probably not
> 	b. probably not
> 	c. yes 
> 
> but I have to double check.
> 
> I can probably audit the ivtv driver on my own.  I understand it's
> structure, but it's a big driver and will take time to check, if no one
> knows off hand.
> 
> The pvrusb2 and cx231xx will be a little harder for me.  They aren't
> terribly large, but I don't understand USB device "interrupt" contexts.
> 
> TIA.
> 
> Regards,
> Andy
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
