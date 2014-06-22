Return-path: <linux-media-owner@vger.kernel.org>
Received: from pide.tip.net.au ([101.0.96.218]:42606 "EHLO pide.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbaFVDCI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jun 2014 23:02:08 -0400
Received: from e4.eyal.emu.id.au (124-168-208-3.dyn.iinet.net.au [124.168.208.3])
	(using TLSv1 with cipher ECDHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by pide.tip.net.au (Postfix) with ESMTPSA id D18A0127227
	for <linux-media@vger.kernel.org>; Sun, 22 Jun 2014 12:52:17 +1000 (EST)
Message-ID: <53A644E1.9010209@eyal.emu.id.au>
Date: Sun, 22 Jun 2014 12:52:17 +1000
From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
MIME-Version: 1.0
To: list linux-media <linux-media@vger.kernel.org>
Subject: DTV2000DS cold vs. warm
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This card was always unreliable, some channels (different each time) fail to tune.
This was blamed on the card not coming up in "cold" state, and as such not being
properly initialised.

So I have some simple questions. Below are the messages from my system. I understand
that this card has two USB devices which are rather independent (am I right?).

I see that the messages for the two USB devices are not the same. The first block
says 'found...in cold state' then 'downloading firmware'. The second says
'found...in warm state'. However both report 'firmware version 4.95.0.0'.

Also, I see the card itself (DTV2000DS) announced as cold/warm, as well as
later the AF9013 reported  as warm. Is it the card or DTV2000DS or the AF9013
that have cold/warm states and need firmware download? (I guess I am showing
my ignorance here).

Is this how it should be? Or should both devices be found in cold state first?

[an aside: why the 'remote query interval' message when I specified 'remote=-1'?]

TIA
	Eyal

Full boot log:

usb 4-1: new high-speed USB device number 2 using ehci-pci
usb 4-1: New USB device found, idVendor=0413, idProduct=6a04
usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 4-1: Product: DVB-T 2
usb 4-1: Manufacturer: Afatech

usb 4-1: dvb_usb_v2: found a 'Leadtek WinFast DTV2000DS' in cold state
usb 4-1: dvb_usb_v2: downloading firmware from file 'dvb-usb-af9015.fw'
usb 4-1: dvb_usb_v2: found a 'Leadtek WinFast DTV2000DS' in warm state

usb 4-1: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
DVB: registering new adapter (Leadtek WinFast DTV2000DS)
i2c i2c-9: af9013: firmware version 4.95.0.0
usb 4-1: DVB: registering adapter 0 frontend 0 (Afatech AF9013)...

usb 4-1: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
DVB: registering new adapter (Leadtek WinFast DTV2000DS)
i2c i2c-9: af9013: found a 'Afatech AF9013' in warm state
i2c i2c-9: af9013: firmware version 4.95.0.0
usb 4-1: DVB: registering adapter 1 frontend 0 (Afatech AF9013)...

usb 4-1: dvb_usb_v2: schedule remote query interval to 500 msecs
usb 4-1: dvb_usb_v2: 'Leadtek WinFast DTV2000DS' successfully initialized and connected
usbcore: registered new interface driver dvb_usb_af9015

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
