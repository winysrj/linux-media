Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50256 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425Ab1LUKv7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Dec 2011 05:51:59 -0500
Message-ID: <4EF1BA4C.8030105@iki.fi>
Date: Wed, 21 Dec 2011 12:51:56 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jyrki Kuoppala <jkp@iki.fi>
CC: Carlos Corbacho <carlos@strangeworlds.co.uk>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] qt1010: Fix tuner frequency selection for 546 to 578
 MHz range
References: <20111220105034.5150.54234.stgit@localhost> <4EF18A2D.5090101@iki.fi> <4EF18DF1.9070703@iki.fi> <4EF196AF.7030208@iki.fi> <4EF1B69B.8020907@iki.fi>
In-Reply-To: <4EF1B69B.8020907@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

You should take sniffs from your device and look values from there in 
order to get understanding.

Thats seems to be one thing looked from my old tests:
u8 zl10353_unknown[] = { 0x90, 0x00, 0xff, 0xff, 0x00, 0xff, 0x3f, 0x3f };

IIRC those were related to IF/RF AGC limits. If you fix tuner then you 
should fix demod too. Otherwise it will not work properly if at all.

I think changing that one register off by one or two does not have much 
effort if all the others are correct. Just for the calibration.


regards
Antti

On 12/21/2011 12:36 PM, Jyrki Kuoppala wrote:
> Thanks, apparently you mean the valptr setting if clauses in QT1010_RD
> and QT1010_M1 cases, if I understand you correctly you are saying code
> should be changed as in the diff below (after my signature).
>
> The change has to with setting reg1f_init_val, reg20_init_val and
> reg25_init_val. To match with
> http://linuxtv.org/wiki/index.php/Quantek_QT1010 , the registers are 31,
> 32 and 37 in decimal.
>
> The patch sent by Carlos modifies how register 0x22 (register 34 in
> decimal) is set from the frequency. Carlos's patch is based on my patch
> which was based on the apparently incorrect (based on Carlos's feedback
> to my original patch, but see below, perhaps the assumption wasn't
> incorrect after all) assumption of linear relation between frequency and
> register 34 equals 0x22 value. So, basically Carlos removed the 0xd1 ->
> 0xd2 part of my patch.
>
> When following frequency setting from the description at
> http://linuxtv.org/wiki/index.php/Quantek_QT1010 , register 34 is set
> from freq_slot12 in the following manner:
>
>     * if reg5_1 is equal to 0x34
>           o if freq_slot12 is larger equal to 0xF0
>                 + if freq_slot12 is less equal to 0xFA
>                       # write freq_slot12 minus 0x20 into freq_slot12
>                 + else
>                       # write 0xDA into freq_slot12
>           o else
>                 + write 0xD0 into freq_slot12
>           o write freq_slot12 into tmp_var1
>     * else
>           o write 0xD0 into tmp_var1
>
>     * write tmp_var1 to tuner register 34
>
> That does describe a linear correlation between freq_slot12 value and
> what is stored to register 34. 0xf0..0xfa are converted to 0xd0 .. 0xda
> which are also the values used in qt1010.c.  But I can't find where
> freq_slot12 comes from (that's apparently in the incomplete part
> ofcalculate_parameter). So it's possible freq_slot12 is converted from
> the frequency non-linearly somewhere before it's used to set register
> 34. The current qt1010.c frequency to register 34 value conversion is
> non-linear and looks strange, setting 0xd1 where linearly setting the
> value would be 0xd2. But IIRC Carlos reported that changing it to 0xd2
> (as in my original proposed patch) breaks some frequencies.
>
> One possibility to try would be to test if the setting of reg 34 indeed
> should be linearly derived from frequency, however not 0xd0, 0xd2, 0xd4
> etc. as in my original patch but instead try 0xd0, 0xd1, 0xd2, 0xd3 etc:
>
>      if      (freq < 450000000) rd[15].val = 0xd0; /* 450 MHz */
>      else if (freq < 466000000) rd[15].val = 0xd1; /* 466 MHz */
>      else if (freq < 482000000) rd[15].val = 0xd2; /* 482 MHz */
>      else if (freq < 498000000) rd[15].val = 0xd3; /* 498 MHz */
>      else if (freq < 514000000) rd[15].val = 0xd4; /* 514 MHz */
>      else if (freq < 530000000) rd[15].val = 0xd5; /* 530 MHz */
>      else if (freq < 546000000) rd[15].val = 0xd6; /* 546 MHz */
>      else if (freq < 562000000) rd[15].val = 0xd7; /* 562 MHz */
>      else if (freq < 578000000) rd[15].val = 0xd8; /* 578 MHz */
>
> Carlos, can you try this, if this makes all channels work for you?
> According to my reasoning, this could be the proper patch, as the 0xd1
> -> 0xd2 change in my original patch failed for you. This would fit the
> picture if your frequency is between 450 Mhz and 466 Mhz, in which case
> my patch changes the correct 0xd1 to the incorrect 0xd2.
>
> If the test succeeds and the relation indeed is linear, instead of the
> table we'll the conversion with math, it's of course silly to have a
> table for a linear relation.
>
> Going through this makes me wonder if we perhaps have two separate
> issues here - one problem with frequency setting experienced by me &
> Carlos, and another problem with tuner init & AGC which Antti is
> describing. Antti, can you comment if you think this may be the case? Or
> is the register 31,32&37 setting somehow related to frequency selection?
> Just wondering why the frequency table seems to fix the issue that me &
> Carlos and others are seeing, if the problem is somewhere else as Antti
> is saying. Two separate issues could explain this.
>
> Antti, any pointers / more info on what's the problem with
> drivers/media/dvb/frontends/zl10353.c AGC settings and how to fix those
> settings?
>
> Jyrki
>
>
>
> diff -ur linux-3.0.3.orig/drivers/media/common/tuners/qt1010.c
> linux-3.0.3/drivers/media/common/tuners/qt1010.c
> --- linux-3.0.3.orig/drivers/media/common/tuners/qt1010.c
> 2011-08-17 20:57:16.000000000 +0300
> +++ linux-3.0.3/drivers/media/common/tuners/qt1010.c    2011-12-21
> 10:38:46.089650261 +0200
> @@ -371,16 +372,16 @@
>                                                i2c_data[i].val);
>                          break;
>                  case QT1010_RD:
> -                       if (i2c_data[i].val == 0x20)
> +                       if (i2c_data[i].reg == 0x20)
>                                  valptr = &priv->reg20_init_val;
>                          else
>                                  valptr = &tmpval;
>                          err = qt1010_readreg(priv, i2c_data[i].reg,
> valptr);
>                          break;
>                  case QT1010_M1:
> -                       if (i2c_data[i].val == 0x25)
> +                       if (i2c_data[i].reg == 0x25)
>                                  valptr = &priv->reg25_init_val;
> -                       else if (i2c_data[i].val == 0x1f)
> +                       else if (i2c_data[i].reg == 0x1f)
>                                  valptr = &priv->reg1f_init_val;
>                          else
>                                  valptr = &tmpval;
>
>
>
> 21.12.2011 10:19, Antti Palosaari kirjoitti:
>> Moikka Jyrki & all.
>> If you look qt1010_init() you can see some registers are stored
>> wrongly. There is compares that stores register values when .val is
>> given. As you can see easily, it should store those when .reg is
>> correct. Store register 0x25 when it is register 0x25 not register
>> value. That leads calibration wrong => tuner sensitivity is bad.
>> But if you fix that it will not likely work since ZL10353 demod AGC
>> settings are not correct. So you should fix it too.
>>
>> I hope you will fix that, since it is surely 10th time I am explaining
>> that same story for someone :-(
>>
>> t. Antti
>>
>>
>>
>>
>> On 12/21/2011 09:42 AM, Jyrki Kuoppala wrote:
>>> Hi,
>>>
>>> To try and shed some more light into the issue, can you describe what
>>> the problem really is and how would we fix the driver correctly? By
>>> "work or not", do you mean the fix works with some devices but not with
>>> some other devices, with some received signal strengths but not some, or
>>> something else? Do you think there's a risk the fix will break
>>> something?
>>>
>>> For me, without the fix, some of the major channels from the transmitter
>>> in the second largest city of Finland are missing, in other words the
>>> fix would remove a major showstopper. Based on Carlos's note, the
>>> situation in UK is something similar.
>>>
>>> It's of course best to aim for the best possible fix, and if we have
>>> enough information to do that, that's of course preferable over this
>>> one. However, if there isn't enough information, and there's no risk of
>>> the proposed fix breaking something, perhaps this patch should be put in
>>> as an interim fix and add some notes somewhere that a better fix is
>>> preferable.
>>>
>>> Jyrki
>>>
>>>
>>> 21.12.2011 09:26, Antti Palosaari kirjoitti:
>>>> Hello,
>>>> You can try to fix it like that, but it is not proper way. It is kinda
>>>> of hack which can just work or not. Proper way is to fix that tuner
>>>> driver correctly and if it was used with zl10353 demoed fix that
>>>> driver too to support IIRC IF/RF agc settings.
>>>>
>>>> regards
>>>> Antti
>>>>
>>>> On 12/20/2011 12:50 PM, Carlos Corbacho wrote:
>>>>> The patch fixes frequency selection for some UHF frequencies e.g.
>>>>> channel 32 (562 MHz) on the qt1010 tuner. For those in the UK,
>>>>> this now means they can tune to the BBC channels (tested on a Compro
>>>>> Vista T750F).
>>>>>
>>>>> One example of problem reports of the bug this fixes can be read at
>>>>> http://www.freak-search.com/de/thread/330303/linux-dvb_tuning_problem_with_some_frequencies_qt1010,_dvb
>>>>>
>>>>>
>>>>>
>>>>> Based on an original patch by Jyrki Kuoppala<jkp@iki.fi>
>>>>>
>>>>> Signed-off-by: Carlos Corbacho<carlos@strangeworlds.co.uk>
>>>>> Cc: Jyrki Kuoppala<jkp@iki.fi>
>>>>> Cc: Mauro Carvalho Chehab<mchehab@infradead.org>
>>>>> ---
>>>>> drivers/media/common/tuners/qt1010.c | 3 ++-
>>>>> 1 files changed, 2 insertions(+), 1 deletions(-)
>>>>>
>>>>> diff --git a/drivers/media/common/tuners/qt1010.c
>>>>> b/drivers/media/common/tuners/qt1010.c
>>>>> index 9f5dba2..8c57d8c 100644
>>>>> --- a/drivers/media/common/tuners/qt1010.c
>>>>> +++ b/drivers/media/common/tuners/qt1010.c
>>>>> @@ -200,7 +200,8 @@ static int qt1010_set_params(struct dvb_frontend
>>>>> *fe,
>>>>> if (freq< 450000000) rd[15].val = 0xd0; /* 450 MHz */
>>>>> else if (freq< 482000000) rd[15].val = 0xd1; /* 482 MHz */
>>>>> else if (freq< 514000000) rd[15].val = 0xd4; /* 514 MHz */
>>>>> - else if (freq< 546000000) rd[15].val = 0xd7; /* 546 MHz */
>>>>> + else if (freq< 546000000) rd[15].val = 0xd6; /* 546 MHz */
>>>>> + else if (freq< 578000000) rd[15].val = 0xd8; /* 578 MHz */
>>>>> else if (freq< 610000000) rd[15].val = 0xda; /* 610 MHz */
>>>>> else rd[15].val = 0xd0;
>>>>>
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>> linux-media" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>>>
>>>>
>>>
>>
>>
>


-- 
http://palosaari.fi/
