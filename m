Return-path: <linux-media-owner@vger.kernel.org>
Received: from dougal.woof94.com ([125.63.57.136]:41874 "EHLO
	dougal.woof94.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaJFBmh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Oct 2014 21:42:37 -0400
Message-ID: <5431F382.3060101@cloud.net.au>
Date: Mon, 06 Oct 2014 12:42:26 +1100
From: Hamish Moffatt <hamish@cloud.net.au>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: leadtek dvb-t dongle dual not working if plugged in during boot via
 hub
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've found that the Leadtek dvb-t dongle dual (USB 0413:6a05) is not 
initialised properly for me if it's plugged in at boot time through a 
USB 2.0 hub. Plugging it in later is fine, and plugging it directly into 
the PC is fine.

[12:33PM] hamish@bandicoot:~ $ dmesg | grep 1-5\\.3
[    2.073403] usb 1-5.3: new high-speed USB device number 6 using xhci_hcd
[    2.165269] usb 1-5.3: New USB device found, idVendor=0413, 
idProduct=6a05
[    2.165274] usb 1-5.3: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[    2.165277] usb 1-5.3: Product: WinFast DTV Dongle Dual
[    2.165279] usb 1-5.3: Manufacturer: Leadtek
[    2.646295] usb 1-5.3: dvb_usb_af9035: prechip_version=83 
chip_version=02 chip_type=9135
[    2.647928] usb 1-5.3: dvb_usb_v2: found a 'Leadtek WinFast DTV 
Dongle Dual' in cold state
[    2.651821] usb 1-5.3: dvb_usb_v2: downloading firmware from file 
'dvb-usb-it9135-02.fw'
[    4.700733] usb 1-5.3: dvb_usb_v2: 2nd usb_bulk_msg() failed=-110
[    4.700755] dvb_usb_af9035: probe of 1-5.3:1.0 failed with error -110

But directly to the PC;

[    2.217824] usb 1-5: dvb_usb_af9035: prechip_version=83 
chip_version=02 chip_type=9135
[    2.218681] usb 1-5: dvb_usb_v2: found a 'Leadtek WinFast DTV Dongle 
Dual' in cold state
[    2.227318] usb 1-5: dvb_usb_v2: downloading firmware from file 
'dvb-usb-it9135-02.fw'
[    4.208169] usb 1-5: dvb_usb_af9035: firmware version=3.40.1.0
[    4.208180] usb 1-5: dvb_usb_v2: found a 'Leadtek WinFast DTV Dongle 
Dual' in warm state
[    4.209733] usb 1-5: dvb_usb_af9035: [0] overriding tuner from 38 to 60
[    4.210926] usb 1-5: dvb_usb_af9035: [1] overriding tuner from 38 to 60
[    4.212191] usb 1-5: dvb_usb_v2: will pass the complete MPEG2 
transport stream to the software demuxer
[    4.244285] usb 1-5: dvb_usb_v2: will pass the complete MPEG2 
transport stream to the software demuxer
[    4.289986] usb 1-5: dvb_usb_v2: schedule remote query interval to 
500 msecs
[    4.289990] usb 1-5: dvb_usb_v2: 'Leadtek WinFast DTV Dongle Dual' 
successfully initialized and connected
[    4.290019] usbcore: registered new interface driver dvb_usb_af9035

Easy to work around, but perhaps there's a bug. Or it's a timing issue.

Hamish
