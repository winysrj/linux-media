Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44329 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab2HFSUG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 14:20:06 -0400
Received: by lbbgm6 with SMTP id gm6so2986576lbb.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 11:20:05 -0700 (PDT)
Message-ID: <50200AC9.9080203@iki.fi>
Date: Mon, 06 Aug 2012 21:19:53 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: tda18271 driver power consumption
References: <500C5B9B.8000303@iki.fi> <CAOcJUbw-8zG-j7YobgKy7k5vp-k_trkaB5fYGz605KdUQHKTGQ@mail.gmail.com> <500F1DC5.1000608@iki.fi> <CAOcJUbzXoLx10o8oprxPM1TELFxyGE7_wodcWsBr8MX4OR0N_w@mail.gmail.com>
In-Reply-To: <CAOcJUbzXoLx10o8oprxPM1TELFxyGE7_wodcWsBr8MX4OR0N_w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/25/2012 01:17 AM, Michael Krufky wrote:
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


You should understand from DVB driver model:
* attach() called only once when driver is loaded
* init() called to wake-up device
* sleep() called to sleep device

What I would like to say is that there is very big risk to shoot own leg 
when doing some initialization on attach(). For example resuming from 
the suspend could cause device reset and if you rely some settings that 
are done during attach() you will likely fail as Kernel / USB-host 
controller has reset your device.

See reset_resume from Kernel documentation:
Documentation/usb/power-management.txt

regards
Antti

-- 
http://palosaari.fi/
