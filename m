Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:35457 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab2GXWRl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jul 2012 18:17:41 -0400
Received: by weyx8 with SMTP id x8so52910wey.19
        for <linux-media@vger.kernel.org>; Tue, 24 Jul 2012 15:17:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <500F1DC5.1000608@iki.fi>
References: <500C5B9B.8000303@iki.fi>
	<CAOcJUbw-8zG-j7YobgKy7k5vp-k_trkaB5fYGz605KdUQHKTGQ@mail.gmail.com>
	<500F1DC5.1000608@iki.fi>
Date: Tue, 24 Jul 2012 18:17:39 -0400
Message-ID: <CAOcJUbzXoLx10o8oprxPM1TELFxyGE7_wodcWsBr8MX4OR0N_w@mail.gmail.com>
Subject: Re: tda18271 driver power consumption
From: Michael Krufky <mkrufky@linuxtv.org>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 24, 2012 at 6:12 PM, Antti Palosaari <crope@iki.fi> wrote:
> On 07/25/2012 12:55 AM, Michael Krufky wrote:
>>
>> On Sun, Jul 22, 2012 at 3:59 PM, Antti Palosaari <crope@iki.fi> wrote:
>>>
>>> Moi Michael,
>>> I just realized tda18271 driver eats 160mA too much current after attach.
>>> This means, there is power management bug.
>>>
>>> When I plug my nanoStick it eats total 240mA, after tda18271 sleep is
>>> called
>>> it eats only 80mA total which is reasonable. If I use Digital Devices
>>> tda18271c2dd driver it is total 110mA after attach, which is also quite
>>> OK.
>>
>>
>> Thanks for the report -- I will take a look at it.
>>
>> ...patches are welcome, of course :-)
>
>
> I suspect it does some tweaking on attach() and chip leaves powered (I saw
> demod debugs at calls I2C-gate control quite many times thus this
> suspicion). When chip is powered-up it is usually in some sleep state by
> default. Also, on attach() there should be no I/O unless very good reason.
> For example chip ID is allowed to read and download firmware in case it is
> really needed to continue - like for tuner communication.
>
>
> What I found quickly testing few DVB USB sticks there seems to be very much
> power management problems... I am now waiting for new multimeter in order to
> make better measurements and likely return fixing these issues later.

The driver does some calibration during attach, some of which is a
one-time initialization to determine a temperature differential for
tune calculation later on, which can take some time on slower USB
buses.  The "fix" for the power usage issue would just be to make sure
to sleep the device before exiting the attach() function.

I'm not looking to remove the calibration from the attach -- this was
done on purpose.

-Mike
