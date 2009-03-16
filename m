Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:32388 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249AbZCPIfs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 04:35:48 -0400
Date: Mon, 16 Mar 2009 09:35:25 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Andy Walls <awalls@radix.net>, Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: bttv, tvaudio and ir-kbd-i2c probing conflict
Message-ID: <20090316093525.15f3dd62@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.58.0903151637370.28292@shell2.speakeasy.net>
References: <200903151344.01730.hverkuil@xs4all.nl>
	<20090315181207.36d951ac@hyperion.delvare>
	<1237145673.3314.47.camel@palomino.walls.org>
	<Pine.LNX.4.58.0903151637370.28292@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Trent,

On Sun, 15 Mar 2009 16:46:36 -0700 (PDT), Trent Piepho wrote:
> On Sun, 15 Mar 2009, Andy Walls wrote:
> > But the specific problem that Hans' brings up is precisely a Linux
> > kernel I2C subsystem *software* prohibition on two i2c_clients binding
> > to the same address on the same adapter.
> 
> For a lot of i2c devices, it would be difficult for two drivers to access
> the device at the same time without some kind of locking.
> 
> If you take the reads and writes of one driver and then intersperse the
> reads and writes of another driver, the resulting sequence from the i2c
> device's point of view is completely broken.

Correct.

> But, I suppose there are some devices where if the drivers all use
> i2c_smbus_read/write_byte/word_data or equivalent atomic transactions
> with i2c_transfer(), then you could get away with two drivers talking to
> the same chip.

Yes, this may be possible for some devices, but it can't be
generalized. Non-atomic transactions are one problem but there are
others, for example some I2C devices do not have a flat address space
(the same I2C transaction can access different registers depending on
the value of another register commonly known as bank selector.) Another
problem is read-modify-write cycles, which in my experience are often
needed for I2C devices, and which are racy if several drivers attempt
to handle the same device and want to touch the same register.

So, all in all, great care should always be taken when more than one
driver accesses the same I2C device. And even if only one driver
accesses the I2C device, all accesses that can happen in parallel (for
example triggered by sysfs attribute reads or writes) may have to be
serialized by the driver.

-- 
Jean Delvare
