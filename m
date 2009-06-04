Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bcode.com ([150.101.204.108]:43101 "EHLO mail.bcode.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750696AbZFDFd2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Jun 2009 01:33:28 -0400
Date: Thu, 4 Jun 2009 15:33:28 +1000
From: Erik de Castro Lopo <erik@bcode.com>
To: linux-media@vger.kernel.org
Cc: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Subject: Re: Creating a V4L driver for a USB camera
Message-Id: <20090604153328.4a3f2a6f.erik@bcode.com>
In-Reply-To: <alpine.LNX.2.00.0906032213001.17620@banach.math.auburn.edu>
References: <20090603141350.04cde59b.erik@bcode.com>
	<62e5edd40906022318l230992b7n34e5178b7e1a7d46@mail.gmail.com>
	<20090604100110.c837c3df.erik@bcode.com>
	<alpine.LNX.2.00.0906032014530.17538@banach.math.auburn.edu>
	<20090604115216.513cc41c.erik@bcode.com>
	<alpine.LNX.2.00.0906032213001.17620@banach.math.auburn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 4 Jun 2009 14:02:37 +1000
Theodore Kilgore <kilgota@banach.math.auburn.edu> wrote:

> Well, if you are interested in using the camera as a still camera, then 
> probably you ought also to send an inquiry over to
> 
> gphoto-devel@lists.sourceforge.net
> 
> because that is, basically, where the still camera support is done, not 
> here.

Well our current camera has a V4L based driver so we'd like to stick
to that :-).

> So the reason for these examples is, it is this kind of information which 
> one must use to judge the situation, and it is this kind of information 
> which one would have to provide in order to begin to get definitive 
> answers. This, in fact, is where one must start.

Ok, to the lsusb -v info:

    Bus 001 Device 011: ID 0547:8031 Anchor Chips, Inc. 
    Device Descriptor:
      bLength                18
      bDescriptorType         1
      bcdUSB               2.00
      bDeviceClass            0 (Defined at Interface level)
      bDeviceSubClass         0 
      bDeviceProtocol         0 
      bMaxPacketSize0        64
      idVendor           0x0547 Anchor Chips, Inc.
      idProduct          0x8031 
      bcdDevice            0.00
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
          bInterfaceSubClass      0 
          bInterfaceProtocol      0 
          iInterface              0 
          Endpoint Descriptor:
            bLength                 7
            bDescriptorType         5
            bEndpointAddress     0x81  EP 1 IN
            bmAttributes            3
              Transfer Type            Interrupt
              Synch Type               None
              Usage Type               Data
            wMaxPacketSize     0x0004  1x 4 bytes
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


The "Vendor Specific Class" above suggests that this camera does not
behave like a proper USV video or still camera, but rather uses its
own protocol (just like the camera we are replacing).

I have managed to convince the manufactuer of the fact that its a
good idea to provide some information and/or windows source code,
but as yet I can't predict how good that information will be.

Erik
-- 
=======================
erik de castro lopo
senior design engineer

bCODE
level 2, 2a glen street
milsons point
sydney nsw 2061
australia

tel +61 (0)2 9954 4411
fax +61 (0)2 9954 4422
www.bcode.com
