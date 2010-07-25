Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab0GYR4x (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jul 2010 13:56:53 -0400
Message-ID: <4C4C7AFC.3050602@redhat.com>
Date: Sun, 25 Jul 2010 14:57:16 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: linux-media@vger.kernel.org, vvvl@onet.pl
Subject: Re: cx23885: Unknown symbol __ir_input_register
References: <Q8994360-053833478ce51cd1e8a0a45c0f796b50@pmq4.m5r2.onet.test.onet.pl>	 <1280061846.2867.5.camel@localhost>  <1280064157.2867.15.camel@localhost> <1280065535.2867.27.camel@localhost>
In-Reply-To: <1280065535.2867.27.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 25-07-2010 10:45, Andy Walls escreveu:
> On Sun, 2010-07-25 at 09:22 -0400, Andy Walls wrote:
>> On Sun, 2010-07-25 at 08:44 -0400, Andy Walls wrote:
>>> On Sat, 2010-07-24 at 18:45 +0200, vvvl@onet.pl wrote:
>>>> with linux-2.6.34-gentoo-r1 and V4L/DVB repository of July 24 I get these errors:
>>>> cx23885: Unknown symbol __ir_input_register
>>>> cx23885: Unknown symbol get_rc_map
>>>
>>> Those are IR related.
>>>
>>> I forgot to add "IR_CORE" to the Kconfig file for the cx23885 driver,
>>> but the the "VIDEO_IR" selection in that Kconfig depends on "IR_CORE",
>>> so I think that should be OK.
>>
>> Hmmm...
>>
>> "select VIDEO_IR" in the cx23885 Kconfig doesn't revisit the
>> dependencies on "IR_CORE" and "INPUT".
>>
>>
>> Mauro,
>>
>> What's the correct thing to do here?
>>
>> Change it to
>>
>> 	"depends VIDEO_IR"
>>
>> or add
>>
>> 	"depends IR_CORE"
>>
>> or add
>>
>> 	"select INPUT"
>> 	"select IR_CORE"
> 
> Bah, the cx23885 driver already has "depends ... && INPUT".
> 
> I'll just add a "select IR_CORE" and remove the "select VIDEO_IR", since
> it looks like the changes I have for cx23885 in the git repo don't use
> the ir-functions.c (ir-common.ko) functions anymore.
> 
> The current hg repository should only have "select IR_CORE" added to the
> cx23885 Kconfig with no removals, untils the code from git gets merged
> back to it.

That's ok for now, but we should really work in a way to allow compiling the drivers
even without INPUT.
> 
> Regards,
> Andy
> 

