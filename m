Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040Ab0DIOVb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Apr 2010 10:21:31 -0400
Message-ID: <4BBF37D9.2060206@redhat.com>
Date: Fri, 09 Apr 2010 11:21:13 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Oliver Endriss <o.endriss@gmx.de>
CC: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
	linux-media@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] V4L/DVB: budget-av: wait longer for frontend to power
 on
References: <1269200787-30681-1-git-send-email-bjorn@mork.no> <4BBE477E.80006@redhat.com> <201004091607.18364@orion.escape-edv.de>
In-Reply-To: <201004091607.18364@orion.escape-edv.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Oliver Endriss wrote:
> Mauro Carvalho Chehab wrote:
>> Bjørn Mork wrote:
>>> Some devices need much more time than 100ms to power on, leading to a
>>> failure to enable the frontend on the first attempt. Instead we get
>>>
>>> [   38.194200] saa7146: register extension 'budget_av'.
>>> [   38.253828] budget_av 0000:05:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
>>> [   38.601572] saa7146: found saa7146 @ mem ffffc90000c6ac00 (revision 1, irq 17) (0x1894,0x0022).
>>> [   39.251324] saa7146 (0): dma buffer size 1347584
>>> [   39.306757] DVB: registering new adapter (KNC1 DVB-C MK3)
>>> [   39.462785] adapter failed MAC signature check
>>> [   39.516159] encoded MAC from EEPROM was ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
>>> [   39.892397] KNC1-0: MAC addr = 00:09:d6:6d:94:5c
>>> [   40.552028] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
>>> [   40.580044] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
>>> [   40.608026] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
>>> [   40.636027] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
>>> [   40.652026] DVB: TDA10023(-1): tda10023_writereg, writereg error (reg == 0x00, val == 0x33, ret == -5)
>>> [   40.664027] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
>>> [   40.692027] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
>>> [   40.720027] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
>>> [   40.748027] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
>>> [   40.764025] DVB: TDA10023(-1): tda10023_readreg: readreg error (reg == 0x1a, ret == -5)
>>> [   40.764067] budget-av: A frontend driver was not found for device [1131:7146] subsystem [1894:0022]
>>>
>>> Unloading and the reloading the driver will work around this problem.  But
>>> it can also be easily fixed by increasing the wait period after powering
>>> on.  The optimum value is unclear to me.  But I've found the 500 ms is not
>>> enough.  5 s is enough for my card, but might be more than actually needed.
>>> However, as long as we don't handle this failure more gracefully, then the
>>> timeout need to be long enough.
>>>
>>> Signed-off-by: Bjørn Mork <bjorn@mork.no>
>>> Cc: stable@kernel.org
>>> ---
>>> Hello,
>>>
>>> I have recently bought a KNC1 clone, called Mystique CaBiX-C2.  This card 
>>> would just not work on reboot in my system, giving the errors shown above.
>>> Unloading the module and then loading it again always fixed the problem,
>>> indicating that it was just a startup timing problem.
>>>
>>> As you can see, the i2c timeouts are from the frontend attach function, 
>>> tda10023_attach():
>>> 	/* wakeup if in standby */
>>> 	tda10023_writereg (state, 0x00, 0x33);
>>> 	/* check if the demod is there */
>>> 	if ((tda10023_readreg(state, 0x1a) & 0xf0) != 0x70) goto error;
>>>
>>> cleary showing that it just isn't responding yet at that point.
>>>
>>> I first tried increasing the msleep() to 500 ms, but still got the same
>>> error.  Increasing it to 5000 ms helped, however, and made my card work
>>> from boot.  I have not tried any values inbetween, as each attempt AFAIK
>>> requires a reboot to get the card into the "cold state" where it will
>>> fail.
>>>
>>> dmesg with the patch installed:
>>>
>>> [   37.786955] saa7146: register extension 'budget_av'.
>>> [   37.846592] budget_av 0000:05:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
>>> [   37.933318] saa7146: found saa7146 @ mem ffffc90000c70c00 (revision 1, irq 17) (0x1894,0x0022).
>>> [   38.037851] saa7146 (0): dma buffer size 1347584
>>> [   38.093224] DVB: registering new adapter (KNC1 DVB-C MK3)
>>> [   38.194254] adapter failed MAC signature check
>>> [   38.247527] encoded MAC from EEPROM was ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
>>> [   38.622678] KNC1-0: MAC addr = 00:09:d6:6d:94:5c
>>> [   43.765897] DVB: registering adapter 0 frontend 0 (Philips TDA10023 DVB-C)...
>>> [   43.851587] budget-av: ci interface initialised.
>>>
>>> Please consider this patch.  Or maybe it is possible to wait smarter,
>>> testing actual frontend power status instead of just a blind sleep?
>>>
>>> I've also included a CC stable as I've had the same problem with the 2.6.32
>>> and 2.6.33 stable drivers.
>> Are you sure you really need 5 seconds to initialize? This time is probably
>> board-specific, and shouldn't be applied as-is. So, if you really need such
>> high timeout, it should be added inside the switch.
>>
>> I dunno if is there a way to test if the power-on cycle has completed,
>> but for sure an approach like that would be better than blindly waiting
>> for 5 secs.
> 
> Mauro, please do not apply this patch!

Don't worry, I won't apply this patch.
> 
> Afaik there is no tuner which takes 5 seconds to initialize. (And if
> there was one, it would be a bad idea to add a 5s delay for all tuners!)

Yes, that's my point: if is there such hardware, the fix should touch
only on the hardware with that broken design.

(btw, there is one tuner that takes almost 30 seconds to initialize:
the firmware load for xc3028 on tm6000 rev A should go on slow speed, 
otherwise, it fails loading - the i2c implementation on tm6000 were
really badly designed)

> The saa7146_i2c_writeout errors are likely caused by broken hardware.

I think so.


Cheers,
Mauro
