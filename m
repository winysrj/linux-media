Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.alice.nl ([217.149.195.8]:51343 "EHLO smtp.alice.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757918Ab0D3Tbc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Apr 2010 15:31:32 -0400
Message-ID: <4BD9D114.6010308@cobradevil.org>
Date: Thu, 29 Apr 2010 20:33:56 +0200
From: william <kc@cobradevil.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: liplianin@me.by
Subject: Re: debugging my Tevii S660 usb 2.0 dvb-s2 device
References: <59062.192.87.141.196.1272466066.squirrel@webmail.spothost.nl> <4BD87EA2.5090700@cobradevil.org>
In-Reply-To: <4BD87EA2.5090700@cobradevil.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all and Igor,

i only showed information with the drivers from tevii but then i looked 
again at the source from the hg v4l repo and there was support for my s660.
So sorry i asked questions about the drivers from tevii itself.

But now the following:

[   45.654362] dvb-usb: found a 'TeVii S660 USB' in cold state, will try 
to load a firmware
[   45.654379] usb 1-3: firmware: requesting dvb-usb-s630.fw
[   45.717438] dvb-usb: downloading firmware from file 'dvb-usb-s630.fw'
[   45.717450] dw2102: start downloading DW210X firmware
[   45.824245] usb 1-3: USB disconnect, address 3
[   45.930055] dvb-usb: found a 'TeVii S660 USB' in warm state.
[   45.930167] dvb-usb: will pass the complete MPEG2 transport stream to 
the software demuxer.
[   45.930233] DVB: registering new adapter (TeVii S660 USB)
[   56.182533] dvb-usb: MAC address: 00:00:00:00:00:00
[   56.262532] mt312: R(126): 00
[   56.262543] Only Zarlink VP310/MT312/ZL10313 are supported chips.
[   56.607024] ds3000_attach
[   56.642535] ds3000_readreg: read reg 0x00, value 0x00
[   56.642542] Invalid probe, probably not a DS3000
[   56.642816] dvb-usb: no frontend was attached by 'TeVii S660 USB'
[   56.643037] input: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:1d.7/usb1/1-3/input/input5
[   56.643189] dvb-usb: schedule remote query interval to 150 msecs.
[   56.643203] dvb-usb: TeVii S660 USB successfully initialized and 
connected.
[   56.643290] usbcore: registered new interface driver dw2102
[   56.773230] dvb-usb: TeVii S660 USB successfully deinitialized and 
disconnected.
[   57.050043] usb 1-3: new high speed USB device using ehci_hcd and 
address 5

in my previous post i got a message that an mt312 chip was found and now 
it does not find anything.
so now i don't have a dvb device at all.

the firmware is from the drivers from tevii. I tried and the s630 
firmware and later the s660 firmware renamed to s630 but none worked.

After installing the driver/changing the firmware, I shutdown the 
computer removed the power from the tevii device and then replugged and 
started my computer again.

Igor or someone else do you have an idea what is happening?

With kind regards

William van de Velde


