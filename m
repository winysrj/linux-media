Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61346 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab1BIBiI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Feb 2011 20:38:08 -0500
Received: by bwz15 with SMTP id 15so458797bwz.19
        for <linux-media@vger.kernel.org>; Tue, 08 Feb 2011 17:38:07 -0800 (PST)
Message-ID: <4D51EFFB.90201@users.sourceforge.net>
Date: Wed, 09 Feb 2011 02:38:03 +0100
From: Lucian Muresan <lucianm@users.sourceforge.net>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Patrick Boettcher <pboettcher@kernellabs.com>,
	Jarod Wilson <jarod@wilsonet.com>
Subject: Re: MCEUSB: falsly claims mass storage device
References: <201101091836.58104.pboettcher@kernellabs.com>
In-Reply-To: <201101091836.58104.pboettcher@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 09.01.2011 18:36, Patrick Boettcher wrote:
> Hi Jarod,
> 
> I'm using an MultiCard-reader which exposes itself like shown below.
> 
> It is falsly claimed by the mceusb-driver from (2.6.36 from debian-
> experimental) . 


Hi there,

I also bought a similar Multi-Cardreader, which also comes with a MCE
remote control. It seems that the Realtek chip inside (RTS5161 I've
found in other posts on the net) can really do it all: flash card
reader, CCID compatible smartcard reader and MCE remote, maybe that's
why on some readers using it, the wrong module claim it, or on some,
like mine, claim "too much"?

My problem on a 2.6.38-rc2 kernel self-built on Gentoo is that the
mceusb module registers 2 LIRC devices /dev/lirc0 and /dev/lirc1, as
well as 2 input devices, and in that situation, the smartcard part of
the reader is not usale by openct. Once I managed, after manually
removing the mceusb module, to load it and have it register only one
such device, and then openct-tool at least found a CCID-compatible
reader, but somehow it only happened once. So there seem to be problems
in the mceusb module with this chip... Is there currently someone
working on this problem? Below, see the output of lsusb for my
multi-reader/MCE RC...

Best Regards,
Lucian


lsusb -v -d 0bda:0161

Bus 001 Device 002: ID 0bda:0161 Realtek Semiconductor Corp. Mass
Storage Device
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x0bda Realtek Semiconductor Corp.
  idProduct          0x0161 Mass Storage Device
  bcdDevice           61.10
  iManufacturer           1 Generic
  iProduct                2 USB2.0-CRW
  iSerial                 3 20070818000000000
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          139
    bNumInterfaces          3
    bConfigurationValue     1
    iConfiguration          4 CARD READER
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass        11 Chip/SmartCard
      bInterfaceSubClass      0
      bInterfaceProtocol      0
      iInterface              6 Smart Card Reader Interface
      ChipCard Interface Descriptor:
        bLength                54
        bDescriptorType        33
        bcdCCID              1.10  (Warning: Only accurate for version 1.0)
        nMaxSlotIndex           0
        bVoltageSupport         7  5.0V 3.0V 1.8V
        dwProtocols             3  T=0 T=1
        dwDefaultClock       3750
        dwMaxiumumClock      7500
        bNumClockSupported      0
        dwDataRate          10080 bps
        dwMaxDataRate      312500 bps
        bNumDataRatesSupp.      0
        dwMaxIFSD             254
        dwSyncProtocols  00000000
        dwMechanical     00000000
        dwFeatures       00010030
          Auto clock change
          Auto baud rate change
          TPDU level exchange
        dwMaxCCIDMsgLen       271
        bClassGetResponse      00
        bClassEnvelope         00
        wlcdLayout           none
        bPINSupport             0
        bMaxCCIDBusySlots       1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               8
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x05  EP 5 OUT
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
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk (Zip)
      iInterface              5 Bulk-In, Bulk-Out, Interface
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
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              7 eHome Infrared Receiver
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x07  EP 7 OUT
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               8
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x88  EP 8 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               8
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
