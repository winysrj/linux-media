Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48528 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab2GUPfj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jul 2012 11:35:39 -0400
Message-ID: <500ACC3F.7070007@iki.fi>
Date: Sat, 21 Jul 2012 18:35:27 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: poma <pomidorabelisima@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Firmware in da wonderland
References: <500ACB80.9080500@gmail.com>
In-Reply-To: <500ACB80.9080500@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/21/2012 06:32 PM, poma wrote:
>
> This one speak for itself;
> …
> usb 1-1: new high-speed USB device number 8 using ehci_hcd
> usb 1-1: New USB device found, idVendor=0ccd, idProduct=0097
> usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 1-1: Product: USB2.0 DVB-T TV Stick
> usb 1-1: Manufacturer: NEWMI
> usb 1-1: SerialNumber: 010101010600001
> dvb-usb: found a 'TerraTec Cinergy T Stick RC' in cold state, will try
> to load a firmware
> dvb-usb: did not find the firmware file. (dvb-usb-af9015.fw) Please see
> linux/Documentation/dvb/ for more details on firmware-problems. (-2)
> dvb_usb_af9015: probe of 1-1:1.0 failed with error -2
> input: NEWMI USB2.0 DVB-T TV Stick as
> /devices/pci0000:00/0000:00:04.1/usb1/1-1/1-1:1.1/input/input18
> generic-usb 0003:0CCD:0097.0007: input,hidraw6: USB HID v1.01 Keyboard
> [NEWMI USB2.0 DVB-T TV Stick] on usb-0000:00:04.1-1/input1
> …
> FW path:
> /usr/lib/firmware/dvb-usb-af9015.fw
> Is it somehow related to Fedora UsrMove!?
> Or Fedora itself :)

Bug 827538 - DVB USB device firmware requested in module_init()
https://bugzilla.redhat.com/show_bug.cgi?id=827538

Antti
-- 
http://palosaari.fi/


