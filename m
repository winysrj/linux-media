Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:33134 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781AbaJPVSp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Oct 2014 17:18:45 -0400
Received: from berryeater.riseup.net (berryeater-pn.riseup.net [10.0.1.120])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "*.riseup.net", Issuer "Gandi Standard SSL CA" (not verified))
	by mx1.riseup.net (Postfix) with ESMTPS id DAC314154E
	for <linux-media@vger.kernel.org>; Thu, 16 Oct 2014 14:18:44 -0700 (PDT)
Message-ID: <5440362F.5040306@riseup.net>
Date: Fri, 17 Oct 2014 07:18:39 +1000
From: Dave Kimble <dave.kimble@riseup.net>
Reply-To: dave.kimble@riseup.net
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: GrabBee-HD
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have just bought an HDMI to USB-2.0 grabber called "GrabBee-HD".
http://www.greada.com/grabbeex-hd.html
Motherboard photo: http://www.davekimble.org.au/computers/GrabBee-HD.jpg
Inside it has chips labelled "Sigma PL330B-CPE3" and "iTE IT6604E".
Note that it compresses the video with H.264 .

I knew it probably wouldn't have drivers for Linux, but it does have 
Windows drivers on CD,
so since I run Ubuntu-VirtualBox-WinXP I thought it might well work one 
way or another.

On Ubuntu 14.04, the USB device is picked up:
$ lsusb -v -d 0658:1100

Bus 001 Device 007: ID 0658:1100 Sigma Designs, Inc.
Couldn't open device, some information will be missing
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x0658 Sigma Designs, Inc.
   idProduct          0x1100
   bcdDevice            0.00
   iManufacturer           1
   iProduct                2
   iSerial                 3
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           46
     bNumInterfaces          1
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
       bNumEndpoints           4
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol      0
       iInterface              4
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x02  EP 2 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               3
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x04  EP 4 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               3
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               3
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               3
====

but it is not recognised as a video capture device by VLC.
/dev/dvb/ , /dev/v4l/ , /dev/video0 do not exist.

So I fired up VB-WinXP and installed the Windows drivers and software, 
and restarted.
Then plugged in the device, which should connect the device to the 
driver, but it didn't.
Starting the Grabbee-HD software gives "No video capture device is 
connected!"
Then I realised the USB device has to be passed through the VB interface,
VB-Manager > USB > Add > "no devices available".

So because Ubuntu doesn't properly recognise the device, it can't pass 
it on to VB and XP.

Is there any chance of getting this going on Ubuntu 14.04 natively?


-- 
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at http://vger.kernel.org/majordomo-info.html

