Return-path: <mchehab@pedra>
Received: from r02s01.colo.vollmar.net ([83.151.24.194]:32924 "EHLO
	holzeisen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab1FRMok (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2011 08:44:40 -0400
Message-ID: <4DFC9DB5.104@holzeisen.de>
Date: Sat, 18 Jun 2011 14:44:37 +0200
From: Thomas Holzeisen <thomas@holzeisen.de>
MIME-Version: 1.0
To: =?UTF-8?B?U2FzY2hhIFfDvHN0ZW1hbm4=?= <sascha@killerhippy.de>
CC: linux-media@vger.kernel.org,
	Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Re: RTL2831U wont compile against 2.6.38
References: <4DF9BCAA.3030301@holzeisen.de> <4DF9EA62.2040008@killerhippy.de> <4DFB2EE4.2030400@holzeisen.de> <4DFBAAE7.9070204@killerhippy.de>
In-Reply-To: <4DFBAAE7.9070204@killerhippy.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I already resolved the symbol thing. Your lsusb explains a lot, you have a RTl2832, while I have
the RTL2831 which seem to be Revision 4 of the RTL2830.

However, there seem to be big similarities between all those chips. It might be not that hard for
the contributors of this driver to add support for the early chips as well. Maybe Jan can shade
some light on it, since he wrote the initial RTL2831 driver. In any case I may help with testing it.


Sascha Wüstemann wrote:
> Thomas Holzeisen wrote:
>> Unknown symbol 
> means, there is unresolved dependencies at your kernel or false
> dependencies in the module.
> 
> My stick works with those google hosted new driver sources and I have no
> use for lirc, so nothing about it at the following lines, they are
> stripped, too:
> 
> ~ # lsusb -v
> Bus 001 Device 021: ID 1d19:1101 Dexatek Technology Ltd. DK DVB-T Dongle
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   idVendor           0x1d19 Dexatek Technology Ltd.
>   idProduct          0x1101 DK DVB-T Dongle
>   bcdDevice            1.00
>   iManufacturer           1 Realtek
>   iProduct                2 Rtl2832UDVB
>   iSerial                 3 0
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           34
>     bNumInterfaces          2
>     bConfigurationValue     1
>     iConfiguration          4 USB2.0-Bulk&Iso
>     bmAttributes         0xa0
>       (Bus Powered)
>       Remote Wakeup
>     MaxPower              500mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass    255 Vendor Specific Subclass
>       bInterfaceProtocol    255 Vendor Specific Protocol
>       iInterface              5 Bulk-In, Interface
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       0
>       bNumEndpoints           0
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass    255 Vendor Specific Subclass
>       bInterfaceProtocol    255 Vendor Specific Protocol
>       iInterface              5 Bulk-In, Interface
> Device Qualifier (for other device speed):
>   bLength                10
>   bDescriptorType         6
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   bNumConfigurations      2
> Device Status:     0x0000
>   (Bus Powered)
> 
> ~ # lsmod | grep dvb
> dvb_usb_rtl2832u      190302  0
> dvb_usb                17272  1 dvb_usb_rtl2832u
> dvb_core               69295  1 dvb_usb
> rc_core                15790  2 dvb_usb
> 
> ~ # dmesg
> usb 1-6: new high speed USB device number 20 using ehci_hcd
> hub 1-6:1.0: USB hub found
> hub 1-6:1.0: 4 ports detected
> usb 1-6.3: new high speed USB device number 21 using ehci_hcd
> dvb-usb: found a 'DK DVBT DONGLE' in warm state.
> dvb-usb: will pass the complete MPEG2 transport stream to the software
> demuxer.
> DVB: registering new adapter (DK DVBT DONGLE)
> DVB: registering adapter 0 frontend 0 (Realtek DVB-T RTL2832)...
> dvb-usb: DK DVBT DONGLE successfully initialized and connected.
> dvb-usb: found a 'DK DVBT DONGLE' in warm state.
> dvb-usb: will pass the complete MPEG2 transport stream to the software
> demuxer.
> DVB: registering new adapter (DK DVBT DONGLE)
> DVB: registering adapter 1 frontend 0 (Realtek DVB-T RTL2832)...
> dvb-usb: DK DVBT DONGLE successfully initialized and connected.
> 
> Yes, works at no powered four port USB-2.0 mini hub without problems.
> 
> ~ # uname -a
> Linux killerghost 2.6.39-gentoo-r1 #1 SMP Fri Jun 10 12:16:38 CEST 2011
> x86_64 Intel(R) Atom(TM) CPU 330 @ 1.60GHz GenuineIntel GNU/Linux
> 
> Greetings from Braunschweig, Germany.
> Sascha
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

