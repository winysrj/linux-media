Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755856Ab0CXMQj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Mar 2010 08:16:39 -0400
Message-ID: <4BAA0257.3090303@redhat.com>
Date: Wed, 24 Mar 2010 09:15:19 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: matthieu castet <castet.matthieu@free.fr>,
	linux-media@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: i2c interface bugs in dvb drivers
References: <4BA6270A.4050703@free.fr> <20100324105636.4d6bf82d@hyperion.delvare>
In-Reply-To: <20100324105636.4d6bf82d@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean Delvare wrote:
> Hi Matthieu,
> 
> On Sun, 21 Mar 2010 15:02:50 +0100, matthieu castet wrote:
>> some dvb driver that export a i2c interface contains some mistakes
>> because they mainly used by driver (frontend, tuner) wrote for them.
>> But the i2c interface is exposed to everybody.
>>
>> One mistake is expect msg[i].addr with 8 bits address instead of 7
>> bits address. This make them use eeprom address at 0xa0 instead of
>> 0x50. Also they shift tuner address (qt1010 tuner is likely to be
>> at address 0x62, but some put it a 0xc4 (af9015, af9005, dtv5100)).
>>
>> Other mistakes is in xfer callback. Often the controller support a
>> limited i2c support (n bytes write then m bytes read). The driver
>> try to convert the linux i2c msg to this pattern, but they often
>> miss cases :
>> - msg[i].len can be null
> 
> Zero, not null. This is a very rare case, I've never seen it in
> multi-message transactions (wouldn't make much sense IMHO), only in
> the single-message transaction known as SMBus quick command. Many
> controllers don't support it, so I2C bus drivers don't have to support
> it. It should be assumed by I2C chip drivers that an I2C adapter
> without functionality bit I2C_FUNC_SMBUS_QUICK does not support 0-byte
> messages.
> 
>> - msg write are not always followed by msg read
>>
>> And this can be dangerous if these interfaces are exported to
>> userspace via i2c-dev :
> 
> Even without that... We certainly hope to reuse client drivers for
> other families of DVB cards, and for this to work, every driver must
> stick to the standard.
> 
>> - some scanning program avoid eeprom by filtering 0x5x range, but
>> now it is at 0xax range (well that should happen because scan limit
>> should be 0x77)
>> - some read only command can be interpreted as write command.
> 
> Very bad indeed.
> 
>> What should be done ?
>> Fix the drivers.
> 
> Yes, definitely. The sooner, the better.

Agreed. Could you please propose some patches to fix them?

>> Have a mode where i2c interface are not exported to everybody.
> 
> I have considered this for a moment. It might be fair to let I2C bus
> drivers decide whether they want i2c-dev to expose their buses or not.
> We could use a new class bit (I2C_CLASS_USER or such) to this purpose. 

This is a good idea. Users shouldn't be playing with the internal interfaces
inside the DVB driver. This can be dangerous, as it may cause driver
miss-functioning, cause memory corruption or eventually hit some bug and
make the driver crash. Also, due to I2C bridges that are very common 
on DVB designs, this interface is broken anyway, as the bridge code, when needed,
is generally implemented outside i2c xfer routines.

Cheers,
Mauro
