Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:37785 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933055AbbCPUvB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 16:51:01 -0400
Message-ID: <55074230.20307@linutronix.de>
Date: Mon, 16 Mar 2015 21:50:56 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
MIME-Version: 1.0
To: Mike Rapoport <mike.rapoport@gmail.com>,
	Wolfram Sang <wsa@the-dreams.de>
CC: linux-i2c@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mike Galbraith <umgwanakikbuti@gmail.com>,
	Jean Delvare <khali@linux-fr.org>
Subject: Re: rt-mutex usage in i2c
References: <54FDA380.8030405@linutronix.de>	<20150314112703.GD970@katana>	<20150314113237.GE970@katana> <CABpLfoiQg1smiebL0=nWX4Sp1H+XD9VViUqGk13gRcfdAwkFoA@mail.gmail.com>
In-Reply-To: <CABpLfoiQg1smiebL0=nWX4Sp1H+XD9VViUqGk13gRcfdAwkFoA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/15/2015 08:07 AM, Mike Rapoport wrote:
> On Sat, Mar 14, 2015 at 1:32 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
>> On Sat, Mar 14, 2015 at 12:27:03PM +0100, Wolfram Sang wrote:
>>> Hi Sebastian,
>>>
>>>> - i2c_transfer() has this piece:
>>>>   2091                 if (in_atomic() || irqs_disabled()) {
>>>>   2092                         ret = i2c_trylock_adapter(adap);
>>>>
>>>>   is this irqs_disabled() is what bothers me and should not be there.
>>>>   pxa does a spin_lock_irq() which would enable interrupts on return /
>>>>   too early.
>>>>   mxs has a wait_for_completion() which needs irqs enabled _and_ makes
>>>>   in_atomic() problematic, too. I have't checked other drivers but the
>>>>   commit, that introduced it, does not explain why it is required.
> 
> That was some time ago, but as far as I remember, PIO in i2c_pxa was
> required to enable communication with PMIC in interrupt context.

Let me add one thing I forgot: the locking is using raw locks which are
not irq safe. It usually works. But. If the wait_lock is hold during
the unlock's slow path (that means there is no owner but the owner
field is not yet NULL) and the interrupt handler gets here with a
try_lock attempt then and it will spin forever on the wait_lock.

I will try to lookup the threads later…

Sebastian
