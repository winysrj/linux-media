Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <spam@mrplanlos.de>) id 1KBPRu-0007tA-FN
	for linux-dvb@linuxtv.org; Wed, 25 Jun 2008 09:29:51 +0200
Received: from [192.168.0.6]
	(ppp-62-216-219-209.dynamic.mnet-online.de [62.216.219.209])
	by post.webmailer.de (mrclete mo22) (RZmta 16.45)
	with ESMTP id R04600k5P6Mwjy for <linux-dvb@linuxtv.org>;
	Wed, 25 Jun 2008 09:29:46 +0200 (MEST)
	(envelope-from: <spam@mrplanlos.de>)
Content-Disposition: inline
From: Mailrobot <spam@mrplanlos.de>
To: linux-dvb@linuxtv.org
Date: Wed, 25 Jun 2008 09:29:28 +0200
MIME-Version: 1.0
Message-Id: <200806250929.28930.spam@mrplanlos.de>
Subject: [linux-dvb] Fwd: Terratec Cinergy USB XE Rev.2
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
I sadly bought this USB DVB-T stick and thought it would be supported by the 
v4l drivers (I didn't know, that there are 2 versions), and now I can't get 
it working.

My system is a 32 bit opensuse 11.0 (2.6.25.5-1.1-pae, gcc-4.3-39.1) and I 
tried to compile the driver the following ways.

1. the suse delivered kernel module
--> nothing happened, only registered as usb device

2. I tried the download from your website, v4l-dvb-49ea64868f0c
--> compiled fine (make && make install), but wehn I plug my usb stick I get 
this output:
af9015: af9015_read_config: tuner id:133 not supported, please report!

3. I tried to fix the "known" problem like sandyabutt described here: 
http://www.linuxtv.org/wiki/index.php/User:Sandybutt
so I donwloaded the "original" driver, copied my kernel delivered dvb files 
(*.c *.h) and pathed it with his pathfile. Make and make install worked fine, 
but I still get this message:
af9015: af9015_read_config: tuner id:133 not supported, please report!

4. So, my next step was to try the driver from anttip 
http://linuxtv.org/hg/~anttip/af9015. Same procedure with make and make 
install, but still I can't get it working.

This is the whole message in dmesg and /var/log/messages:
Jun 25 09:13:44 simon kernel: usb 2-6.1: new high speed USB device using 
ehci_hcd and address 6
Jun 25 09:13:44 simon kernel: usb 2-6.1: configuration #1 chosen from 1 choice
Jun 25 09:13:44 simon kernel: af9015_usb_probe: interface:0
Jun 25 09:13:44 simon kernel: af9015_read_config: IR mode:0
Jun 25 09:13:44 simon kernel: af9015_read_config: TS mode:0
Jun 25 09:13:44 simon kernel: af9015_read_config: [0] xtal:2 set 
adc_clock:28000
Jun 25 09:13:44 simon kernel: af9015_read_config: [0] IF1:36167
Jun 25 09:13:44 simon kernel: af9015_read_config: [0] MT2060 IF1:1220
Jun 25 09:13:44 simon kernel: af9015: af9015_read_config: tuner id:133 not 
supported, please report!
Jun 25 09:13:44 simon kernel: usb 2-6.1: New USB device found, idVendor=0ccd, 
idProduct=0069
Jun 25 09:13:44 simon kernel: usb 2-6.1: New USB device strings: Mfr=1, 
Product=2, SerialNumber=3
Jun 25 09:13:44 simon kernel: usb 2-6.1: Product: Cinergy T USB XE Ver.2
Jun 25 09:13:44 simon kernel: usb 2-6.1: Manufacturer: TerraTec
Jun 25 09:13:44 simon kernel: usb 2-6.1: SerialNumber: 10012007
Jun 25 09:13:44 simon kernel: dvb_af901x: disagrees about version of symbol 
dvb_usb_device_init
Jun 25 09:13:44 simon kernel: dvb_af901x: Unknown symbol dvb_usb_device_init



simon:/home/user/downloads # lsusb
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 002: ID 046a:0101 Cherry GmbH
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 006: ID 0ccd:0069 TerraTec Electronic GmbH Cinergy T XE DVB-T 
Receiver
Bus 002 Device 003: ID 058f:6254 Alcor Micro Corp.
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub



simon:/home/user/downloads # lsmod |grep dvb
dvb_usb_af9015         35616  0
dvb_usb                39180  1 dvb_usb_af9015
dvb_core               96744  1 dvb_usb
firmware_class         25984  2 microcode,dvb_usb
i2c_core               41108  4 dvb_usb_af9015,dvb_usb,i2c_i801,nvidia
usbcore               164684  6 
dvb_usb_af9015,dvb_usb,usbhid,ehci_hcd,uhci_hcd


I'm still not successfull and I know that some users got this stick working, 
but I can't find the solution. 
Is there anybody out there who could help me?

-------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
