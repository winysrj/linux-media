Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932149Ab2HFUlj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Aug 2012 16:41:39 -0400
Message-ID: <50202BF7.8040004@redhat.com>
Date: Mon, 06 Aug 2012 17:41:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Bert Massop <bert.massop@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] [media] tuner, xc2028: add support for get_afc()
References: <1341497792-6066-1-git-send-email-mchehab@redhat.com> <1341497792-6066-3-git-send-email-mchehab@redhat.com> <4FF5AD40.3070707@iki.fi> <CAKJOob9KBQRHXWTrOM_=hmF5OSoovhPWY4aGCbhhsbLKTk5NgQ@mail.gmail.com> <4FF5F4C4.7080904@redhat.com> <4FF8139F.7010602@iki.fi> <502024D3.8070301@iki.fi>
In-Reply-To: <502024D3.8070301@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 06-08-2012 17:10, Antti Palosaari escreveu:
> Mauro, I am still waiting for your explanation for that.
> 
> On 07/07/2012 01:46 PM, Antti Palosaari wrote:
>> On 07/05/2012 11:10 PM, Mauro Carvalho Chehab wrote:
>>> Em 05-07-2012 14:37, Bert Massop escreveu:
>>>> On Thu, Jul 5, 2012 at 5:05 PM, Antti Palosaari <crope@iki.fi> wrote:
>>>>>
>>>>> On 07/05/2012 05:16 PM, Mauro Carvalho Chehab wrote:
>>>>>>
>>>>>> Implement API support to return AFC frequency shift, as this device
>>>>>> supports it. The only other driver that implements it is tda9887,
>>>>>> and the frequency there is reported in Hz. So, use Hz also for this
>>>>>> tuner.
>>>>>
>>>>>
>>>>> What is AFC and why it is needed?
>>>>>
>>>>
>>>> AFC is short for Automatic Frequency Control, by which a tuner
>>>> automatically fine-tunes the frequency for the best reception,
>>>> compensating for small offsets and oscillator frequency drift.
>>>> This is however done automatically on the tuner, so its configuration
>>>> is read-only. Aside from being a "nice to know" statistic, getting
>>>> hold of the AFC frequency shift does as far as I know not have any
>>>> practical uses related to properly operating the tuner.
>>>
>>> AFC might be useful on a few situations. For example, my CATV operator
>>> still broadcasts some channels in both analog and digital. The analog
>>> equipment there doesn't seem to be well-maintained, as some channels have
>>> frequency shifts or have some other artifacts. Still, analog broadcast
>>> is useful for me to test drivers ;)
>>>
>>> Anyway, adjusting the channel tables to consider that offset shift help
>>> to tune them a little faster and/or get a better quality by letting the
>>> PLL to work closer to the pilot carrier.
>>
>> We has already .get_frequency() which returns same information. It is
>> not currently used though few drivers implements it (wrongly). So I
>> don't see why this new callback should be added.
>>
>> u32 actual_freq;
>> int afc;
>>
>> struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>> ret = .get_frequency(fe, &actual_freq);
>> afc = c->frequency - actual_freq;
> 
> Let me revise what I think. We have now 3 methods for resolving actual frequency after tuner is set:
> 
> 1) .get_frequency()
> ** that is old APIv3 callback returning tuner frequency
> 
> 2) fe->dtv_property_cache->frequency
> ** that is newer APIv5 method returning tuner frequency
> 
> 3) .get_afc()
> ** new callback to return frequency shift from target frequency
> 
> For my eyes this kind of duplicate methods are bad, causing only confusion, and should be avoided always when possible.

Yes, duplication is a bad thing.

Yet, I don't think get_afc() is a duplication. Let me explain:

fe->dtv_property_cache->frequency is only available for DTV. For analog TV,
this propery doesn't exist (or it is not visible by the analog core).
The get_afc() callback was created to fulfill the analog case.

For digital, fe->dtv_property_cache->frequency previous value is not stored,
e. g. it stores either the user requested frequency or the frontend-detected one.
So, the frequency shift is actually not directly known. Ok, some logic could
be added there, if we ever need to return AFC to userspace via dvb_frontend.

For frontends with software zig-zag, fe->dtv_property_cache->frequency is
updated during the zig-zag logic, so, there's no need to a get_frequency
callback (or anything inside the frontend driver to touch at 
fe->dtv_property_cache->frequency.

However, for devices with hardware zig-zag, the only way to get the real
frequency is to call the device, after waiting for a while for the device
to lock. So, a call to set_frontend() won't work.

For that to work, there are currently two ways: get_frontend() or get_frequency().

get_frontend() will not only read the frequency register, but also will read
all other I2C status registers, in order to get modulation type, guard interval,
etc. That can be too much I2C traffic, when just the frequency offset may be
needed.

Yet, maybe get_frequency() could be removed. We need to take a look where this
is used.

Regards,
Mauro
