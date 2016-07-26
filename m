Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout3.freenet.de ([195.4.92.93]:51177 "EHLO mout3.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921AbcG0AN5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2016 20:13:57 -0400
Received: from [195.4.92.141] (helo=mjail1.freenet.de)
	by mout3.freenet.de with esmtpa (ID axel.rometsch@freenet.de) (port 25) (Exim 4.85 #1)
	id 1bSBsg-0003wf-2w
	for linux-media@vger.kernel.org; Wed, 27 Jul 2016 01:35:22 +0200
Received: from localhost ([::1]:46427 helo=mjail1.freenet.de)
	by mjail1.freenet.de with esmtpa (ID axel.rometsch@freenet.de) (Exim 4.85 #1)
	id 1bSBsf-0008Nf-VJ
	for linux-media@vger.kernel.org; Wed, 27 Jul 2016 01:35:22 +0200
Received: from mx13.freenet.de ([195.4.92.23]:34133)
	by mjail1.freenet.de with esmtpa (ID axel.rometsch@freenet.de) (Exim 4.85 #1)
	id 1bSBq3-0006x0-FJ
	for linux-media@vger.kernel.org; Wed, 27 Jul 2016 01:32:39 +0200
Received: from dslb-094-217-250-129.094.217.pools.vodafone-ip.de ([94.217.250.129]:44994 helo=lucy.localnet)
	by mx13.freenet.de with esmtpsa (ID axel.rometsch@freenet.de) (TLSv1:DHE-RSA-AES256-SHA:256) (port 25) (Exim 4.85 #1)
	id 1bSBq3-0002HP-Bt
	for linux-media@vger.kernel.org; Wed, 27 Jul 2016 01:32:39 +0200
From: Axel Rometsch <axel.rometsch@freenet.de>
To: linux-media@vger.kernel.org
Subject: Avermedia TD310
Date: Wed, 27 Jul 2016 01:32:38 +0200
Message-ID: <3326871.nOY5XFVsrE@lucy>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

would it be possible to add support for the Avermedia TD310 USB TV 
Dongle? It is a combined DVB-C, DVB-T and DVB-T2 device that supports 
HEVC.

lsusb
ID 07ca:1871 AVerMedia Technologies, Inc. 

lsusb -v 
Bus 002 Device 003: ID 07ca:1871 AVerMedia Technologies, Inc. 
Couldn't open device, some information will be missing
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x07ca AVerMedia Technologies, Inc.
  idProduct          0x1871 
  bcdDevice            1.00
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

Please let me know, if you need further informations

thank you

Axel

