Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51352 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751248AbZKGJ4V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2009 04:56:21 -0500
Date: Sat, 7 Nov 2009 10:56:14 +0100
From: Mario Bachmann <grafgrimm77@gmx.de>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: linux-media@vger.kernel.org
Subject: dibusb-common.c FE_HAS_LOCK problem
Message-ID: <20091107105614.7a51f2f5@x2.grafnetz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there, 

I tried linux-2.6.31.5 and tuning still does not work: 
tuning to 738000000 Hz
video pid 0x0131, audio pid 0x0132
status 00 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff | 
status 00 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff | 
status 00 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff | 
status 04 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff | 

With some changes for the following file it works again:
/usr/src/linux/drivers/media/dvb/dvb-usb/dibusb-common.c

diff -Naur dibusb-common.c-ORIGINAL dibusb-common.c

--- dibusb-common.c-ORIGINAL	2009-11-07 10:30:43.705344308 +0100
+++ dibusb-common.c	2009-11-07 10:33:49.969345253 +0100
@@ -133,17 +133,14 @@
 
 	for (i = 0; i < num; i++) {
 		/* write/read request */
-		if (i+1 < num && (msg[i].flags & I2C_M_RD) == 0
-					  && (msg[i+1].flags & I2C_M_RD)) {
+		if (i+1 < num && (msg[i+1].flags & I2C_M_RD)) {
 			if (dibusb_i2c_msg(d, msg[i].addr, msg[i].buf,msg[i].len,
 						msg[i+1].buf,msg[i+1].len) < 0)
 				break;
 			i++;
-		} else if ((msg[i].flags & I2C_M_RD) == 0) {
+		} else
 			if (dibusb_i2c_msg(d, msg[i].addr, msg[i].buf,msg[i].len,NULL,0) < 0)
 				break;
-		} else
-			break;
 	}
 
 	mutex_unlock(&d->i2c_mutex);


With this patch, tuning works again:
tuning to 738000000 Hz
video pid 0x0131, audio pid 0x0132
status 00 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff | 
status 1f | signal ffff | snr 008d | ber 001fffff | unc 0000ffff | FE_HAS_LOCK
status 1f | signal ffff | snr 00a1 | ber 000005a4 | unc 00000043 | FE_HAS_LOCK
status 1f | signal ffff | snr 00a3 | ber 000005a4 | unc 00000043 | FE_HAS_LOCK
status 1f | signal ffff | snr 009d | ber 00000000 | unc 00000000 | FE_HAS_LOCK


This is my DVB-T-Box (dmesg):
usb 4-2: new full speed USB device using ohci_hcd and address 6
usb 4-2: configuration #1 chosen from 1 choice
dvb-usb: found a 'TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA USB1.1
DVB-T device' in warm state. dvb-usb: will use the device's hardware
PID filter (table count: 16). DVB: registering new adapter (TwinhanDTV
USB-Ter USB1.1 / Magic Box I / HAMA USB1.1 DVB-T device) DVB:
registering adapter 0 frontend 0 (DiBcom 3000M-B DVB-T)... dibusb: This
device has the Thomson Cable onboard. Which is default. input:
IR-receiver inside an USB DVB receiver
as /devices/pci0000:00/0000:00:04.0/usb4/4-2/input/input6 dvb-usb:
schedule remote query interval to 150 msecs. dvb-usb: TwinhanDTV
USB-Ter USB1.1 / Magic Box I / HAMA USB1.1 DVB-T device successfully
initialized and connected.

Mario
