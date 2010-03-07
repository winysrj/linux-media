Return-path: <linux-media-owner@vger.kernel.org>
Received: from psmtp30.wxs.nl ([195.121.247.32]:54027 "EHLO psmtp30.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab0CGHT3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Mar 2010 02:19:29 -0500
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp30.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0KYW001PSHOF0G@psmtp30.wxs.nl> for linux-media@vger.kernel.org;
 Sun, 07 Mar 2010 08:19:28 +0100 (MET)
Date: Sun, 07 Mar 2010 08:19:27 +0100
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Re: Help with RTL2832U DVB-T dongle (LeadTek WinFast DTV Dongle Mini)
In-reply-to: <6934ea941003052353n4258600cs78dba8487d203564@mail.gmail.com>
To: Jan Slaninka <jan@slaninka.eu>
Cc: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Message-id: <4B93537F.30407@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <6934ea941003052353n4258600cs78dba8487d203564@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti has been working on drivers for the RTL283x.

http://linuxtv.org/hg/~anttip/rtl2831u
or
http://linuxtv.org/hg/~anttip/qt1010/

If you have more information on the RTL2832, I'd be happy to add it at:
http://www.linuxtv.org/wiki/index.php/Rtl2831_devices


Jan Slaninka wrote:
> Hi,
> 
> I'd like to ask for a support with getting LeadTek WindFast DTV Dongle
> mini running on Linux. So far I was able to fetch latest v4l-dvb from
> HG, and successfully compiled module dvb_usb_rtl2832u found in
> 090730_RTL2832U_LINUX_Ver1.1.rar  but with no luck.
> The box says the dongle's TV Tuner is Infineon 396 and Demodulator is
> RTL2832U. Is there any chance with this one? Any hints appreciated.
> 
> Thanks,
> Jan
> 
> lsmod:
> Module                  Size  Used by
> dvb_usb_rtl2832u       94445  0
> dvb_usb                18655  1 dvb_usb_rtl2832u
> 
> dmesg output:
> [ 9283.804050] usb 2-1: new high speed USB device using ehci_hcd and address 9
> [ 9283.930504] usb 2-1: New USB device found, idVendor=0413, idProduct=6a03
> [ 9283.930507] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [ 9283.930510] usb 2-1: Product: usbtv
> [ 9283.930512] usb 2-1: Manufacturer: realtek
> [ 9283.930610] usb 2-1: configuration #1 chosen from 1 choice
> 
> lsusb:
> Bus 002 Device 009: ID 0413:6a03 Leadtek Research, Inc.
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   idVendor           0x0413 Leadtek Research, Inc.
>   idProduct          0x6a03
>   bcdDevice            1.00
>   iManufacturer           1 realtek
>   iProduct                2 usbtv
>   iSerial                 0
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           25
>     bNumInterfaces          1
>     bConfigurationValue     1
>     iConfiguration          4 USB2.0-Bulk&Iso
>     bmAttributes         0x80
>       (Bus Powered)
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
