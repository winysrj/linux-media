Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:24607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890Ab1DTMhZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Apr 2011 08:37:25 -0400
Message-ID: <4DAED378.308@redhat.com>
Date: Wed, 20 Apr 2011 09:37:12 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>
CC: linux-media@vger.kernel.org, d.belimov@gmail.com
Subject: Re: [PATCH 1/5] tm6000: add mts parameter
References: <1301948324-27186-1-git-send-email-stefan.ringel@arcor.de> <4DADFCD2.1090401@redhat.com> <4DAE95CE.4020705@arcor.de>
In-Reply-To: <4DAE95CE.4020705@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 20-04-2011 05:14, Stefan Ringel escreveu:
> Am 19.04.2011 23:21, schrieb Mauro Carvalho Chehab:
>> Em 04-04-2011 17:18, stefan.ringel@arcor.de escreveu:
>>> From: Stefan Ringel<stefan.ringel@arcor.de>
>>>
>>> add mts parameter
>> Stefan,
>>
>> The MTS config depends on the specific board design (generally present on
>> mono NTSC cards). So, it should be inside the cards struct, and not
>> provided as an userspace parameter.
>>
>> Mauro.
> No. It wrong. I think edge board must work under all region and TV standards and if I set MTS, it doesn't work in Germany (PAL_BG and DVB-T). The best is to set outside region specific params.

Stefan,

Not all boards have MTS wired. Also, MTS works only for BTSC and EIAJ,
e. g. STD M/N. The SIF output works for all standards, depending of the audio
decoder capabilities, and if the SIF is properly wired. AFAIK, tm5600/6000/tm6010 
is a worldwide decoder, so if SIF is wired, it should be capable of also decoding
BTSC, EIAJ and the other sound standards found elsewhere.

In other words, boards shipped outside NTSC or PAL-M Countries use SIF and supports
worldwide standards. however, most boards shipped in US with xc3028 have only
MTS wired and won't work outside NTSC/PAL-M/PAL-N area (America, Japan and a few
other places).

>>> .
>>>
>>> Signed-off-by: Stefan Ringel<stefan.ringel@arcor.de>
>>> ---
>>>   drivers/staging/tm6000/tm6000-cards.c |    7 +++++++
>>>   1 files changed, 7 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
>>> index 146c7e8..eef58da 100644
>>> --- a/drivers/staging/tm6000/tm6000-cards.c
>>> +++ b/drivers/staging/tm6000/tm6000-cards.c
>>> @@ -61,6 +61,10 @@ module_param_array(card,  int, NULL, 0444);
>>>
>>>   static unsigned long tm6000_devused;
>>>
>>> +static unsigned int xc2028_mts;
>>> +module_param(xc2028_mts, int, 0644);
>>> +MODULE_PARM_DESC(xc2028_mts, "enable mts firmware (xc2028/3028 only)");
>>> +
>>>
>>>   struct tm6000_board {
>>>       char            *name;
>>> @@ -685,6 +689,9 @@ static void tm6000_config_tuner(struct tm6000_core *dev)
>>>           ctl.demod = XC3028_FE_ZARLINK456;
>>>           ctl.vhfbw7 = 1;
>>>           ctl.uhfbw8 = 1;
>>> +        if (xc2028_mts)
>>> +            ctl.mts = 1;
>>> +
>>>           xc2028_cfg.tuner = TUNER_XC2028;
>>>           xc2028_cfg.priv  =&ctl;
>>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

