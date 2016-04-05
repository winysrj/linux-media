Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:35778 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097AbcDETeo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2016 15:34:44 -0400
Received: by mail-lb0-f171.google.com with SMTP id bc4so16096604lbc.2
        for <linux-media@vger.kernel.org>; Tue, 05 Apr 2016 12:34:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <570400DE.9040306@iki.fi>
References: <CAO8Cc0qvJxO2Z63HJd1_df+mY8HHB-UrUUZLPqBHQuoyD=TAkQ@mail.gmail.com>
	<570400DE.9040306@iki.fi>
Date: Tue, 5 Apr 2016 21:34:41 +0200
Message-ID: <CAO8Cc0oHFwaRHAZaY5BZUAyYwCWRoD7s_97gr0vLF5YLgGAntA@mail.gmail.com>
Subject: Re: AVerMedia HD Volar (A867) AF9035 + MXL5007T driver issues
From: Alessandro Radicati <alessandro@radicati.net>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 5, 2016 at 8:15 PM, Antti Palosaari <crope@iki.fi> wrote:
> On 04/02/2016 01:44 PM, Alessandro Radicati wrote:
>>
>> Hi,
>> In trying to understand why my DVB USB tuner doesn't work with stock
>> kernel drivers (4.2.0), I decided to pull out my logic analyser and
>> sniff the I2C bus between the AF9035 and MXL5007T.  I seem to have
>> uncovered a couple of issues:
>>
>> 1) Attach fails because MXL5007T driver I2C soft reset fails.  This is
>> due to the preceding chip id read request that seems to hang the I2C
>> bus and cause subsequent I2C commands to fail.
>
>
> In my understanding MXL5007T register read is done in a two transactions.
> First you should write wanted register to register 0xfb. After that single
> byte read from the chip returns value for register configured to 0xfb.
> Write+read with repeated start is not supported and driver is buggy as it
> request that which usually leads to bogus value.
>

I'm not sure if it supports repeated start or not, but in reality the
AF9035 firmware will not perform a repeated start sequence.  I.e. a
single read USB command results in two separate I2C transactions (s
write ... p + s read ... p).  So using the specific I2C tuner read usb
command (with address fields) is the same as using two separate write
and read commands.  I've only tested default firmware version: LINK
12.13.15.0 - OFDM 6.20.15.0

>
>> 2) AF9035 driver I2C master xfer incorrectly implements "Write read"
>> case.  The FW expects register address fields to be used to send the
>> I2C writes for register selection.  The current implementation ignores
>> these fields and the result is that only an I2C read is issued.
>> Therefore the "0x3f" returned by the MXL5007T chip id query is not
>> from the expected register.  This is what is seen on the I2C bus:
>>
>> S | Read 0x60 + ACK | 0x3F + NAK | ...
>>
>> After which SDA is held low for ~6sec; reason for subsequent commands
>> failing.
>
>
> You should use "S | W | P | S | R | P", no "S | W | S | R | P" == write read
> with repeated start condition.
>

This is what I sniffed on the bus without any modifications to the
driver.  My intent was to show that there is no write transaction at
all.

>> 3) After modifying the AF9035 driver to fix point 2 and use the
>> register address field, the following is seen on the I2C bus:
>>
>> S | Write 0x60 + ACK | 0xFB + ACK | 0xD9 + ACK | P
>> S | Read 0x60 + ACK | 0x14 + NAK | ...
>
>
> That is correct sequence. You are trying to read more than 1 byte and it
> fails?
>

This is after I modified the driver to use the register address
fields.  Sequence looks good except for the missing P after the NAK,
but this is due to something holding SDA low or an issue with the
AF9035.  I've tested this reading other registers, but same behavior.
I've also tried using two separate write read commands, exact same I2C
sequence and same result.  I also hacked the driver to read two bytes
instead of one.  Interestingly I got 0x14 twice as expected, but again
the bus hangs after the NAK that marks the end of the read.

>> This time we get an expected response, but the I2C bus still hangs
>> with SDA held low and no Stop sequence.  It seems that the MXL5007T is
>> holding SDA low since the AF9035 happily cycles SCL trying to execute
>> the subsequent writes.  Without a solution to this, it seems that
>> avoiding the I2C read is the best way to have the driver work
>> correctly.  There are no other tuner reads so point 2 above becomes
>> moot for at least this device.
>>
>> Does anyone have any insight on the MXL5007T chip ID command and
>> whether it should be issued in certain conditions?  Any suggestions on
>> how to resolve this given the above?
>
>
> I tried to fix it earlier:
> http://www.spinics.net/lists/linux-media/msg62264.html
>
> Feel free to fix! It should not be very hard as you could even sniff data
> from the I2C bus directly. I don't have any AF9035+MXL5007T device, but I
> have tested it with older AF9015+MXL5007T.
>

So there are two problems:
1) AF9035 I2C master read function needs to use the register address
fields.  This is a trivial fix and I've done a patch.  However I'm
unsure of the consequences this may have with other tuners.  I can
only guess that tuner reads are almost never done or are not
important, otherwise this would have been caught earlier.  Again, this
may be something related to this specific firmware, but unlikely.
2) I2C bus hangs after any MXL5007t I2C read is performed.  I have no
idea why this happens, or who is the culprit.  I'm happy to test out
any suggestions.

Thanks,
Alessandro
