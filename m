Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp16.protectedservice.net ([217.154.106.151]:49244 "EHLO
	smtp16.protectedservice.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752917AbZERU4M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2009 16:56:12 -0400
Received: from [79.94.244.252] (helo=[192.168.1.35])
	by smtp16.protectedservice.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.63)
	(envelope-from <glaures@lauresconseil.fr>)
	id 1M69R6-0005xt-Ac
	for linux-media@vger.kernel.org; Mon, 18 May 2009 21:27:48 +0100
Message-Id: <C9D3D945-05BF-48DA-9CEF-CF7D4DFE8053@lauresconseil.fr>
From: =?ISO-8859-1?Q?Guillaume_Laur=E8s?= <glaures@lauresconseil.fr>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: no tuning with an hvr-1700
Date: Mon, 18 May 2009 22:27:47 +0200
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

I can't find digital channels with an hvr-1700.
"dvb-scan -a2  /usr/share/dvb/dvb-t/fr-Tours" outputs no channel info,  
only some "tuning failed" messages. Two hvr-3000 in the same box work  
flawlessly (both dvb-t and dvb-s).

I run v4l-sources (last saturday's snapshot), on a 2.6.28-gentoo-r5  
x64 host.
The card is recognized as /dev/dvb/adapter2 and firmwares are loaded.  
I also tried with the hvr-1700 alone and got the same result.
Here is some dmesg output with debugging enabled, this shows activity  
from modprobe and dvb-scan.

May 18 22:00:02 hesa3 cx23885 driver version 0.0.2 loaded
May 18 22:00:02 hesa3 cx23885 0000:04:00.0: PCI INT A -> Link[LN2A] ->  
GSI 18 (level, low) -> IRQ 18
May 18 22:00:02 hesa3 cx23885[0]/0: cx23885_dev_setup() Memory  
configured for PCIe bridge type 885
May 18 22:00:02 hesa3 cx23885[0]/0: cx23885_init_tsport(portno=2)
May 18 22:00:02 hesa3 CORE cx23885[0]: subsystem: 0070:8101, board:  
Hauppauge WinTV-HVR1700 [card=8,autodetected]
May 18 22:00:02 hesa3 cx23885[0]/0: cx23885_pci_quirks()
May 18 22:00:02 hesa3 cx23885[0]/0: cx23885_dev_setup() tuner_type =  
0x0 tuner_addr = 0x0
May 18 22:00:02 hesa3 cx23885[0]/0: cx23885_dev_setup() radio_type =  
0x0 radio_addr = 0x0
May 18 22:00:02 hesa3 cx23885[0]/0: cx23885_reset()
May 18 22:00:02 hesa3 cx23885[0]/0: cx23885_sram_channel_setup()  
Configuring channel [VID A]
May 18 22:00:02 hesa3 cx23885[0]/0: cx23885_sram_channel_setup()  
Erasing channel [ch2]
May 18 22:00:02 hesa3 cx23885[0]/0: cx23885_sram_channel_setup()  
Configuring channel [TS1 B]
May 18 22:00:02 hesa3 cx23885[0]/0: cx23885_sram_channel_setup()  
Erasing channel [ch4]
May 18 22:00:02 hesa3 cx23885[0]/0: cx23885_sram_channel_setup()  
Erasing channel [ch5]
May 18 22:00:02 hesa3 cx23885[0]/0: cx23885_sram_channel_setup()  
Configuring channel [TS2 C]
May 18 22:00:02 hesa3 cx23885[0]/0: cx23885_sram_channel_setup()  
Erasing channel [ch7]
May 18 22:00:02 hesa3 cx23885[0]/0: cx23885_sram_channel_setup()  
Erasing channel [ch8]
May 18 22:00:02 hesa3 cx23885[0]/0: cx23885_sram_channel_setup()  
Erasing channel [ch9]
May 18 22:00:02 hesa3 tveeprom 7-0050: Hauppauge model 81519, rev  
B2E9, serial# 6177447
May 18 22:00:02 hesa3 tveeprom 7-0050: MAC address is 00-0D-FE-5E-42-A7
May 18 22:00:02 hesa3 tveeprom 7-0050: tuner model is Philips  
18271_8295 (idx 149, type 54)
May 18 22:00:02 hesa3 tveeprom 7-0050: TV standards PAL(B/G) PAL(I)  
SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
May 18 22:00:02 hesa3 tveeprom 7-0050: audio processor is CX23885 (idx  
39)
May 18 22:00:02 hesa3 tveeprom 7-0050: decoder processor is CX23885  
(idx 33)
May 18 22:00:02 hesa3 tveeprom 7-0050: has no radio
May 18 22:00:02 hesa3 cx23885[0]: hauppauge eeprom: model=81519
May 18 22:00:02 hesa3 cx25840 9-0044: cx25  0-21 found @ 0x88  
(cx23885[0])
May 18 22:00:02 hesa3 cx25840 9-0044: firmware: requesting v4l-cx23885- 
avcore-01.fw
May 18 22:00:03 hesa3 cx25840 9-0044: loaded v4l-cx23885-avcore-01.fw  
firmware (16382 bytes)
May 18 22:00:03 hesa3 cx23885_dvb_register() allocating 1 frontend(s)
May 18 22:00:03 hesa3 cx23885[0]: cx23885 based dvb card
May 18 22:00:03 hesa3 tda829x 8-0042: type set to tda8295
May 18 22:00:03 hesa3 tda18271 8-0060: creating new instance
May 18 22:00:03 hesa3 TDA18271HD/C1 detected @ 8-0060
May 18 22:00:05 hesa3 DVB: registering new adapter (cx23885[0])
May 18 22:00:05 hesa3 DVB: registering adapter 2 frontend 0 (NXP  
TDA10048HN DVB-T)...
May 18 22:00:05 hesa3 cx23885_dev_checkrevision() Hardware revision =  
0xb0
May 18 22:00:05 hesa3 cx23885[0]/0: found at 0000:04:00.0, rev: 2,  
irq: 18, latency: 0, mmio: 0xfe800000
May 18 22:00:05 hesa3 cx23885 0000:04:00.0: setting latency timer to 64
<-- dvbscan starts here
May 18 22:01:55 hesa3 tda10048_firmware_upload: waiting for firmware  
upload (dvb-fe-tda10048-1.0.fw)...
May 18 22:01:55 hesa3 cx23885 0000:04:00.0: firmware: requesting dvb- 
fe-tda10048-1.0.fw
May 18 22:01:55 hesa3 tda10048_firmware_upload: firmware read 24878  
bytes.
May 18 22:01:55 hesa3 tda10048_firmware_upload: firmware uploading
May 18 22:01:58 hesa3 tda10048_firmware_upload: firmware uploaded

Any hints ?

Cheers

GoM
