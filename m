Return-path: <linux-media-owner@vger.kernel.org>
Received: from racoon.tvdr.de ([188.40.50.18]:38106 "EHLO racoon.tvdr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756325Ab3AQRh0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jan 2013 12:37:26 -0500
Received: from dolphin.tvdr.de (dolphin.tvdr.de [192.168.100.2])
	by racoon.tvdr.de (8.14.5/8.14.5) with ESMTP id r0HHbOr0009567
	for <linux-media@vger.kernel.org>; Thu, 17 Jan 2013 18:37:25 +0100
Received: from [192.168.100.11] (falcon.tvdr.de [192.168.100.11])
	by dolphin.tvdr.de (8.14.4/8.14.4) with ESMTP id r0HHbIpX013472
	for <linux-media@vger.kernel.org>; Thu, 17 Jan 2013 18:37:19 +0100
Message-ID: <50F836CE.2020502@tvdr.de>
Date: Thu, 17 Jan 2013 18:37:18 +0100
From: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-media] Re: [PATCH RFCv10 00/15] DVB QoS statistics API
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com> <20130116152151.5461221c@redhat.com> <CAHFNz9KjG-qO5WoCMzPtcdb6d-4iZk695zp_L3iSeb=ZiWKhQw@mail.gmail.com> <2817386.vHx2V41lNt@f17simon> <20130116200153.3ec3ee7d@redhat.com> <CAHFNz9L-Dzrv=+Z01ndrfK3GmvFyxT6941W4-_63bwn1HrQBYQ@mail.gmail.com> <50F7C57A.6090703@iki.fi> <CAHFNz9LRf0aYMR0nYCgtkatkjHgbCKJKovRaUsdQ1X=UmFEOLQ@mail.gmail.com> <50F8333E.2020904@iki.fi>
In-Reply-To: <50F8333E.2020904@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17.01.2013 18:22, Antti Palosaari wrote:
> On 01/17/2013 07:16 PM, Manu Abraham wrote:
>> On Thu, Jan 17, 2013 at 3:03 PM, Antti Palosaari <crope@iki.fi> wrote:
>>> On 01/17/2013 05:40 AM, Manu Abraham wrote:
>>>> MB86A20 is not the only demodulator driver with the Linux DVB.
>>>> And not all devices can output in dB scale proposed by you, But any device
>>>> output can be scaled in a relative way. So I don't see any reason why
>>>> userspace has to deal with cumbersome controls to deal with redundant
>>>> statistics, which is nonsense.
>>>
>>>
>>> What goes to these units in general, dB conversion is done by the driver
>>> about always. It is quite hard or even impossible to find out that formula
>>> unless you has adjustable test signal generator.
>>>
>>> Also we could not offer always dBm as signal strength. This comes to fact
>>> that only recent silicon RF-tuners are able to provide RF strength. More
>>> traditionally that estimation is done by demod from IF/RF AGC, which leads
>>> very, very, rough estimation.
>>
>> What I am saying is that, rather than sticking to a dB scale, it would be
>> better to fit it into a relative scale, ie loose dB altogether and use only the
>> relative scale. With that approach any device can be fit into that convention.
>> Even with an unknown device, it makes it pretty easy for anyone to fit
>> into that
>> scale. All you need is a few trial runs to get maxima/minima. When there
>> exists only a single convention that is simple, it makes it more easier for
>> people to stick to that convention, rather than for people to not support it.
>
> That is true. I don't have really clear opinion whether to force all to one scale, or return dBm those which could and that dummy scale for the others. Maybe I will still vote for both relative and dBm.
>
> Shortly there is two possibilities:
> 1) support only relative scale
> 2) support both dBm and relative scale (with dBm priority)
>
> [3) support only dBm is not possible]

4) support relative scale (mandatory!) and dBm (if applicable).

I concur with Antti. Any device's values can be made to fit into
a 0..100 (or whatever) range, so *that* should be the primary (and
mandatory) value. If the device can do so, it can also provide a dB*
value (replace * with anything you like, 'm', 'uV', 'uW', whatever)
and maybe all other sorts of bells and whistles.
So real world applications could simply and savely use the relative
value (which is all they need), and special applications could fiddle
around with dB values (provided the device in use can deliver them).

@Mauro: here's some further reading for you, just in case ;-)

   http://en.wikipedia.org/wiki/KISS_principle
   http://www.inspireux.com/2008/07/14/a-designer-achieves-perfection-when-there-is-nothing-left-to-take-away

Klaus
