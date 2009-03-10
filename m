Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:29486 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbZCJFnx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 01:43:53 -0400
Received: by rv-out-0506.google.com with SMTP id g37so2039857rvb.1
        for <linux-media@vger.kernel.org>; Mon, 09 Mar 2009 22:43:51 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 10 Mar 2009 14:43:51 +0900
Message-ID: <66cf70750903092243v7c1ba7c0of95d0bdc836116be@mail.gmail.com>
Subject: Compro VideoMate U90
From: scott <scottlegs@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I recently bought a Compro VideoMate U90, described on the box as a
"USB 2.0 DVB-T Stick with Remote".

When plugging it in, /var/log/messages simply says:

Mar 10 12:50:49 sonata kernel: [60359.936022] usb 4-5: new high speed
USB device using ehci_hcd and address 3
Mar 10 12:50:49 sonata kernel: [60360.070474] usb 4-5: configuration
#1 chosen from 1 choice

On my system (Kubuntu 8.10), it registers as a "VideoMate U150", which
appears to be a similar (same?) device available in Taiwan. Does
anyone have any more information about this device, or advice on how
to get it working?

Regards,
Scott.

Some more info below:
U90 page: http://www.comprousa.com/en/product/u90/u90.html
U150 page (english translation):
http://translate.google.com/translate?prev=hp&hl=en&u=http%3A%2F%2Fwww.comprousa.com%2Ftw%2Fproduct%2Fu150%2Fu150.html&sl=auto&tl=en

$ uname -srvmo
Linux 2.6.27-13-generic #1 SMP Thu Feb 26 07:31:49 UTC 2009 x86_64 GNU/Linux

$ sudo lsusb -v
 Bus 004 Device 003: ID 185b:0150 Compro
 Device Descriptor:
 bLength                18
 bDescriptorType         1
 bcdUSB               2.00
 bDeviceClass            0 (Defined at Interface level)
 bDeviceSubClass         0
 bDeviceProtocol         0
 bMaxPacketSize0        64
 idVendor           0x185b Compro
 idProduct          0x0150
 bcdDevice            1.00
 iManufacturer           1 COMPRO
 iProduct                2 VideoMate U150
 iSerial                 3 00000172
 bNumConfigurations      1
 Configuration Descriptor:
 bLength                 9
 bDescriptorType         2
 wTotalLength           41
 bNumInterfaces          1
 bConfigurationValue     1
 iConfiguration          4 USB2.0-Bulk&Iso
 bmAttributes         0xa0
 (Bus Powered)
 Remote Wakeup
 MaxPower              500mA
 Interface Descriptor:
 bLength                 9
 bDescriptorType         4
 bInterfaceNumber        0
 bAlternateSetting       0
 bNumEndpoints           1
 bInterfaceClass       255 Vendor Specific Class
 bInterfaceSubClass    255 Vendor Specific Subclass
 bInterfaceProtocol    255 Vendor Specific Protocol
 iInterface              5 Bulk-In, Interface
 Endpoint Descriptor:
 bLength                 7
 bDescriptorType         5
 bEndpointAddress     0x81  EP 1 IN
 bmAttributes            2
 Transfer Type            Bulk
 Synch Type               None
 Usage Type               Data
 wMaxPacketSize     0x0200  1x 512 bytes
 bInterval               0
 Interface Descriptor:
 bLength                 9
 bDescriptorType         4
 bInterfaceNumber        0
 bAlternateSetting       1
 bNumEndpoints           1
 bInterfaceClass       255 Vendor Specific Class
 bInterfaceSubClass    255 Vendor Specific Subclass
 bInterfaceProtocol    255 Vendor Specific Protocol
 iInterface              6 Iso-In, Interface
 Endpoint Descriptor:
 bLength                 7
 bDescriptorType         5
 bEndpointAddress     0x81  EP 1 IN
 bmAttributes            1
 Transfer Type            Isochronous
 Synch Type               None
 Usage Type               Data
 wMaxPacketSize     0x03ac  1x 940 bytes
 bInterval               1
 Device Qualifier (for other device speed):
 bLength                10
 bDescriptorType         6
 bcdUSB               2.00
 bDeviceClass            0 (Defined at Interface level)
 bDeviceSubClass         0
 bDeviceProtocol         0
 bMaxPacketSize0        64
 bNumConfigurations      2
 Device Status:     0x0000
 (Bus Powered)
