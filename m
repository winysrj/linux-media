Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:47314 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab3AQRQn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jan 2013 12:16:43 -0500
Received: by mail-ob0-f179.google.com with SMTP id x4so2765005obh.24
        for <linux-media@vger.kernel.org>; Thu, 17 Jan 2013 09:16:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50F7C57A.6090703@iki.fi>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
	<20130116152151.5461221c@redhat.com>
	<CAHFNz9KjG-qO5WoCMzPtcdb6d-4iZk695zp_L3iSeb=ZiWKhQw@mail.gmail.com>
	<2817386.vHx2V41lNt@f17simon>
	<20130116200153.3ec3ee7d@redhat.com>
	<CAHFNz9L-Dzrv=+Z01ndrfK3GmvFyxT6941W4-_63bwn1HrQBYQ@mail.gmail.com>
	<50F7C57A.6090703@iki.fi>
Date: Thu, 17 Jan 2013 22:46:42 +0530
Message-ID: <CAHFNz9LRf0aYMR0nYCgtkatkjHgbCKJKovRaUsdQ1X=UmFEOLQ@mail.gmail.com>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
From: Manu Abraham <abraham.manu@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Simon Farnsworth <simon.farnsworth@onelan.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 17, 2013 at 3:03 PM, Antti Palosaari <crope@iki.fi> wrote:
> On 01/17/2013 05:40 AM, Manu Abraham wrote:
>>
>> On Thu, Jan 17, 2013 at 3:31 AM, Mauro Carvalho Chehab
>> <mchehab@redhat.com> wrote:
>>>
>>> Em Wed, 16 Jan 2013 19:29:28 +0000
>>> Simon Farnsworth <simon.farnsworth@onelan.com> escreveu:
>>>
>>>> On Wednesday 16 January 2013 23:56:48 Manu Abraham wrote:
>>>>>
>>>>> On Wed, Jan 16, 2013 at 10:51 PM, Mauro Carvalho Chehab
>>>>
>>>> <snip>
>>>>>>
>>>>>>
>>>>>> It is a common sense that the existing API is broken. If my proposal
>>>>>> requires adjustments, please comment on each specific patchset,
>>>>>> instead
>>>>>> of filling this thread of destructive and useless complains.
>>>>>
>>>>>
>>>>>
>>>>> No, the concept of such a generalization is broken, as each new device
>>>>> will
>>>>> be different and trying to make more generalization is a waste of
>>>>> developer
>>>>> time and effort. The simplest approach would be to do a coarse
>>>>> approach,
>>>>> which is not a perfect world, but it will do some good results for all
>>>>> the
>>>>> people who use Linux-DVB. Still, repeating myself we are not dealing
>>>>> with
>>>>> high end professional devices. If we have such devices, then it makes
>>>>> sense
>>>>> to start such a discussion. Anyway professional devices will need a lot
>>>>> of
>>>>> other API extensions, so your arguments on the need for professional
>>>>> devices that do not exist are pointless and not agreeable to.
>>>>>
>>>> Let's step back a bit. As a sophisticated API user, I want to be able to
>>>> give
>>>> my end-users the following information:
>>>>
>>>>   * Signal strength in dBm
>>>>   * Signal quality as "poor", "OK" and "good".
>>>>   * Ideally, "increase signal strength to improve things" or "attenuate
>>>> signal
>>>> to improve things"
>>>>
>>>> In a DVBv3 world, "poor" equates to UNC != 0, "OK" is UNC == 0, BER !=
>>>> 0,
>>>> and "good" is UNC == BER == 0. The idea is that a user seeing "poor"
>>>> knows
>>>> that they will see glitches in the output; a user seeing "OK" knows that
>>>> there's no glitching right now, but that the setup is marginal and may
>>>> struggle if anything changes, and a user seeing "good" knows that
>>>> they've got
>>>> high quality signal.
>>>>
>>>> VDR wants even simpler - it just wants strength and quality on a 0 to
>>>> 100
>>>> scale, where 100 is perfect, and 0 is nothing present.
>>>>
>>>> In both cases, we want per-layer quality for ISDB-T, for the reasons
>>>> you've
>>>> already outlined.
>>>>
>>>> So, how do you provide such information? Is it enough to simply provide
>>>> strength in dBm, and quality as 0 to 100, where anything under 33
>>>> indicates
>>>> uncorrected errors, and anything under 66 indicates that quality is
>>>> marginal?
>>>
>>>
>>> Unfortunately, not all devices can provide strength in dBm.
>>
>>
>> MB86A20 is not the only demodulator driver with the Linux DVB.
>> And not all devices can output in dB scale proposed by you, But any device
>> output can be scaled in a relative way. So I don't see any reason why
>> userspace has to deal with cumbersome controls to deal with redundant
>> statistics, which is nonsense.
>
>
> What goes to these units in general, dB conversion is done by the driver
> about always. It is quite hard or even impossible to find out that formula
> unless you has adjustable test signal generator.
>
> Also we could not offer always dBm as signal strength. This comes to fact
> that only recent silicon RF-tuners are able to provide RF strength. More
> traditionally that estimation is done by demod from IF/RF AGC, which leads
> very, very, rough estimation.

What I am saying is that, rather than sticking to a dB scale, it would be
better to fit it into a relative scale, ie loose dB altogether and use only the
relative scale. With that approach any device can be fit into that convention.
Even with an unknown device, it makes it pretty easy for anyone to fit
into that
scale. All you need is a few trial runs to get maxima/minima. When there
exists only a single convention that is simple, it makes it more easier for
people to stick to that convention, rather than for people to not support it.

Manu
