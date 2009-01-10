Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail0.scram.de ([78.47.204.202]:60990 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804AbZAJOe7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Jan 2009 09:34:59 -0500
Message-ID: <4968B21E.7010509@scram.de>
Date: Sat, 10 Jan 2009 15:35:10 +0100
From: Jochen Friedrich <jochen@scram.de>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Roberto Ragusa <mail@robertoragusa.it>, linux-dvb@linuxtv.org,
	linux-media@vger.kernel.org, Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [linux-dvb] MC44S803 frontend (it works)
References: <200901091615.21641.lacsilva@gmail.com>	<4967783B.2060007@robertoragusa.it> <49678BD3.7070105@scram.de> <496795F5.6080309@iki.fi> <496875BF.7060605@scram.de> <4968A9C5.7060708@iki.fi>
In-Reply-To: <4968A9C5.7060708@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

>> Yes. Currently, MC44S803 uses a READ in mc44s80x_get_devid() to check the ID register.
>> According to the spec from freescale, a READ needs to be a seperate I2c transaction,
>> because the STOP bit is used to latch the address registers. That's the reason why a
>> dedicated READ support is needed (most other tuners use a WRITE / READ combined I2c
>> transaction instead).
> 
> OK. Maybe comment to the code is required, but I can add it. I am 
> willing to see, if you have, usb-sniffs for tuner read and write.

there is documentation for this tuner at the freescale web page:

http://www.freescale.com/files/rf_if/doc/data_sheet/MC44S803.pdf?pspll=1

>From page 8:

I2C OPERATION
The same 24-bit shift register is used to shift data in and
out of the part. The input data stream is clocked in on the
rising edge of SCLK into the shift register with the MSB first.
The IC Address and R/W bit are sent first. This allows the IC
to determine if it is the device that is being communicated
with. After that, 24 bits are clocked in to control the IC. If less
than 24 bits are required, then 16 or 8 bits could be used. In
other words, commands can be sent in 1, 2, or 3 byte
increments depending on the requirements for the particular
control register you are writing to. Data can be read back from
the IC in 1, 2, or 3 byte increments also. The Master controls
the clock line, whether writing to the part or reading from it.
After each byte that is sent, the device that receives it sends
an acknowledge bit. The output data stream is clocked out of
the shift register on the falling edge of SCLK and valid on the
rising edge, with the MSB first. The data stored in the shift
register is loaded into one of the appropriate registers after
the Stop Condition is sent. The 4 LSBs are the Control
Register Address Bits.

This means a READ needs to be implemented using 2 transactions.
One transaction to write the address and one to read the value back.

The read operations are specified on pages 22 and 23:

There are 16 Data Registers that can be read back from
the IC. The 1011 Control Register (Data Register Address)
controls which of these Data Registers will be read out of the
IC during the next read operation. To select the desired Data
Register this address register first needs to be set. Then on
the next read operation the desired data will be available.

Currently the driver only reads the ID bits to verify it's talking to a 
MC44S80x chip.

The READ operation was modeled after the "official" driver from TerraTec:

ftp://ftp.terratec.net/Receiver/Cinergy_T_USB_XE/Update/Cinergy_T_USB_XE_MKII_Drv_Linux.zip

>>> Maybe I can move MC44S803 and needed AF9015 changes to my devel tree at 
>>> linuxtv.org... But that does not change problem that tuner is not still 
>>> in v4l-dvb-master nor coming for Kernel before Manu will pull it.
>> Unfortunately, i didn't see any comments from Manu yet...
> 
> we will waiting...

OK, we'll do.

Thanks,
Jochen
