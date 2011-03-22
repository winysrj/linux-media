Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:30299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754229Ab1CVAkk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2011 20:40:40 -0400
Message-ID: <4D87F005.4070602@redhat.com>
Date: Mon, 21 Mar 2011 21:40:37 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] v180 - DM04/QQBOX added support for BS2F7HZ0194 versions
References: <1297560908.24985.5.camel@tvboxspy>	 <4D87EAA7.2040803@redhat.com> <1300753968.15997.4.camel@localhost>
In-Reply-To: <1300753968.15997.4.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 21-03-2011 21:32, Malcolm Priestley escreveu:
> On Mon, 2011-03-21 at 21:17 -0300, Mauro Carvalho Chehab wrote:
>> Em 12-02-2011 23:35, Malcolm Priestley escreveu:
>>> Old versions of these boxes have the BS2F7HZ0194 tuner module on
>>> both the LME2510 and LME2510C.
>>>
>>> Firmware dvb-usb-lme2510-s0194.fw  and/or dvb-usb-lme2510c-s0194.fw
>>> files are required.
>>>
>>> See Documentation/dvb/lmedm04.txt
>>>
>>> Patch 535181 is also required.
>>>
>>> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
>>> ---
>>
>>> @@ -1110,5 +1220,5 @@ module_exit(lme2510_module_exit);
>>>  
>>>  MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
>>>  MODULE_DESCRIPTION("LME2510(C) DVB-S USB2.0");
>>> -MODULE_VERSION("1.76");
>>> +MODULE_VERSION("1.80");
>>>  MODULE_LICENSE("GPL");
>>
>>
>> There were a merge conflict on this patch. The version we have was 1.75.
>>
>> Maybe some patch got missed?
> 
> 1.76 relates to remote control patches.
> 
> https://patchwork.kernel.org/patch/499391/
> https://patchwork.kernel.org/patch/499401/

Ah! Ok, I'll be applying them. Btw, please, move the keycode tables to the
proper place and use the RC core stuff. The idea is to remove all those keytables
from kernel in a near future, and use the userspace tool to load it via udev.

Thanks!
Mauro
