Return-path: <linux-media-owner@vger.kernel.org>
Received: from humboldt.pingu.fi ([81.22.249.143]:40884 "EHLO
	humboldt.pingu.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab0FMOBv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jun 2010 10:01:51 -0400
Received: from xdsl-179-201.nblnetworks.fi ([217.30.179.201] helo=[192.168.3.3])
	by humboldt.pingu.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <tuomas@kulve.fi>)
	id 1ONnSy-0004E8-4L
	for linux-media@vger.kernel.org; Sun, 13 Jun 2010 16:43:12 +0300
Message-ID: <4C14E06A.6070407@kulve.fi>
Date: Sun, 13 Jun 2010 16:43:06 +0300
From: Tuomas Kulve <tuomas@kulve.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Help needed with TerraTec Cinergy T Stick Dual RC
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,


I bought a TerraTec Cinergy T Stick Dual RC[1] which is not supported in 
linux, AFAIK. The USB VID:PID is 0ccd:0099.

I didn't find much about it with google, so I opened it up. There are 
five chips inside: AF9013-N1, AF9015A-N1, 2x MXL5007T and FM24C02 eeprom.

I'm not a kernel developer but I tried to add the correct USB PID to the 
af9015 driver and modified it to attach the mxl5007t tuner (by following 
the procedure in DiB0700 driver).

The DiB0700 driver uses 0x60 i2c address for MXL5007t tuner but I got 
replies only from addresses 0x38, 0x39, 0xa0, 0xa1, 0xc0, and 0xc1 and 
all with unknown chip id, so I'm probably doing it wrong.

Below is the kernel output when I plugin the USB DVB stick. It seems to 
find the two tuners and tries to use the same i2c address for both as 
I've hardcoded that in the attach function call.


usb 2-2: new high speed USB device using ehci_hcd and address 3
usb 2-2: New USB device found, idVendor=0ccd, idProduct=0099
usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-2: Product: DVB-T 2
usb 2-2: Manufacturer: Afatech
usb 2-2: SerialNumber: 010101010600001
input: Afatech DVB-T 2 as /class/input/input5
generic-usb 0003:0CCD:0099.0003: input: USB HID v1.01 Keyboard [Afatech 
DVB-T 2] on usb-0000:00:13.2-2/input1
dvb-usb: found a 'TerraTec Cinergy T Stick Dual RC' in cold state, will 
try to load a firmware
usb 2-2: firmware: requesting dvb-usb-af9015.fw
dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
dvb-usb: found a 'TerraTec Cinergy T Stick Dual RC' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software 
demuxer.
DVB: registering new adapter (TerraTec Cinergy T Stick Dual RC)
af9013: firmware version:4.95.0
DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
mxl5007t 6-0038: creating new instance
mxl5007t_get_chip_id: unknown rev (3d)
mxl5007t_get_chip_id: MxL5007T detected @ 6-0038
dvb-usb: will pass the complete MPEG2 transport stream to the software 
demuxer.
DVB: registering new adapter (TerraTec Cinergy T Stick Dual RC)
af9013: found a 'Afatech AF9013 DVB-T' in warm state.
af9013: firmware version:4.95.0
DVB: registering adapter 1 frontend 0 (Afatech AF9013 DVB-T)...
mxl5007t 7-0038: creating new instance
mxl5007t_get_chip_id: unknown rev (3d)
mxl5007t_get_chip_id: MxL5007T detected @ 7-0038
dvb-usb: TerraTec Cinergy T Stick Dual RC successfully initialized and 
connected.
usbcore: registered new interface driver dvb_usb_af9015


Any suggestions on how to move on?


[1]http://www.terratec.net/en/products/driver/produkte_treiber_en_105736.html


Thanks,
-- 
Tuomas
