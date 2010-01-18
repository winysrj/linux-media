Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:52367 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714Ab0ARFUU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 00:20:20 -0500
Subject: Do any drivers access the cx25840 module in an atomic context?
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely <isely@isely.net>, stoth@kernellabs.com,
	hverkuil@xs4all.nl
Content-Type: text/plain
Date: Mon, 18 Jan 2010 00:19:28 -0500
Message-Id: <1263791968.5220.87.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am going to add locking to the cx25840 module register reads and
writes because I now have a case where a workqueue, a userpace, and/or
the cx25840 firmware loading workqueue could contend for access to the
CX2584x or equivalent device.

I have identiifed the following drivers that actually use this module:

	cx231xx, pvrusb2, ivtv, cx23885

Now here's where I need help, since I don't understand the USB stuff too
well and there's a lot of code to audit:

Do any of these modules call the cx25840 routines with either:

a. call the cx25840 module subdev functions with a spinlock held ? or
b. call the cx25840 module subdev functions from an interrupt context:
i.e. a hard irq or tasklet ? or
c. bypass the normal cx25840_read/write calls with direct I2C access to
the client address of 0x44 (0x88 >> 1) ?

Any definitive confirmation anyone can give on any of these drivers
would be helpful and would save me some time.



For the cx23885 driver I think these are the answers:

	a. probably not
	b. probably not
	c. yes 

but I have to double check.

I can probably audit the ivtv driver on my own.  I understand it's
structure, but it's a big driver and will take time to check, if no one
knows off hand.

The pvrusb2 and cx231xx will be a little harder for me.  They aren't
terribly large, but I don't understand USB device "interrupt" contexts.

TIA.

Regards,
Andy

