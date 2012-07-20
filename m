Return-path: <linux-media-owner@vger.kernel.org>
Received: from deliverator1.gatech.edu ([130.207.165.161]:36500 "EHLO
	deliverator1.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab2GTTJf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jul 2012 15:09:35 -0400
Received: from deliverator1.gatech.edu (localhost [127.0.0.1])
	by localhost (Postfix) with SMTP id BBF21D44F27
	for <linux-media@vger.kernel.org>; Fri, 20 Jul 2012 15:09:34 -0400 (EDT)
Received: from mail8.gatech.edu (mail8.gatech.edu [130.207.185.168])
	by deliverator1.gatech.edu (Postfix) with ESMTP id 9C6F9D44B78
	for <linux-media@vger.kernel.org>; Fri, 20 Jul 2012 15:09:33 -0400 (EDT)
Received: from [192.168.1.102] (rehearsalrouter.tss.gatech.edu [130.207.44.218])
	(Authenticated sender: akoza3)
	by mail8.gatech.edu (Postfix) with ESMTPSA id 8AEEB2E8824
	for <linux-media@vger.kernel.org>; Fri, 20 Jul 2012 15:09:33 -0400 (EDT)
From: Adam Koza <adamkoza@gatech.edu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: Build Failure: ddbridge-core.o and drxk_hard.o
Message-Id: <76009C42-CABF-412B-885E-0379169DDBA2@gatech.edu>
Date: Fri, 20 Jul 2012 15:09:31 -0400
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1485\))
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have been building a streaming server at Georgia Tech and I have recently run into a build error using the media_build git repository that I have yet to find a solution for. 

The drivers built, installed, and worked about a month ago, but with the recent git update it has failed to build. 

I wasn't able to find the same error in the daily builds and thought I'd ask to see if anyone could point me in the right direction, whether it be a bug in the build files or something on my end. 

I am running RHEL 6 without any GUI installed and everything is up to date.

Server Info:
---------------
Red Hat Enterprise Linux 6
Kernel: 2.6.32-279.1.1.el6.x86_64
GCC Version: 4.4.6

Main Build Error:
-----------------------
 CC [M]  /root/downloads/media_build/v4l/ddbridge-core.o
/root/downloads/media_build/v4l/ddbridge-core.c: In function 'ddb_class_create':
/root/downloads/media_build/v4l/ddbridge-core.c:1502: warning: assignment from incompatible pointer type
  CC [M]  /root/downloads/media_build/v4l/drxd_firm.o
  CC [M]  /root/downloads/media_build/v4l/drxd_hard.o
  CC [M]  /root/downloads/media_build/v4l/drxk_hard.o
/root/downloads/media_build/v4l/drxk_hard.c: In function 'drxk_attach':
/root/downloads/media_build/v4l/drxk_hard.c:6615: warning: passing argument 5 of 'request_firmware_nowait' makes integer from pointer without a cast
include/linux/firmware.h:40: note: expected 'gfp_t' but argument is of type 'struct drxk_state *'
/root/downloads/media_build/v4l/drxk_hard.c:6615: error: too few arguments to function 'request_firmware_nowait'
make[3]: *** [/root/downloads/media_build/v4l/drxk_hard.o] Error 1
make[2]: *** [_module_/root/downloads/media_build/v4l] Error 2
make[2]: Leaving directory `/usr/src/kernels/2.6.32-279.el6.x86_64'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/root/downloads/media_build/v4l'
make: *** [all] Error 2
build failed at ./build line 452.

Other Information:
------------------------
Tuning card: Hauppauge WinTV-HVR-2250 (I'm tuning Clear-QAM and NTSC)
Device Subsystem ID
Multimedia controller [0480]: Philips Semiconductors SAA7164 [1131:7164] (rev 81)
	Subsystem: Hauppauge computer works Inc. WinTV HVR-2250 [0070:8851]
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at df000000 (64-bit, non-prefetchable) [size=4M]
	Memory at df400000 (64-bit, non-prefetchable) [size=4M]
	Capabilities: [40] MSI: Enable- Count=1/16 Maskable- 64bit+
	Capabilities: [50] Express Endpoint, MSI 00
	Capabilities: [74] Power Management version 3
	Capabilities: [7c] Vendor Specific Information <?>
	Capabilities: [100] Vendor Specific Information <?>
	Capabilities: [160] Virtual Channel <?>
	Kernel driver in use: saa7164
	Kernel modules: saa7164

Base Board Information
	Manufacturer: Dell Inc.
	Product Name: 05XKKK

BIOS Information
	Vendor: Dell Inc.
	Version: 1.8.2
	Release Date: 08/17/2011
	Address: 0xF0000
	Runtime Size: 64 kB
	ROM Size: 4096 kB
	Characteristics:
		ISA is supported
		PCI is supported
		PNP is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		Boot from CD is supported
		Selectable boot is supported
		EDD is supported
		Japanese floppy for Toshiba 1.2 MB is supported (int 13h)
		5.25"/360 kB floppy services are supported (int 13h)
		5.25"/1.2 MB floppy services are supported (int 13h)
		3.5"/720 kB floppy services are supported (int 13h)
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		CGA/mono video services are supported (int 10h)
		ACPI is supported
		USB legacy is supported
		BIOS boot specification is supported
		Function key-initiated network boot is supported
		Targeted content distribution is supported
	BIOS Revision: 1.8

Processor Information
	Socket Designation: CPU1
	Type: Central Processor
	Family: Xeon
	Manufacturer: Intel
	ID: E5 06 01 00 FF FB EB BF
	Signature: Type 0, Family 6, Model 30, Stepping 5
	Version: Intel(R) Xeon(R) CPU           X3480  @ 3.07GHz
	Voltage: 1.2 V
	External Clock: 4800 MHz
	Max Speed: 3600 MHz
	Current Speed: 3066 MHz
	Status: Populated, Enabled
	Upgrade: Socket LGA1366
	L1 Cache Handle: 0x0700
	L2 Cache Handle: 0x0701
	L3 Cache Handle: 0x0702
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified
	Core Count: 4
	Core Enabled: 4
	Thread Count: 8
	Characteristics:
		64-bit capable

Dmesg Log for saa7164 Driver:
--------------------------------------------
saa7164 driver loaded
saa7164 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
CORE saa7164[0]: subsystem: 0070:8851, board: Hauppauge WinTV-HVR2250 [card=7,autodetected]
saa7164[0]/0: found at 0000:04:00.0, rev: 129, irq: 16, latency: 0, mmio: 0xdf000000
saa7164 0000:04:00.0: setting latency timer to 64
IRQ 16/saa7164[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7164_downloadfirmware() no first image
saa7164_downloadfirmware() Waiting for firmware upload (NXP7164-2010-03-10.1.fw)
saa7164 0000:04:00.0: firmware: requesting NXP7164-2010-03-10.1.fw
saa7164_downloadfirmware() firmware read 4019072 bytes.
saa7164_downloadfirmware() firmware loaded.
Firmware file header part 1:
 .FirmwareSize = 0x0
 .BSLSize = 0x0
 .Reserved = 0x3d538
 .Version = 0x3
saa7164_downloadfirmware() SecBootLoader.FileSize = 4019072
saa7164_downloadfirmware() FirmwareSize = 0x1fd6
saa7164_downloadfirmware() BSLSize = 0x0
saa7164_downloadfirmware() Reserved = 0x0
saa7164_downloadfirmware() Version = 0x1661c00
saa7164_downloadimage() Image downloaded, booting...
saa7164_downloadimage() Image booted successfully.
starting firmware download(2)
saa7164_downloadimage() Image downloaded, booting...
saa7164_downloadimage() Image booted successfully.
firmware download complete.
tveeprom 0-0000: Hauppauge model 88061, rev C4F2, serial# 8798501
tveeprom 0-0000: MAC address is 00:0d:fe:86:41:25
tveeprom 0-0000: tuner model is NXP 18271C2_716x (idx 152, type 4)
tveeprom 0-0000: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)
tveeprom 0-0000: audio processor is SAA7164 (idx 43)
tveeprom 0-0000: decoder processor is SAA7164 (idx 40)
tveeprom 0-0000: has radio, has IR receiver, has no IR transmitter
saa7164[0]: Hauppauge eeprom: model=88061
tda18271 1-0060: creating new instance
TDA18271HD/C2 detected @ 1-0060
DVB: registering new adapter (saa7164)
DVB: registering adapter 0 frontend 0 (Samsung S5H1411 QAM/8VSB Frontend)...
tda18271 2-0060: creating new instance
TDA18271HD/C2 detected @ 2-0060
tda18271: performing RF tracking filter calibration
tda18271: RF tracking filter calibration complete
DVB: registering new adapter (saa7164)
DVB: registering adapter 1 frontend 0 (Samsung S5H1411 QAM/8VSB Frontend)...
saa7164[0]: registered device video0 [mpeg]
saa7164[0]: registered device video1 [mpeg]
saa7164[0]: registered device vbi0 [vbi]
saa7164[0]: registered device vbi1 [vbi]

Commands used to build:
git clone git://linuxtv.org/media_build.git
cd media_build 
./build

If you need anymore information I will gladly supply it. Also, let me know if I didn't follow the proper listserv etiquette or should post somewhere else. 

Thanks,

---------------------------------
Adam Koza
adamkoza@gatech.edu