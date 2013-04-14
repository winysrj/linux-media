Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56153 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106Ab3DNTdQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 15:33:16 -0400
Message-ID: <516B0452.7020801@iki.fi>
Date: Sun, 14 Apr 2013 22:32:34 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 0/3] em28xx: clean up end extend the GPIO port handling
References: <1365846521-3127-1-git-send-email-fschaefer.oss@googlemail.com> <51695A7B.4010206@iki.fi> <20130413112517.40833d48@redhat.com> <51696DA6.9020508@iki.fi> <20130413223247.3dc4da85@redhat.com>
In-Reply-To: <20130413223247.3dc4da85@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/14/2013 04:32 AM, Mauro Carvalho Chehab wrote:
> Em Sat, 13 Apr 2013 17:37:26 +0300
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> On 04/13/2013 05:25 PM, Mauro Carvalho Chehab wrote:
>>> Em Sat, 13 Apr 2013 16:15:39 +0300
>>> Antti Palosaari <crope@iki.fi> escreveu:
>>>
>>>> On 04/13/2013 12:48 PM, Frank Schäfer wrote:
>>>>> Patch 1 removes the unneeded and broken gpio register caching code.
>>>>> Patch 2 adds the gpio register defintions for the em25xx/em276x/7x/8x
>>>>> and patch 3 finally adds a new helper function for gpio ports with separate
>>>>> registers for read and write access.
>>>>
>>>>
>>>> I have nothing to say directly about those patches - they looked good at
>>>> the quick check. But I wonder if you have any idea if it is possible to
>>>> use some existing Kernel GPIO functionality in order to provide standard
>>>> interface (interface like I2C). I did some work last summer in order to
>>>> use GPIOLIB and it is used between em28xx-dvb and cxd2820r for LNA
>>>> control. Anyhow, I was a little bit disappointed as GPIOLIB is disabled
>>>> by default and due to that there is macros to disable LNA when GPIOLIB
>>>> is not compiled.
>>>> I noticed recently there is some ongoing development for Kernel GPIO. I
>>>> haven't looked yet if it makes use of GPIO interface more common...
>>>
>>> I have conflicting opinions myself weather we should use gpiolib or not.
>>>
>>> I don't mind with the fact that GPIOLIB is disabled by default. If all
>>> media drivers start depending on it, distros will enable it to keep
>>> media support on it.
>>>
>>> I never took the time to take a look on what methods gpiolib provides.
>>> Maybe it will bring some benefits. I dunno.
>>
>> Compare to benefits of I2C bus. It offers standard interface. Also it
>> offers userspace debug interface - like I2C also does.
>
> I2C benefit is that the same I2C driver can be used by several different
> drivers. GPIO code, on the other hand, is on most cases[1] specific to a
> given device.

That is same for GPIO - it offers standard interface between modules for 
GPIO "bus".

I used it to control LNA, which is connected to demodulator (cxd2820r) 
GPIO. It is bridge which gets LNA API commands and GPIO is property of 
demod. Some interface is needed in order to deliver data between bridge 
and demod in that case.


> [1] Ok, if you're using a GPIO pin to carry some protocol inside it, like
> UART, RC, etc, then I can see a benefit on using a bus type of solution.
>
>>> Just looking at the existing drivers (almost all has some sort of GPIO
>>> config), GPIO is just a single register bitmask read/write. Most drivers
>>> need already bitmask read/write operations. So, in principle, I can't
>>> foresee any code simplification by using a library.
>>
>> Use of lib interface is not very practical inside of module, however it
>> could be used. Again, as compared to I2C there is some bridge drivers
>> which do some I2C access using I2C interface, even bridge could do it
>> directly (as it offers I2C adapter). I think it is most common to do it
>> directly to simplify things.
>>
>>> Also, from a very pragmatic view, changing (almost) all existing drivers
>>> to use gpiolib is a big effort.
>>
>> It is not needed to implement for all driver as one go.
>>
>>> However, for that to happen, one question should be answered: what
>>> benefits would be obtained by using gpiolib?
>>
>> Obtain GPIO access between modules using standard interface and offer
>> handy debug interface to switch GPIOs from userspace.
>
> It is known that enabling both analog and digital demods at the same time
> can melt some devices. So, it is risky to allow userspace to touch
> the GPIOs that enable such chips.
>
> (ok, there are also other forms to melt such devices in userspace
>   if the user has CAP_SYS_ADMIN)

Do you need eyeglasses? I said it is debug interface. It needs root 
privileges in order to setup and use.

I can say I could surely break more devices via I2C debug interface than 
GPIO debug interface in case both are implemented by every driver. Just 
sent garbage writes to well known eeprom addresses and kaboom. Your 
device is bricked. It is totally stupid to say you could brick your 
device using debug functionality - yes you can, but it is very unlikely 
someone does it as a mistake.


>> You could ask why we use Kernel I2C library as we could do it directly
>> :) Or clock framework. Or SPI, is there SPI bus modeled yet?
>
> As I said, i2c allowed code re-usage. Probably, the clock framework and
> SPI also can be used for that.
>
> With regards to GPIO, at least currently, I can only see its usage
> justified, in terms of code reuse, for remote controllers.

Maybe better to read Kernel GPIO documentation. There is few points 
mentioned why to use it and what are advantages.

regards
Antti

-- 
http://palosaari.fi/
