Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:59759 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751643Ab2LEJ4v (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2012 04:56:51 -0500
Message-ID: <50BF1A5F.60700@gmx.de>
Date: Wed, 05 Dec 2012 10:56:47 +0100
From: Markus Feldmann <feldmann_markus@gmx.de>
MIME-Version: 1.0
To: Mailing List Linux Media <linux-media@vger.kernel.org>
Subject: Re: ASUS My Cinema U3000 Mini DVBT Tuner
References: <50BF0C9B.70407@gmx.de>
In-Reply-To: <50BF0C9B.70407@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here  is my <lsusb -v> output for this device:



Bus 001 Device 006: ID 0b05:171f ASUSTek Computer, Inc. My Cinema U3000 
Mini [DiBcom DiB7700P]
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x0b05 ASUSTek Computer, Inc.
   idProduct          0x171f My Cinema U3000 Mini [DiBcom DiB7700P]
   bcdDevice            1.00
   iManufacturer           1 DIBCOM
   iProduct                2 STK7700
   iSerial                 3 6803800468
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

