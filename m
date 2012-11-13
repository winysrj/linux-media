Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:51611 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012Ab2KMOFZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 09:05:25 -0500
Received: by mail-la0-f46.google.com with SMTP id h6so5446316lag.19
        for <linux-media@vger.kernel.org>; Tue, 13 Nov 2012 06:05:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALF0-+XthyGJ-LzovTxLAKmMBif-YkLnNNcQBJvtnqTua+Ktag@mail.gmail.com>
References: <CALF0-+XthyGJ-LzovTxLAKmMBif-YkLnNNcQBJvtnqTua+Ktag@mail.gmail.com>
Date: Tue, 13 Nov 2012 14:05:23 +0000
Message-ID: <CAE8Q9tDW9D=oP=hNmLot0OoYk9V7xsm0R4SrcY+tpWhgbdTAbA@mail.gmail.com>
Subject: Re: Regarding bulk transfers on stk1160
From: Gordon Hollingworth <gordon@holliweb.co.uk>
To: Ezequiel Garcia <elezegarcia@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	michael hartup <michael.hartup@gmail.com>,
	linux-rpi-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Might see if I can get hold of one of these, is there a commercial device name?

Gordon

On 13/11/2012, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> Hello,
>
> A user (Michael Hartup in Cc) wants to use stk1160 on low power, low
> cost devices (like raspberrypi).
>
> At the moment raspberrypi can't stream using isoc urbs due to problems
> with usb host driver (dwc-otg)
> preventing it from achieving the required throughput.
> For instance, on my rpi setup I can stream (using dd) at 16MB/s; but
> at least 20 MB/s are required.
>
> Having read that bulk transfers may work better with rpi usb driver, I
> decided to try to implement
> those at stk1160. However, I later discovered stk1160 doesn't have any
> bulk endpoint (see lsusb below).
> (I'm no expert, but I assume lack of bulk endpoint means I can't use
> bulk urbs, right?).
>
> We could use a lower alternate setting, but unless we know how to
> reduce device frame rate
> or frame size, this won't work. If there's anyone from syntek reading
> this, we would appreciate
> to have some information on this issue.
>
> If anyone can think of something to solve this, or make a suggestion
> on another low cost, low power board
> to use, I'm sure Michael would appreciate it.
>
> Thanks!
>
>     Ezequiel
>
> ---
>
> Bus 002 Device 006: ID 05e1:0408 Syntek Semiconductor Co., Ltd STK1160
> Video Capture Device
> Couldn't open device, some information will be missing
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   idVendor           0x05e1 Syntek Semiconductor Co., Ltd
>   idProduct          0x0408 STK1160 Video Capture Device
>   bcdDevice            0.05
>   iManufacturer           1
>   iProduct                2
>   iSerial                 0
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength          251
>     bNumInterfaces          3
>     bConfigurationValue     1
>     iConfiguration          0
>     bmAttributes         0x80
>       (Bus Powered)
>     MaxPower              500mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass    255 Vendor Specific Subclass
>       bInterfaceProtocol    255 Vendor Specific Protocol
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0000  1x 0 bytes
>         bInterval               5
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0000  1x 0 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       1
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass    255 Vendor Specific Subclass
>       bInterfaceProtocol    255 Vendor Specific Protocol
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0002  1x 2 bytes
>         bInterval               5
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0300  1x 768 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       2
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass    255 Vendor Specific Subclass
>       bInterfaceProtocol    255 Vendor Specific Protocol
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0002  1x 2 bytes
>         bInterval               5
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x03fc  1x 1020 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       3
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass    255 Vendor Specific Subclass
>       bInterfaceProtocol    255 Vendor Specific Protocol
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0002  1x 2 bytes
>         bInterval               5
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0400  1x 1024 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       4
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass    255 Vendor Specific Subclass
>       bInterfaceProtocol    255 Vendor Specific Protocol
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0002  1x 2 bytes
>         bInterval               5
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0c00  2x 1024 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       5
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass    255 Vendor Specific Subclass
>       bInterfaceProtocol    255 Vendor Specific Protocol
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0002  1x 2 bytes
>         bInterval               5
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x1400  3x 1024 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       0
>       bNumEndpoints           0
>       bInterfaceClass         1 Audio
>       bInterfaceSubClass      1 Control Device
>       bInterfaceProtocol      0
>       iInterface             11
>       AudioControl Interface Descriptor:
>         bLength                 9
>         bDescriptorType        36
>         bDescriptorSubtype      1 (HEADER)
>         bcdADC               1.00
>         wTotalLength           38
>         bInCollection           1
>         baInterfaceNr( 0)       2
>       AudioControl Interface Descriptor:
>         bLength                12
>         bDescriptorType        36
>         bDescriptorSubtype      2 (INPUT_TERMINAL)
>         bTerminalID             1
>         wTerminalType      0x0602 Digital Audio Interface
>         bAssocTerminal          0
>         bNrChannels             2
>         wChannelConfig     0x0003
>           Left Front (L)
>           Right Front (R)
>         iChannelNames           0
>         iTerminal               0
>       AudioControl Interface Descriptor:
>         bLength                 9
>         bDescriptorType        36
>         bDescriptorSubtype      3 (OUTPUT_TERMINAL)
>         bTerminalID             2
>         wTerminalType      0x0101 USB Streaming
>         bAssocTerminal          0
>         bSourceID               3
>         iTerminal               0
>       AudioControl Interface Descriptor:
>         bLength                 8
>         bDescriptorType        36
>         bDescriptorSubtype      6 (FEATURE_UNIT)
>         bUnitID                 3
>         bSourceID               1
>         bControlSize            1
>         bmaControls( 0)      0x01
>           Mute Control
>         iFeature                0
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        2
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass         1 Audio
>       bInterfaceSubClass      2 Streaming
>       bInterfaceProtocol      0
>       iInterface             11
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x84  EP 4 IN
>         bmAttributes            5
>           Transfer Type            Isochronous
>           Synch Type               Asynchronous
>           Usage Type               Data
>         wMaxPacketSize     0x0000  1x 0 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        2
>       bAlternateSetting       1
>       bNumEndpoints           1
>       bInterfaceClass         1 Audio
>       bInterfaceSubClass      2 Streaming
>       bInterfaceProtocol      0
>       iInterface             11
>       AudioStreaming Interface Descriptor:
>         bLength                 7
>         bDescriptorType        36
>         bDescriptorSubtype      1 (AS_GENERAL)
>         bTerminalLink           2
>         bDelay                  1 frames
>         wFormatTag              1 PCM
>       AudioStreaming Interface Descriptor:
>         bLength                11
>         bDescriptorType        36
>         bDescriptorSubtype      2 (FORMAT_TYPE)
>         bFormatType             1 (FORMAT_TYPE_I)
>         bNrChannels             2
>         bSubframeSize           2
>         bBitResolution         16
>         bSamFreqType            1 Discrete
>         tSamFreq[ 0]        48000
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x84  EP 4 IN
>         bmAttributes            5
>           Transfer Type            Isochronous
>           Synch Type               Asynchronous
>           Usage Type               Data
>         wMaxPacketSize     0x0100  1x 256 bytes
>         bInterval               4
>         AudioControl Endpoint Descriptor:
>           bLength                 7
>           bDescriptorType        37
>           bDescriptorSubtype      1 (EP_GENERAL)
>           bmAttributes         0x00
>           bLockDelayUnits         0 Undefined
>           wLockDelay              0 Undefined
>
> _______________________________________________
> linux-rpi-kernel mailing list
> linux-rpi-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-rpi-kernel
>

-- 
Sent from my mobile device
