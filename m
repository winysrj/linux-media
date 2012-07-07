Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43900 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630Ab2GGKrF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jul 2012 06:47:05 -0400
Message-ID: <4FF8139F.7010602@iki.fi>
Date: Sat, 07 Jul 2012 13:46:55 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Bert Massop <bert.massop@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] [media] tuner, xc2028: add support for get_afc()
References: <1341497792-6066-1-git-send-email-mchehab@redhat.com> <1341497792-6066-3-git-send-email-mchehab@redhat.com> <4FF5AD40.3070707@iki.fi> <CAKJOob9KBQRHXWTrOM_=hmF5OSoovhPWY4aGCbhhsbLKTk5NgQ@mail.gmail.com> <4FF5F4C4.7080904@redhat.com>
In-Reply-To: <4FF5F4C4.7080904@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/05/2012 11:10 PM, Mauro Carvalho Chehab wrote:
> Em 05-07-2012 14:37, Bert Massop escreveu:
>> On Thu, Jul 5, 2012 at 5:05 PM, Antti Palosaari <crope@iki.fi> wrote:
>>>
>>> On 07/05/2012 05:16 PM, Mauro Carvalho Chehab wrote:
>>>>
>>>> Implement API support to return AFC frequency shift, as this device
>>>> supports it. The only other driver that implements it is tda9887,
>>>> and the frequency there is reported in Hz. So, use Hz also for this
>>>> tuner.
>>>
>>>
>>> What is AFC and why it is needed?
>>>
>>
>> AFC is short for Automatic Frequency Control, by which a tuner
>> automatically fine-tunes the frequency for the best reception,
>> compensating for small offsets and oscillator frequency drift.
>> This is however done automatically on the tuner, so its configuration
>> is read-only. Aside from being a "nice to know" statistic, getting
>> hold of the AFC frequency shift does as far as I know not have any
>> practical uses related to properly operating the tuner.
>
> AFC might be useful on a few situations. For example, my CATV operator
> still broadcasts some channels in both analog and digital. The analog
> equipment there doesn't seem to be well-maintained, as some channels have
> frequency shifts or have some other artifacts. Still, analog broadcast
> is useful for me to test drivers ;)
>
> Anyway, adjusting the channel tables to consider that offset shift help
> to tune them a little faster and/or get a better quality by letting the
> PLL to work closer to the pilot carrier.

We has already .get_frequency() which returns same information. It is 
not currently used though few drivers implements it (wrongly). So I 
don't see why this new callback should be added.

u32 actual_freq;
int afc;

struct dtv_frontend_properties *c = &fe->dtv_property_cache;
ret = .get_frequency(fe, &actual_freq);
afc = c->frequency - actual_freq;

regards
Antti

-- 
http://palosaari.fi/


