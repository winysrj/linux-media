Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp112.mail.ukl.yahoo.com ([77.238.184.50]:44718 "HELO
	smtp112.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752467AbZL2QNn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2009 11:13:43 -0500
Message-ID: <580652.33691.qm@smtp112.mail.ukl.yahoo.com>
Date: Tue, 29 Dec 2009 17:13:41 +0100
To: linux-media@vger.kernel.org
From: sebax75@yahoo.it
Subject: Siano SMS1140 problem
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I've already worked with different adapters (Pinnacle 320E with  em28xx, Intel CE9500B1, Hauppauge Nova-T Stick and SAA7134), and all have worked without big problem reading the howto I've found online; but now I've a new dvb-adapter, and it's a Siano SMS1140.
I've found some howto, but I'm not able to get it working.
Here are the steps I've followed:
- downloaded latest v4l-dvb tree (hg clone http://linuxtv.org/hg/v4l-dvb);
- compiled the tree without error (cd v4l-dvb; make);
- installed the new module (make install);
- rebooted the system;
- downloaded firmwares for dvbt from "http://steventoth.net/linux/sms1xxx/" and copied the firmware (tried version from 01 to 03) as dvb_nova_12mhz_b0.inp (as requested in dmesg output) in /lib/modules/firmware.
When I plug the adpter dmesg seems ok, but no device will be created in /dev/dvb (dvb was not created too), so all program don't find dvb-t.
I've tried to search inside the code, but I've not found anything interesting for me.
The only informations I can add are:
- USB ID: 187f:0201;
- name in source code: SMS1XXX_BOARD_SIANO_NOVA_B (Siano Nova B Digital Receiver);
- dmesg output:
usb 1-7: new high speed USB device using ehci_hcd and address 7
usb 1-7: New USB device found, idVendor=187f, idProduct=0201
usb 1-7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-7: Product: MDTV Receiver
usb 1-7: Manufacturer: MDTV Receiver
usb 1-7: configuration #1 chosen from 1 choice
usb 1-7: firmware: requesting dvb_nova_12mhz_b0.inp
smscore_set_device_mode: firmware download success: dvb_nova_12mhz_b0.inp
usbcore: registered new interface driver smsusb
- when I unplug the adapter and do "modprobe -r smsusb smsmdtv", in dmesg:
usb 1-7: USB disconnect, address 5
smsusb_onresponse: line: 74: error, urb status -108 (-ESHUTDOWN), 0 bytes
smsusb_onresponse: line: 74: error, urb status -108 (-ESHUTDOWN), 0 bytes
smsusb_onresponse: line: 74: error, urb status -108 (-ESHUTDOWN), 0 bytes
smsusb_onresponse: line: 74: error, urb status -108 (-ESHUTDOWN), 0 bytes
smsusb_onresponse: line: 74: error, urb status -108 (-ESHUTDOWN), 0 bytes
smsusb_onresponse: line: 74: error, urb status -108 (-ESHUTDOWN), 0 bytes
smsusb_onresponse: line: 74: error, urb status -108 (-ESHUTDOWN), 0 bytes
smsusb_onresponse: line: 74: error, urb status -108 (-ESHUTDOWN), 0 bytes
smsusb_onresponse: line: 74: error, urb status -108 (-ESHUTDOWN), 0 bytes
smsusb_onresponse: line: 74: error, urb status -108 (-ESHUTDOWN), 0 bytes
sms_ir_exit:
usbcore: deregistering interface driver smsusb

Someone can explain to me how to get it to work or where I miss something ori, if it's due to some regression, how to debug it and support a programmer for this?

Very thanks for the help in advance,
Sebastian


