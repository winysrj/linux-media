Return-path: <linux-media-owner@vger.kernel.org>
Received: from fold.natur.cuni.cz ([195.113.57.32]:55116 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760055Ab2CaPOH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Mar 2012 11:14:07 -0400
Message-ID: <4F771DAA.1000200@fold.natur.cuni.cz>
Date: Sat, 31 Mar 2012 17:07:22 +0200
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
MIME-Version: 1.0
To: linux-uvc-devel@lists.berlios.de, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Subject: linux-3.2.12: uvcvideo: ** UNRECOGNIZED:  24 ff 42 49 53 54 00 01
 05 02 10 00 00 00 00 00 01 06 b8 0b 02 07 b8 0b 03 08 b8 0b 04 09 4e 20 05
 0a b8 0b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
  when inspecting "lsusb -v" output I came across this UNRECOGNIZED message. Anything to worry about?

Bus 001 Device 003: ID 05ca:1820 Ricoh Co., Ltd
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x05ca Ricoh Co., Ltd
  idProduct          0x1820
  bcdDevice            c.27
  iManufacturer           1 CN01MWM9724871A4KB28A00
  iProduct                2 Laptop_Integrated_Webcam_FHD
[cut]
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting      13
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x1400  3x 1024 bytes
        bInterval               1
        ** UNRECOGNIZED:  24 ff 42 49 53 54 00 01 05 02 10 00 00 00 00 00 01 06 b8 0b 02 07 b8 0b 03 08 b8 0b 04 09 4e 20 05 0a b8 0b



It is about the uvcvideo driver I think. The camera works, at least in skype
so probably I should not bother you asking this question at all. ;-)


usb 1-1.5: new high-speed USB device number 3 using ehci_hcd
usb 1-1.5: skipped 1 descriptor after configuration
usb 1-1.5: skipped 6 descriptors after interface
usb 1-1.5: skipped 1 descriptor after endpoint
usb 1-1.5: skipped 19 descriptors after interface
usb 1-1.5: skipped 1 descriptor after endpoint
usb 1-1.5: default language 0x0409
usb 1-1.5: udev 3, busnum 1, minor = 2
usb 1-1.5: New USB device found, idVendor=05ca, idProduct=1820
usb 1-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1.5: Product: Laptop_Integrated_Webcam_FHD
usb 1-1.5: Manufacturer: CN01MWM9724871A4KB28A00
usb 1-1.5: usb_probe_device
usb 1-1.5: configuration #1 chosen from 1 choice
usb 1-1.5: adding 1-1.5:1.0 (config #1, interface 0)
uvcvideo 1-1.5:1.0: usb_probe_interface
uvcvideo 1-1.5:1.0: usb_probe_interface - got id
uvcvideo: Found UVC 1.00 device Laptop_Integrated_Webcam_FHD (05ca:1820)
input: Laptop_Integrated_Webcam_FHD as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5:1.0/input/input8
usb 1-1.5: adding 1-1.5:1.1 (config #1, interface 1)


Thanks,
Martin
