Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:59056 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbaIGJfK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Sep 2014 05:35:10 -0400
Received: by mail-we0-f181.google.com with SMTP id x48so13481675wes.26
        for <linux-media@vger.kernel.org>; Sun, 07 Sep 2014 02:35:09 -0700 (PDT)
Message-ID: <540C26C5.1010002@gmail.com>
Date: Sun, 07 Sep 2014 10:35:01 +0100
From: Malcolm Priestley <tvboxspy@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Akihiro TSUKADA <tskd08@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/5] dvb-core: add a new tuner ops to dvb_frontend
 for APIv5
References: <1409153356-1887-1-git-send-email-tskd08@gmail.com> <1409153356-1887-2-git-send-email-tskd08@gmail.com> <53FE1EF5.5060007@iki.fi> <53FEF144.6060106@gmail.com> <53FFD1F0.9050306@iki.fi> <540059B5.8050100@gmail.com> <540A6CF3.4070401@iki.fi> <20140905235105.3ab6e7c4.m.chehab@samsung.com> <540B3551.9060003@gmail.com> <540B7E91.5000700@gmail.com> <20140906193728.13b0f725.m.chehab@samsung.com> <540B9AE5.1080708@iki.fi>
In-Reply-To: <540B9AE5.1080708@iki.fi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/09/14 00:38, Antti Palosaari wrote:
>
>
> On 09/07/2014 01:37 AM, Mauro Carvalho Chehab wrote:
>> Em Sat, 06 Sep 2014 22:37:21 +0100
>> Malcolm Priestley <tvboxspy@gmail.com> escreveu:
>>
>>> On 06/09/14 17:24, Malcolm Priestley wrote:
>>>> On 06/09/14 03:51, Mauro Carvalho Chehab wrote:
>>>>> Em Sat, 06 Sep 2014 05:09:55 +0300
>>>>> Antti Palosaari <crope@iki.fi> escreveu:
>>>>>
>>>>>> Moro!
>>>>>>
>>>>>> On 08/29/2014 01:45 PM, Akihiro TSUKADA wrote:
>>>>>>> moikka,
>>>>>>>
>>>>>>>> Start polling thread, which polls once per 2 sec or so, which reads
>>>>>>>> RSSI
>>>>>>>> and writes value to struct dtv_frontend_properties. That it is,
>>>>>>>> in my
>>>>>>>> understanding. Same for all those DVBv5 stats. Mauro knows better
>>>>>>>> as he
>>>>>>>> designed that functionality.
>>>>>>>
>>>>>>> I understand that RSSI property should be set directly in the tuner
>>>>>>> driver,
>>>>>>> but I'm afraid that creating a kthread just for updating RSSI
>>>>>>> would be
>>>>>>> overkill and complicate matters.
>>>>>>>
>>>>>>> Would you give me an advice? >> Mauro
>>>>>>
>>>>>> Now I know that as I implement it. I added kthread and it works
>>>>>> correctly, just I though it is aimed to work. In my case signal
>>>>>> strength
>>>>>> is reported by demod, not tuner, because there is some logic in
>>>>>> firmware
>>>>>> to calculate it.
>>>>>>
>>>>>> Here is patches you would like to look as a example:
>>>>>>
>>>>>> af9033: implement DVBv5 statistic for signal strength
>>>>>> https://patchwork.linuxtv.org/patch/25748/
>>>>>
>>>>> Actually, you don't need to add a separate kthread to collect the
>>>>> stats.
>>>>> The DVB frontend core already has a thread that calls the frontend
>>>>> status
>>>>> on every 3 seconds (the time can actually be different, depending on
>>>>> the value for fepriv->delay. So, if the device doesn't have any issues
>>>>> on getting stats on this period, it could just hook the DVBv5 stats
>>>>> logic
>>>>> at ops.read_status().
>>>>>
>>>>
>>>> Hmm, fepriv->delay missed that one, 3 seconds is far too long for
>>>> lmedm04.
>>>
>>> The only way change this is by using algo DVBFE_ALGO_HW using the
>>> frontend ops tune.
>>>
>>> As most frontends are using dvb_frontend_swzigzag it could be
>>> implemented by patching the frontend ops tune code at the lock
>>> return in this function or in dvb_frontend_swzigzag_update_delay.
>>
>> Well, if a different value is needed, it shouldn't be hard to add a
>> way to customize it, letting the demod to specify it, in the same way
>> as fe->ops.info.frequency_stepsize (and other similar demot properties)
>> are passed through the core.
>
> DVBFE_ALGO_SW, which is used normally, polls read_status rather rapidly.
> For statics problem is that it is too rapid, not that it is too slow. If
> you want re-use that as a timer for statistics, you could simply make
> own ratelimit very easily using kernel jiffies.
The default starts off at 50msec and gradually rises to around 950msec.

There is another way to set fepriv->delay that is in 
ops->get_tune_settings  dvb_frontend_tune_settings->min_delay_ms.

The delay increases by around 900msec on top of the value set there.

In the case of lmedm04/m88rs2000 that why I am seeing 3 sec.

Regards


Malcolm




