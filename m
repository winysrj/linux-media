Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35823 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545AbZAJN7h (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Jan 2009 08:59:37 -0500
Message-ID: <4968A9C5.7060708@iki.fi>
Date: Sat, 10 Jan 2009 15:59:33 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jochen Friedrich <jochen@scram.de>
CC: Roberto Ragusa <mail@robertoragusa.it>, linux-dvb@linuxtv.org,
	linux-media@vger.kernel.org, Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [linux-dvb] MC44S803 frontend (it works)
References: <200901091615.21641.lacsilva@gmail.com>	<4967783B.2060007@robertoragusa.it> <49678BD3.7070105@scram.de> <496795F5.6080309@iki.fi> <496875BF.7060605@scram.de>
In-Reply-To: <496875BF.7060605@scram.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jochen Friedrich wrote:
> Hi Antti,
> 
>> Could you explain for changes af9015_i2c_xfer() done? Is it for case I2C 
>> READ coming from MC44S803 but tuner does not implement read at all? Is 
>> it really needed?
> 
> Yes. Currently, MC44S803 uses a READ in mc44s80x_get_devid() to check the ID register.
> According to the spec from freescale, a READ needs to be a seperate I2c transaction,
> because the STOP bit is used to latch the address registers. That's the reason why a
> dedicated READ support is needed (most other tuners use a WRITE / READ combined I2c
> transaction instead).

OK. Maybe comment to the code is required, but I can add it. I am 
willing to see, if you have, usb-sniffs for tuner read and write.

> 
>> Maybe I can move MC44S803 and needed AF9015 changes to my devel tree at 
>> linuxtv.org... But that does not change problem that tuner is not still 
>> in v4l-dvb-master nor coming for Kernel before Manu will pull it.
> 
> Unfortunately, i didn't see any comments from Manu yet...

we will waiting...

> 
> Thanks,
> Jochen

regards
Antti
-- 
http://palosaari.fi/
