Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f41.google.com ([209.85.212.41]:47187 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab3AOSfw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jan 2013 13:35:52 -0500
Received: by mail-vb0-f41.google.com with SMTP id l22so452559vbn.14
        for <linux-media@vger.kernel.org>; Tue, 15 Jan 2013 10:35:51 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 15 Jan 2013 19:35:51 +0100
Message-ID: <CAOJkWC_jDkc2xwM9+8oZOJgeQXfpSdTRycGjKbmeGhj3vb4snA@mail.gmail.com>
Subject: DVB-T USB Device elgato EyeTV Micro
From: Michael Gustav Simon <mgsimon@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

try to get DVB-T USB Device EyeTV Micro
(http://www.elgato.com/elgato/int/mainmenu/products/tuner/EyeTV-Micro.en.html)
from elgato for Android, Mac OS X and Windows with current media_build
without any success running.

$ uname -r
3.5.0-21-generic

$ dmesg
[44358.948126] usb 1-1: new high-speed USB device number 12 using ehci_hcd
[44359.081099] usb 1-1: New USB device found, idVendor=0fd9, idProduct=004c
[44359.081106] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[44359.081109] usb 1-1: Product: EyeTV Micro
[44359.081113] usb 1-1: Manufacturer: Elgato

$ lsusb
Bus 001 Device 012: ID 0fd9:004c Elgato Systems GmbH

$ lsusb -v -d 0fd9:004c
Bus 001 Device 012: ID 0fd9:004c Elgato Systems GmbH
Couldn't open device, some information will be missing
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x0fd9 Elgato Systems GmbH
  idProduct          0x004c
  bcdDevice            0.01
  iManufacturer           1
  iProduct                2
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1

Android application "EyeTV Micro" device info:

Firmware: SMS-DVB-d 07.02.02 RIO (maybe siano?)
Tunertyp: DVB-T
USB path: /dev/bus/usb/001/003

investigation Android application "EyeTV-Micro  1.1.0.apk"

Firmware files in assets/sms:
sms1140_dvbt.inp
sms1140_isdbt.inp
sms1150_atsc.inp
sms1180_cmmb.inp
sms2230_dvbt.inp (maybe mdtv?)
sms2230_isdbt.inp

"ELF 32-bit LSB shared object, ARM, version 1 (SYSV), dynamically
linked, stripped" files in lib/armeabi-v7a:
libaacarm_elgato.so
libaacarm_noneon_elgato.so
libcrypto_elgato.so
libiconv_elgato.so
libportable_elgato.so
libssl_elgato.so

Windows driver http://www.elgato.com/elgato/int/mainmenu/support/Update-Start/Driver-EyeTV-Micro.en.html

What are the next steps to implement this device?

Regards,
mg
