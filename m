Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:30380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322Ab1CVXAo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 19:00:44 -0400
Message-ID: <4D892A0D.9090505@redhat.com>
Date: Tue, 22 Mar 2011 20:00:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] v180 - DM04/QQBOX added support for BS2F7HZ0194 versions
References: <1297560908.24985.5.camel@tvboxspy>	 <4D87EAA7.2040803@redhat.com> <1300753968.15997.4.camel@localhost>	 <4D87F0CB.2090705@iki.fi> <1300831959.2048.25.camel@localhost>
In-Reply-To: <1300831959.2048.25.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 22-03-2011 19:12, Malcolm Priestley escreveu:
> On Tue, 2011-03-22 at 02:43 +0200, Antti Palosaari wrote:
>> On 03/22/2011 02:32 AM, Malcolm Priestley wrote:
>>> On Mon, 2011-03-21 at 21:17 -0300, Mauro Carvalho Chehab wrote:
>>>> Em 12-02-2011 23:35, Malcolm Priestley escreveu:
>>>>> Old versions of these boxes have the BS2F7HZ0194 tuner module on
>>>>> both the LME2510 and LME2510C.
>>>>>
>>>>> Firmware dvb-usb-lme2510-s0194.fw  and/or dvb-usb-lme2510c-s0194.fw
>>>>> files are required.
>>>>>
>>>>> See Documentation/dvb/lmedm04.txt
>>>>>
>>>>> Patch 535181 is also required.
>>>>>
>>>>> Signed-off-by: Malcolm Priestley<tvboxspy@gmail.com>
>>>>> ---
>>>>
>>>>> @@ -1110,5 +1220,5 @@ module_exit(lme2510_module_exit);
>>>>>
>>>>>   MODULE_AUTHOR("Malcolm Priestley<tvboxspy@gmail.com>");
>>>>>   MODULE_DESCRIPTION("LME2510(C) DVB-S USB2.0");
>>>>> -MODULE_VERSION("1.76");
>>>>> +MODULE_VERSION("1.80");
>>>>>   MODULE_LICENSE("GPL");
>>>>
>>>>
>>>> There were a merge conflict on this patch. The version we have was 1.75.
>>>>
>>>> Maybe some patch got missed?
>>>
>>> 1.76 relates to remote control patches.
>>>
>>> https://patchwork.kernel.org/patch/499391/
>>> https://patchwork.kernel.org/patch/499401/
>>
>> Those are NEC extended remotes. You are now setting it as 32 bit NEC, in 
>> my understanding it should be defined as 24 bit NEC extended.
>>
>> Anyhow, my opinion is still that we *should* make all NEC remotes as 32 
>> bit and leave handling of NEC 16, NEC 24, NEC 32 to NEC decoder. For 
>> example AF9015 current NEC handling is too complex for that reason... I 
>> don't like how it is implemented currently.
> 
> One of the reasons for using 32 bit was interference from other consumer
> remotes.  It appears, these near identical bubble remotes originate from
> a Chinese factory and supplied with the same product with completely
> different key mapping.
> 
> I am not sure how many of these remotes are common to other devices.

Drivers should get the 32 bit codes form NEC when hardware provides it.
What we currently do is to identify if the code has 16, 24 or 32 bits,
but it is probably better to always handle them as if they have 32 bits.
> 
> Regards
> 
> 
> Malcolm
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

