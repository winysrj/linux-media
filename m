Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:38398 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab2FJMUH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 08:20:07 -0400
Received: from ipb3.telenor.se (ipb3.telenor.se [195.54.127.166])
	by smtprelay-b12.telenor.se (Postfix) with ESMTP id D5A85C04F
	for <linux-media@vger.kernel.org>; Sun, 10 Jun 2012 14:20:05 +0200 (CEST)
Message-ID: <4FD490F5.8090901@bredband.net>
Date: Sun, 10 Jun 2012 14:20:05 +0200
From: Fredrik <shade@bredband.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: stv0298 signal issues on QAM256
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.

Unfortunatly my cable provider "Comhem" moved almost all channels to QAM256.
The results are terrible on my two cards. Blocky picture and skipping audio.
I've tried all suggestions i've found on mailing lists to change 
different values in stv0297.c  but without luck.
What i cannot see is, if those who reported problems since 2005, are 
happy now or not. Perhaps this hardware is too obsolete.
On other devices QAM256 is ok.
Anyway im hoping for some help or some information to make me decide 
about placing these card in the junkbox.


04:00.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
         Subsystem: Technotrend Systemtechnik GmbH Octal/Technotrend 
DVB-C for iTV
         Kernel driver in use: av7110
         Kernel modules: dvb-ttpci

dmsg snip..
[    1.572820] DVB: registering new adapter (Technotrend/Hauppauge WinTV 
Nexus-CA rev1.X)
[    1.584677] DVB: registering adapter 0 frontend 0 (Philips TDA10023 
DVB-C)...
[    1.590877] adapter has MAC addr = 00:d0:5c:24:5c:71
[    1.592807] IR keymap rc-anysee not found
[    1.592809] Registered IR keymap rc-empty
[    1.592852] input: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:1d.7/usb1/1-6/rc/rc0/input0
[    1.592869] rc0: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:1d.7/usb1/1-6/rc/rc0
[    1.592871] dvb-usb: schedule remote query interval to 250 msecs.
[    1.592873] dvb-usb: Anysee DVB USB2.0 successfully initialized and 
connected.
[    1.594442] usbcore: registered new interface driver dvb_usb_anysee
[    1.731015] usb 2-2: new full-speed USB device number 2 using uhci_hcd
[    1.900088] usb 2-2: New USB device found, idVendor=046d, idProduct=0b04
[    1.900092] usb 2-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[    1.900095] usb 2-2: Product: Logitech BT Mini-Receiver
[    1.900098] usb 2-2: Manufacturer: Logitech
[    1.903118] hub 2-2:1.0: USB hub found
[    1.905092] hub 2-2:1.0: 3 ports detected
[    1.924098] dvb-ttpci: info @ card 1: firm f0240009, rtsl b0250018, 
vid 71010068, app 80f12623
[    1.924102] dvb-ttpci: firmware @ card 1 supports CI link layer interface
[    1.998276] dvb_ttpci: DVB-C analog module @ card 1 detected, 
initializing MSP3415
[    2.101563] dvb_ttpci: saa7113 not accessible
[    2.116015] usb 3-1: new full-speed USB device number 2 using uhci_hcd
[    2.131523] saa7146_vv: saa7146 (0): registered device video0 [v4l2]
[    2.131535] saa7146_vv: saa7146 (0): registered device vbi0 [v4l2]
[    2.133473] DVB: registering adapter 1 frontend 0 (ST STV0297 DVB-C)...
[    2.136094] input: DVB on-card IR receiver as 
/devices/pci0000:00/0000:00:1e.0/0000:04:00.0/input/input1
[    2.136119] dvb-ttpci: found av7110-0.
[    2.136157] saa7146: found saa7146 @ mem fa0b0000 (revision 1, irq 
19) (0x13c2,0x000a)
[    2.137704] DVB: registering new adapter (Technotrend/Hauppauge WinTV 
Nexus-CA rev1.X)
[    2.155901] adapter has MAC addr = 00:d0:5c:24:47:2a
[    2.283286] usb 3-1: New USB device found, idVendor=08e6, idProduct=3437
[    2.283290] usb 3-1: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[    2.283293] usb 3-1: Product: USB SmartCard Reader
[    2.283296] usb 3-1: Manufacturer: Gemplus
[    2.485099] dvb-ttpci: info @ card 2: firm f0240009, rtsl b0250018, 
vid 71010068, app 80f12623
[    2.485102] dvb-ttpci: firmware @ card 2 supports CI link layer interface
[    2.492128] usb 5-2: new full-speed USB device number 2 using uhci_hcd
[    2.562280] dvb_ttpci: DVB-C analog module @ card 2 detected, 
initializing MSP3415
[    2.650542] usb 5-2: New USB device found, idVendor=0471, idProduct=0815
[    2.650545] usb 5-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[    2.650548] usb 5-2: Product: eHome Infrared Transceiver
[    2.650551] usb 5-2: Manufacturer: Philips
[    2.650553] usb 5-2: SerialNumber: PH00GEFN
[    2.665560] dvb_ttpci: saa7113 not accessible
[    2.695510] saa7146_vv: saa7146 (1): registered device video1 [v4l2]
[    2.695522] saa7146_vv: saa7146 (1): registered device vbi1 [v4l2]
[    2.695832] DVB: registering adapter 2 frontend 0 (ST STV0297 DVB-C)...
[    2.695906] input: DVB on-card IR receiver as 
/devices/pci0000:00/0000:00:1e.0/0000:04:01.0/input/input2
[    2.695923] dvb-ttpci: found av7110-1.

Br Fredrik
