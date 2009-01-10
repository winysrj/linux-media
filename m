Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail0.scram.de ([78.47.204.202]:42854 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbZAJKRZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Jan 2009 05:17:25 -0500
Message-ID: <496875BF.7060605@scram.de>
Date: Sat, 10 Jan 2009 11:17:35 +0100
From: Jochen Friedrich <jochen@scram.de>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Roberto Ragusa <mail@robertoragusa.it>, linux-dvb@linuxtv.org,
	linux-media@vger.kernel.org, Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [linux-dvb] MC44S803 frontend (it works)
References: <200901091615.21641.lacsilva@gmail.com>	<4967783B.2060007@robertoragusa.it> <49678BD3.7070105@scram.de> <496795F5.6080309@iki.fi>
In-Reply-To: <496795F5.6080309@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

> Could you explain for changes af9015_i2c_xfer() done? Is it for case I2C 
> READ coming from MC44S803 but tuner does not implement read at all? Is 
> it really needed?

Yes. Currently, MC44S803 uses a READ in mc44s80x_get_devid() to check the ID register.
According to the spec from freescale, a READ needs to be a seperate I2c transaction,
because the STOP bit is used to latch the address registers. That's the reason why a
dedicated READ support is needed (most other tuners use a WRITE / READ combined I2c
transaction instead).

> Maybe I can move MC44S803 and needed AF9015 changes to my devel tree at 
> linuxtv.org... But that does not change problem that tuner is not still 
> in v4l-dvb-master nor coming for Kernel before Manu will pull it.

Unfortunately, i didn't see any comments from Manu yet...

Thanks,
Jochen
