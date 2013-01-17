Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37515 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963Ab3AQWWo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jan 2013 17:22:44 -0500
Message-ID: <50F87988.5060605@iki.fi>
Date: Fri, 18 Jan 2013 00:22:00 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Simon Farnsworth <simon.farnsworth@onelan.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com> <20130116152151.5461221c@redhat.com> <CAHFNz9KjG-qO5WoCMzPtcdb6d-4iZk695zp_L3iSeb=ZiWKhQw@mail.gmail.com> <2817386.vHx2V41lNt@f17simon> <20130116200153.3ec3ee7d@redhat.com> <CAHFNz9L-Dzrv=+Z01ndrfK3GmvFyxT6941W4-_63bwn1HrQBYQ@mail.gmail.com> <50F7C57A.6090703@iki.fi> <20130117145036.55745a60@redhat.com> <50F831AA.8010708@iki.fi> <20130117161126.6b2e809d@redhat.com> <50F84276.3080909@iki.fi> <CAHFNz9JDqYnrmNDt0_nBJMgzAymZSCXBbwY5MHR8AkMopPPQOA@mail.gmail.com> <20130117165037.6ed80366@redhat.com> <50F84CCC.5040103@iki.fi> <CAHFNz9LzWG4DX6s0FieNoiae=A3a=h+JzXAG1XPTMvANb93Skg@mail.gmail.com>
In-Reply-To: <CAHFNz9LzWG4DX6s0FieNoiae=A3a=h+JzXAG1XPTMvANb93Skg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/17/2013 11:29 PM, Manu Abraham wrote:
> On Fri, Jan 18, 2013 at 12:41 AM, Antti Palosaari <crope@iki.fi> wrote:
>> On 01/17/2013 08:50 PM, Mauro Carvalho Chehab wrote:
>>>
>>> Em Fri, 18 Jan 2013 00:07:17 +0530
>>> Manu Abraham <abraham.manu@gmail.com> escreveu:
>>>
>>>> On Thu, Jan 17, 2013 at 11:57 PM, Antti Palosaari <crope@iki.fi> wrote:
>>>>
>>>>>
>>>>>
>>>>> Resetting counters when user tunes channel sounds the only correct
>>>>> option.
>>>>>
>>>>
>>>> This might not be correct, especially when we have true Multiple Input
>>>> Streams.
>>>> The tune might be single, but the filter setup would be different. In
>>>> which case it
>>>> wouldn't correct to do a reset of the counters ona tune. Resetting the
>>>> counters
>>>> should be the responsibility of the driver.
>>>
>>>
>>> I moved the counters reset to the driver's logic on v11. I'm posting the
>>> patches in a few.
>>>
>>>> As I said in an earlier
>>>> post, anything
>>>> other than the driver handling any statistical event monitoring, such an
>>>> API is
>>>> broken for sure, without even reading single line of code for that API
>>>> for which
>>>>    it is written for.
>>>
>>>
>>> Yes, driver should have full control on it.
>>>
>>>>> OK, maybe we will see in near future if that works well or not. I think
>>>>> that
>>>>> for calculating of PER it is required to start continuous polling to
>>>>> keep up
>>>>> total block counters. Maybe updating UCB counter continously needs that
>>>>> too,
>>>>> so it should work.
>>>>
>>>>
>>>>
>>>> With multi-standard demodulators, some of them PER compute is a
>>>> by-product
>>>> of some internal demodulator algorithmic operation. In some cases, it
>>>> might
>>>> require a loop in the driver. As I said, again; It is very hard/wrong
>>>> to do basic
>>>> generalizations.
>>>
>>>
>>> Agreed.
>>>
>>
>> I think we will have soon kinda consensus everyone could approve! Anyhow, I
>> didn't liked that kind of PATCH RFC process. That change was too big for
>> PATCH style RFC and it was hard to keep track what going on looking those
>> patches. Maybe requirement specification RFCs first and when requirements
>> are clear => PATCH RFC for implementation.
>>
>> What I know understand, requirements are:
>>
>> signal strength:
>> ==============
>> Offer both discussed methods.
>> Simple [0...n] scale and dB...
>> Driver must support simple scale over dB.
>
>
> What happens, if the hardware doesn't support any dB scale ?
>
>
>>
>> CNR (SNR)
>> ==============
>> Offer both discussed methods.
>> Simple [0...n] scale and dB...
>> Driver must support simple scale over dB.
>
>
> Same question here as well.
>
>>
>> BER
>> ==============
>> Offer global BER and per layer BER.
>> Measure is returned as two numbers, one for error bit count and one for
>> total bit count.
>>
>> uncorrected packets/blocks
>> ==============
>> Offer global UCB and per layer UCB.
>> Measure is returned as two numbers, one for uncorrected packet count and one
>> for total packet count.
>>
>> counter reset
>> ==============
>> counters are reset when channel is tuned
>
>
> Counter reset behaviour is a bit undefined, for the reason stated earlier.
> ie, the driver should do the reset, as it sees fit rather than common code.
> well, it would be correct to state at start of frame count after
> stream is initialized.
> Initialization of stream can happen on legacy systems: only after successful
> synchronous viterbi is achieved. Tuning to a channel doesn't make any sense.
>
> In some of the non-legacy systems, stream initialization would happen
> on a filter
> setup change as well. It is not dependent on a  channel switch/tune.
>
>
>> And if we end up returning "simple" values over dB values, then I think
>> driver could be simple and implement only dB and dvb-core is responsible to
>> convert dB => simple. That should quite be possible as we know which dB
>> value is good signal and which is bad signal.
>
> Again, not all devices can output in dB.
>
> Manu
>

I was a little bit unclear? There is two supported methods for SS and 
CNR, dB and relative scale to some defined range. If driver supports dB 
then dB is used, and if not then then relative scale is used.

My propose was to ask if we could add some generic calculations for the 
DVB-core, so that implementing only one method for the driver is enough. 
If app is asking relative value and driver does dB, then DVB-core makes 
conversion. For CNR, take CNR dB and modulation, return relative value 
for app. For SS conversion is even simpler.

regards
Antti

-- 
http://palosaari.fi/
