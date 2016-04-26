Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:34630 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbcDZDQz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 23:16:55 -0400
Received: by mail-io0-f196.google.com with SMTP id d62so563400iof.1
        for <linux-media@vger.kernel.org>; Mon, 25 Apr 2016 20:16:55 -0700 (PDT)
Date: Mon, 25 Apr 2016 21:16:51 -0600
From: Wade Berrier <wberrier@gmail.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: mceusb xhci issue?
Message-ID: <20160426031650.GA13700@berrier.lan>
References: <20160425040632.GD15140@berrier.lan>
 <20160425171506.GA25277@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160425171506.GA25277@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Apr 25 18:15, Sean Young wrote:
> On Sun, Apr 24, 2016 at 10:06:33PM -0600, Wade Berrier wrote:
> > Hello,
> > 
> > I have a mceusb compatible transceiver that only seems to work with
> > certain computers.  I'm testing this on centos7 (3.10.0) and fedora23
> > (4.4.7).
> > 
> > The only difference I can see is that the working computer shows
> > "using uhci_hcd" and the non working shows "using xhci_hcd".
> > 
> > Here's the dmesg output of the non-working version:
> > 
> > ---------------------
> > 
> > [  217.951079] usb 1-5: new full-speed USB device number 10 using xhci_hcd
> > [  218.104087] usb 1-5: device descriptor read/64, error -71
> > [  218.371010] usb 1-5: config 1 interface 0 altsetting 0 endpoint 0x1 has an invalid bInterval 0, changing to 32
> > [  218.371019] usb 1-5: config 1 interface 0 altsetting 0 endpoint 0x81 has an invalid bInterval 0, changing to 32
> 
> That's odd. Can you post a "lsusb -vvv" of the device please?
> 

Sure.

-------------------

Bus 002 Device 009: ID 1784:0006 TopSeed Technology Corp. eHome Infrared Transceiver
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x1784 TopSeed Technology Corp.
  idProduct          0x0006 eHome Infrared Transceiver
  bcdDevice            1.02
  iManufacturer           1 TopSeed Technology Corp.
  iProduct                2 eHome Infrared Transceiver
  iSerial                 3 TS004RrP
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
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
        wMaxPacketSize     0x0020  1x 32 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0020  1x 32 bytes
        bInterval               0
Device Status:     0x0001
  Self Powered

-------------------

Also, here's a link to a response on the lirc list:

https://sourceforge.net/p/lirc/mailman/message/35039126/

Wade
