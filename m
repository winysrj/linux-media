Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:51923 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670Ab3AWKRG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 05:17:06 -0500
Received: by mail-ie0-f174.google.com with SMTP id k11so7539707iea.33
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2013 02:17:05 -0800 (PST)
MIME-Version: 1.0
From: didli <mediaklan@gmail.com>
Date: Wed, 23 Jan 2013 11:16:45 +0100
Message-ID: <CAJscJ6mjUgFt4Tvo9Pa+FqhNs0=N31xFL0yJFDg_2J_sWTBwng@mail.gmail.com>
Subject: [linux-media] Strange behavior between Terratec Cinergy HD RTL2838 &
 Alfa AWUS036h RTL2870
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi to u all !
I'm using Xubuntu 12.10, v4l latest media_build, with Alfa Network
AWUS036H (rtl2870) and a Terratec Cinergy HD (rtl2832).
These two cards works flawlessly, but not together : I need to
manually power off the Alfa Network card in order to get TV image with
the Terratec Cinergy HD.
If I use kaffeine or me-tv with AWUS036H power on, display is crappy
and scan with Terratec is almost impossible.
If I power off the AWUS036h usb card, everything with the Cinergy card
works as expected.
lsusb :
[code]
Bus 001 Device 002: ID 0ccd:00d3 TerraTec Electronic GmbH
Device Descriptor:
  bLength 18
  bDescriptorType 1
  bcdUSB 2.00
  bDeviceClass 0 (Defined at Interface level)
  bDeviceSubClass 0
  bDeviceProtocol 0
  bMaxPacketSize0 64
  idVendor 0x0ccd TerraTec Electronic GmbH
  idProduct 0x00d3
  bcdDevice 1.00
  iManufacturer 1
  iProduct 2
  iSerial 3
  bNumConfigurations 1
  Configuration Descriptor:
    bLength 9
    bDescriptorType 2
    wTotalLength 34
    bNumInterfaces 2
    bConfigurationValue 1
    iConfiguration 4
    bmAttributes 0x80
      (Bus Powered)
    MaxPower 500mA
    Interface Descriptor:
      bLength 9
      bDescriptorType 4
      bInterfaceNumber 0
      bAlternateSetting 0
      bNumEndpoints 1
      bInterfaceClass 255 Vendor Specific Class
      bInterfaceSubClass 255 Vendor Specific Subclass
      bInterfaceProtocol 255 Vendor Specific Protocol
      iInterface 5
      Endpoint Descriptor:
        bLength 7
        bDescriptorType 5
        bEndpointAddress 0x81 EP 1 IN
        bmAttributes 2
          Transfer Type Bulk
          Synch Type None
          Usage Type Data
        wMaxPacketSize 0x0200 1x 512 bytes
        bInterval 0
    Interface Descriptor:
      bLength 9
      bDescriptorType 4
      bInterfaceNumber 1
      bAlternateSetting 0
      bNumEndpoints 0
      bInterfaceClass 255 Vendor Specific Class
      bInterfaceSubClass 255 Vendor Specific Subclass
      bInterfaceProtocol 255 Vendor Specific Protocol
      iInterface 5


Bus 001 Device 004: ID 0bda:8187 Realtek Semiconductor Corp. RTL8187
Wireless Adapter
Device Descriptor:
  bLength 18
  bDescriptorType 1
  bcdUSB 2.00
  bDeviceClass 0 (Defined at Interface level)
  bDeviceSubClass 0
  bDeviceProtocol 0
  bMaxPacketSize0 64
  idVendor 0x0bda Realtek Semiconductor Corp.
  idProduct 0x8187 RTL8187 Wireless Adapter
  bcdDevice 1.00
  iManufacturer 1
  iProduct 2
  iSerial 3
  bNumConfigurations 1
  Configuration Descriptor:
    bLength 9
    bDescriptorType 2
    wTotalLength 39
    bNumInterfaces 1
    bConfigurationValue 1
    iConfiguration 4
    bmAttributes 0x80
      (Bus Powered)
    MaxPower 500mA
    Interface Descriptor:
      bLength 9
      bDescriptorType 4
      bInterfaceNumber 0
      bAlternateSetting 0
      bNumEndpoints 3
      bInterfaceClass 0 (Defined at Interface level)
      bInterfaceSubClass 0
      bInterfaceProtocol 0
      iInterface 5
      Endpoint Descriptor:
        bLength 7
        bDescriptorType 5
        bEndpointAddress 0x81 EP 1 IN
        bmAttributes 2
          Transfer Type Bulk
          Synch Type None
          Usage Type Data
        wMaxPacketSize 0x0200 1x 512 bytes
        bInterval 0
      Endpoint Descriptor:
        bLength 7
        bDescriptorType 5
        bEndpointAddress 0x02 EP 2 OUT
        bmAttributes 2
          Transfer Type Bulk
          Synch Type None
          Usage Type Data
        wMaxPacketSize 0x0200 1x 512 bytes
        bInterval 0
      Endpoint Descriptor:
        bLength 7
        bDescriptorType 5
        bEndpointAddress 0x03 EP 3 OUT
        bmAttributes 2
          Transfer Type Bulk
          Synch Type None
          Usage Type Data
        wMaxPacketSize 0x0200 1x 512 bytes
        bInterval 0[/code]

dmesg :
[code]
[45981.215807] i2c i2c-2: rtl2832: i2c rd failed=-110 reg=51 len=1
[45982.539669] i2c i2c-2: rtl2832: i2c rd failed=-110 reg=51 len=1
[45983.539751] i2c i2c-2: rtl2832: i2c rd failed=-110 reg=51 len=1
[45985.264752] usb_urb_complete: 269 callbacks suppressed
[45988.455662] i2c i2c-2: rtl2832: i2c rd failed=-110 reg=51 len=1
[45989.011363] i2c i2c-2: rtl2832: i2c wr failed=-32 reg=01 len=1
[45989.013075] i2c i2c-2: e4000: i2c wr failed=-32 reg=1a len=1
[45989.020746] i2c i2c-2: rtl2832: i2c wr failed=-32 reg=1c len=1
[45990.267531] usb_urb_complete: 730 callbacks suppressed
[45995.369950] usb_urb_complete: 988 callbacks suppressed
[46000.379616] usb_urb_complete: 2908 callbacks suppressed
[46005.383791] usb_urb_complete: 3790 callbacks suppressed
[46010.387969] usb_urb_complete: 3152 callbacks suppressed
[46015.392149] usb_urb_complete: 3790 callbacks suppressed
[46020.396057] usb_urb_complete: 3790 callbacks suppressed
[46025.400225] usb_urb_complete: 3790 callbacks suppressed
[46030.404399] usb_urb_complete: 3790 callbacks suppressed
[46035.408324] usb_urb_complete: 3790 callbacks suppressed
[46040.411231] usb_urb_complete: 3789 callbacks suppressed
[46045.415154] usb_urb_complete: 3790 callbacks suppressed
[46050.419447] usb_urb_complete: 3790 callbacks suppressed
[46055.423361] usb_urb_complete: 3790 callbacks suppressed
[46060.427535] usb_urb_complete: 3790 callbacks suppressed
[46065.431447] usb_urb_complete: 3790 callbacks suppressed
[46070.435627] usb_urb_complete: 3790 callbacks suppressed
[46075.439661] usb_urb_complete: 3790 callbacks suppressed
[46080.443713] usb_urb_complete: 3790 callbacks suppressed
[46085.447875] usb_urb_complete: 3790 callbacks suppressed
[46090.452049] usb_urb_complete: 3790 callbacks suppressed
[46095.454710] usb_urb_complete: 3789 callbacks suppressed
[46100.458881] usb_urb_complete: 3790 callbacks suppressed


[133177.263354] usb 1-1: new high-speed USB device number 11 using ehci_hcd
[133177.407784] usb 1-1: New USB device found, idVendor=0ccd, idProduct=00d3
[133177.407791] usb 1-1: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[133177.407794] usb 1-1: Product: RTL2838UHIDIR
[133177.407796] usb 1-1: Manufacturer: Realtek
[133177.407799] usb 1-1: SerialNumber: 00000001
[133177.413632] usb 1-1: dvb_usb_v2: found a 'TerraTec Cinergy T Stick
RC (Rev. 3)' in warm state
[133177.480380] usb 1-1: dvb_usb_v2: will pass the complete MPEG2
transport stream to the software demuxer
[133177.480409] DVB: registering new adapter (TerraTec Cinergy T Stick
RC (Rev. 3))
[133177.483575] usb 1-1: DVB: registering adapter 0 frontend 0
(Realtek RTL2832 (DVB-T))...
[133177.493415] i2c i2c-2: e4000: Elonics E4000 successfully identified
[133177.505594] Registered IR keymap rc-empty
[133177.505719] input: TerraTec Cinergy T Stick RC (Rev. 3) as
/devices/pci0000:00/0000:00:13.5/usb1/1-1/rc/rc1/input7
[133177.505866] rc1: TerraTec Cinergy T Stick RC (Rev. 3) as
/devices/pci0000:00/0000:00:13.5/usb1/1-1/rc/rc1
[133177.505873] usb 1-1: dvb_usb_v2: schedule remote query interval to 400 msecs
[133177.518320] usb 1-1: dvb_usb_v2: 'TerraTec Cinergy T Stick RC
(Rev. 3)' successfully initialized and connected
[/code]
Any idea to fix this behavior please ?
Thanks to u all !

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Didier LIMA | Mediaklan
Webdesign - Création Graphique - Identité Visuelle
Mobile : 06 516 04 992 - Tél. : 09 53 45 00 90
Mél. : mediaklan@gmail.com
