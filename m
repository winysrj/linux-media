Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp.adfinis.com ([212.103.64.13])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@0x17.ch>) id 1K4WB8-0000gk-1n
	for linux-dvb@linuxtv.org; Fri, 06 Jun 2008 09:16:03 +0200
Received: from mail.adfinis.com (HELO [192.168.42.50])
	(adfinis.auth:lists@0x17.ch@[212.103.64.15])
	(envelope-sender <lists@0x17.ch>) by 0 (qmail-ldap-1.03) with SMTP
	for <linux-dvb@linuxtv.org>; 6 Jun 2008 09:16:17 +0200
From: Nicolas Christener <lists@0x17.ch>
To: linux-dvb@linuxtv.org
Date: Fri, 06 Jun 2008 09:15:55 +0200
Message-Id: <1212736555.4264.12.camel@oipunk.loozer.local>
Mime-Version: 1.0
Subject: [linux-dvb] Terratec Cinergy Piranha
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

Hello
according to [1] i should contact this list, because I own a currently
unsupported DVB-T USB device and want to support development :)
The device I got is labeled 'Terratec Cinergy Piranha'.

output of `dmesg':
kernel: hub 5-0:1.0: unable to enumerate USB device on port 5
kernel: usb 3-1: new full speed USB device using uhci_hcd and address 6
kernel: usb 3-1: configuration #1 chosen from 1 choice
kernel: usb 3-1: New USB device found, idVendor=187f, idProduct=0010
kernel: usb 3-1: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
kernel: usb 3-1: Product: SMS 1000
kernel: usb 3-1: Manufacturer: Siano

Although I can probably not help to write code for this device I'd be
happy, if I could help in any other way to get this device supported by
linux.

[1] http://linuxtv.org/wiki/index.php/DVB-T_USB_Devices

kind regards
Nicolas


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
