Return-path: <mchehab@pedra>
Received: from bombadil.infradead.org ([18.85.46.34]:43684 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab0ITQfh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Sep 2010 12:35:37 -0400
Message-ID: <4C978D55.9000901@infradead.org>
Date: Mon, 20 Sep 2010 13:35:33 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: =?ISO-8859-2?Q?Pawe=B3_Ku=BCniar?= <pawel@kuzniar.com.pl>
CC: linux-media@vger.kernel.org
Subject: Re: Videomed Videosmart VX-3001
References: <AANLkTinSB_ChWLnR=hQ6jAuRtgeLm0dze6f4mTy5buNt@mail.gmail.com>	<4C8FF30B.2080900@redhat.com> <AANLkTinxtii3nA1=16RJsi6OM1AyFAbH5rEpD6jw6dR6@mail.gmail.com>
In-Reply-To: <AANLkTinxtii3nA1=16RJsi6OM1AyFAbH5rEpD6jw6dR6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 20-09-2010 10:15, Pawe³ Ku¼niar escreveu:
>> This patch should reduce the bus speed to 25 kHz, hopefully giving us more information
>> about your device.
>>
> Here are logs with patched driver:
> 
> [115345.416343] usbcore: registered new interface driver em28xx
> [115345.416350] em28xx driver loaded
> [115397.552829] usb 1-3: new high speed USB device using ehci_hcd and address 21
> [115397.704422] em28xx: New device @ 480 Mbps (eb1a:2861, interface 0, class 0)
> [115397.704488] em28xx #0: chip ID is em2860
> [115397.874880] em28xx #0: i2c eeprom 00: 00 00 00 00 00 00 00 00 00

Same issue... it is returning zero for all I2C reads...

Oh well... We'll need to go to the hard way.

Please install usbsnoop and capture the data exchange for the usb device eb1a:2861.
The log will contain all init sequence used by the driver. There's probably an 
gpio init sequence that is needed, in order to access the I2C bus on that device.

There are some instructions about that at:

	http://linuxtv.org/wiki/index.php/Bus_snooping/sniffing

Cheers,
Mauro
