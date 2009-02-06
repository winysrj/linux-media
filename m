Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:40977 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbZBFTDk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Feb 2009 14:03:40 -0500
Received: by fg-out-1718.google.com with SMTP id 16so591396fgg.17
        for <linux-media@vger.kernel.org>; Fri, 06 Feb 2009 11:03:38 -0800 (PST)
Message-ID: <498C8988.8030103@googlemail.com>
Date: Fri, 06 Feb 2009 20:03:36 +0100
From: Johannes Engel <jcnengel@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: dvb-usb-cinergyT2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

Switching to the new kernel 2.6.28 including the new driver for my Terratec Cinergy T² made the thing almost unusable.
Neither mplayer nor scan resp. w_scan is able to tune the card anymore, not even the led lights up anymore. Sometimes tzap manages to get out a proper signal, but not reliably.

The kernel logs says the following:

dvb-usb: TerraTec/qanu USB2.0 Highspeed DVB-T Receiver successfully
deinitialized and disconnected.
usbcore: deregistering interface driver cinergyT2
usb 5-1: new high speed USB device using ehci_hcd and address 13
usb 5-1: config 1 interface 0 altsetting 0 bulk endpoint 0x1 has invalid maxpacket 64
usb 5-1: config 1 interface 0 altsetting 0 bulk endpoint 0x81 has invalid maxpacket 64
usb 5-1: configuration #1 chosen from 1 choice
usb 5-1: New USB device found, idVendor=0ccd, idProduct=0038
usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-1: Product: Cinergy T�
usb 5-1: Manufacturer: TerraTec GmbH
dvb-usb: found a 'TerraTec/qanu USB2.0 Highspeed DVB-T Receiver' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (TerraTec/qanu USB2.0 Highspeed DVB-T Receiver)
DVB: registering adapter 0 frontend 0 (TerraTec/qanu USB2.0 Highspeed DVB-T Receiver)...
input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1d.7/usb5/5-1/input/input17
dvb-usb: schedule remote query interval to 50 msecs.
dvb-usb: TerraTec/qanu USB2.0 Highspeed DVB-T Receiver successfully initialized and connected.
usbcore: registered new interface driver cinergyT2

Do you need any further information? Please CC me, since I am not subscribed to the list.

Cheers, Johannes

