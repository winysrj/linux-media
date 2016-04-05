Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38364 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758499AbcDESQD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Apr 2016 14:16:03 -0400
Subject: Re: AVerMedia HD Volar (A867) AF9035 + MXL5007T driver issues
To: Alessandro Radicati <alessandro@radicati.net>,
	linux-media@vger.kernel.org
References: <CAO8Cc0qvJxO2Z63HJd1_df+mY8HHB-UrUUZLPqBHQuoyD=TAkQ@mail.gmail.com>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <570400DE.9040306@iki.fi>
Date: Tue, 5 Apr 2016 21:15:58 +0300
MIME-Version: 1.0
In-Reply-To: <CAO8Cc0qvJxO2Z63HJd1_df+mY8HHB-UrUUZLPqBHQuoyD=TAkQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/02/2016 01:44 PM, Alessandro Radicati wrote:
> Hi,
> In trying to understand why my DVB USB tuner doesn't work with stock
> kernel drivers (4.2.0), I decided to pull out my logic analyser and
> sniff the I2C bus between the AF9035 and MXL5007T.  I seem to have
> uncovered a couple of issues:
>
> 1) Attach fails because MXL5007T driver I2C soft reset fails.  This is
> due to the preceding chip id read request that seems to hang the I2C
> bus and cause subsequent I2C commands to fail.

In my understanding MXL5007T register read is done in a two 
transactions. First you should write wanted register to register 0xfb. 
After that single byte read from the chip returns value for register 
configured to 0xfb. Write+read with repeated start is not supported and 
driver is buggy as it request that which usually leads to bogus value.


> 2) AF9035 driver I2C master xfer incorrectly implements "Write read"
> case.  The FW expects register address fields to be used to send the
> I2C writes for register selection.  The current implementation ignores
> these fields and the result is that only an I2C read is issued.
> Therefore the "0x3f" returned by the MXL5007T chip id query is not
> from the expected register.  This is what is seen on the I2C bus:
>
> S | Read 0x60 + ACK | 0x3F + NAK | ...
>
> After which SDA is held low for ~6sec; reason for subsequent commands failing.

You should use "S | W | P | S | R | P", no "S | W | S | R | P" == write 
read with repeated start condition.

> 3) After modifying the AF9035 driver to fix point 2 and use the
> register address field, the following is seen on the I2C bus:
>
> S | Write 0x60 + ACK | 0xFB + ACK | 0xD9 + ACK | P
> S | Read 0x60 + ACK | 0x14 + NAK | ...

That is correct sequence. You are trying to read more than 1 byte and it 
fails?

> This time we get an expected response, but the I2C bus still hangs
> with SDA held low and no Stop sequence.  It seems that the MXL5007T is
> holding SDA low since the AF9035 happily cycles SCL trying to execute
> the subsequent writes.  Without a solution to this, it seems that
> avoiding the I2C read is the best way to have the driver work
> correctly.  There are no other tuner reads so point 2 above becomes
> moot for at least this device.
>
> Does anyone have any insight on the MXL5007T chip ID command and
> whether it should be issued in certain conditions?  Any suggestions on
> how to resolve this given the above?

I tried to fix it earlier:
http://www.spinics.net/lists/linux-media/msg62264.html

Feel free to fix! It should not be very hard as you could even sniff 
data from the I2C bus directly. I don't have any AF9035+MXL5007T device, 
but I have tested it with older AF9015+MXL5007T.

regards
Antti

-- 
http://palosaari.fi/
