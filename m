Return-path: <linux-media-owner@vger.kernel.org>
Received: from m4.goneo.de ([82.100.220.86]:62430 "EHLO m4.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782AbZIOSuf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 14:50:35 -0400
Received: from localhost (localhost [127.0.0.1])
	by scan.goneo.de (Postfix) with ESMTP id 3FF4CA6665B
	for <linux-media@vger.kernel.org>; Tue, 15 Sep 2009 20:50:38 +0200 (CEST)
Received: from m4.goneo.de ([127.0.0.1])
	by localhost (m4.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id HC9eD62oaz3s for <linux-media@vger.kernel.org>;
	Tue, 15 Sep 2009 20:50:38 +0200 (CEST)
Received: from [192.168.2.32] (localhost [127.0.0.1])
	by m4-smtp.goneo.de (Postfix) with ESMTPA id 09C5FA66652
	for <linux-media@vger.kernel.org>; Tue, 15 Sep 2009 20:50:37 +0200 (CEST)
To: linux-media@vger.kernel.org
Subject: Re: MSI Digivox Micro HD support?
Content-Disposition: inline
From: "Roman v. Gemmeren" <roman@hasnoname.de>
Date: Tue, 15 Sep 2009 20:50:32 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909152050.32487.roman@hasnoname.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Tuesday 15 September 2009 20:31:29 schrieben Sie:
> On 09/15/2009 08:32 PM, Roman v. Gemmeren wrote:
> > hi list,
> >
> > i just bought the above mentioned DVBT-Stick after my terratec prodigy
> > died (from overheating i guess).
> > I remembered sth. about digivox being supported, but i found only drivers
> > for the "Digivox Mini II 3.0" which don't seem to recognize that stick at
> > all.
> >
> > Anyone got that card working? If it is just the usb-id which is missing,
> > how /where would i add that to the source?
>
> Just do lsusb -vvd USB:ID and post here. From that we usually can say
> which chips are used and correct driver needed for device. Also you can
> look driver .inf file, driver filenames, look strings from driver, look
> sniff or open the box to identify chips.
>
> Antti
This is the output for the Stick:

root@Seth:~strowi/tmp> lsusb -vvd 1ba6:0001

Bus 001 Device 005: ID 1ba6:0001
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass       255 Vendor Specific Subclass
  bDeviceProtocol       255 Vendor Specific Protocol
  bMaxPacketSize0        64
  idVendor           0x1ba6
  idProduct          0x0001
  bcdDevice            1.00
  iManufacturer           1 Abilis Systems
  iProduct                2 ATon2 DVB Receiver
  iSerial                 3 0001
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           39
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              300mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
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
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
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

greetings,
Roman
