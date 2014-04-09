Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f45.google.com ([209.85.213.45]:36985 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932932AbaDIM0h (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Apr 2014 08:26:37 -0400
Received: by mail-yh0-f45.google.com with SMTP id a41so2227345yho.32
        for <linux-media@vger.kernel.org>; Wed, 09 Apr 2014 05:26:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+d4A-_qqjKVq3amo3kRMLpVYP-KE=CLxhC76rFFaKZ31a=Khw@mail.gmail.com>
References: <CA+d4A-_qqjKVq3amo3kRMLpVYP-KE=CLxhC76rFFaKZ31a=Khw@mail.gmail.com>
Date: Wed, 9 Apr 2014 08:26:36 -0400
Message-ID: <CALzAhNU=4TpW6TwqQLQSjw_RwYX1=qE=wHnaNBNnU=v5Nk2RSw@mail.gmail.com>
Subject: Re: Kworld PlusTV All in One PI610 - need help
From: Steven Toth <stoth@kernellabs.com>
To: Julian Day <julianfday@gmail.com>
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I don't know the 7131 but the following advice is generic for any USB,
PCI or PCIE device:

Essentially, when correctly configured, the tuner will output an
Intermediate Frequency (IF). This is the frequency you've selected to
tune, for example 474MHz, isolated into a 8MHz band and shifted down
to a different frequency that the 10046 demodulator is designed to
receive. Typicaly IFs are 44Mhz, 6MHz or variations of.

So, rule #1, match the IF on the tuner to the IF settings for the
10046 demodulator. These are typically passed to tuner and demodulator
parts during dvb_attach with tuner and demodualtor specific
structures. Generally, this is very simple to to. If you create a
miss-match, the demodulator is never going to lock, no matter how many
times you tune the tuner to a new 474, 482 etc frequency.

Rule #2, you need reliable communication via i2c to the tuner. Look
for any i2c errors during communication.

> I guess demod_address is likely to be 0x8 and tuner_address is likely
> to be 0x61 or 0x60. I think 0x61 seems more like it. What else needs
> to be set there and is there any guidance on how to probe this type of
> info?

I typically probe the i2c bus using a logic analyzer to do this with a
PCI device. Often, poking at the windows driver configuration files
can reveal the I2C addresses but ideally, look directly at the I2C bus
when running the device under windows.

>
> With these mods scan shows tuning failed for every channel:
>>>> tune to: 474000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!

My advice, don't rely on scanning. Find an exact and strong frequency
that's working reliably for you with another product and focus
specificially on that frequency when test the new PCI board. Use tzap
exclusive as a test tool until you see the tool report a LOCKED
status.

Once you have a LOCK, use the dvbtraffic tool in addition to tzap to
help diagnose, no other s/w tools should be required.

>
> and:
> julian@pabay:~$ dmesg |grep -i saa
> [   19.248098] saa7130/34: v4l2 driver version 0, 2, 17 loaded
> [   19.248462] saa7133[0]: found at 0000:04:08.0, rev: 209, irq: 16,
> latency: 64, mmio: 0xfe6fb000
> [   19.248467] saa7133[0]: subsystem: 17de:7256, board: Kworld PlusTV
> All in One (PI610) [card=193,autodetected]
> [   19.248482] saa7133[0]: board init: gpio is 100
> [   19.400046] saa7133[0]: i2c eeprom 00: de 17 56 72 54 20 1c 00 43
> 43 a9 1c 55 d2 b2 92
> [   19.400058] saa7133[0]: i2c eeprom 10: ff ff ff 0f ff 20 ff ff ff
> ff ff ff ff ff ff 01
> [   19.400068] saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08
> ff 00 fe ff ff ff ff
> [   19.400077] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   19.400087] saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 15
> 56 ff ff ff ff ff ff
> [   19.400096] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   19.400106] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   19.400115] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   19.400124] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   19.400134] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   19.400143] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   19.400153] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   19.400162] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   19.400171] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   19.400181] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   19.400190] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   24.053223] saa7133[0]: dsp access wait timeout [bit=WRR]
> [   24.053764] saa7133[0]: dsp access wait timeout [bit=WRR]
> [   24.116116] saa7133[0]: registered device video0 [v4l2]
> [   24.116202] saa7133[0]: registered device vbi0
> [   24.116260] saa7133[0]: registered device radio0
> [   24.174563] saa7134 ALSA driver for DMA sound loaded
> [   24.174590] saa7133[0]/alsa: saa7133[0] at 0xfe6fb000 irq 16
> registered as card -2
> [   24.179995] saa7133[0]: dsp access wait timeout [bit=WRR]
> [   24.180539] saa7133[0]: dsp access wait timeout [bit=WRR]
> [   24.185216] saa7133[0]: dsp access wait timeout [bit=WRR]
> [   24.185756] saa7133[0]: dsp access wait timeout [bit=WRR]
> [   24.640035] DVB: registering new adapter (saa7133[0])
> [   24.640043] saa7134 0000:04:08.0: DVB: registering adapter 0
> frontend 0 (Philips TDA10046H DVB-T)...
> [   25.632561] saa7133[0]: dsp access wait timeout [bit=WRR]

Once you have the demodulator locking, he next issue you'll
potentially come across is the MPEG interfacing between the
demodulator and the PCI controller. These are settings, usually passed
in the 10046 struct during DVB_ATTACH. Each demodulator usually lets
you configure serial vs parallel digital interfacing, and various
polarity settings for the SOP and VALID lines. If you get the polarity
wrong then the DVB-T bytes can be reliably moved between the
demodulator and the PCI 7131. Uou'd expect either a) a complete loss
of packets - which is what the dsp is reporting above or b) mangled
and junk being received. dvbtraffic lets you 'see' the packets.
Ideally you will see a list of pids and counts increasing, if the
pids# column varies then most likely the mpeg interface is incorrectly
configured.

Other aspects come into play which can prevent the demodulator MPEG
output from being received by the 7131, for example a gpio driven
muxes can often cause problems, by routing altering the MPEG
electrical routing....

Focus on tzap and getting the demodulator to report successful LOCK first.

Please ensure ensure any replies include the mailing list.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
