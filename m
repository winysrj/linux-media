Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33650 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab3AQRWo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jan 2013 12:22:44 -0500
Message-ID: <50F8333E.2020904@iki.fi>
Date: Thu, 17 Jan 2013 19:22:06 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Simon Farnsworth <simon.farnsworth@onelan.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com> <20130116152151.5461221c@redhat.com> <CAHFNz9KjG-qO5WoCMzPtcdb6d-4iZk695zp_L3iSeb=ZiWKhQw@mail.gmail.com> <2817386.vHx2V41lNt@f17simon> <20130116200153.3ec3ee7d@redhat.com> <CAHFNz9L-Dzrv=+Z01ndrfK3GmvFyxT6941W4-_63bwn1HrQBYQ@mail.gmail.com> <50F7C57A.6090703@iki.fi> <CAHFNz9LRf0aYMR0nYCgtkatkjHgbCKJKovRaUsdQ1X=UmFEOLQ@mail.gmail.com>
In-Reply-To: <CAHFNz9LRf0aYMR0nYCgtkatkjHgbCKJKovRaUsdQ1X=UmFEOLQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/17/2013 07:16 PM, Manu Abraham wrote:
> On Thu, Jan 17, 2013 at 3:03 PM, Antti Palosaari <crope@iki.fi> wrote:
>> On 01/17/2013 05:40 AM, Manu Abraham wrote:
>>> MB86A20 is not the only demodulator driver with the Linux DVB.
>>> And not all devices can output in dB scale proposed by you, But any device
>>> output can be scaled in a relative way. So I don't see any reason why
>>> userspace has to deal with cumbersome controls to deal with redundant
>>> statistics, which is nonsense.
>>
>>
>> What goes to these units in general, dB conversion is done by the driver
>> about always. It is quite hard or even impossible to find out that formula
>> unless you has adjustable test signal generator.
>>
>> Also we could not offer always dBm as signal strength. This comes to fact
>> that only recent silicon RF-tuners are able to provide RF strength. More
>> traditionally that estimation is done by demod from IF/RF AGC, which leads
>> very, very, rough estimation.
>
> What I am saying is that, rather than sticking to a dB scale, it would be
> better to fit it into a relative scale, ie loose dB altogether and use only the
> relative scale. With that approach any device can be fit into that convention.
> Even with an unknown device, it makes it pretty easy for anyone to fit
> into that
> scale. All you need is a few trial runs to get maxima/minima. When there
> exists only a single convention that is simple, it makes it more easier for
> people to stick to that convention, rather than for people to not support it.

That is true. I don't have really clear opinion whether to force all to 
one scale, or return dBm those which could and that dummy scale for the 
others. Maybe I will still vote for both relative and dBm.

Shortly there is two possibilities:
1) support only relative scale
2) support both dBm and relative scale (with dBm priority)

[3) support only dBm is not possible]

regards
Antti

-- 
http://palosaari.fi/
