Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:50026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510Ab1ECKFE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 May 2011 06:05:04 -0400
Message-ID: <4DBFD34A.3030303@redhat.com>
Date: Tue, 03 May 2011 07:04:58 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/5] tm6000: add dtv78 parameter
References: <1301948324-27186-1-git-send-email-stefan.ringel@arcor.de> <1301948324-27186-2-git-send-email-stefan.ringel@arcor.de> <4DADFD31.1010200@redhat.com> <4DAE96F8.2070307@arcor.de> <4DAED3E0.2030606@redhat.com> <4DAEEE07.1040306@arcor.de>
In-Reply-To: <4DAEEE07.1040306@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 20-04-2011 11:30, Stefan Ringel escreveu:
> Am 20.04.2011 14:38, schrieb Mauro Carvalho Chehab:
>> Em 20-04-2011 05:19, Stefan Ringel escreveu:
>>> Am 19.04.2011 23:22, schrieb Mauro Carvalho Chehab:
>>>> Em 04-04-2011 17:18, stefan.ringel@arcor.de escreveu:
>>>>> From: Stefan Ringel<stefan.ringel@arcor.de>
>>>>>
>>>>> add dtv78 parameter
>>>> The dtv78 entry is a hack meant for card usage in Australia, that
>>>> speeds up channel detection there. Again, it should be specified
>>>> only when needed, and at per-board basis.
>>> I have test and auto detect doesn't work right. That is also region
>>> specific staff and it's better to set outside. In other words in Germany
>>> it must set this param and in other country, which use only 7MHz or 8MHz it doesn't set (i.e. Australia).
>> xc3028 has a logic to detect and work on both Australia and Europe.
>> If that logic is broken, we should fix it, not adding a manual
>> parameter for it.
>>
> It positively a bug. When I use lower band (7MHz, load DTV7 SCODE) it doesn't work, then I go in the high band (8MHz, load DTV78, DTV8 SCODE) and have channels and can watch TV. If I go now in the lower band (7MHz, don't reload SCODE) it works. This effect is for me a bug.

The fix for it should be at xc3028. Please propose a patch for it. Maybe we should add there
a parameter for auto-detection, or to force it to use dtv78, if bandwith is > 6MHz.


>>>>> Signed-off-by: Stefan Ringel<stefan.ringel@arcor.de>
>>>>> ---
>>>>>    drivers/staging/tm6000/tm6000-cards.c |   11 +++++++++--
>>>>>    1 files changed, 9 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
>>>>> index eef58da..cf2e76c 100644
>>>>> --- a/drivers/staging/tm6000/tm6000-cards.c
>>>>> +++ b/drivers/staging/tm6000/tm6000-cards.c
>>>>> @@ -65,6 +65,9 @@ static unsigned int xc2028_mts;
>>>>>    module_param(xc2028_mts, int, 0644);
>>>>>    MODULE_PARM_DESC(xc2028_mts, "enable mts firmware (xc2028/3028 only)");
>>>>>
>>>>> +static unsigned int xc2028_dtv78;
>>>>> +module_param(xc2028_dtv78, int, 0644);
>>>>> +MODULE_PARM_DESC(xc2028_dtv78, "enable dualband config (xc2028/3028 only)");
>>>>>
>>>>>    struct tm6000_board {
>>>>>        char            *name;
>>>>> @@ -687,8 +690,12 @@ static void tm6000_config_tuner(struct tm6000_core *dev)
>>>>>            ctl.read_not_reliable = 0;
>>>>>            ctl.msleep = 10;
>>>>>            ctl.demod = XC3028_FE_ZARLINK456;
>>>>> -        ctl.vhfbw7 = 1;
>>>>> -        ctl.uhfbw8 = 1;
>>>>> +
>>>>> +        if (xc2028_dtv78) {
>>>>> +            ctl.vhfbw7 = 1;
>>>>> +            ctl.uhfbw8 = 1;
>>>>> +        }
>>>>> +
>>>>>            if (xc2028_mts)
>>>>>                ctl.mts = 1;
>>>>>
>>>> -- 
>>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

