Return-path: <linux-media-owner@vger.kernel.org>
Received: from ara.aytolacoruna.es ([91.117.124.165]:49825 "EHLO
	mx.aytolacoruna.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbZDQW7W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 18:59:22 -0400
Received: from vip.manty.net (unknown [85.52.197.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx.aytolacoruna.es (Postfix) with ESMTPSA id 224541BC826
	for <linux-media@vger.kernel.org>; Sat, 18 Apr 2009 00:51:11 +0200 (CEST)
Date: Sat, 18 Apr 2009 00:51:08 +0200
From: Santiago Garcia Mantinan <manty@manty.net>
To: linux-media@vger.kernel.org
Subject: rtl2830 based freecom dvb-t card
Message-ID: <20090417225108.GA18028@vip.manty.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I have a Freecom DVB-T USB Stick around, ht has a RTL2830, a MT2060F and a
CY7C68013A-56LFXC, the card is exaxply like the Freecom DVB-T 14aa:0225 on
http://www.bttv-gallery.de/ but changes vendor, mine shows 14ff:0225 also
the same as Yakumo QuickStick Basic DVB-T on
http://www.svethardware.cz/art_doc-68A7D8BB854EBE54C125723F007253B1.html

The only difference I appreciated between my card and the ones on those two
webs is that by the PCB version number they show 0618 on bigger but thinner
numbers while mine shows 0634.

I tried to add my usb ids to the driver at
http://linuxtv.org/hg/~jhoogenraad/rtl2831-r2 but it looks like my first
approach is wrong, as I get the driver to load when I insert the card but
it does nothing.

This is the diff I made when I tried to add this card id to the driver:

diff -r -u rtl2831-r2-c7564e1397d3/linux/drivers/media/dvb/rtl2831/rtd2830u.c rtl2831-r2-c7564e1397d3.mio/linux/drivers/media/dvb/rtl2831/rtd2830u.c
--- rtl2831-r2-c7564e1397d3/linux/drivers/media/dvb/rtl2831/rtd2830u.c	2009-03-05 21:01:32.000000000 +0100
+++ rtl2831-r2-c7564e1397d3.mio/linux/drivers/media/dvb/rtl2831/rtd2830u.c	2009-04-17 21:31:49.000000000 +0200
@@ -382,6 +382,7 @@
 	{USB_DEVICE(USB_VID_COMPRO, USB_PID_COMPRO_WARM)},
 	{USB_DEVICE(USB_VID_VESTEL, USB_PID_VESTEL_WARM)},
 	{USB_DEVICE(USB_VID_FREECOM, USB_PID_FREECOM_WARM)},
+	{USB_DEVICE(USB_VID_FREECOM_2, USB_PID_FREECOM_WARM_2)},
 	{0},
 };
 
@@ -449,6 +450,10 @@
 		     .cold_ids = {NULL, NULL},
 		     .warm_ids = {&rtd2831u_usb_table[10], NULL},
 		     },
+		    {.name = "Freecom USB 2.0 DVB-T Device",
+		     .cold_ids = {NULL, NULL},
+		     .warm_ids = {&rtd2831u_usb_table[11], NULL},
+		     },
 		    {NULL},
 		    }
 };
diff -r -u rtl2831-r2-c7564e1397d3/linux/drivers/media/dvb/rtl2831/rtd2831u.h rtl2831-r2-c7564e1397d3.mio/linux/drivers/media/dvb/rtl2831/rtd2831u.h
--- rtl2831-r2-c7564e1397d3/linux/drivers/media/dvb/rtl2831/rtd2831u.h	2009-03-05 21:01:32.000000000 +0100
+++ rtl2831-r2-c7564e1397d3.mio/linux/drivers/media/dvb/rtl2831/rtd2831u.h	2009-04-17 18:11:02.000000000 +0200
@@ -65,6 +65,9 @@
 #define	USB_VID_FREECOM			0x14AA
 #define	USB_PID_FREECOM_WARM	0x0160
 
+#define	USB_VID_FREECOM_2			0x14FF
+#define	USB_PID_FREECOM_WARM_2	0x0225
+
 #define RTD2831_URB_SIZE			4096
 #define RTD2831_URB_NUMBER		7
 

Can somebody please tell me what should I add to test if this card is
supported with this driver?

In case it means something here is the lsusb -v for the card:

Bus 001 Device 002: ID 14ff:0225  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass       255 Vendor Specific Subclass
  bDeviceProtocol       255 Vendor Specific Protocol
  bMaxPacketSize0        64
  idVendor           0x14ff 
  idProduct          0x0225 
  bcdDevice            0.00
  iManufacturer           0 
  iProduct                0 
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          171
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
      bNumEndpoints           0
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0 
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       1
      bNumEndpoints           6
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
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
        bInterval               0
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
        bEndpointAddress     0x04  EP 4 OUT
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
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x88  EP 8 IN
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
      bAlternateSetting       2
      bNumEndpoints           6
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
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
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x88  EP 8 IN
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
      bAlternateSetting       3
      bNumEndpoints           6
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
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
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x88  EP 8 IN
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
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass       255 Vendor Specific Subclass
  bDeviceProtocol       255 Vendor Specific Protocol
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

Thanks in advance!

Regards.

PS: Please reply to me as I'm not on the list.
