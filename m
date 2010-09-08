Return-path: <mchehab@pedra>
Received: from bombadil.infradead.org ([18.85.46.34]:41831 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab0IHXtG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 19:49:06 -0400
Message-ID: <4C8820ED.4070402@infradead.org>
Date: Wed, 08 Sep 2010 20:49:01 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Jarod Wilson <jarod@redhat.com>, Jarod Wilson <jarod@wilsonet.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	lirc-list@lists.sourceforge.net,
	=?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 7/8] IR: extend ir_raw_event and do refactoring
References: <1283808373-27876-1-git-send-email-maximlevitsky@gmail.com>	 <1283808373-27876-8-git-send-email-maximlevitsky@gmail.com>	 <AANLkTinr6mN=t=vNnR3pSBxXb0ud=Ymrqn_WyDNkUJTz@mail.gmail.com>	 <1283964646.6372.90.camel@morgan.silverblock.net>	 <20100908172708.GH22323@redhat.com> <1283986953.29812.24.camel@morgan.silverblock.net>
In-Reply-To: <1283986953.29812.24.camel@morgan.silverblock.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Em 08-09-2010 20:02, Andy Walls escreveu:
> On Wed, 2010-09-08 at 13:27 -0400, Jarod Wilson wrote:
 
>>>>  I'd be inclined to
>>>> simply move duty_cycle out of the union and leave just duration and
>>>> carrier in it.
>>>
>>> That's not necessary and it could be confusing depending on where you
>>> put duty_cycle.
>>
>> There's that. But without having code that actually uses duty_cycle in a
>> meaningful way yet, its hard to say for sure. If carrier and duty_cycle
>> were only being sent out in their own events, you might actually want a
>> union of duration, carrier and duty_cycle. Though I suspect we'll probably
>> want to pass along carrier and duty_cycle at the same time.
> 
> I suspect you're right on that.  I don't have any experience with
> hardware that can actually estimate carrier freq or duty cycle.  I
> suspect they can be measured together using edge detection on both
> rising and falling edges.

As duty cycle is not currently used, the better is to just remove it from
the struct, adding it on a separate patch, together with a code that will
need it.

Cheers,
Mauro
