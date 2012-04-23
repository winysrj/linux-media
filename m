Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38266 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab2DWTvW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 15:51:22 -0400
Received: by eaaq12 with SMTP id q12so3326360eaa.19
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2012 12:51:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F958640.9010404@iki.fi>
References: <1327228731.2540.3.camel@tvbox>
	<4F2185A1.2000402@redhat.com>
	<201204152353103757288@gmail.com>
	<201204201601166255937@gmail.com>
	<4F9130BB.8060107@iki.fi>
	<201204211045557968605@gmail.com>
	<4F958640.9010404@iki.fi>
Date: Mon, 23 Apr 2012 22:51:21 +0300
Message-ID: <CAF0Ff2nNP6WRUWcs7PqVRxhXHCmUFqqswL4757WijFaKT5P5-w@mail.gmail.com>
Subject: Re: [PATCH 1/6] m88ds3103, montage dvb-s/s2 demodulator driver
From: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: "nibble.max" <nibble.max@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti, i already commented about ds3103 drivers months ago:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg41135.html

and from my point of view nothing have changed - ds3103 chip is almost
the same as ds3000 and the driver i made for ds3000 from scratch is
what was used ds3103 drivers to be created. so, what you actually is
suggesting - my driver to be removed from the kernel and driver that
was made based on my hard work to be included and that driver author
even refuses to acknowledge my work?!  such practices are really good
for the open-source community, don't you think? also, we already have
one case for example, where to satisfy someone's interests two drivers
for the same demodulators (STV090x family of chips) were accepted in
the kernel - i doubt anyone actually can tell why there are 2 drivers
for STV090x in the kernel and instead the community to support the
driver for STV090x that was made with more open-source ideas in mind,
i.e. the one that can work with any STV090x design and which relies
less on code copyrighted by ST - anyway, those details about STV090x
drivers are off-topic here, but i'm still giving them as example,
because the fact is that already once such mess was created having
multiple drivers for the same generation of chips in the kernel and
apparently those practices will continue if someone don't raise those
questions out loud.

also, why Montage tuner code should be spitted from the demodulator
code? is there any evidence that any Montage tuner (ts2020 or ts2022)
can work with 3rd party demodulator different than ds3000 or ds3103?
are there such designs in real-life, e.g. either Montage demodulator
with 3rd party tuner or actually more importantly for what you're
suggesting Montage tuner (ts2020 or ts2022) with third party
demodulator? it's more or less the same case as with cx24116 (and
tda10071) demodulator, where the tuner (cx24118a) is controlled by the
firmware and thus it's solely part of the demodulator driver, even
that it's possible to control the cx24118a tuner that is used with
cx24116 (and tda10071) designs directly bypassing the firmware. so,
why we don't change in that way the cx24116 (and tda10071) drivers
too?

i just don't see what's the motivation behind what you're suggesting,
because ds3103 is almost the same as ds3000 from driver point of view
and one driver code can be used for both and Montage tuners in
question can work only with those demodulators (or at least are used
in practice only with them). so, if there are any evidences that's not
true then OK let's split them, but if not then what's the point of
that?

On Mon, Apr 23, 2012 at 7:41 PM, Antti Palosaari <crope@iki.fi> wrote:
> On 21.04.2012 05:45, nibble.max wrote:
>>
>> 2012-04-21 10:38:02 nibble.max@gmail.com
>>>
>>> Em 20-04-2012 06:47, Antti Palosaari escreveu:
>>>>
>>>> On 20.04.2012 11:01, nibble.max wrote:
>>>>>
>>>>> 2012-04-20 15:56:27 nibble.max@gmail.com
>>>>> At first time, I check it exist so try to patch it.
>>>>> But with new m88ds3103 features to add and ts2022 tuner include, find
>>>>> it is hard to do simply patch.
>>>>> It is better to create a new driver for maintain.
>>>>>>
>>>>>> Hi Max,
>>>>>>
>>>>>> Em 15-04-2012 12:53, nibble.max escreveu:
>>>>>>>
>>>>>>> Montage m88ds3103 demodulator and ts2022 tuner driver.
>>>>>>
>>>>>>
>>>>>> It was pointed to me that this device were already discussed on:
>>>>>>
>>>>>>
>>>>>>  http://www.mail-archive.com/linux-media@vger.kernel.org/msg43109.html
>>>>>>
>>>>>> If m88ds3103 demod is similar enough to ds3000, it should just add the
>>>>>> needed
>>>>>> bits at the existing driver, and not creating a new driver.
>>>>>>
>>>>>> Thanks,
>>>>>> Mauro
>>>>
>>>>
>>>> The main problem of these all existing and upcoming Montage DVB-S/S2
>>>> drivers are those are not split originally correct as a tuner and demod and
>>>> now it causes problems.
>>>>
>>>> I really suspect it should be:
>>>> * single demod driver that supports both DS3000 and DS3103
>>>> * single tuner driver that supports both TS2020 and TS2022
>>>>
>>>> And now what we have is 2 drivers that contains both tuner and demod.
>>>> And a lot of same code. :-(
>>>>
>>>> But it is almost impossible to split it correctly at that phase if you
>>>> don't have both hardware combinations, DS3000/TS2020 and DS3103/TS2022. I
>>>> think it is best to leave old DS3000 as it is and make new driver for DS3103
>>>> *and* TS2022. Maybe after that someone could add DS3000 support to new
>>>> DS3103 driver and TS2020 support to new TS2022 driver. After that it is
>>>> possible to remove old DS3000 driver.
>>>>
>>>> And we should really consider make simple rule not to accept any driver
>>>> which is not split as logical parts: USB/PCI-interface + demodulator +
>>>> tuner.
>>>
>>>
>>> Mixing tuner and demod is not good. Yet, dropping the current ds3000
>>> doesn't
>>> seem to be the best approach.
>>>
>>> IMO, Konstantin/Montage should split the ds3000 driver on two drivers,
>>> putting
>>> the ts2020 bits on a separate driver.
>>>
>>> Then, Max should write a patch for ds3000 in order to add support for
>>> ds3103 on
>>> it, and a patch for ts2020 driver, in order to add support for ts2022 on
>>> it.
>>>
>>> Of course, Konstantin should check if Max changes don't break support for
>>> the
>>> DS3000/TS2020 configuration.
>>>
>>> Regards,
>>> Mauro
>>
>> Actually, I have the following hardware combinations.
>> 1)DS3000 and TS2020 2)DS3103 and TS2020 3)DS3103 and TS2022
>> Should I sumbit the driver for DS3103 and TS2022 in the split files?
>> Or I must wait for Konstantin's work. How long should I wait for?
>
>
> OK, then you have good change to write driver for the DS3103 and
> TS2020/TS2022.
>
> I don't know how long exactly we should wait Konstantin's reply - this issue
> have open now several weeks and I think he haven't replied. My opinion is
> that lets wait few days and if no any reply just start splitting your driver
> for the DS3103 and TS2020/TS2022.
>
>
> regards
> Antti
> --
> http://palosaari.fi/
