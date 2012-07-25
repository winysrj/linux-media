Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:44212 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab2GYAPb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jul 2012 20:15:31 -0400
Received: by weyx8 with SMTP id x8so106551wey.19
        for <linux-media@vger.kernel.org>; Tue, 24 Jul 2012 17:15:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOcJUbzXoLx10o8oprxPM1TELFxyGE7_wodcWsBr8MX4OR0N_w@mail.gmail.com>
References: <500C5B9B.8000303@iki.fi>
	<CAOcJUbw-8zG-j7YobgKy7k5vp-k_trkaB5fYGz605KdUQHKTGQ@mail.gmail.com>
	<500F1DC5.1000608@iki.fi>
	<CAOcJUbzXoLx10o8oprxPM1TELFxyGE7_wodcWsBr8MX4OR0N_w@mail.gmail.com>
Date: Tue, 24 Jul 2012 20:15:30 -0400
Message-ID: <CAOcJUbzJjBBMcLmeaOCsJRz44KVPqZ_sGctG8+ai=n1W+9P9xA@mail.gmail.com>
Subject: Re: tda18271 driver power consumption
From: Michael Krufky <mkrufky@linuxtv.org>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 24, 2012 at 6:17 PM, Michael Krufky <mkrufky@linuxtv.org> wrote:
> On Tue, Jul 24, 2012 at 6:12 PM, Antti Palosaari <crope@iki.fi> wrote:
>> On 07/25/2012 12:55 AM, Michael Krufky wrote:
>>>
>>> On Sun, Jul 22, 2012 at 3:59 PM, Antti Palosaari <crope@iki.fi> wrote:
>>>>
>>>> Moi Michael,
>>>> I just realized tda18271 driver eats 160mA too much current after attach.
>>>> This means, there is power management bug.
>>>>
>>>> When I plug my nanoStick it eats total 240mA, after tda18271 sleep is
>>>> called
>>>> it eats only 80mA total which is reasonable. If I use Digital Devices
>>>> tda18271c2dd driver it is total 110mA after attach, which is also quite
>>>> OK.
>>>
>>>
>>> Thanks for the report -- I will take a look at it.
>>>
>>> ...patches are welcome, of course :-)
>>
>>
>> I suspect it does some tweaking on attach() and chip leaves powered (I saw
>> demod debugs at calls I2C-gate control quite many times thus this
>> suspicion). When chip is powered-up it is usually in some sleep state by
>> default. Also, on attach() there should be no I/O unless very good reason.
>> For example chip ID is allowed to read and download firmware in case it is
>> really needed to continue - like for tuner communication.
>>
>>
>> What I found quickly testing few DVB USB sticks there seems to be very much
>> power management problems... I am now waiting for new multimeter in order to
>> make better measurements and likely return fixing these issues later.
>
> The driver does some calibration during attach, some of which is a
> one-time initialization to determine a temperature differential for
> tune calculation later on, which can take some time on slower USB
> buses.  The "fix" for the power usage issue would just be to make sure
> to sleep the device before exiting the attach() function.
>
> I'm not looking to remove the calibration from the attach -- this was
> done on purpose.
>

Antti,

After looking again, I realize that we are purposefully not sleeping
the device before we exit the attach() function.

The tda18271 is commonly found in multi-chip designs that may or may
not include an analog demodulator and / or other tda18271 tuners.  In
such designs, the chips tend to be daisy-chained to each other, using
the xtal output and loop-thru features of the tda18271.  We set the
required features in the attach-time configuration structure.
However, we must keep in mind that this is a hybrid tuner chip, and
the analog side of the bridge driver may actually come up before the
digital side.  Since the actual configuration tends to be done in the
digital bring-up, the analog side is brought up within tuner.ko using
the most generic one-size-fits all configuration, which gets
overridden when the digital side initializes.

It is absolutely crucial that if we actually need the xtal output
feature enabled, that it must *never* be turned off, otherwise the i2c
bus may get wedged unrecoverably.  So, we make sure to leave this
feature enabled during the attach function, since we don't yet know at
that point whether there is another "instance" of this same tuner yet
to be initialized.  It is not safe to power off that feature until
after we are sure that the bridge has completely initialized.

In order to rectify this issue from within your driver, you should
call sleep after you complete the attach.  For instance, this is what
we do in the cx23885 driver:

if (fe0->dvb.frontend->ops.analog_ops.standby)
                 fe0->dvb.frontend->ops.analog_ops.standby(fe0->dvb.frontend);


...except you should call into the tuner_ops->sleep() function instead
of analog_demod_ops->standby()

Does this clear things up for you?

Regards,

Mike Krufky
