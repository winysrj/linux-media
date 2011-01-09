Return-path: <mchehab@pedra>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:36179 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab1AIRkp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Jan 2011 12:40:45 -0500
Received: by wwi17 with SMTP id 17so949192wwi.1
        for <linux-media@vger.kernel.org>; Sun, 09 Jan 2011 09:40:43 -0800 (PST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Jarod Wilson <jarod@wilsonet.com>
Subject: MCEUSB: falsly claims mass storage device
Date: Sun, 9 Jan 2011 18:36:57 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101091836.58104.pboettcher@kernellabs.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Jarod,

I'm using an MultiCard-reader which exposes itself like shown below.

It is falsly claimed by the mceusb-driver from (2.6.36 from debian-
experimental) . 

Would be good to create an exception for this one if possible. Let me know if 
you need more information or if you want me to take other actions.

>From dmesg:

[22389.084024] Registered IR keymap rc-rc6-mce
[22389.084288] input: Media Center Ed. eHome Infrared Remote Transceiver 
(0bda:0161) as /devices/virtual/rc/rc0/input8
[22389.084484] rc0: Media Center Ed. eHome Infrared Remote Transceiver 
(0bda:0161) as /devices/virtual/rc/rc0
[22389.084877] rc rc0: lirc_dev: driver ir-lirc-codec (mceusb) registered at 
minor = 1
[22389.085515] mceusb 1-2:1.0: Registered Generic USB2.0-CRW on usb1:6
[22389.164964] Registered IR keymap rc-rc6-mce
[22389.165264] input: Media Center Ed. eHome Infrared Remote Transceiver 
(0bda:0161) as /devices/virtual/rc/rc1/input9
[22389.165402] rc1: Media Center Ed. eHome Infrared Remote Transceiver 
(0bda:0161) as /devices/virtual/rc/rc1
[22389.171179] rc rc1: lirc_dev: driver ir-lirc-codec (mceusb) registered at 
minor = 2
[22389.171995] mceusb 1-2:1.1: Registered Generic USB2.0-CRW on usb1:6

lsusb -v: 

Bus 001 Device 007: ID 0bda:0161 Realtek Semiconductor Corp. Mass Storage 
Device
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x0bda Realtek Semiconductor Corp.
  idProduct          0x0161 Mass Storage Device
  bcdDevice           61.10
  iManufacturer           1 
  iProduct                2 
  iSerial                 3 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          116
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          4 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass        11 Chip/SmartCard
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              6 
      ChipCard Interface Descriptor:
        bLength                54
        bDescriptorType        33
        bcdCCID              1.10  (Warning: Only accurate for version 1.0)
        nMaxSlotIndex           0
        bVoltageSupport         7  5.0V 3.0V 1.8V 
        dwProtocols             3  T=0 T=1
        dwDefaultClock       3750
        dwMaxiumumClock      7500
        bNumClockSupported      0
        dwDataRate          10080 bps
        dwMaxDataRate      312500 bps
        bNumDataRatesSupp.      0
        dwMaxIFSD             254
        dwSyncProtocols  00000000 
        dwMechanical     00000000 
        dwFeatures       00010030
          Auto clock change
          Auto baud rate change
          TPDU level exchange
        dwMaxCCIDMsgLen       271
        bClassGetResponse      00
        bClassEnvelope         00
        wlcdLayout           none
        bPINSupport             0 
        bMaxCCIDBusySlots       1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               8
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x05  EP 5 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk (Zip)
      iInterface              5 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0

best regards,
--
Patrick Boettcher - KernelLabs
http://www.kernellabs.com/
