Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134Ab0G1R7u (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 13:59:50 -0400
Message-ID: <4C50701B.4030807@redhat.com>
Date: Wed, 28 Jul 2010 14:59:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/9] IR: minor fixes:
References: <1280330051-27732-1-git-send-email-maximlevitsky@gmail.com>	 <1280330051-27732-3-git-send-email-maximlevitsky@gmail.com>	 <4C505451.8030809@redhat.com> <1280335110.28785.12.camel@localhost.localdomain>
In-Reply-To: <1280335110.28785.12.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 28-07-2010 13:38, Maxim Levitsky escreveu:
> On Wed, 2010-07-28 at 13:01 -0300, Mauro Carvalho Chehab wrote:
>> Em 28-07-2010 12:14, Maxim Levitsky escreveu:
>>> * lirc: Don't propagate reset event to userspace
>>> * lirc: Remove strange logic from lirc that would make first sample always be pulse
>>> * Make TO_US macro actualy print what it should.
>>>
>>> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
>>> ---
>>>  drivers/media/IR/ir-core-priv.h  |    3 +--
>>>  drivers/media/IR/ir-lirc-codec.c |   14 ++++++++------
>>>  drivers/media/IR/ir-raw-event.c  |    3 +++
>>>  3 files changed, 12 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/IR/ir-core-priv.h
>>> index babd520..8ce80e4 100644
>>> --- a/drivers/media/IR/ir-core-priv.h
>>> +++ b/drivers/media/IR/ir-core-priv.h
>>> @@ -76,7 +76,6 @@ struct ir_raw_event_ctrl {
>>>  	struct lirc_codec {
>>>  		struct ir_input_dev *ir_dev;
>>>  		struct lirc_driver *drv;
>>> -		int lircdata;
>>>  	} lirc;
>>>  };
>>>  
>>> @@ -104,7 +103,7 @@ static inline void decrease_duration(struct ir_raw_event *ev, unsigned duration)
>>>  		ev->duration -= duration;
>>>  }
>>>  
>>> -#define TO_US(duration)			(((duration) + 500) / 1000)
>>> +#define TO_US(duration)			((duration) / 1000)
>>
>> It is better to keep rounding the duration to its closest value.
> 
> But that breaks if duration is already at maximum. At that case,
> you see usual signed int wrap from positive to negative, and abnormally
> large space...
> 
> I didn't notice though that you do rounding here.
> I replace that with something better.

There's a function for rounding at kernel. The better is to use it, as it should already
solve the signal wrap.

Cheers,
Mauro
