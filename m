Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from legolas.alcom.aland.fi ([194.112.1.132])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <jan.sundman@aland.net>) id 1NFWPj-0005Ja-TS
	for linux-dvb@linuxtv.org; Tue, 01 Dec 2009 18:21:25 +0100
Received: from aragon.alcom.aland.fi (aragon [194.112.0.1])
	by legolas.alcom.aland.fi (8.12.11.20060308/8.12.11) with ESMTP id
	nB1HKmER011819
	for <linux-dvb@linuxtv.org>; Tue, 1 Dec 2009 19:20:48 +0200
Received: from [10.0.0.2] (82-199-168-58.bredband.aland.net [82.199.168.58])
	(authenticated bits=0)
	by aragon.alcom.aland.fi (8.12.11.20060308/8.12.11) with ESMTP id
	nB1HKkWv004674
	for <linux-dvb@linuxtv.org>; Tue, 1 Dec 2009 19:20:47 +0200
From: Jan Sundman <jan.sundman@aland.net>
To: linux-dvb@linuxtv.org
Date: Tue, 01 Dec 2009 19:20:41 +0200
Message-ID: <1259688041.5239.1.camel@desktop>
Mime-Version: 1.0
Subject: [linux-dvb] af9015: tuner id:179 not supported, please report!
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

Hi,

I just received a usb DVB-T card and have been trying to get it to work
under Ubuntu 9.10, but to no avail. dmesg shows the following when
plugging in the card:

[   35.280024] usb 2-1: new high speed USB device using ehci_hcd and
address 4
[   35.435978] usb 2-1: configuration #1 chosen from 1 choice
[   35.450176] af9015: tuner id:179 not supported, please report!
[   35.452891] Afatech DVB-T 2: Fixing fullspeed to highspeed interval:
10 -> 7
[   35.453097] input: Afatech DVB-T 2
as /devices/pci0000:00/0000:00:13.2/usb2/2-1/2-1:1.1/input/input8
[   35.453141] generic-usb 0003:15A4:9016.0005: input,hidraw3: USB HID
v1.01 Keyboard [Afatech DVB-T 2] on usb-0000:00:13.2-1/input1

lsusb shows:
Bus 002 Device 005: ID 15a4:9016  

and finally lsmod | grep dvb
dvb_usb_af9015         37152  0 
dvb_usb                22892  1 dvb_usb_af9015
dvb_core              109716  1 dvb_usb

While googling for an answer to my troubles I came across
http://ubuntuforums.org/showthread.php?t=606487&page=5 which hints that
the card may use the TDA18218HK tuner chip which does not seem to be
supported currently.

Does anyone have any experience regarding this chip and know what to do
to get it working.

Best regards,

//Jan


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
