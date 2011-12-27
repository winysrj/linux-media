Return-path: <linux-media-owner@vger.kernel.org>
Received: from r02s01.colo.vollmar.net ([83.151.24.194]:42853 "EHLO
	holzeisen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245Ab1L0QyS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Dec 2011 11:54:18 -0500
Received: from [10.7.0.6] (unknown [10.7.0.6])
	by holzeisen.de (Postfix) with ESMTPA id 71067807C316
	for <linux-media@vger.kernel.org>; Tue, 27 Dec 2011 17:44:41 +0100 (CET)
Message-ID: <4EF9F5E9.9020908@holzeisen.de>
Date: Tue, 27 Dec 2011 17:44:25 +0100
From: Thomas Holzeisen <thomas@holzeisen.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: af9015: Second Tuner hangs after a while
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello there,

I got a MSI DigiVox Duo stick identifying as:

Bus 001 Device 005: ID 1462:8801 Micro Star International
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x1462 Micro Star International
  idProduct          0x8801
  bcdDevice            2.00
  iManufacturer           1 Afatech
  iProduct                2 DVB-T 2
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           46
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
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
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
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
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

Until some time ago, there was not even a remote chance getting this Dual-Tuner Stick to work. When trying to tune in a
second transponder, the log got spammed with these:

[  835.412375] af9015: command failed:1
[  835.412383] mxl5005s I2C write failed

However, I applied the patches ba730b56cc9afbcb10f329c17320c9e535c43526 and 61875c55170f2cf275263b4ba77e6cc787596d9f
from Antti Palosaari. For the first time I got able to receive two Transponders at once. Sadly after a while the second
adapter stops working, showing the I2C erros above. The first adapter keeps working. Also attaching and removing the
stick does not work out very well.

First plugin attempt:
[   78.552597] dvb-usb: found a 'MSI DIGIVOX Duo' in cold state, will try to load a firmware
[   78.592456] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
[   78.662114] dvb-usb: found a 'MSI DIGIVOX Duo' in warm state.
[   78.662251] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[   78.663514] DVB: registering new adapter (MSI DIGIVOX Duo)
[   78.709768] af9013: firmware version 0.0.0.0
[   78.711858] DVB: registering adapter 0 frontend 0 (Afatech AF9013)...
[   78.745265] MXL5005S: Attached at address 0xc6
[   78.745278] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[   78.746513] DVB: registering new adapter (MSI DIGIVOX Duo)
[   79.361106] af9015: firmware did not run
[   79.361117] af9015: firmware copy to 2nd frontend failed, will disable it
[   79.361127] dvb-usb: no frontend was attached by 'MSI DIGIVOX Duo'
[   79.361136] dvb-usb: MSI DIGIVOX Duo successfully initialized and connected.
[   79.368407] usbcore: registered new interface driver dvb_usb_af9015

removing and inserting again
[  160.290935] dvb-usb: MSI DIGIVOX Duo successfully deinitialized and disconnected.
[  197.576325] af9015: recv bulk message failed:-110
[  197.576338] af9015: eeprom read failed=-1
[  197.576363] dvb_usb_af9015: probe of 1-1:1.0 failed with error -1

third one
[  222.198442] dvb-usb: found a 'MSI DIGIVOX Duo' in cold state, will try to load a firmware
[  222.205585] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
[  222.274229] dvb-usb: found a 'MSI DIGIVOX Duo' in warm state.
[  222.274371] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[  222.275468] DVB: registering new adapter (MSI DIGIVOX Duo)
[  222.277066] af9013: firmware version 4.95.0.0
[  222.280128] DVB: registering adapter 0 frontend 0 (Afatech AF9013)...
[  222.280480] MXL5005S: Attached at address 0xc6
[  222.280490] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[  222.280978] DVB: registering new adapter (MSI DIGIVOX Duo)
[  222.997193] af9013: found a 'Afatech AF9013' in warm state.
[  223.000695] af9013: firmware version 4.95.0.0
[  223.006960] DVB: registering adapter 1 frontend 0 (Afatech AF9013)...
[  223.007258] MXL5005S: Attached at address 0xc6
[  223.007269] dvb-usb: MSI DIGIVOX Duo successfully initialized and connected.

this is repeatable to me every time. Removing the stick when in warm state, leads to kernel oops every time. Kernel
Version is 3.1.2.
