Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:42607 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbbBEUpE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Feb 2015 15:45:04 -0500
Received: by mail-ob0-f176.google.com with SMTP id wo20so9348665obc.7
        for <linux-media@vger.kernel.org>; Thu, 05 Feb 2015 12:45:03 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 5 Feb 2015 20:45:03 +0000
Message-ID: <CACha5riDu2q1wztAny5he+s0W26rkY2_YuTZLNox7O2m8N=9UA@mail.gmail.com>
Subject: ISDB Dongle MyGica S2870
From: Nicolas Antonio Corrarello <ncorrare@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey Everyone,
I just bought this new dongle, and while the parts seem to be
supported, the usb id is not recognised.
It seems to be based on the dibcom 0700 IC and it identifies itself as
STK8096-PVR.

I tried the patch in
http://www.spinics.net/lists/linux-media/msg63445.html on the latest
linux media tree, but while the dib0700 module now loads
automatically, I don't see anything on dmesg showing that its loading
the firmware, and I most definitely don't get a /dev/dvb directory.

[255053.847864] usb 1-3: new high-speed USB device number 4 using xhci_hcd
[255054.012368] usb 1-3: New USB device found, idVendor=10b8, idProduct=1faa
[255054.012373] usb 1-3: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[255054.012376] usb 1-3: Product: STK8096-PVR
[255054.012379] usb 1-3: Manufacturer: Geniatech
[255054.012381] usb 1-3: SerialNumber: 1
[255055.034149] rc_core: module verification failed: signature and/or
required key missing - tainting kernel
[255055.034764] WARNING: You are using an experimental version of the
media stack.
As the driver is backported to an older kernel, it doesn't offer
enough quality for its usage in production.
Use it with care.
Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
a5f43c18fceb2b96ec9fddb4348f5282a71cf2b0 [media]
Documentation/video4linux: remove obsolete text files
51d3d4eee565a707e4053fe447cd28b2d1f4ce79 [media] bw/c-qcam, w9966,
pms: remove deprecated staging drivers
8f32df451f843df2ba88f9597a34b8dc3533dee7 [media] vino/saa7191: remove
deprecated drivers
[255055.039058] WARNING: You are using an experimental version of the
media stack.
As the driver is backported to an older kernel, it doesn't offer
enough quality for its usage in production.
Use it with care.
Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
a5f43c18fceb2b96ec9fddb4348f5282a71cf2b0 [media]
Documentation/video4linux: remove obsolete text files
51d3d4eee565a707e4053fe447cd28b2d1f4ce79 [media] bw/c-qcam, w9966,
pms: remove deprecated staging drivers
8f32df451f843df2ba88f9597a34b8dc3533dee7 [media] vino/saa7191: remove
deprecated drivers
[255055.072159] usbcore: registered new interface driver dvb_usb_dib0700
[root@chromebox1 ~]# ls /dev/dvb
ls: cannot access /dev/dvb: No such file or directory


[root@chromebox1 ~]# lsusb -v -d 10b8:1faa

Bus 001 Device 004: ID 10b8:1faa DiBcom
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x10b8 DiBcom
  idProduct          0x1faa
  bcdDevice            1.00
  iManufacturer           1 Geniatech
  iProduct                2 STK8096-PVR
  iSerial                 3 1
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           46
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
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
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

Does everyone know if this device is actually supported now? If not,
is there any information I can provide to help with the development.

Regards,
