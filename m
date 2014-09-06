Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:50932 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaIFQZD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Sep 2014 12:25:03 -0400
Received: by mail-we0-f170.google.com with SMTP id u57so630444wes.1
        for <linux-media@vger.kernel.org>; Sat, 06 Sep 2014 09:25:01 -0700 (PDT)
Message-ID: <540B3551.9060003@gmail.com>
Date: Sat, 06 Sep 2014 17:24:49 +0100
From: Malcolm Priestley <tvboxspy@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Antti Palosaari <crope@iki.fi>
CC: Akihiro TSUKADA <tskd08@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/5] dvb-core: add a new tuner ops to dvb_frontend
 for APIv5
References: <1409153356-1887-1-git-send-email-tskd08@gmail.com> <1409153356-1887-2-git-send-email-tskd08@gmail.com> <53FE1EF5.5060007@iki.fi> <53FEF144.6060106@gmail.com> <53FFD1F0.9050306@iki.fi> <540059B5.8050100@gmail.com> <540A6CF3.4070401@iki.fi> <20140905235105.3ab6e7c4.m.chehab@samsung.com>
In-Reply-To: <20140905235105.3ab6e7c4.m.chehab@samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/09/14 03:51, Mauro Carvalho Chehab wrote:
> Em Sat, 06 Sep 2014 05:09:55 +0300
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> Moro!
>>
>> On 08/29/2014 01:45 PM, Akihiro TSUKADA wrote:
>>> moikka,
>>>
>>>> Start polling thread, which polls once per 2 sec or so, which reads RSSI
>>>> and writes value to struct dtv_frontend_properties. That it is, in my
>>>> understanding. Same for all those DVBv5 stats. Mauro knows better as he
>>>> designed that functionality.
>>>
>>> I understand that RSSI property should be set directly in the tuner driver,
>>> but I'm afraid that creating a kthread just for updating RSSI would be
>>> overkill and complicate matters.
>>>
>>> Would you give me an advice? >> Mauro
>>
>> Now I know that as I implement it. I added kthread and it works
>> correctly, just I though it is aimed to work. In my case signal strength
>> is reported by demod, not tuner, because there is some logic in firmware
>> to calculate it.
>>
>> Here is patches you would like to look as a example:
>>
>> af9033: implement DVBv5 statistic for signal strength
>> https://patchwork.linuxtv.org/patch/25748/
>
> Actually, you don't need to add a separate kthread to collect the stats.
> The DVB frontend core already has a thread that calls the frontend status
> on every 3 seconds (the time can actually be different, depending on
> the value for fepriv->delay. So, if the device doesn't have any issues
> on getting stats on this period, it could just hook the DVBv5 stats logic
> at ops.read_status().
>

Hmm, fepriv->delay missed that one, 3 seconds is far too long for lmedm04.

It would be good to hook stats on to this thread.

Regards


Malcolm






