Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:33521 "EHLO
	mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbcDBKoX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Apr 2016 06:44:23 -0400
Received: by mail-lf0-f43.google.com with SMTP id p188so77808110lfd.0
        for <linux-media@vger.kernel.org>; Sat, 02 Apr 2016 03:44:22 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 2 Apr 2016 12:44:21 +0200
Message-ID: <CAO8Cc0qvJxO2Z63HJd1_df+mY8HHB-UrUUZLPqBHQuoyD=TAkQ@mail.gmail.com>
Subject: AVerMedia HD Volar (A867) AF9035 + MXL5007T driver issues
From: Alessandro Radicati <alessandro@radicati.net>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
In trying to understand why my DVB USB tuner doesn't work with stock
kernel drivers (4.2.0), I decided to pull out my logic analyser and
sniff the I2C bus between the AF9035 and MXL5007T.  I seem to have
uncovered a couple of issues:

1) Attach fails because MXL5007T driver I2C soft reset fails.  This is
due to the preceding chip id read request that seems to hang the I2C
bus and cause subsequent I2C commands to fail.

2) AF9035 driver I2C master xfer incorrectly implements "Write read"
case.  The FW expects register address fields to be used to send the
I2C writes for register selection.  The current implementation ignores
these fields and the result is that only an I2C read is issued.
Therefore the "0x3f" returned by the MXL5007T chip id query is not
from the expected register.  This is what is seen on the I2C bus:

S | Read 0x60 + ACK | 0x3F + NAK | ...

After which SDA is held low for ~6sec; reason for subsequent commands failing.

3) After modifying the AF9035 driver to fix point 2 and use the
register address field, the following is seen on the I2C bus:

S | Write 0x60 + ACK | 0xFB + ACK | 0xD9 + ACK | P
S | Read 0x60 + ACK | 0x14 + NAK | ...

This time we get an expected response, but the I2C bus still hangs
with SDA held low and no Stop sequence.  It seems that the MXL5007T is
holding SDA low since the AF9035 happily cycles SCL trying to execute
the subsequent writes.  Without a solution to this, it seems that
avoiding the I2C read is the best way to have the driver work
correctly.  There are no other tuner reads so point 2 above becomes
moot for at least this device.

Does anyone have any insight on the MXL5007T chip ID command and
whether it should be issued in certain conditions?  Any suggestions on
how to resolve this given the above?

Regards,
Alessandro Radicati
