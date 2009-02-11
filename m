Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:53397 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755969AbZBKT7l (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Feb 2009 14:59:41 -0500
Message-ID: <49932E47.7050307@free.fr>
Date: Wed, 11 Feb 2009 21:00:07 +0100
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: Johannes Engel <jcnengel@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: dvb-usb-cinergyT2
References: <498C8988.8030103@googlemail.com>
In-Reply-To: <498C8988.8030103@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Johannes,

Johannes Engel wrote:
> Hello!
> 
> Switching to the new kernel 2.6.28 including the new driver for my Terratec Cinergy T² made the thing almost unusable.
> Neither mplayer nor scan resp. w_scan is able to tune the card anymore, not even the led lights up anymore. Sometimes tzap manages to get out a proper signal, but not reliably.
> 
> The kernel logs says the following:
> 
> dvb-usb: TerraTec/qanu USB2.0 Highspeed DVB-T Receiver successfully
> deinitialized and disconnected.
> usbcore: deregistering interface driver cinergyT2
> usb 5-1: new high speed USB device using ehci_hcd and address 13
> usb 5-1: config 1 interface 0 altsetting 0 bulk endpoint 0x1 has invalid maxpacket 64
> usb 5-1: config 1 interface 0 altsetting 0 bulk endpoint 0x81 has invalid maxpacket 64
> usb 5-1: configuration #1 chosen from 1 choice
> usb 5-1: New USB device found, idVendor=0ccd, idProduct=0038
> usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> usb 5-1: Product: Cinergy T�
> usb 5-1: Manufacturer: TerraTec GmbH
> dvb-usb: found a 'TerraTec/qanu USB2.0 Highspeed DVB-T Receiver' in warm state.
> dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
> DVB: registering new adapter (TerraTec/qanu USB2.0 Highspeed DVB-T Receiver)
> DVB: registering adapter 0 frontend 0 (TerraTec/qanu USB2.0 Highspeed DVB-T Receiver)...
> input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1d.7/usb5/5-1/input/input17
> dvb-usb: schedule remote query interval to 50 msecs.
> dvb-usb: TerraTec/qanu USB2.0 Highspeed DVB-T Receiver successfully initialized and connected.
> usbcore: registered new interface driver cinergyT2
> 
> Do you need any further information? Please CC me, since I am not subscribed to the list.
> 
another user has got the same problem, except that the led still lights up.
Can you tell us what it the firmware version in your device?
You can see it by doing lsusb -vvv, for the Cinergy T2 entry this is the "bcdDevice" line.
I have the 1.06 firmware version and it works.
Cheers,
Thierry
