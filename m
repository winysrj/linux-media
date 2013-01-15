Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55993 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929Ab3AOUiS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jan 2013 15:38:18 -0500
Message-ID: <50F5BE14.9000705@iki.fi>
Date: Tue, 15 Jan 2013 22:37:40 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com> <50F522AD.8000109@iki.fi> <20130115111041.6b78a935@redhat.com> <50F56C63.7010503@iki.fi> <50F57519.5060402@iki.fi> <20130115151203.7221b1db@redhat.com>
In-Reply-To: <20130115151203.7221b1db@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/15/2013 07:12 PM, Mauro Carvalho Chehab wrote:
> Em Tue, 15 Jan 2013 17:26:17 +0200
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> On 01/15/2013 04:49 PM, Antti Palosaari wrote:
>>> I am a little bit lazy to read all those patches, but I assume it is
>>> possible:
>>> * return SNR (CNR) as both dB and linear?
>>> * return signal strength as both dBm and linear?
>>>
>>> And what happens when when multiple statistics are queried, but fronted
>>> cannot perform all those?
>>>
>>> Lets say SS, SNR, BER, UCB are queried, but only SS and SNR are ready to
>>> be returned, whilst rest are not possible? As I remember DVBv5 API is
>>> broken by design and cannot return error code per request.
>>
>> OK, I read that patch still. All these are OK as there is SCALE flag
>> used to inform if there is measurement or not available.
>> No anymore question about these.
>>
>> Issues what I still would like to raise now are:
>>
>> 1) How about change unit from dB/10 to dB/100 or even dB/1000, just for
>> the sure?
>
> I'm OK with that. I doubt that it would be practical, but we have 64
> bits for it, so db/1000 will fit.
>
>> 2) Counter are reset when DELIVERY SYSTEM is set, practically when
>> tuning attempt is done. There is new callback for that, but no API
>> command. Functionality is correct for my eyes, is that extra callback
>> needed?
>
> Not sure. It should be noticed that, at least on ISDB, some sort of
> reset may happen, for example if one layer disappears. The global BER
> will (with the current code) reflect the lack of the layer, by not summing
> up the data from the removed layer.
>
> Perhaps it makes more sense to, instead, add a way for the driver to flag
> when a counter reset happened.
>
>> 3) Post-BER. I don't need it, but is there someone else who thinks there
>> should be both pre-BER and post-BER? IMHO, just better to leave it out
>> to keep it simple. In practice both pre-BER and post-BER are running
>> relatively, lets say if pre-BER shows number 1000 then post-BER shows
>> only 10. Or pre-BER 600, post-BER 6. Due to that, I don't see much
>> interest to return it for userspace. Of course someone would like to
>> know how much inner coder is working and fixing error bits and in that
>> case both BERs are nice...
>
> I don't see any need for it. In the case of ISDB, I'll likely convert
> the post-BER error into per-layer CNR, as it might be useful for one.
>
> I don't have any strong opinion on that though.
>
>> 4) Returning bit counts as BER and UCB means also driver should start
>> polling work in order to keep driver internal counters up to date.
>> Returning BER as rate is cheaper in that mean, as driver could make
>> decision how often to poll and in which condition (and return values
>> from cache). Keeping track of total bit counts means continuous polling!
>
> The way it was specified, the bit count/block count is relative to the
> same period where bit error/block error count was taken, and are there
> to calculate BER and PER.

Eh, then this is functionality is against 2) what I asked about 
functionality of the counter reset. You should make decision to increase 
counters continuously and reset only given condition (on channel tune as 
it is done now) OR leave whole counter reset and increase to 
responsibility of the driver.

Do you see conflict here???

My opinion is to remove counter reset callback and leave all to 
responsibility of the driver.

> Not all frontends allow continuous measurement of BER and PER. In the
> case of mb86a20s, BER is currently not continuous. I think that there's
> a way to do continuous PER measurement, but I need to double-check
> it.

Personally I am going to implement that way it returns those bit counts 
from the driver cache. Driver makes decision when to make measurements, 
like just after channel is tuned and after that maybe once per minute or so.

regards
Antti

-- 
http://palosaari.fi/
