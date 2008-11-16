Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dans.spam@gmail.com>) id 1L1cTb-0006lF-W9
	for linux-dvb@linuxtv.org; Sun, 16 Nov 2008 08:55:24 +0100
Received: by ey-out-2122.google.com with SMTP id 25so792590eya.17
	for <linux-dvb@linuxtv.org>; Sat, 15 Nov 2008 23:55:20 -0800 (PST)
Message-ID: <cda0e2660811152355m32a391b0x187d75497a1f2d9c@mail.gmail.com>
Date: Sat, 15 Nov 2008 23:55:20 -0800
From: "Dan Sanders" <dans.spam@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] WinTV-HVR-1500 analog - firmware loading problem
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello,

I am trying to get my WinTV-HVR-1500 working. I am using the
~stoth/cx23885-audio repository, which seems to be the only one with
HVR-1500 analog support, but I am getting an error in the firmware
step for the tuner chip.

dmesg looks like this:

[ 1099.493745] Linux video capture interface: v2.00
[ 1099.503677] cx23885 driver version 0.0.1 loaded
[ 1099.503732] cx23885 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[ 1099.503810] CORE cx23885[0]: subsystem: 0070:7790, board: Hauppauge
WinTV-HVR1500 [card=6,insmod option]
[ 1099.612900] cx23885[0]: i2c bus 0 registered
[ 1099.613604] cx23885[0]: i2c bus 1 registered
[ 1099.614250] cx23885[0]: i2c bus 2 registered
[ 1099.642338] tveeprom 0-0050: Encountered bad packet header [ff].
Corrupt or not a Hauppauge eeprom.
[ 1099.642344] cx23885[0]: warning: unknown hauppauge model #0
[ 1099.642346] cx23885[0]: hauppauge eeprom: model=0
[ 1099.651724] cx25840' 2-0044: cx25  0-21 found @ 0x88 (cx23885[0])
[ 1099.666656] tuner' 1-0061: chip found @ 0xc2 (cx23885[0])
[ 1099.687281] xc2028 1-0061: creating new instance
[ 1099.687288] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[ 1099.692057] xc2028 1-0061: destroying instance
[ 1099.692142] xc2028 1-0061: creating new instance
[ 1099.692144] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[ 1099.692280] cx23885[0]/0: registered device video0 [v4l2]
[ 1099.692610] cx23885[0]/1: registered ALSA audio device
[ 1099.692616] firmware: requesting xc3028-v27.fw
[ 1099.848072] xc2028 1-0061: Loading 80 firmware images from
xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[ 1100.046592] xc2028 1-0061: Loading firmware for type=BASE (1), id
0000000000000000.
[ 1100.667376] xc2028 1-0061: i2c output error: rc = -5 (should be 64)
[ 1100.667384] xc2028 1-0061: -5 returned from send
[ 1100.667388] xc2028 1-0061: Error -22 while loading base firmware
[ 1100.918459] xc2028 1-0061: Loading firmware for type=BASE (1), id
0000000000000000.
[ 1101.487794] xc2028 1-0061: i2c output error: rc = -5 (should be 64)
[ 1101.487803] xc2028 1-0061: -5 returned from send
[ 1101.487807] xc2028 1-0061: Error -22 while loading base firmware
[ 1101.491986] firmware: requesting v4l-cx23885-avcore-01.fw
[ 1102.220875] cx25840' 2-0044: loaded v4l-cx23885-avcore-01.fw
firmware (16382 bytes)
[ 1102.235880] cx23885[0]: cx23885 based dvb card
[ 1102.287830] xc2028 1-0061: attaching existing instance
[ 1102.287839] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[ 1102.289726] DVB: registering new adapter (cx23885[0])
[ 1102.290448] DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB
Frontend)...
[ 1102.319882] cx23885_dev_checkrevision() Hardware revision = 0xb0
[ 1102.319899] cx23885[0]/0: found at 0000:03:00.0, rev: 2, irq: 18,
latency: 0, mmio: 0xa8400000
[ 1102.319911] cx23885 0000:03:00.0: setting latency timer to 64

Thanks for any help!


- Dan

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
