Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755506Ab0FHOvA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Jun 2010 10:51:00 -0400
Message-ID: <4C0E58B8.3010004@redhat.com>
Date: Tue, 08 Jun 2010 11:50:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: vdr@helmutauer.de
CC: jarod@wilsonet.com, linux-media@vger.kernel.org
Subject: Re: v4l-dvb - Is it still usable for a distribution ?
References: <20100608085644.73E9B10FC098@dd16922.kasserver.com>
In-Reply-To: <20100608085644.73E9B10FC098@dd16922.kasserver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 08-06-2010 05:56, vdr@helmutauer.de escreveu:
> Hi
> 
>>> Is your imon driver fully compatible with the lirc_imon in the display part ?
>>
>> Yes, works perfectly fine with the exact same lcdproc setup here --
>> both vfd and lcd tested.
>>
>>> It would be very helpful to add a parameter for disabling the IR Part, I have many users which
>>> are using only the display part.
>>
>> Hm. I was going to suggest that if people aren't using the receiver,
>> there should be no need to disable IR, but I guess someone might want
>> to use an mce remote w/an mce receiver, and that would have
>> interesting results if they had one of the imon IR receivers
>> programmed for mce mode. I'll keep it in mind for the next time I'm
>> poking at the imon code in depth. Need to finish work on some of the
>> other new ir/rc bits first (you'll soon be seeing the mceusb driver
>> ported to the new infra also in v4l-dvb hg, as well as an lirc bridge
>> driver, which is currently my main focal point).
>>
> Just one more question.
> Your driver is missing the ir_protocol parameter. How can I switch between Native Imon and RC-6 ?

With the IR subsystem, the protocol changes are done via sysfs. The 
ir-keytable program, at v4l-utils git tree, allows controlling the 
enabled protocols and changing the IR keytable.

Cheers,
Mauro.
