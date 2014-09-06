Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44988 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbaIFDKG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Sep 2014 23:10:06 -0400
Message-ID: <540A7B09.2090300@iki.fi>
Date: Sat, 06 Sep 2014 06:10:01 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Akihiro TSUKADA <tskd08@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/5] dvb-core: add a new tuner ops to dvb_frontend
 for APIv5
References: <1409153356-1887-1-git-send-email-tskd08@gmail.com> <1409153356-1887-2-git-send-email-tskd08@gmail.com> <53FE1EF5.5060007@iki.fi> <53FEF144.6060106@gmail.com> <53FFD1F0.9050306@iki.fi> <540059B5.8050100@gmail.com> <540A6CF3.4070401@iki.fi> <20140905235105.3ab6e7c4.m.chehab@samsung.com> <20140905235432.5eeab2a3.m.chehab@samsung.com>
In-Reply-To: <20140905235432.5eeab2a3.m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/06/2014 05:54 AM, Mauro Carvalho Chehab wrote:
> Em Fri, 5 Sep 2014 23:51:05 -0300
> Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:
>
>> Em Sat, 06 Sep 2014 05:09:55 +0300
>> Antti Palosaari <crope@iki.fi> escreveu:
>>
>>> Moro!
>>>
>>> On 08/29/2014 01:45 PM, Akihiro TSUKADA wrote:
>>>> moikka,
>>>>
>>>>> Start polling thread, which polls once per 2 sec or so, which reads RSSI
>>>>> and writes value to struct dtv_frontend_properties. That it is, in my
>>>>> understanding. Same for all those DVBv5 stats. Mauro knows better as he
>>>>> designed that functionality.
>>>>
>>>> I understand that RSSI property should be set directly in the tuner driver,
>>>> but I'm afraid that creating a kthread just for updating RSSI would be
>>>> overkill and complicate matters.
>>>>
>>>> Would you give me an advice? >> Mauro
>>>
>>> Now I know that as I implement it. I added kthread and it works
>>> correctly, just I though it is aimed to work. In my case signal strength
>>> is reported by demod, not tuner, because there is some logic in firmware
>>> to calculate it.
>>>
>>> Here is patches you would like to look as a example:
>>>
>>> af9033: implement DVBv5 statistic for signal strength
>>> https://patchwork.linuxtv.org/patch/25748/
>>
>> Actually, you don't need to add a separate kthread to collect the stats.
>> The DVB frontend core already has a thread that calls the frontend status
>> on every 3 seconds (the time can actually be different, depending on
>> the value for fepriv->delay. So, if the device doesn't have any issues
>> on getting stats on this period, it could just hook the DVBv5 stats logic
>> at ops.read_status().
>
> In time: not implementing its own thread has one drawback: the driver needs
> to check if the minimal time needed to get a new stats were already archived.
>
> Please see the mt86a20s driver and check for some examples on how to
> properly do that.
>
> There, we do things like:
>
> static int mb86a20s_read_signal_strength(struct dvb_frontend *fe)
> {
> 	struct mb86a20s_state *state = fe->demodulator_priv;
> 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> 	int rc;
> 	unsigned rf_max, rf_min, rf;
>
> 	if (state->get_strength_time &&
> 	   (!time_after(jiffies, state->get_strength_time)))
> 		return c->strength.stat[0].uvalue;
>
> To prevent the stats to be called too fast.

... I simply don't understand why you want hook that RF strength call 
via demod? The frontend cache is shared between demod and tuner. We use 
it for tuner driver as well demod driver. Let the tuner driver make RSSI 
calculation independently without any unneeded relation to demod driver.

regards
Antti

-- 
http://palosaari.fi/
