Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:35067 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab0CFHxQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Mar 2010 02:53:16 -0500
Received: by fxm19 with SMTP id 19so4874177fxm.21
        for <linux-media@vger.kernel.org>; Fri, 05 Mar 2010 23:53:15 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 6 Mar 2010 08:53:14 +0100
Message-ID: <6934ea941003052353n4258600cs78dba8487d203564@mail.gmail.com>
Subject: Help with RTL2832U DVB-T dongle (LeadTek WinFast DTV Dongle Mini)
From: Jan Slaninka <jan@slaninka.eu>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'd like to ask for a support with getting LeadTek WindFast DTV Dongle
mini running on Linux. So far I was able to fetch latest v4l-dvb from
HG, and successfully compiled module dvb_usb_rtl2832u found in
090730_RTL2832U_LINUX_Ver1.1.rar  but with no luck.
The box says the dongle's TV Tuner is Infineon 396 and Demodulator is
RTL2832U. Is there any chance with this one? Any hints appreciated.

Thanks,
Jan

lsmod:
Module                  Size  Used by
dvb_usb_rtl2832u       94445  0
dvb_usb                18655  1 dvb_usb_rtl2832u

dmesg output:
[ 9283.804050] usb 2-1: new high speed USB device using ehci_hcd and address 9
[ 9283.930504] usb 2-1: New USB device found, idVendor=0413, idProduct=6a03
[ 9283.930507] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 9283.930510] usb 2-1: Product: usbtv
[ 9283.930512] usb 2-1: Manufacturer: realtek
[ 9283.930610] usb 2-1: configuration #1 chosen from 1 choice

lsusb:
Bus 002 Device 009: ID 0413:6a03 Leadtek Research, Inc.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x0413 Leadtek Research, Inc.
  idProduct          0x6a03
  bcdDevice            1.00
  iManufacturer           1 realtek
  iProduct                2 usbtv
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          4 USB2.0-Bulk&Iso
    bmAttributes         0x80
      (Bus Powered)
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
