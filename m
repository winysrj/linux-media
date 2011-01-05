Return-path: <mchehab@gaivota>
Received: from zone0.gcu-squad.org ([212.85.147.21]:16080 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab1AEVwl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Jan 2011 16:52:41 -0500
Date: Wed, 5 Jan 2011 22:51:49 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org,
	Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>
Subject: Re: [PATCH 3/3] lirc_zilog: Remove use of deprecated struct
 i2c_adapter.id  field
Message-ID: <20110105225149.1145420b@endymion.delvare>
In-Reply-To: <4D24ABA4.5070100@redhat.com>
References: <1293587067.3098.10.camel@localhost>
	<1293587390.3098.16.camel@localhost>
	<20110105154553.546998bf@endymion.delvare>
	<4D24ABA4.5070100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Mauro,

On Wed, 05 Jan 2011 15:34:28 -0200, Mauro Carvalho Chehab wrote:
> Hi Jean,
> 
> Thanks for your acks for patches 1 and 2. I've already applied the patches 
> on my tree and at linux-next. I'll try to add the acks on it before sending
> upstream.

If you can't, it's fine. I merely wanted to show my support to Andy's
work, I don't care if I'm not counted as a reviewer for these small
patches.

> Em 05-01-2011 12:45, Jean Delvare escreveu:
> > From a purely technical perspective, changing client->addr in the
> > probe() function is totally prohibited.
> 
> Agreed. Btw, there are some other hacks with client->addr abuse on some 
> other random places at drivers/media, mostly at the device bridge code, 
> used to test if certain devices are present and/or to open some I2C gates 
> before doing some init code. People use this approach as it provides a
> fast way to do some things. On several cases, the amount of code for
> doing such hack is very small, when compared to writing a new I2C driver
> just to do some static initialization code. Not sure what would be the 
> better approach to fix them.

Hard to tell without seeing the exact code. Ideally,
i2c_new_dummy() would cover these cases: you don't need to write an
actual driver for the device, it's perfectly OK to use the freshly
instantiated i2c_client from the bridge driver directly. Alternatively,
i2c_smbus_xfer() or i2c_transfer() can be used for one-time data
exchange with any slave on the bus as long as you know what you're
doing (i.e. you know that no i2c_client will ever be instantiated for
this slave.)

If you have specific cases you don't know how to solve, please point me
to them and I'll take a look.

-- 
Jean Delvare
