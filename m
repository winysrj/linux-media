Return-path: <mchehab@pedra>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:54677 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752757Ab1ECOwm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 May 2011 10:52:42 -0400
Message-ID: <4DC016B7.3030506@arcor.de>
Date: Tue, 03 May 2011 16:52:39 +0200
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org, d.belimov@gmail.com
Subject: Re: [PATCH 3/5] tm6000: add audio mode parameter
References: <1301948324-27186-1-git-send-email-stefan.ringel@arcor.de> <1301948324-27186-3-git-send-email-stefan.ringel@arcor.de> <4DADFDF1.9020108@redhat.com> <4DAE9B00.7050404@arcor.de> <4DBFD3CD.9070008@redhat.com> <4DC01043.6090309@arcor.de> <4DC01442.2060207@redhat.com>
In-Reply-To: <4DC01442.2060207@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Am 03.05.2011 16:42, schrieb Mauro Carvalho Chehab:
> Em 03-05-2011 11:25, Stefan Ringel arcor escreveu:
>> Am 03.05.2011 12:07, schrieb Mauro Carvalho Chehab:
>>> Em 20-04-2011 05:36, Stefan Ringel escreveu:
>>>> Am 19.04.2011 23:26, schrieb Mauro Carvalho Chehab:
>>>>> Em 04-04-2011 17:18, stefan.ringel@arcor.de escreveu:
>>>>>> From: Stefan Ringel<stefan.ringel@arcor.de>
>>>>>>
>>>>>> add audio mode parameter
>>>>> Why we need a parameter for it? It should be determined based on
>>>>> the standard.
>>>>>
>>>> tm6010 has a sif decoder, and I think if auto detect doesn't work, use can set the audio standard, which it has in your region. Or it's better if users can see image but can hear audio?
>>> I did some tests with SIF and MTS here. None of them were capable of working with BTSC signals with
>>> my devices. Adding a parameter won't help it at all. What we need to do is to fix the audio
>>> decoding.
>>>
>> In the next patch I will send it. A preview I have send to be test (
>> https://patchwork.kernel.org/patch/722021/ ).
> I tested your preview. Didn't make any difference.
Has you test with all setting variants? (BG_A2 works auto and A2 audio 
mode).
>>>>>> Signed-off-by: Stefan Ringel<stefan.ringel@arcor.de>
>>>>>> ---
>>>>>>    drivers/staging/tm6000/tm6000-stds.c |    5 +++++
>>>>>>    1 files changed, 5 insertions(+), 0 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/staging/tm6000/tm6000-stds.c b/drivers/staging/tm6000/tm6000-stds.c
>>>>>> index da3e51b..a9e1921 100644
>>>>>> --- a/drivers/staging/tm6000/tm6000-stds.c
>>>>>> +++ b/drivers/staging/tm6000/tm6000-stds.c
>>>>>> @@ -22,12 +22,17 @@
>>>>>>    #include "tm6000.h"
>>>>>>    #include "tm6000-regs.h"
>>>>>>
>>>>>> +static unsigned int tm6010_a_mode;
>>>>>> +module_param(tm6010_a_mode, int, 0644);
>>>>>> +MODULE_PARM_DESC(tm6010_a_mode, "set sif audio mode (tm6010 only)");
>>>>>> +
>>>>>>    struct tm6000_reg_settings {
>>>>>>        unsigned char req;
>>>>>>        unsigned char reg;
>>>>>>        unsigned char value;
>>>>>>    };
>>>>>>
>>>>>> +/* must be updated */
>>>>>>    enum tm6000_audio_std {
>>>>>>        BG_NICAM,
>>>>>>        BTSC,
>>>> -- 
>>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

