Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932147Ab1LEUQh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Dec 2011 15:16:37 -0500
Message-ID: <4EDD268E.9010603@redhat.com>
Date: Mon, 05 Dec 2011 18:16:14 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Ringel <linuxtv@stefanringel.de>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
	linux-media@vger.kernel.org, d.belimov@gmail.com
Subject: Re: [PATCH 3/5] tm6000: bugfix interrupt reset
References: <1322509580-14460-1-git-send-email-linuxtv@stefanringel.de> <1322509580-14460-3-git-send-email-linuxtv@stefanringel.de> <20111205072131.GB7341@avionic-0098.mockup.avionic-design.de> <4EDCB33E.8090100@redhat.com> <20111205153800.GA32512@avionic-0098.mockup.avionic-design.de> <4EDD0BBF.3020804@redhat.com> <4EDD235A.9000100@stefanringel.de>
In-Reply-To: <4EDD235A.9000100@stefanringel.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05-12-2011 18:02, Stefan Ringel wrote:
> Am 05.12.2011 19:21, schrieb Mauro Carvalho Chehab:
>> On 05-12-2011 13:38, Thierry Reding wrote:
>>> * Mauro Carvalho Chehab wrote:
>>>> On 05-12-2011 05:21, Thierry Reding wrote:
>>>>> * linuxtv@stefanringel.de wrote:
>>>>>> From: Stefan Ringel<linuxtv@stefanringel.de>
>>>>>>
>>>>>> Signed-off-by: Stefan Ringel<linuxtv@stefanringel.de>
>>>>>
>>>>> Your commit message needs more details. Why do you think this is a bugfix?
>>>>> Also this commit seems to effectively revert (and then partially reimplement)
>>>>> a patch that I posted some months ago.
>>>>
>>>> Thierry,
>>>>
>>>> I noticed this. I tested tm6000 with those changes with both the first gen
>>>> tm5600 devices I have and HVR900H and I didn't notice any bad thing with this
>>>> approach, and changing from one standard to another is now faster.
>>>>
>>>> So, I decided to apply it (with the remaining patches I've made to
>>>> fix audio for PAL/M and NTSC/M).
>>>>
>>>> I also noticed that TM6000_QUIRK_NO_USB_DELAY is not needed anymore
>>>> (still, Stefan's patches didn't remove it completely).
>>>>
>>>> Could you please test if the problems you've solved with your approach
>>>> are still occurring?
>>>
>>> Unfortunately I don't have any hardware available anymore. I will see if I
>>> can get my hands on some of the devices, but that may take a while. I guess
>>> you'll just have to apply without me testing them first.
>>
>> Ok.
>>
>>> My comments should be addressed anyway, though.
>>
>> Sure.
>>
>> Stefan,
>>
>> Could you better explain a little more about this change?
>>
>
>
> After add Thierry's patch the interrupt endpoint don't send data anymore.
> I tested different ways to bring the interrupt endpoint in working. First in the function tm6000_uninit_isoc() -> nothing, but if I remove the function tm6000_reset(), then works.
> The next what I tested are directly in the function tm6000_reset(), but it froze in.
> Now I am adding this lines in function tm600_relese() in position it call tm6000() (after videobuf_mmap_free() and it froze in, but before videobuf_mmap_free() it don't froze in and I have now data over the interrupt endpoint, and IR works.
>
>
> better now?

Ah, OK. Well, the IR code were re-written. If, for any reason, the interrupt
endpoint refuses to accept an usb_submission, the IR code will defer work to
re-try it again after 100ms.

That means that all we need is to get rid of TM6000_QUIRK_NO_USB_DELAY.

>
> Stefan
>> Also, if this is not required anymore, please send us a patch removing the
>> TM6000_QUIRK_NO_USB_DELAY quirk.
>>
> In a few days, if I have tested my next patch (signal detection)
>> Regards,
>> Mauro.
>>>
>>> Thierry
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>

