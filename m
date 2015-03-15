Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:36827 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbbCOHHX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 03:07:23 -0400
MIME-Version: 1.0
In-Reply-To: <20150314113237.GE970@katana>
References: <54FDA380.8030405@linutronix.de>
	<20150314112703.GD970@katana>
	<20150314113237.GE970@katana>
Date: Sun, 15 Mar 2015 09:07:21 +0200
Message-ID: <CABpLfoiQg1smiebL0=nWX4Sp1H+XD9VViUqGk13gRcfdAwkFoA@mail.gmail.com>
Subject: Re: rt-mutex usage in i2c
From: Mike Rapoport <mike.rapoport@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	linux-i2c@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mike Galbraith <umgwanakikbuti@gmail.com>,
	Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Mar 14, 2015 at 1:32 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> On Sat, Mar 14, 2015 at 12:27:03PM +0100, Wolfram Sang wrote:
>> Hi Sebastian,
>>
>> > - i2c_transfer() has this piece:
>> >   2091                 if (in_atomic() || irqs_disabled()) {
>> >   2092                         ret = i2c_trylock_adapter(adap);
>> >
>> >   is this irqs_disabled() is what bothers me and should not be there.
>> >   pxa does a spin_lock_irq() which would enable interrupts on return /
>> >   too early.
>> >   mxs has a wait_for_completion() which needs irqs enabled _and_ makes
>> >   in_atomic() problematic, too. I have't checked other drivers but the
>> >   commit, that introduced it, does not explain why it is required.

That was some time ago, but as far as I remember, PIO in i2c_pxa was
required to enable communication with PMIC in interrupt context.


>> I haven't really looked into it, but a quick search gave me this thread
>> explaining the intention of the code in question:
>>
>> http://lists.lm-sensors.org/pipermail/i2c/2007-November/002268.html
>>
>> Regards,
>>
>>    Wolfram
>>
>
> And adding a recent mail address from Mike to cc.
>



-- 
Sincerely yours,
Mike.
