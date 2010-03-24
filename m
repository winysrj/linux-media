Return-path: <linux-media-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:63930 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290Ab0CXJ4j (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Mar 2010 05:56:39 -0400
Date: Wed, 24 Mar 2010 10:56:36 +0100
From: Jean Delvare <khali@linux-fr.org>
To: matthieu castet <castet.matthieu@free.fr>
Cc: linux-media@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: i2c interface bugs in dvb drivers
Message-ID: <20100324105636.4d6bf82d@hyperion.delvare>
In-Reply-To: <4BA6270A.4050703@free.fr>
References: <4BA6270A.4050703@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matthieu,

On Sun, 21 Mar 2010 15:02:50 +0100, matthieu castet wrote:
> some dvb driver that export a i2c interface contains some mistakes
> because they mainly used by driver (frontend, tuner) wrote for them.
> But the i2c interface is exposed to everybody.
> 
> One mistake is expect msg[i].addr with 8 bits address instead of 7
> bits address. This make them use eeprom address at 0xa0 instead of
> 0x50. Also they shift tuner address (qt1010 tuner is likely to be
> at address 0x62, but some put it a 0xc4 (af9015, af9005, dtv5100)).
> 
> Other mistakes is in xfer callback. Often the controller support a
> limited i2c support (n bytes write then m bytes read). The driver
> try to convert the linux i2c msg to this pattern, but they often
> miss cases :
> - msg[i].len can be null

Zero, not null. This is a very rare case, I've never seen it in
multi-message transactions (wouldn't make much sense IMHO), only in
the single-message transaction known as SMBus quick command. Many
controllers don't support it, so I2C bus drivers don't have to support
it. It should be assumed by I2C chip drivers that an I2C adapter
without functionality bit I2C_FUNC_SMBUS_QUICK does not support 0-byte
messages.

> - msg write are not always followed by msg read
> 
> And this can be dangerous if these interfaces are exported to
> userspace via i2c-dev :

Even without that... We certainly hope to reuse client drivers for
other families of DVB cards, and for this to work, every driver must
stick to the standard.

> - some scanning program avoid eeprom by filtering 0x5x range, but
> now it is at 0xax range (well that should happen because scan limit
> should be 0x77)
> - some read only command can be interpreted as write command.

Very bad indeed.

> What should be done ?
> Fix the drivers.

Yes, definitely. The sooner, the better.

> Have a mode where i2c interface are not exported to everybody.

I have considered this for a moment. It might be fair to let I2C bus
drivers decide whether they want i2c-dev to expose their buses or not.
We could use a new class bit (I2C_CLASS_USER or such) to this purpose. I
didn't get to it yet though, as this doesn't seem to be urgent, and
i2c-dev has so many other problems...

That being said, this is hardly a valid answer to the problem you
discovered. Preventing user-space from triggering bugs is not fixing
them.

> Don't care.

No, that's not an option.

> First why does the i2c stack doesn't check that the address is on
> 7 bits (like the attached patch) ?

Performance reasons, I presume. Having to check this each time a
transaction is attempted would be quite costly.

Secondly, I suspect it was never thought that raw I2C messaging would
become so popular. The original intent was to have all I2C device
drivers (except maybe i2c-dev) register their clients. The legacy
method for this (i2c_detect) _does_ have an address check included, and
so do i2c_new_probed_device and i2c_sysfs_new_device. Probably we
should add it to i2c_new_device as well, for consistency. It is way
less expensive to check the address once and for all, than with each
transaction.

I certainly hope that DVB will move to client-based I2C device drivers
at some point in time.

Note though that the address check is in no way bullet-proof. If
addresses in the range 0x03-0x3b are handled as 8-bit entities instead
of 7-bit entities, they will appear to be in the range 0x06-0x76, which
is perfectly valid.

> Also I believe a program for testing i2c interface corner case
> should catch most of these bugs :
> - null msg[i].len
> - different transactions on a device :
>  - one write/read transaction
>  - one write transaction then one read transaction
> [...]
> 
> Does a such program exist ?

We have several programs in the i2c-tools package, which can be used to
this purpose:
* i2cdetect
* i2cdump
* i2cget
* i2cset

With these 4 tools, almost all SMBus transaction types are covered.
This is sufficient in most cases in my experience. If not, these tools
can certainly get extended, at least to cover all of SMBus.

-- 
Jean Delvare
