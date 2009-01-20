Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.tut.by ([195.137.160.40]:59891 "EHLO speedy.tutby.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464AbZATUr3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 15:47:29 -0500
From: "Igor M. Liplianin" <liplianin@tut.by>
To: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] QQ box dvb-s usb dongle not supported ?
Date: Tue, 20 Jan 2009 22:47:16 +0200
References: <1232480273.23804.10.camel@hp>
In-Reply-To: <1232480273.23804.10.camel@hp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901202247.16446.liplianin@tut.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

В сообщении от 20 January 2009 21:37:53 ar написал(а):
> I am running ubuntu intrepid latest update on hp pavilion tx1000z with
> latest dvb kernel modules.
>
> I have bought the "QQ box" dvb-s usb dongle and it seems to be
> unsupported.
>
> HOW CAN I GET IT WORKING UNDER LINUX ?
> ------------------------------------------------------------------------
> Here is tech info:
>
> system:	Linux hp 2.6.27-9-generic #1 SMP Thu Nov 20 22:15:32 UTC 2008
> x86_64 GNU/Linux
>
> output of lsusb -v for the device:
>
> Bus 002 Device 027: ID 3344:1120
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   idVendor           0x3344
>   idProduct          0x1120
>   bcdDevice            0.00
>   iManufacturer           0
>   iProduct                0
>   iSerial                 3 ???
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           76
>     bNumInterfaces          1
>     bConfigurationValue     1
>     iConfiguration          0
>     bmAttributes         0xc0
>       Self Powered
>     MaxPower              500mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           0
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass      0
>       bInterfaceProtocol      0
>       iInterface              0
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       1
>       bNumEndpoints           7
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass      0
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x01  EP 1 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x02  EP 2 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x86  EP 6 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x87  EP 7 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x03fc  1x 1020 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x0a  EP 10 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x8a  EP 10 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               0
> Device Qualifier (for other device speed):
>   bLength                10
>   bDescriptorType         6
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   bNumConfigurations      1
> Device Status:     0x0000
>   (Bus Powered)
>
> dmesg output:
>
> [102008.676081] usb 2-8: new high speed USB device using ehci_hcd and
> address 28
> [102008.808944] usb 2-8: config 1 interface 0 altsetting 1 bulk endpoint
> 0x81 has invalid maxpacket 64
> [102008.808966] usb 2-8: config 1 interface 0 altsetting 1 bulk endpoint
> 0x1 has invalid maxpacket 64
> [102008.808974] usb 2-8: config 1 interface 0 altsetting 1 bulk endpoint
> 0x2 has invalid maxpacket 64
> [102008.808982] usb 2-8: config 1 interface 0 altsetting 1 bulk endpoint
> 0x8A has invalid maxpacket 64
> [102008.814644] usb 2-8: configuration #1 chosen from 1 choice

I believe, it contains LME2510 USB chip.
As I have a card with that chip too, I begin to write code (hard to say 'driver').
For now I can load firmware (of two parts) and determine 'cold' and 'warm' state.
Eventually, the card was rejected by vendor and I drop it.

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
