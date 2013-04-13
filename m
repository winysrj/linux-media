Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:36563 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab3DMP3m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Apr 2013 11:29:42 -0400
Received: by mail-ea0-f182.google.com with SMTP id q15so1657067ead.41
        for <linux-media@vger.kernel.org>; Sat, 13 Apr 2013 08:29:41 -0700 (PDT)
Message-ID: <51697A29.5030307@googlemail.com>
Date: Sat, 13 Apr 2013 17:30:49 +0200
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/3] em28xx: clean up end extend the GPIO port handling
References: <1365846521-3127-1-git-send-email-fschaefer.oss@googlemail.com> <51695A7B.4010206@iki.fi> <20130413112517.40833d48@redhat.com>
In-Reply-To: <20130413112517.40833d48@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 13.04.2013 16:25, schrieb Mauro Carvalho Chehab:
> Em Sat, 13 Apr 2013 16:15:39 +0300
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> On 04/13/2013 12:48 PM, Frank Schäfer wrote:
>>> Patch 1 removes the unneeded and broken gpio register caching code.
>>> Patch 2 adds the gpio register defintions for the em25xx/em276x/7x/8x
>>> and patch 3 finally adds a new helper function for gpio ports with separate
>>> registers for read and write access.
>>
>> I have nothing to say directly about those patches - they looked good at 
>> the quick check. But I wonder if you have any idea if it is possible to 
>> use some existing Kernel GPIO functionality in order to provide standard 
>> interface (interface like I2C). I did some work last summer in order to 
>> use GPIOLIB and it is used between em28xx-dvb and cxd2820r for LNA 
>> control. Anyhow, I was a little bit disappointed as GPIOLIB is disabled 
>> by default and due to that there is macros to disable LNA when GPIOLIB 
>> is not compiled.
>> I noticed recently there is some ongoing development for Kernel GPIO. I 
>> haven't looked yet if it makes use of GPIO interface more common...
> I have conflicting opinions myself weather we should use gpiolib or not.
>
> I don't mind with the fact that GPIOLIB is disabled by default. If all
> media drivers start depending on it, distros will enable it to keep
> media support on it.

Right.

> I never took the time to take a look on what methods gpiolib provides.
> Maybe it will bring some benefits. I dunno.
>
> Just looking at the existing drivers (almost all has some sort of GPIO
> config), GPIO is just a single register bitmask read/write. Most drivers
> need already bitmask read/write operations. So, in principle, I can't
> foresee any code simplification by using a library.
...
> However, for that to happen, one question should be answered: what
> benefits would be obtained by using gpiolib?
>

I've checked the documentation about the gpio and led frameworks a few
weeks ago to find out if it makes sense to use them for the
gpio/buttons/led stuff of the VAD Laplace webcam.
AFAICS, there are no benfits as long as you are dealing with these
things internally. It just increases the code size and adds an
additional dependency in this case.
Of course, the situation is different when there is an interaction with
other modules or userspace. In that case using gpiolib could make sense.
I don't know which case applies to the LAN stuff, but for the
buttons/leds it's the first case.

Regards,
Frank


