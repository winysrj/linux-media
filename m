Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53995 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763868AbZDAQdO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Apr 2009 12:33:14 -0400
Message-ID: <49D39741.3080806@iki.fi>
Date: Wed, 01 Apr 2009 19:33:05 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: C Khmer1 <ckhmer1l@live.it>
CC: linux-media@vger.kernel.org
Subject: Re: Driver for GL861+AF9003+MT2060]
References: <BLU0-SMTP24C120D13E754132593F63988B0@phx.gbl>
In-Reply-To: <BLU0-SMTP24C120D13E754132593F63988B0@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

C Khmer1 wrote:
> Hello,
> I'm trying to write a linux driver for my A-Data DT1 USB2 DVB-T card.
> This card has the GL861+AF9003+MT2060 chips.
> I've the specification of AF9002/3/5 family, and there is a linux driver
> for AF9005 chip that is an USB back-end plus AF9003 front-end.
> There is already a front-end driver for AF9003 inside the AF9005 code
> (should be the file AF9005-fe.c in the linux kernel tree).
> The real problem is that i don't know how to perform the boot process
> because it is different from AF9005 and how to handle the chip GL861
> +AF9003 together.

It is not mission impossible. Basically all chips are supported. The 
biggest you have to is split demodulator code to own module. Very 
similar situation is used by af9015+af9013. You can look example from there.

> I've seen the GL861 linux driver code. It is very simple and support
> only two commands_
> 
> C0 02 for reading
> 40 01 for writing
> 
> Sniffing the USB data using windows driver I've discovered that the
> windows driver is using following commands:
> 
> 40 01
> 40 03
> 40 05
> c0 02
> c0 08

4 x read and 2 x write. There is IR-table which can be uploaded to the 
gl861, since one or two commands are probably for that. Should be easy 
to detect, for example comparing IR-table from driver to data seen in 
sniffs.
Other possibilities could be for example GPIO, streaming control, 
USB-controller register/memory read/write, eeprom... Look existing 
dvb-usb -drivers for some hints about used commands.

> I don't know what do they mean and how I should use it.

First "emulate" as Windows driver does (seen from sniff). After you get 
picture you can test whether or not all commands are needed and what is 
effect of commands. For example remove one command and remote does not 
work => should be remote command.

> Maybe with the GL861 specification I can understand. Sadly I've no
> specification for GL861.

DVB-USB -protocols are typically rather easy to reverse-engineer and 
guess. :) GL861 is one of the simplest ones.

> Also the commands '40 01' and 'c0 02' are used in a different way not
> foreseen from the GL861 driver (the GL861 driver support up to 2 bytes
> to write but I see more data to write).

You should add multibyte i2c support then. Many existing drivers to see 
help.

> I'm trying to understand the USB data before to writing the GL861 code
> to handle the AF9003 front-end (demod).
> Could someone help me?

There was someone else with similar device some months ago. Look ML 
archives and put your helping hands together.

If you post one simple sniff to me I can try to look.

regards
Antti
-- 
http://palosaari.fi/
