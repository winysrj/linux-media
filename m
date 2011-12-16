Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out13.tpgi.com.au ([220.244.226.123]:38454 "EHLO
	mail13.tpgi.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750821Ab1LPFUE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Dec 2011 00:20:04 -0500
Received: from [192.168.224.56] (27-33-30-46.static.tpgi.com.au [27.33.30.46])
	(authenticated bits=0)
	by mail13.tpgi.com.au (envelope-from Andrew.Congdon@iplatinum.com.au) (8.14.3/8.14.3) with ESMTP id pBG56gKm029273
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 16 Dec 2011 16:06:45 +1100
Message-ID: <4EEAD1E2.7090605@iplatinum.com.au>
Date: Fri, 16 Dec 2011 16:06:42 +1100
From: Andrew Congdon <Andrew.Congdon@iplatinum.com.au>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: LME2510 Sharp 0194A DVB-S
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have a DM04 DVB-S USB box which doesn't seem to be supported with the
kernel 3.x dvb-usb-lmedm04 driver although it seems very close. The
firmware is loaded the tuner seems to be identified but it fails to
attach the tuner?

It has a LME2510 chip and the tuner has Sharp F7HZ0194A on it.

This is the debug trace:

LME2510(C): Firmware Status: 6 (44)
LME2510(C): FRM Loading dvb-usb-lme2510-s0194.fw file
LME2510(C): FRM Starting Firmware Download
LME2510(C): FRM Firmware Download Completed - Resetting Device
usbcore: registered new interface driver LME2510C_DVB-S
usb 1-2: USB disconnect, device number 3
usb 1-2: new high speed USB device number 7 using ehci_hcd
usb 1-2: config 1 interface 0 altsetting 1 bulk endpoint 0x87 has
invalid maxpacket 64
usb 1-2: config 1 interface 0 altsetting 1 bulk endpoint 0x3 has invalid
maxpacket 64
usb 1-2: config 1 interface 0 altsetting 1 bulk endpoint 0x8A has
invalid maxpacket 64
usb 1-2: config 1 interface 0 altsetting 1 bulk endpoint 0xA has invalid
maxpacket 64usb 1-2: New USB device found, idVendor=3344, idProduct=1122
usb 1-2: New USB device strings: Mfr=0, Product=0, SerialNumber=3
usb 1-2: SerialNumber: 䥈児
LME2510(C): Firmware Status: 6 (47)
dvb-usb: found a 'DM04_LME2510_DVB-S' in warm state.
dvb-usb: will use the device's hardware PID filter (table count: 15).
DVB: registering new adapter (DM04_LME2510_DVB-S)
LME2510(C): DM04 Not Supported
dvb-usb: no frontend was attached by 'DM04_LME2510_DVB-S'
Registered IR keymap rc-lme2510
input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:0b.1/usb1/1-2/rc/rc2/input11
rc2: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:0b.1/usb1/1-2/rc/rc2
dvb-usb: DM04_LME2510_DVB-S successfully initialized and connected.
LME2510(C): DEV registering device driver
