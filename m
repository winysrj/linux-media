Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:51543 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751710Ab2LEI6G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2012 03:58:06 -0500
Message-ID: <50BF0C9B.70407@gmx.de>
Date: Wed, 05 Dec 2012 09:58:03 +0100
From: Markus Feldmann <feldmann_markus@gmx.de>
MIME-Version: 1.0
To: Mailing List Linux Media <linux-media@vger.kernel.org>
Subject: ASUS My Cinema U3000 Mini DVBT Tuner
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

i am trying to get this DVBT usb device to work on my Linux Mint Debian 
System. I configured my kernel 3.6.2, but i am not sure whether 
something is missing.

When i plug in this device i get the following <dmesg>:
[58564.761059] usb 1-1.1: new high-speed USB device number 8 using ehci_hcd
[58564.845858] usb 1-1.1: New USB device found, idVendor=0b05, 
idProduct=171f
[58564.845863] usb 1-1.1: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[58564.845867] usb 1-1.1: Product: STK7700
[58564.845870] usb 1-1.1: Manufacturer: DIBCOM
[58564.845874] usb 1-1.1: SerialNumber: 6803800468
[58565.243046] dvb-usb: found a 'ASUS My Cinema U3000 Mini DVBT Tuner' 
in cold state, will try to load a firmware
[58565.359590] dvb-usb: downloading firmware from file 
'dvb-usb-dib0700-1.20.fw'
[58565.560519] dib0700: firmware started successfully.
[58566.061319] dvb-usb: found a 'ASUS My Cinema U3000 Mini DVBT Tuner' 
in warm state.
[58566.061375] dvb-usb: will pass the complete MPEG2 transport stream to 
the software demuxer.
[58566.061506] DVB: registering new adapter (ASUS My Cinema U3000 Mini 
DVBT Tuner)
[58566.105071] dib0700: stk7700P2_frontend_attach: 
dib7000p_i2c_enumeration failed.  Cannot continue
[58566.105071]
[58566.105078] dvb-usb: no frontend was attached by 'ASUS My Cinema 
U3000 Mini DVBT Tuner'
[58566.167327] Registered IR keymap rc-dib0700-rc5
[58566.167539] input: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/rc/rc0/input18
[58566.167625] rc0: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/rc/rc0
[58566.167889] dvb-usb: schedule remote query interval to 50 msecs.
[58566.167894] dvb-usb: ASUS My Cinema U3000 Mini DVBT Tuner 
successfully initialized and connected.
[58566.168136] usbcore: registered new interface driver dvb_usb_dib0700
[58612.073124] usb 1-1.1: USB disconnect, device number 8
[58612.112148] dvb-usb: ASUS My Cinema U3000 Mini DVBT Tuner 
successfully deinitialized and disconnected.
[58621.960328] usb 1-1.1: new high-speed USB device number 9 using ehci_hcd
[58622.044735] usb 1-1.1: New USB device found, idVendor=0b05, 
idProduct=171f
[58622.044741] usb 1-1.1: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[58622.044745] usb 1-1.1: Product: STK7700
[58622.044748] usb 1-1.1: Manufacturer: DIBCOM
[58622.044751] usb 1-1.1: SerialNumber: 6803800468
[58622.045479] dvb-usb: found a 'ASUS My Cinema U3000 Mini DVBT Tuner' 
in cold state, will try to load a firmware
[58622.049845] dvb-usb: downloading firmware from file 
'dvb-usb-dib0700-1.20.fw'
[58622.251193] dib0700: firmware started successfully.
[58622.751730] dvb-usb: found a 'ASUS My Cinema U3000 Mini DVBT Tuner' 
in warm state.
[58622.751790] dvb-usb: will pass the complete MPEG2 transport stream to 
the software demuxer.
[58622.751958] DVB: registering new adapter (ASUS My Cinema U3000 Mini 
DVBT Tuner)
[58622.795727] dib0700: stk7700P2_frontend_attach: 
dib7000p_i2c_enumeration failed.  Cannot continue
[58622.795727]
[58622.795733] dvb-usb: no frontend was attached by 'ASUS My Cinema 
U3000 Mini DVBT Tuner'
[58622.795742] Registered IR keymap rc-dib0700-rc5
[58622.795922] input: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/rc/rc1/input19
[58622.796059] rc1: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/rc/rc1
[58622.796364] dvb-usb: schedule remote query interval to 50 msecs.
[58622.796369] dvb-usb: ASUS My Cinema U3000 Mini DVBT Tuner 
successfully initialized and connected.

It seems that i have no frontend? Am i right? Do you have some advice 
for me?

regards Markus
