Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:37860 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751150AbcIOWsI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 18:48:08 -0400
Date: Thu, 15 Sep 2016 16:48:04 -0600
From: Wade Berrier <wberrier@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: mceusb xhci issue?
Message-ID: <20160915224804.GA14827@miniwade.localdomain>
References: <20160910195811.GA4941@berrier.lan>
 <Pine.LNX.4.44L0.1609151447410.1396-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1609151447410.1396-100000@iolanthe.rowland.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu Sep 15 15:13, Alan Stern wrote:
> On Sat, 10 Sep 2016, Wade Berrier wrote:
> 
> > On Thu Aug 11 16:18, Alan Stern wrote:
> > > I never received any replies to this message.  Should the patch I 
> > > suggested be merged?
> > >
> > 
> > Hello,
> > 
> > I applied this updated patch to the fedora23 4.7.2 kernel and the mceusb
> > transceiver works as expected.
> 
> Thank you for testing.  Can you provide the "lsusb -v" output for the
> troublesome IR transceiver?
> 

Here's the output:

Bus 001 Device 006: ID 1784:0006 TopSeed Technology Corp. eHome Infrared Transceiver
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

Wade
