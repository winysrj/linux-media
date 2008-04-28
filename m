Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fmmailgate02.web.de ([217.72.192.227])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <viets@web.de>) id 1JqRP3-0000Z8-5S
	for linux-dvb@linuxtv.org; Mon, 28 Apr 2008 13:20:14 +0200
Received: from smtp07.web.de (fmsmtp07.dlan.cinetic.de [172.20.5.215])
	by fmmailgate02.web.de (Postfix) with ESMTP id EDCB1DA816A3
	for <linux-dvb@linuxtv.org>; Mon, 28 Apr 2008 13:19:39 +0200 (CEST)
Received: from [212.12.32.70] (helo=[10.10.2.101])
	by smtp07.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.109 #226) id 1JqROV-0004oT-00
	for linux-dvb@linuxtv.org; Mon, 28 Apr 2008 13:19:39 +0200
Message-ID: <4815B2A9.4060209@web.de>
Date: Mon, 28 Apr 2008 13:19:05 +0200
From: Torben Viets <viets@web.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Hauppauge HVR-1700 Support
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

I have a Hauppauge HVR-1700 PCI Express, I have read all posts about
this card here, but I didn't get it working, how does it work?

Kernel: linux-2.6.25-git10

Firmware-Files:
ls -al /lib/firmware/2.6.25-git10/
total 416
drwxr-xr-x 2 root root     91 Apr 27 16:27 .
drwxr-xr-x 3 root root     25 Apr 27 16:26 ..
-rw-r--r-- 1 root root  24878 Apr 27 16:27 dvb-fe-tda10048-1.0.fw
-r--r--r-- 1 root root  16382 Apr 27 16:27 v4l-cx23885-avcore-01.fw
-r--r--r-- 1 root root 376836 Apr 27 16:26 v4l-cx23885-enc.fw

The modules I use are from the actual v4l-dvb hg, if I type make load,
the only thing I get is a /dev/video0, but I have no picture with xawtv...

The DVB doesn't work at all, I have no /dev/dvb*, here is my dmesg:

cx23885 driver version 0.0.1 loaded
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 24 (level, low) -> IRQ 24
CORE cx23885[0]: subsystem: 0070:8101, board: Hauppauge WinTV-HVR1700
[card=8,autodetected]
cx23885[0]: i2c bus 0 registered
cx23885[0]: i2c bus 1 registered
cx23885[0]: i2c bus 2 registered
tveeprom 0-0050: Huh, no eeprom present (err=-5)?
tveeprom 0-0050: Encountered bad packet header [00].
Corrupt or not a Hauppauge
eeprom.
cx23885[0]: warning: unknown hauppauge model #0
cx23885[0]: hauppauge eeprom: model=0
cx23885[0]: cx23885 based dvb card
tda10048_readreg: readreg error (ret == -5)
cx23885[0]: frontend initialization failed
cx23885_dvb_register() dvb_register failed err = -1
cx23885_dev_setup() Failed to register dvb on VID_C
cx23885_dev_checkrevision() New hardware revision found 0x0
cx23885_dev_checkrevision() Hardware revision unknown 0x0
cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 24, latency: 0, mmio:
0xfe800000

Thank you and greetings
Torben Viets



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
