Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:36175 "EHLO
	mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbcEOC3u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 May 2016 22:29:50 -0400
Received: by mail-pf0-f169.google.com with SMTP id c189so57162067pfb.3
        for <linux-media@vger.kernel.org>; Sat, 14 May 2016 19:29:49 -0700 (PDT)
Date: Sat, 14 May 2016 20:29:43 -0600
From: Wade Berrier <wberrier@gmail.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: mceusb xhci issue?
Message-ID: <20160515022940.GB2865@miniwade.localdomain>
References: <20160425040632.GD15140@berrier.lan>
 <20160425171506.GA25277@gofer.mess.org>
 <20160426031650.GA13700@berrier.lan>
 <20160427200730.GA6632@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160427200730.GA6632@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed Apr 27 21:07, Sean Young wrote:
> On Mon, Apr 25, 2016 at 09:16:51PM -0600, Wade Berrier wrote:
> > On Apr 25 18:15, Sean Young wrote:
> > > On Sun, Apr 24, 2016 at 10:06:33PM -0600, Wade Berrier wrote:
> > > > Hello,
> > > > 
> > > > I have a mceusb compatible transceiver that only seems to work with
> > > > certain computers.  I'm testing this on centos7 (3.10.0) and fedora23
> > > > (4.4.7).
> > > > 
> > > > The only difference I can see is that the working computer shows
> > > > "using uhci_hcd" and the non working shows "using xhci_hcd".
> > > > 
> > > > Here's the dmesg output of the non-working version:
> > > > 
> > > > ---------------------
> > > > 
> > > > [  217.951079] usb 1-5: new full-speed USB device number 10 using xhci_hcd
> > > > [  218.104087] usb 1-5: device descriptor read/64, error -71
> > > > [  218.371010] usb 1-5: config 1 interface 0 altsetting 0 endpoint 0x1 has an invalid bInterval 0, changing to 32
> > > > [  218.371019] usb 1-5: config 1 interface 0 altsetting 0 endpoint 0x81 has an invalid bInterval 0, changing to 32
> > > 
> > > That's odd. Can you post a "lsusb -vvv" of the device please?
> > > 
> > 
> > Sure.
> > 
> > -------------------
> > 
> > Bus 002 Device 009: ID 1784:0006 TopSeed Technology Corp. eHome Infrared Transceiver
> > Device Descriptor:
> >   bLength                18
> >   bDescriptorType         1
> >   bcdUSB               2.00
> >   bDeviceClass            0 
> >   bDeviceSubClass         0 
> >   bDeviceProtocol         0 
> >   bMaxPacketSize0         8
> >   idVendor           0x1784 TopSeed Technology Corp.
> >   idProduct          0x0006 eHome Infrared Transceiver
> >   bcdDevice            1.02
> >   iManufacturer           1 TopSeed Technology Corp.
> >   iProduct                2 eHome Infrared Transceiver
> >   iSerial                 3 TS004RrP
> >   bNumConfigurations      1
> >   Configuration Descriptor:
> >     bLength                 9
> >     bDescriptorType         2
> >     wTotalLength           32
> >     bNumInterfaces          1
> >     bConfigurationValue     1
> >     iConfiguration          0 
> >     bmAttributes         0xa0
> >       (Bus Powered)
> >       Remote Wakeup
> >     MaxPower              100mA
> >     Interface Descriptor:
> >       bLength                 9
> >       bDescriptorType         4
> >       bInterfaceNumber        0
> >       bAlternateSetting       0
> >       bNumEndpoints           2
> >       bInterfaceClass       255 Vendor Specific Class
> >       bInterfaceSubClass    255 Vendor Specific Subclass
> >       bInterfaceProtocol    255 Vendor Specific Protocol
> >       iInterface              0 
> >       Endpoint Descriptor:
> >         bLength                 7
> >         bDescriptorType         5
> >         bEndpointAddress     0x01  EP 1 OUT
> >         bmAttributes            3
> >           Transfer Type            Interrupt
> >           Synch Type               None
> >           Usage Type               Data
> >         wMaxPacketSize     0x0020  1x 32 bytes
> >         bInterval               0
> 
> That's wrong indeed. It might be interesting to see if there is anything
> in the xhci debug messages with (in Fedora 23):
> 
> echo "file xhci*.c +p" > /sys/kernel/debug/dynamic_debug/control
> echo "file mceusb.c +p" > /sys/kernel/debug/dynamic_debug/control
> 
> And then plug in the receiver, and try to send IR to it with a remote.
> You should have quite a few kernel messages in the journal.

Here's the output after enabling the debug options, plugging in the
receiver, running lircd, and pressing some remote buttons:

[ 3034.530870] xhci_hcd 0000:00:14.0: // Setting command ring address to 0x79b16001
[ 3034.530903] xhci_hcd 0000:00:14.0: Port Status Change Event for port 5
[ 3034.530906] xhci_hcd 0000:00:14.0: resume root hub
[ 3034.530910] xhci_hcd 0000:00:14.0: handle_port_status: starting port polling.
[ 3034.530918] xhci_hcd 0000:00:14.0: Port Status Change Event for port 10
[ 3034.530921] xhci_hcd 0000:00:14.0: resume root hub
[ 3034.530923] xhci_hcd 0000:00:14.0: handle_port_status: starting port polling.
[ 3034.530928] xhci_hcd 0000:00:14.0: xhci_hub_status_data: stopping port polling.
[ 3034.530930] xhci_hcd 0000:00:14.0: Port Status Change Event for port 11
[ 3034.530933] xhci_hcd 0000:00:14.0: resume root hub
[ 3034.530935] xhci_hcd 0000:00:14.0: handle_port_status: starting port polling.
[ 3034.530940] xhci_hcd 0000:00:14.0: xhci_hub_status_data: stopping port polling.
[ 3034.530942] xhci_hcd 0000:00:14.0: Port Status Change Event for port 12
[ 3034.530944] xhci_hcd 0000:00:14.0: resume root hub
[ 3034.530946] xhci_hcd 0000:00:14.0: handle_port_status: starting port polling.
[ 3034.530951] xhci_hcd 0000:00:14.0: xhci_hub_status_data: stopping port polling.
[ 3034.530953] xhci_hcd 0000:00:14.0: Port Status Change Event for port 13
[ 3034.530956] xhci_hcd 0000:00:14.0: resume root hub
[ 3034.530958] xhci_hcd 0000:00:14.0: handle_port_status: starting port polling.
[ 3034.530962] xhci_hcd 0000:00:14.0: xhci_hub_status_data: stopping port polling.
[ 3034.530966] xhci_hcd 0000:00:14.0: xhci_resume: starting port polling.
[ 3034.530971] xhci_hcd 0000:00:14.0: xhci_hub_status_data: stopping port polling.
[ 3034.531004] xhci_hcd 0000:00:14.0: get port status, actual port 0 status  = 0x2a0
[ 3034.531006] xhci_hcd 0000:00:14.0: Get port status returned 0x100
[ 3034.531016] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2a0
[ 3034.531018] xhci_hcd 0000:00:14.0: Get port status returned 0x100
[ 3034.531023] xhci_hcd 0000:00:14.0: get port status, actual port 2 status  = 0xe63
[ 3034.531025] xhci_hcd 0000:00:14.0: Get port status returned 0x507
[ 3034.531030] xhci_hcd 0000:00:14.0: get port status, actual port 3 status  = 0x663
[ 3034.531032] xhci_hcd 0000:00:14.0: Get port status returned 0x107
[ 3034.531037] xhci_hcd 0000:00:14.0: get port status, actual port 4 status  = 0x206e1
[ 3034.531039] xhci_hcd 0000:00:14.0: Get port status returned 0x10101
[ 3034.531046] xhci_hcd 0000:00:14.0: clear port connect change, actual port 4 status  = 0x6e1
[ 3034.531051] xhci_hcd 0000:00:14.0: get port status, actual port 5 status  = 0x2a0
[ 3034.531053] xhci_hcd 0000:00:14.0: Get port status returned 0x100
[ 3034.531058] xhci_hcd 0000:00:14.0: get port status, actual port 6 status  = 0x2a0
[ 3034.531060] xhci_hcd 0000:00:14.0: Get port status returned 0x100
[ 3034.531065] xhci_hcd 0000:00:14.0: get port status, actual port 7 status  = 0x2a0
[ 3034.531067] xhci_hcd 0000:00:14.0: Get port status returned 0x100
[ 3034.531085] xhci_hcd 0000:00:14.0: get port status, actual port 0 status  = 0x2a0
[ 3034.531087] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[ 3034.531096] xhci_hcd 0000:00:14.0: get port status, actual port 1 status  = 0x2a0
[ 3034.531098] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[ 3034.531106] xhci_hcd 0000:00:14.0: get port status, actual port 2 status  = 0x2a0
[ 3034.531108] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[ 3034.531114] xhci_hcd 0000:00:14.0: get port status, actual port 3 status  = 0x2a0
[ 3034.531116] xhci_hcd 0000:00:14.0: Get port status returned 0x2a0
[ 3034.531132] xhci_hcd 0000:00:14.0: set port remote wake mask, actual port 0 status  = 0xe0002a0
[ 3034.531141] xhci_hcd 0000:00:14.0: set port remote wake mask, actual port 1 status  = 0xe0002a0
[ 3034.531149] xhci_hcd 0000:00:14.0: set port remote wake mask, actual port 2 status  = 0xe0002a0
[ 3034.531158] xhci_hcd 0000:00:14.0: set port remote wake mask, actual port 3 status  = 0xe0002a0
[ 3034.531176] xhci_hcd 0000:00:14.0: xhci_hub_status_data: stopping port polling.
[ 3034.631850] xhci_hcd 0000:00:14.0: get port status, actual port 4 status  = 0x6e1
[ 3034.631855] xhci_hcd 0000:00:14.0: Get port status returned 0x101
[ 3034.631874] xhci_hcd 0000:00:14.0: // Ding dong!
[ 3034.631900] xhci_hcd 0000:00:14.0: Slot 5 output ctx = 0x4ac58000 (dma)
[ 3034.631903] xhci_hcd 0000:00:14.0: Slot 5 input ctx = 0x3750b000 (dma)
[ 3034.631910] xhci_hcd 0000:00:14.0: Set slot id 5 dcbaa entry ffff880079b14028 to 0x4ac58000
[ 3034.631922] xhci_hcd 0000:00:14.0: set port reset, actual port 4 status  = 0x791
[ 3034.632833] xhci_hcd 0000:00:14.0: xhci_hub_status_data: stopping port polling.
[ 3034.682895] xhci_hcd 0000:00:14.0: get port status, actual port 4 status  = 0x791
[ 3034.682900] xhci_hcd 0000:00:14.0: Get port status returned 0x111
[ 3034.687099] xhci_hcd 0000:00:14.0: Port Status Change Event for port 5
[ 3034.687108] xhci_hcd 0000:00:14.0: handle_port_status: starting port polling.
[ 3034.733891] xhci_hcd 0000:00:14.0: get port status, actual port 4 status  = 0x200603
[ 3034.733896] xhci_hcd 0000:00:14.0: Get port status returned 0x100103
[ 3034.733914] xhci_hcd 0000:00:14.0: clear port reset change, actual port 4 status  = 0x603
[ 3034.744862] xhci_hcd 0000:00:14.0: xhci_hub_status_data: stopping port polling.
[ 3034.784889] usb 2-5: new full-speed USB device number 6 using xhci_hcd
[ 3034.784898] xhci_hcd 0000:00:14.0: Set root hub portnum to 5
[ 3034.784901] xhci_hcd 0000:00:14.0: Set fake root hub portnum to 5
[ 3034.784904] xhci_hcd 0000:00:14.0: udev->tt = ffff880079acc8a0
[ 3034.784906] xhci_hcd 0000:00:14.0: udev->ttport = 0x5
[ 3034.784908] xhci_hcd 0000:00:14.0: Slot ID 5 Input Context:
[ 3034.784912] xhci_hcd 0000:00:14.0: @ffff88003750b000 (virt) @3750b000 (dma) 0x000000 - drop flags
[ 3034.784914] xhci_hcd 0000:00:14.0: @ffff88003750b004 (virt) @3750b004 (dma) 0x000003 - add flags
[ 3034.784917] xhci_hcd 0000:00:14.0: @ffff88003750b008 (virt) @3750b008 (dma) 0x000000 - rsvd2[0]
[ 3034.784919] xhci_hcd 0000:00:14.0: @ffff88003750b00c (virt) @3750b00c (dma) 0x000000 - rsvd2[1]
[ 3034.784922] xhci_hcd 0000:00:14.0: @ffff88003750b010 (virt) @3750b010 (dma) 0x000000 - rsvd2[2]
[ 3034.784924] xhci_hcd 0000:00:14.0: @ffff88003750b014 (virt) @3750b014 (dma) 0x000000 - rsvd2[3]
[ 3034.784926] xhci_hcd 0000:00:14.0: @ffff88003750b018 (virt) @3750b018 (dma) 0x000000 - rsvd2[4]
[ 3034.784929] xhci_hcd 0000:00:14.0: @ffff88003750b01c (virt) @3750b01c (dma) 0x000000 - rsvd2[5]
[ 3034.784931] xhci_hcd 0000:00:14.0: Slot Context:
[ 3034.784933] xhci_hcd 0000:00:14.0: @ffff88003750b020 (virt) @3750b020 (dma) 0x8100000 - dev_info
[ 3034.784936] xhci_hcd 0000:00:14.0: @ffff88003750b024 (virt) @3750b024 (dma) 0x050000 - dev_info2
[ 3034.784938] xhci_hcd 0000:00:14.0: @ffff88003750b028 (virt) @3750b028 (dma) 0x000000 - tt_info
[ 3034.784940] xhci_hcd 0000:00:14.0: @ffff88003750b02c (virt) @3750b02c (dma) 0x000000 - dev_state
[ 3034.784943] xhci_hcd 0000:00:14.0: @ffff88003750b030 (virt) @3750b030 (dma) 0x000000 - rsvd[0]
[ 3034.784946] xhci_hcd 0000:00:14.0: @ffff88003750b034 (virt) @3750b034 (dma) 0x000000 - rsvd[1]
[ 3034.784948] xhci_hcd 0000:00:14.0: @ffff88003750b038 (virt) @3750b038 (dma) 0x000000 - rsvd[2]
[ 3034.784950] xhci_hcd 0000:00:14.0: @ffff88003750b03c (virt) @3750b03c (dma) 0x000000 - rsvd[3]
[ 3034.784953] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
[ 3034.784956] xhci_hcd 0000:00:14.0: @ffff88003750b040 (virt) @3750b040 (dma) 0x000000 - ep_info
[ 3034.784958] xhci_hcd 0000:00:14.0: @ffff88003750b044 (virt) @3750b044 (dma) 0x400026 - ep_info2
[ 3034.784961] xhci_hcd 0000:00:14.0: @ffff88003750b048 (virt) @3750b048 (dma) 0x377f7001 - deq
[ 3034.784963] xhci_hcd 0000:00:14.0: @ffff88003750b050 (virt) @3750b050 (dma) 0x000000 - tx_info
[ 3034.784966] xhci_hcd 0000:00:14.0: @ffff88003750b054 (virt) @3750b054 (dma) 0x000000 - rsvd[0]
[ 3034.784968] xhci_hcd 0000:00:14.0: @ffff88003750b058 (virt) @3750b058 (dma) 0x000000 - rsvd[1]
[ 3034.784970] xhci_hcd 0000:00:14.0: @ffff88003750b05c (virt) @3750b05c (dma) 0x000000 - rsvd[2]
[ 3034.784973] xhci_hcd 0000:00:14.0: OUT Endpoint 01 Context (ep_index 01):
[ 3034.784975] xhci_hcd 0000:00:14.0: @ffff88003750b060 (virt) @3750b060 (dma) 0x000000 - ep_info
[ 3034.784977] xhci_hcd 0000:00:14.0: @ffff88003750b064 (virt) @3750b064 (dma) 0x000000 - ep_info2
[ 3034.784980] xhci_hcd 0000:00:14.0: @ffff88003750b068 (virt) @3750b068 (dma) 0x000000 - deq
[ 3034.784982] xhci_hcd 0000:00:14.0: @ffff88003750b070 (virt) @3750b070 (dma) 0x000000 - tx_info
[ 3034.784984] xhci_hcd 0000:00:14.0: @ffff88003750b074 (virt) @3750b074 (dma) 0x000000 - rsvd[0]
[ 3034.784987] xhci_hcd 0000:00:14.0: @ffff88003750b078 (virt) @3750b078 (dma) 0x000000 - rsvd[1]
[ 3034.784989] xhci_hcd 0000:00:14.0: @ffff88003750b07c (virt) @3750b07c (dma) 0x000000 - rsvd[2]
[ 3034.784991] xhci_hcd 0000:00:14.0: IN Endpoint 01 Context (ep_index 02):
[ 3034.784994] xhci_hcd 0000:00:14.0: @ffff88003750b080 (virt) @3750b080 (dma) 0x000000 - ep_info
[ 3034.784996] xhci_hcd 0000:00:14.0: @ffff88003750b084 (virt) @3750b084 (dma) 0x000000 - ep_info2
[ 3034.784998] xhci_hcd 0000:00:14.0: @ffff88003750b088 (virt) @3750b088 (dma) 0x000000 - deq
[ 3034.785001] xhci_hcd 0000:00:14.0: @ffff88003750b090 (virt) @3750b090 (dma) 0x000000 - tx_info
[ 3034.785003] xhci_hcd 0000:00:14.0: @ffff88003750b094 (virt) @3750b094 (dma) 0x000000 - rsvd[0]
[ 3034.785005] xhci_hcd 0000:00:14.0: @ffff88003750b098 (virt) @3750b098 (dma) 0x000000 - rsvd[1]
[ 3034.785008] xhci_hcd 0000:00:14.0: @ffff88003750b09c (virt) @3750b09c (dma) 0x000000 - rsvd[2]
[ 3034.785011] xhci_hcd 0000:00:14.0: // Ding dong!
[ 3034.785029] xhci_hcd 0000:00:14.0: Successful setup context command
[ 3034.785032] xhci_hcd 0000:00:14.0: Op regs DCBAA ptr = 0x00000079b14000
[ 3034.785035] xhci_hcd 0000:00:14.0: Slot ID 5 dcbaa entry @ffff880079b14028 = 0x0000004ac58000
[ 3034.785037] xhci_hcd 0000:00:14.0: Output Context DMA address = 0x4ac58000
[ 3034.785039] xhci_hcd 0000:00:14.0: Slot ID 5 Input Context:
[ 3034.785042] xhci_hcd 0000:00:14.0: @ffff88003750b000 (virt) @3750b000 (dma) 0x000000 - drop flags
[ 3034.785044] xhci_hcd 0000:00:14.0: @ffff88003750b004 (virt) @3750b004 (dma) 0x000003 - add flags
[ 3034.785047] xhci_hcd 0000:00:14.0: @ffff88003750b008 (virt) @3750b008 (dma) 0x000000 - rsvd2[0]
[ 3034.785049] xhci_hcd 0000:00:14.0: @ffff88003750b00c (virt) @3750b00c (dma) 0x000000 - rsvd2[1]
[ 3034.785051] xhci_hcd 0000:00:14.0: @ffff88003750b010 (virt) @3750b010 (dma) 0x000000 - rsvd2[2]
[ 3034.785054] xhci_hcd 0000:00:14.0: @ffff88003750b014 (virt) @3750b014 (dma) 0x000000 - rsvd2[3]
[ 3034.785056] xhci_hcd 0000:00:14.0: @ffff88003750b018 (virt) @3750b018 (dma) 0x000000 - rsvd2[4]
[ 3034.785058] xhci_hcd 0000:00:14.0: @ffff88003750b01c (virt) @3750b01c (dma) 0x000000 - rsvd2[5]
[ 3034.785060] xhci_hcd 0000:00:14.0: Slot Context:
[ 3034.785063] xhci_hcd 0000:00:14.0: @ffff88003750b020 (virt) @3750b020 (dma) 0x8100000 - dev_info
[ 3034.785065] xhci_hcd 0000:00:14.0: @ffff88003750b024 (virt) @3750b024 (dma) 0x050000 - dev_info2
[ 3034.785067] xhci_hcd 0000:00:14.0: @ffff88003750b028 (virt) @3750b028 (dma) 0x000000 - tt_info
[ 3034.785070] xhci_hcd 0000:00:14.0: @ffff88003750b02c (virt) @3750b02c (dma) 0x000000 - dev_state
[ 3034.785072] xhci_hcd 0000:00:14.0: @ffff88003750b030 (virt) @3750b030 (dma) 0x000000 - rsvd[0]
[ 3034.785074] xhci_hcd 0000:00:14.0: @ffff88003750b034 (virt) @3750b034 (dma) 0x000000 - rsvd[1]
[ 3034.785077] xhci_hcd 0000:00:14.0: @ffff88003750b038 (virt) @3750b038 (dma) 0x000000 - rsvd[2]
[ 3034.785079] xhci_hcd 0000:00:14.0: @ffff88003750b03c (virt) @3750b03c (dma) 0x000000 - rsvd[3]
[ 3034.785081] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
[ 3034.785083] xhci_hcd 0000:00:14.0: @ffff88003750b040 (virt) @3750b040 (dma) 0x000000 - ep_info
[ 3034.785086] xhci_hcd 0000:00:14.0: @ffff88003750b044 (virt) @3750b044 (dma) 0x400026 - ep_info2
[ 3034.785088] xhci_hcd 0000:00:14.0: @ffff88003750b048 (virt) @3750b048 (dma) 0x377f7001 - deq
[ 3034.785090] xhci_hcd 0000:00:14.0: @ffff88003750b050 (virt) @3750b050 (dma) 0x000000 - tx_info
[ 3034.785093] xhci_hcd 0000:00:14.0: @ffff88003750b054 (virt) @3750b054 (dma) 0x000000 - rsvd[0]
[ 3034.785095] xhci_hcd 0000:00:14.0: @ffff88003750b058 (virt) @3750b058 (dma) 0x000000 - rsvd[1]
[ 3034.785097] xhci_hcd 0000:00:14.0: @ffff88003750b05c (virt) @3750b05c (dma) 0x000000 - rsvd[2]
[ 3034.785100] xhci_hcd 0000:00:14.0: OUT Endpoint 01 Context (ep_index 01):
[ 3034.785102] xhci_hcd 0000:00:14.0: @ffff88003750b060 (virt) @3750b060 (dma) 0x000000 - ep_info
[ 3034.785104] xhci_hcd 0000:00:14.0: @ffff88003750b064 (virt) @3750b064 (dma) 0x000000 - ep_info2
[ 3034.785106] xhci_hcd 0000:00:14.0: @ffff88003750b068 (virt) @3750b068 (dma) 0x000000 - deq
[ 3034.785109] xhci_hcd 0000:00:14.0: @ffff88003750b070 (virt) @3750b070 (dma) 0x000000 - tx_info
[ 3034.785111] xhci_hcd 0000:00:14.0: @ffff88003750b074 (virt) @3750b074 (dma) 0x000000 - rsvd[0]
[ 3034.785113] xhci_hcd 0000:00:14.0: @ffff88003750b078 (virt) @3750b078 (dma) 0x000000 - rsvd[1]
[ 3034.785116] xhci_hcd 0000:00:14.0: @ffff88003750b07c (virt) @3750b07c (dma) 0x000000 - rsvd[2]
[ 3034.785118] xhci_hcd 0000:00:14.0: IN Endpoint 01 Context (ep_index 02):
[ 3034.785120] xhci_hcd 0000:00:14.0: @ffff88003750b080 (virt) @3750b080 (dma) 0x000000 - ep_info
[ 3034.785122] xhci_hcd 0000:00:14.0: @ffff88003750b084 (virt) @3750b084 (dma) 0x000000 - ep_info2
[ 3034.785125] xhci_hcd 0000:00:14.0: @ffff88003750b088 (virt) @3750b088 (dma) 0x000000 - deq
[ 3034.785127] xhci_hcd 0000:00:14.0: @ffff88003750b090 (virt) @3750b090 (dma) 0x000000 - tx_info
[ 3034.785129] xhci_hcd 0000:00:14.0: @ffff88003750b094 (virt) @3750b094 (dma) 0x000000 - rsvd[0]
[ 3034.785132] xhci_hcd 0000:00:14.0: @ffff88003750b098 (virt) @3750b098 (dma) 0x000000 - rsvd[1]
[ 3034.785134] xhci_hcd 0000:00:14.0: @ffff88003750b09c (virt) @3750b09c (dma) 0x000000 - rsvd[2]
[ 3034.785136] xhci_hcd 0000:00:14.0: Slot ID 5 Output Context:
[ 3034.785138] xhci_hcd 0000:00:14.0: Slot Context:
[ 3034.785140] xhci_hcd 0000:00:14.0: @ffff88004ac58000 (virt) @4ac58000 (dma) 0x8100000 - dev_info
[ 3034.785143] xhci_hcd 0000:00:14.0: @ffff88004ac58004 (virt) @4ac58004 (dma) 0x050000 - dev_info2
[ 3034.785145] xhci_hcd 0000:00:14.0: @ffff88004ac58008 (virt) @4ac58008 (dma) 0x000000 - tt_info
[ 3034.785147] xhci_hcd 0000:00:14.0: @ffff88004ac5800c (virt) @4ac5800c (dma) 0x8000000 - dev_state
[ 3034.785150] xhci_hcd 0000:00:14.0: @ffff88004ac58010 (virt) @4ac58010 (dma) 0x000000 - rsvd[0]
[ 3034.785152] xhci_hcd 0000:00:14.0: @ffff88004ac58014 (virt) @4ac58014 (dma) 0x000000 - rsvd[1]
[ 3034.785154] xhci_hcd 0000:00:14.0: @ffff88004ac58018 (virt) @4ac58018 (dma) 0x000000 - rsvd[2]
[ 3034.785157] xhci_hcd 0000:00:14.0: @ffff88004ac5801c (virt) @4ac5801c (dma) 0x000000 - rsvd[3]
[ 3034.785159] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
[ 3034.785161] xhci_hcd 0000:00:14.0: @ffff88004ac58020 (virt) @4ac58020 (dma) 0x000001 - ep_info
[ 3034.785163] xhci_hcd 0000:00:14.0: @ffff88004ac58024 (virt) @4ac58024 (dma) 0x400026 - ep_info2
[ 3034.785166] xhci_hcd 0000:00:14.0: @ffff88004ac58028 (virt) @4ac58028 (dma) 0x377f7001 - deq
[ 3034.785168] xhci_hcd 0000:00:14.0: @ffff88004ac58030 (virt) @4ac58030 (dma) 0x000000 - tx_info
[ 3034.785170] xhci_hcd 0000:00:14.0: @ffff88004ac58034 (virt) @4ac58034 (dma) 0x000000 - rsvd[0]
[ 3034.785173] xhci_hcd 0000:00:14.0: @ffff88004ac58038 (virt) @4ac58038 (dma) 0x000000 - rsvd[1]
[ 3034.785175] xhci_hcd 0000:00:14.0: @ffff88004ac5803c (virt) @4ac5803c (dma) 0x000000 - rsvd[2]
[ 3034.785177] xhci_hcd 0000:00:14.0: OUT Endpoint 01 Context (ep_index 01):
[ 3034.785179] xhci_hcd 0000:00:14.0: @ffff88004ac58040 (virt) @4ac58040 (dma) 0x000000 - ep_info
[ 3034.785182] xhci_hcd 0000:00:14.0: @ffff88004ac58044 (virt) @4ac58044 (dma) 0x000000 - ep_info2
[ 3034.785184] xhci_hcd 0000:00:14.0: @ffff88004ac58048 (virt) @4ac58048 (dma) 0x000000 - deq
[ 3034.785186] xhci_hcd 0000:00:14.0: @ffff88004ac58050 (virt) @4ac58050 (dma) 0x000000 - tx_info
[ 3034.785189] xhci_hcd 0000:00:14.0: @ffff88004ac58054 (virt) @4ac58054 (dma) 0x000000 - rsvd[0]
[ 3034.785191] xhci_hcd 0000:00:14.0: @ffff88004ac58058 (virt) @4ac58058 (dma) 0x000000 - rsvd[1]
[ 3034.785193] xhci_hcd 0000:00:14.0: @ffff88004ac5805c (virt) @4ac5805c (dma) 0x000000 - rsvd[2]
[ 3034.785196] xhci_hcd 0000:00:14.0: IN Endpoint 01 Context (ep_index 02):
[ 3034.785198] xhci_hcd 0000:00:14.0: @ffff88004ac58060 (virt) @4ac58060 (dma) 0x000000 - ep_info
[ 3034.785200] xhci_hcd 0000:00:14.0: @ffff88004ac58064 (virt) @4ac58064 (dma) 0x000000 - ep_info2
[ 3034.785202] xhci_hcd 0000:00:14.0: @ffff88004ac58068 (virt) @4ac58068 (dma) 0x000000 - deq
[ 3034.785205] xhci_hcd 0000:00:14.0: @ffff88004ac58070 (virt) @4ac58070 (dma) 0x000000 - tx_info
[ 3034.785207] xhci_hcd 0000:00:14.0: @ffff88004ac58074 (virt) @4ac58074 (dma) 0x000000 - rsvd[0]
[ 3034.785209] xhci_hcd 0000:00:14.0: @ffff88004ac58078 (virt) @4ac58078 (dma) 0x000000 - rsvd[1]
[ 3034.785212] xhci_hcd 0000:00:14.0: @ffff88004ac5807c (virt) @4ac5807c (dma) 0x000000 - rsvd[2]
[ 3034.785214] xhci_hcd 0000:00:14.0: Internal device address = 0
[ 3034.785387] xhci_hcd 0000:00:14.0: Waiting for status stage event
[ 3034.785404] xhci_hcd 0000:00:14.0: set port reset, actual port 4 status  = 0x791
[ 3034.835888] xhci_hcd 0000:00:14.0: get port status, actual port 4 status  = 0x791
[ 3034.835894] xhci_hcd 0000:00:14.0: Get port status returned 0x111
[ 3034.840611] xhci_hcd 0000:00:14.0: Port Status Change Event for port 5
[ 3034.840619] xhci_hcd 0000:00:14.0: handle_port_status: starting port polling.
[ 3034.886884] xhci_hcd 0000:00:14.0: get port status, actual port 4 status  = 0x200603
[ 3034.886889] xhci_hcd 0000:00:14.0: Get port status returned 0x100103
[ 3034.886909] xhci_hcd 0000:00:14.0: clear port reset change, actual port 4 status  = 0x603
[ 3034.937880] xhci_hcd 0000:00:14.0: Resetting device with slot ID 5
[ 3034.937888] xhci_hcd 0000:00:14.0: // Ding dong!
[ 3034.937897] xhci_hcd 0000:00:14.0: Completed reset device command.
[ 3034.937905] xhci_hcd 0000:00:14.0: Can't reset device (slot ID 5) in default state
[ 3034.937907] xhci_hcd 0000:00:14.0: Not freeing device rings.
[ 3034.937913] xhci_hcd 0000:00:14.0: Slot ID 5 Input Context:
[ 3034.937917] xhci_hcd 0000:00:14.0: @ffff88003750b000 (virt) @3750b000 (dma) 0x000000 - drop flags
[ 3034.937920] xhci_hcd 0000:00:14.0: @ffff88003750b004 (virt) @3750b004 (dma) 0x000003 - add flags
[ 3034.937922] xhci_hcd 0000:00:14.0: @ffff88003750b008 (virt) @3750b008 (dma) 0x000000 - rsvd2[0]
[ 3034.937925] xhci_hcd 0000:00:14.0: @ffff88003750b00c (virt) @3750b00c (dma) 0x000000 - rsvd2[1]
[ 3034.937927] xhci_hcd 0000:00:14.0: @ffff88003750b010 (virt) @3750b010 (dma) 0x000000 - rsvd2[2]
[ 3034.937930] xhci_hcd 0000:00:14.0: @ffff88003750b014 (virt) @3750b014 (dma) 0x000000 - rsvd2[3]
[ 3034.937932] xhci_hcd 0000:00:14.0: @ffff88003750b018 (virt) @3750b018 (dma) 0x000000 - rsvd2[4]
[ 3034.937934] xhci_hcd 0000:00:14.0: @ffff88003750b01c (virt) @3750b01c (dma) 0x000000 - rsvd2[5]
[ 3034.937936] xhci_hcd 0000:00:14.0: Slot Context:
[ 3034.937939] xhci_hcd 0000:00:14.0: @ffff88003750b020 (virt) @3750b020 (dma) 0x8100000 - dev_info
[ 3034.937941] xhci_hcd 0000:00:14.0: @ffff88003750b024 (virt) @3750b024 (dma) 0x050000 - dev_info2
[ 3034.937944] xhci_hcd 0000:00:14.0: @ffff88003750b028 (virt) @3750b028 (dma) 0x000000 - tt_info
[ 3034.937946] xhci_hcd 0000:00:14.0: @ffff88003750b02c (virt) @3750b02c (dma) 0x000000 - dev_state
[ 3034.937949] xhci_hcd 0000:00:14.0: @ffff88003750b030 (virt) @3750b030 (dma) 0x000000 - rsvd[0]
[ 3034.937951] xhci_hcd 0000:00:14.0: @ffff88003750b034 (virt) @3750b034 (dma) 0x000000 - rsvd[1]
[ 3034.937954] xhci_hcd 0000:00:14.0: @ffff88003750b038 (virt) @3750b038 (dma) 0x000000 - rsvd[2]
[ 3034.937956] xhci_hcd 0000:00:14.0: @ffff88003750b03c (virt) @3750b03c (dma) 0x000000 - rsvd[3]
[ 3034.937959] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
[ 3034.937961] xhci_hcd 0000:00:14.0: @ffff88003750b040 (virt) @3750b040 (dma) 0x000000 - ep_info
[ 3034.937964] xhci_hcd 0000:00:14.0: @ffff88003750b044 (virt) @3750b044 (dma) 0x400026 - ep_info2
[ 3034.937966] xhci_hcd 0000:00:14.0: @ffff88003750b048 (virt) @3750b048 (dma) 0x377f7031 - deq
[ 3034.937969] xhci_hcd 0000:00:14.0: @ffff88003750b050 (virt) @3750b050 (dma) 0x000000 - tx_info
[ 3034.937971] xhci_hcd 0000:00:14.0: @ffff88003750b054 (virt) @3750b054 (dma) 0x000000 - rsvd[0]
[ 3034.937974] xhci_hcd 0000:00:14.0: @ffff88003750b058 (virt) @3750b058 (dma) 0x000000 - rsvd[1]
[ 3034.937976] xhci_hcd 0000:00:14.0: @ffff88003750b05c (virt) @3750b05c (dma) 0x000000 - rsvd[2]
[ 3034.937978] xhci_hcd 0000:00:14.0: OUT Endpoint 01 Context (ep_index 01):
[ 3034.937981] xhci_hcd 0000:00:14.0: @ffff88003750b060 (virt) @3750b060 (dma) 0x000000 - ep_info
[ 3034.937983] xhci_hcd 0000:00:14.0: @ffff88003750b064 (virt) @3750b064 (dma) 0x000000 - ep_info2
[ 3034.937985] xhci_hcd 0000:00:14.0: @ffff88003750b068 (virt) @3750b068 (dma) 0x000000 - deq
[ 3034.937988] xhci_hcd 0000:00:14.0: @ffff88003750b070 (virt) @3750b070 (dma) 0x000000 - tx_info
[ 3034.937990] xhci_hcd 0000:00:14.0: @ffff88003750b074 (virt) @3750b074 (dma) 0x000000 - rsvd[0]
[ 3034.937992] xhci_hcd 0000:00:14.0: @ffff88003750b078 (virt) @3750b078 (dma) 0x000000 - rsvd[1]
[ 3034.937995] xhci_hcd 0000:00:14.0: @ffff88003750b07c (virt) @3750b07c (dma) 0x000000 - rsvd[2]
[ 3034.937997] xhci_hcd 0000:00:14.0: IN Endpoint 01 Context (ep_index 02):
[ 3034.937999] xhci_hcd 0000:00:14.0: @ffff88003750b080 (virt) @3750b080 (dma) 0x000000 - ep_info
[ 3034.938002] xhci_hcd 0000:00:14.0: @ffff88003750b084 (virt) @3750b084 (dma) 0x000000 - ep_info2
[ 3034.938004] xhci_hcd 0000:00:14.0: @ffff88003750b088 (virt) @3750b088 (dma) 0x000000 - deq
[ 3034.938006] xhci_hcd 0000:00:14.0: @ffff88003750b090 (virt) @3750b090 (dma) 0x000000 - tx_info
[ 3034.938008] xhci_hcd 0000:00:14.0: @ffff88003750b094 (virt) @3750b094 (dma) 0x000000 - rsvd[0]
[ 3034.938011] xhci_hcd 0000:00:14.0: @ffff88003750b098 (virt) @3750b098 (dma) 0x000000 - rsvd[1]
[ 3034.938013] xhci_hcd 0000:00:14.0: @ffff88003750b09c (virt) @3750b09c (dma) 0x000000 - rsvd[2]
[ 3034.938016] xhci_hcd 0000:00:14.0: // Ding dong!
[ 3034.938195] xhci_hcd 0000:00:14.0: Successful setup address command
[ 3034.938202] xhci_hcd 0000:00:14.0: Op regs DCBAA ptr = 0x00000079b14000
[ 3034.938206] xhci_hcd 0000:00:14.0: Slot ID 5 dcbaa entry @ffff880079b14028 = 0x0000004ac58000
[ 3034.938209] xhci_hcd 0000:00:14.0: Output Context DMA address = 0x4ac58000
[ 3034.938212] xhci_hcd 0000:00:14.0: Slot ID 5 Input Context:
[ 3034.938215] xhci_hcd 0000:00:14.0: @ffff88003750b000 (virt) @3750b000 (dma) 0x000000 - drop flags
[ 3034.938218] xhci_hcd 0000:00:14.0: @ffff88003750b004 (virt) @3750b004 (dma) 0x000003 - add flags
[ 3034.938220] xhci_hcd 0000:00:14.0: @ffff88003750b008 (virt) @3750b008 (dma) 0x000000 - rsvd2[0]
[ 3034.938223] xhci_hcd 0000:00:14.0: @ffff88003750b00c (virt) @3750b00c (dma) 0x000000 - rsvd2[1]
[ 3034.938225] xhci_hcd 0000:00:14.0: @ffff88003750b010 (virt) @3750b010 (dma) 0x000000 - rsvd2[2]
[ 3034.938228] xhci_hcd 0000:00:14.0: @ffff88003750b014 (virt) @3750b014 (dma) 0x000000 - rsvd2[3]
[ 3034.938230] xhci_hcd 0000:00:14.0: @ffff88003750b018 (virt) @3750b018 (dma) 0x000000 - rsvd2[4]
[ 3034.938232] xhci_hcd 0000:00:14.0: @ffff88003750b01c (virt) @3750b01c (dma) 0x000000 - rsvd2[5]
[ 3034.938234] xhci_hcd 0000:00:14.0: Slot Context:
[ 3034.938237] xhci_hcd 0000:00:14.0: @ffff88003750b020 (virt) @3750b020 (dma) 0x8100000 - dev_info
[ 3034.938239] xhci_hcd 0000:00:14.0: @ffff88003750b024 (virt) @3750b024 (dma) 0x050000 - dev_info2
[ 3034.938242] xhci_hcd 0000:00:14.0: @ffff88003750b028 (virt) @3750b028 (dma) 0x000000 - tt_info
[ 3034.938244] xhci_hcd 0000:00:14.0: @ffff88003750b02c (virt) @3750b02c (dma) 0x000000 - dev_state
[ 3034.938247] xhci_hcd 0000:00:14.0: @ffff88003750b030 (virt) @3750b030 (dma) 0x000000 - rsvd[0]
[ 3034.938249] xhci_hcd 0000:00:14.0: @ffff88003750b034 (virt) @3750b034 (dma) 0x000000 - rsvd[1]
[ 3034.938252] xhci_hcd 0000:00:14.0: @ffff88003750b038 (virt) @3750b038 (dma) 0x000000 - rsvd[2]
[ 3034.938254] xhci_hcd 0000:00:14.0: @ffff88003750b03c (virt) @3750b03c (dma) 0x000000 - rsvd[3]
[ 3034.938257] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
[ 3034.938259] xhci_hcd 0000:00:14.0: @ffff88003750b040 (virt) @3750b040 (dma) 0x000000 - ep_info
[ 3034.938262] xhci_hcd 0000:00:14.0: @ffff88003750b044 (virt) @3750b044 (dma) 0x400026 - ep_info2
[ 3034.938264] xhci_hcd 0000:00:14.0: @ffff88003750b048 (virt) @3750b048 (dma) 0x377f7031 - deq
[ 3034.938267] xhci_hcd 0000:00:14.0: @ffff88003750b050 (virt) @3750b050 (dma) 0x000000 - tx_info
[ 3034.938269] xhci_hcd 0000:00:14.0: @ffff88003750b054 (virt) @3750b054 (dma) 0x000000 - rsvd[0]
[ 3034.938272] xhci_hcd 0000:00:14.0: @ffff88003750b058 (virt) @3750b058 (dma) 0x000000 - rsvd[1]
[ 3034.938274] xhci_hcd 0000:00:14.0: @ffff88003750b05c (virt) @3750b05c (dma) 0x000000 - rsvd[2]
[ 3034.938276] xhci_hcd 0000:00:14.0: OUT Endpoint 01 Context (ep_index 01):
[ 3034.938279] xhci_hcd 0000:00:14.0: @ffff88003750b060 (virt) @3750b060 (dma) 0x000000 - ep_info
[ 3034.938281] xhci_hcd 0000:00:14.0: @ffff88003750b064 (virt) @3750b064 (dma) 0x000000 - ep_info2
[ 3034.938283] xhci_hcd 0000:00:14.0: @ffff88003750b068 (virt) @3750b068 (dma) 0x000000 - deq
[ 3034.938286] xhci_hcd 0000:00:14.0: @ffff88003750b070 (virt) @3750b070 (dma) 0x000000 - tx_info
[ 3034.938288] xhci_hcd 0000:00:14.0: @ffff88003750b074 (virt) @3750b074 (dma) 0x000000 - rsvd[0]
[ 3034.938290] xhci_hcd 0000:00:14.0: @ffff88003750b078 (virt) @3750b078 (dma) 0x000000 - rsvd[1]
[ 3034.938293] xhci_hcd 0000:00:14.0: @ffff88003750b07c (virt) @3750b07c (dma) 0x000000 - rsvd[2]
[ 3034.938295] xhci_hcd 0000:00:14.0: IN Endpoint 01 Context (ep_index 02):
[ 3034.938297] xhci_hcd 0000:00:14.0: @ffff88003750b080 (virt) @3750b080 (dma) 0x000000 - ep_info
[ 3034.938299] xhci_hcd 0000:00:14.0: @ffff88003750b084 (virt) @3750b084 (dma) 0x000000 - ep_info2
[ 3034.938302] xhci_hcd 0000:00:14.0: @ffff88003750b088 (virt) @3750b088 (dma) 0x000000 - deq
[ 3034.938304] xhci_hcd 0000:00:14.0: @ffff88003750b090 (virt) @3750b090 (dma) 0x000000 - tx_info
[ 3034.938306] xhci_hcd 0000:00:14.0: @ffff88003750b094 (virt) @3750b094 (dma) 0x000000 - rsvd[0]
[ 3034.938309] xhci_hcd 0000:00:14.0: @ffff88003750b098 (virt) @3750b098 (dma) 0x000000 - rsvd[1]
[ 3034.938311] xhci_hcd 0000:00:14.0: @ffff88003750b09c (virt) @3750b09c (dma) 0x000000 - rsvd[2]
[ 3034.938313] xhci_hcd 0000:00:14.0: Slot ID 5 Output Context:
[ 3034.938315] xhci_hcd 0000:00:14.0: Slot Context:
[ 3034.938318] xhci_hcd 0000:00:14.0: @ffff88004ac58000 (virt) @4ac58000 (dma) 0x8100000 - dev_info
[ 3034.938320] xhci_hcd 0000:00:14.0: @ffff88004ac58004 (virt) @4ac58004 (dma) 0x050000 - dev_info2
[ 3034.938322] xhci_hcd 0000:00:14.0: @ffff88004ac58008 (virt) @4ac58008 (dma) 0x000000 - tt_info
[ 3034.938324] xhci_hcd 0000:00:14.0: @ffff88004ac5800c (virt) @4ac5800c (dma) 0x10000005 - dev_state
[ 3034.938327] xhci_hcd 0000:00:14.0: @ffff88004ac58010 (virt) @4ac58010 (dma) 0x000000 - rsvd[0]
[ 3034.938329] xhci_hcd 0000:00:14.0: @ffff88004ac58014 (virt) @4ac58014 (dma) 0x000000 - rsvd[1]
[ 3034.938332] xhci_hcd 0000:00:14.0: @ffff88004ac58018 (virt) @4ac58018 (dma) 0x000000 - rsvd[2]
[ 3034.938334] xhci_hcd 0000:00:14.0: @ffff88004ac5801c (virt) @4ac5801c (dma) 0x000000 - rsvd[3]
[ 3034.938336] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
[ 3034.938338] xhci_hcd 0000:00:14.0: @ffff88004ac58020 (virt) @4ac58020 (dma) 0x000001 - ep_info
[ 3034.938341] xhci_hcd 0000:00:14.0: @ffff88004ac58024 (virt) @4ac58024 (dma) 0x400026 - ep_info2
[ 3034.938343] xhci_hcd 0000:00:14.0: @ffff88004ac58028 (virt) @4ac58028 (dma) 0x377f7031 - deq
[ 3034.938345] xhci_hcd 0000:00:14.0: @ffff88004ac58030 (virt) @4ac58030 (dma) 0x000000 - tx_info
[ 3034.938348] xhci_hcd 0000:00:14.0: @ffff88004ac58034 (virt) @4ac58034 (dma) 0x000000 - rsvd[0]
[ 3034.938350] xhci_hcd 0000:00:14.0: @ffff88004ac58038 (virt) @4ac58038 (dma) 0x000000 - rsvd[1]
[ 3034.938352] xhci_hcd 0000:00:14.0: @ffff88004ac5803c (virt) @4ac5803c (dma) 0x000000 - rsvd[2]
[ 3034.938354] xhci_hcd 0000:00:14.0: OUT Endpoint 01 Context (ep_index 01):
[ 3034.938357] xhci_hcd 0000:00:14.0: @ffff88004ac58040 (virt) @4ac58040 (dma) 0x000000 - ep_info
[ 3034.938359] xhci_hcd 0000:00:14.0: @ffff88004ac58044 (virt) @4ac58044 (dma) 0x000000 - ep_info2
[ 3034.938361] xhci_hcd 0000:00:14.0: @ffff88004ac58048 (virt) @4ac58048 (dma) 0x000000 - deq
[ 3034.938364] xhci_hcd 0000:00:14.0: @ffff88004ac58050 (virt) @4ac58050 (dma) 0x000000 - tx_info
[ 3034.938366] xhci_hcd 0000:00:14.0: @ffff88004ac58054 (virt) @4ac58054 (dma) 0x000000 - rsvd[0]
[ 3034.938368] xhci_hcd 0000:00:14.0: @ffff88004ac58058 (virt) @4ac58058 (dma) 0x000000 - rsvd[1]
[ 3034.938371] xhci_hcd 0000:00:14.0: @ffff88004ac5805c (virt) @4ac5805c (dma) 0x000000 - rsvd[2]
[ 3034.938373] xhci_hcd 0000:00:14.0: IN Endpoint 01 Context (ep_index 02):
[ 3034.938375] xhci_hcd 0000:00:14.0: @ffff88004ac58060 (virt) @4ac58060 (dma) 0x000000 - ep_info
[ 3034.938377] xhci_hcd 0000:00:14.0: @ffff88004ac58064 (virt) @4ac58064 (dma) 0x000000 - ep_info2
[ 3034.938380] xhci_hcd 0000:00:14.0: @ffff88004ac58068 (virt) @4ac58068 (dma) 0x000000 - deq
[ 3034.938382] xhci_hcd 0000:00:14.0: @ffff88004ac58070 (virt) @4ac58070 (dma) 0x000000 - tx_info
[ 3034.938384] xhci_hcd 0000:00:14.0: @ffff88004ac58074 (virt) @4ac58074 (dma) 0x000000 - rsvd[0]
[ 3034.938387] xhci_hcd 0000:00:14.0: @ffff88004ac58078 (virt) @4ac58078 (dma) 0x000000 - rsvd[1]
[ 3034.938389] xhci_hcd 0000:00:14.0: @ffff88004ac5807c (virt) @4ac5807c (dma) 0x000000 - rsvd[2]
[ 3034.938391] xhci_hcd 0000:00:14.0: Internal device address = 5
[ 3034.938396] xhci_hcd 0000:00:14.0: Endpoint 0x0 ep reset callback called
[ 3034.948809] xhci_hcd 0000:00:14.0: Endpoint 0x0 ep reset callback called
[ 3034.948818] xhci_hcd 0000:00:14.0: Max Packet Size for ep 0 changed.
[ 3034.948820] xhci_hcd 0000:00:14.0: Max packet size in usb_device = 8
[ 3034.948823] xhci_hcd 0000:00:14.0: Max packet size in xHCI HW = 64
[ 3034.948825] xhci_hcd 0000:00:14.0: Issuing evaluate context command.
[ 3034.948828] xhci_hcd 0000:00:14.0: Slot 5 input context
[ 3034.948831] xhci_hcd 0000:00:14.0: @ffff88003750b000 (virt) @3750b000 (dma) 0x000000 - drop flags
[ 3034.948834] xhci_hcd 0000:00:14.0: @ffff88003750b004 (virt) @3750b004 (dma) 0x000002 - add flags
[ 3034.948836] xhci_hcd 0000:00:14.0: @ffff88003750b008 (virt) @3750b008 (dma) 0x000000 - rsvd2[0]
[ 3034.948839] xhci_hcd 0000:00:14.0: @ffff88003750b00c (virt) @3750b00c (dma) 0x000000 - rsvd2[1]
[ 3034.948841] xhci_hcd 0000:00:14.0: @ffff88003750b010 (virt) @3750b010 (dma) 0x000000 - rsvd2[2]
[ 3034.948843] xhci_hcd 0000:00:14.0: @ffff88003750b014 (virt) @3750b014 (dma) 0x000000 - rsvd2[3]
[ 3034.948846] xhci_hcd 0000:00:14.0: @ffff88003750b018 (virt) @3750b018 (dma) 0x000000 - rsvd2[4]
[ 3034.948848] xhci_hcd 0000:00:14.0: @ffff88003750b01c (virt) @3750b01c (dma) 0x000000 - rsvd2[5]
[ 3034.948850] xhci_hcd 0000:00:14.0: Slot Context:
[ 3034.948853] xhci_hcd 0000:00:14.0: @ffff88003750b020 (virt) @3750b020 (dma) 0x8100000 - dev_info
[ 3034.948855] xhci_hcd 0000:00:14.0: @ffff88003750b024 (virt) @3750b024 (dma) 0x050000 - dev_info2
[ 3034.948857] xhci_hcd 0000:00:14.0: @ffff88003750b028 (virt) @3750b028 (dma) 0x000000 - tt_info
[ 3034.948859] xhci_hcd 0000:00:14.0: @ffff88003750b02c (virt) @3750b02c (dma) 0x000000 - dev_state
[ 3034.948862] xhci_hcd 0000:00:14.0: @ffff88003750b030 (virt) @3750b030 (dma) 0x000000 - rsvd[0]
[ 3034.948864] xhci_hcd 0000:00:14.0: @ffff88003750b034 (virt) @3750b034 (dma) 0x000000 - rsvd[1]
[ 3034.948867] xhci_hcd 0000:00:14.0: @ffff88003750b038 (virt) @3750b038 (dma) 0x000000 - rsvd[2]
[ 3034.948869] xhci_hcd 0000:00:14.0: @ffff88003750b03c (virt) @3750b03c (dma) 0x000000 - rsvd[3]
[ 3034.948872] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
[ 3034.948874] xhci_hcd 0000:00:14.0: @ffff88003750b040 (virt) @3750b040 (dma) 0x000001 - ep_info
[ 3034.948877] xhci_hcd 0000:00:14.0: @ffff88003750b044 (virt) @3750b044 (dma) 0x080026 - ep_info2
[ 3034.948879] xhci_hcd 0000:00:14.0: @ffff88003750b048 (virt) @3750b048 (dma) 0x377f7031 - deq
[ 3034.948882] xhci_hcd 0000:00:14.0: @ffff88003750b050 (virt) @3750b050 (dma) 0x000000 - tx_info
[ 3034.948884] xhci_hcd 0000:00:14.0: @ffff88003750b054 (virt) @3750b054 (dma) 0x000000 - rsvd[0]
[ 3034.948886] xhci_hcd 0000:00:14.0: @ffff88003750b058 (virt) @3750b058 (dma) 0x000000 - rsvd[1]
[ 3034.948888] xhci_hcd 0000:00:14.0: @ffff88003750b05c (virt) @3750b05c (dma) 0x000000 - rsvd[2]
[ 3034.948891] xhci_hcd 0000:00:14.0: Slot 5 output context
[ 3034.948893] xhci_hcd 0000:00:14.0: Slot Context:
[ 3034.948895] xhci_hcd 0000:00:14.0: @ffff88004ac58000 (virt) @4ac58000 (dma) 0x8100000 - dev_info
[ 3034.948897] xhci_hcd 0000:00:14.0: @ffff88004ac58004 (virt) @4ac58004 (dma) 0x050000 - dev_info2
[ 3034.948900] xhci_hcd 0000:00:14.0: @ffff88004ac58008 (virt) @4ac58008 (dma) 0x000000 - tt_info
[ 3034.948902] xhci_hcd 0000:00:14.0: @ffff88004ac5800c (virt) @4ac5800c (dma) 0x10000005 - dev_state
[ 3034.948904] xhci_hcd 0000:00:14.0: @ffff88004ac58010 (virt) @4ac58010 (dma) 0x000000 - rsvd[0]
[ 3034.948907] xhci_hcd 0000:00:14.0: @ffff88004ac58014 (virt) @4ac58014 (dma) 0x000000 - rsvd[1]
[ 3034.948909] xhci_hcd 0000:00:14.0: @ffff88004ac58018 (virt) @4ac58018 (dma) 0x000000 - rsvd[2]
[ 3034.948911] xhci_hcd 0000:00:14.0: @ffff88004ac5801c (virt) @4ac5801c (dma) 0x000000 - rsvd[3]
[ 3034.948913] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
[ 3034.948916] xhci_hcd 0000:00:14.0: @ffff88004ac58020 (virt) @4ac58020 (dma) 0x000001 - ep_info
[ 3034.948918] xhci_hcd 0000:00:14.0: @ffff88004ac58024 (virt) @4ac58024 (dma) 0x400026 - ep_info2
[ 3034.948920] xhci_hcd 0000:00:14.0: @ffff88004ac58028 (virt) @4ac58028 (dma) 0x377f7031 - deq
[ 3034.948923] xhci_hcd 0000:00:14.0: @ffff88004ac58030 (virt) @4ac58030 (dma) 0x000000 - tx_info
[ 3034.948925] xhci_hcd 0000:00:14.0: @ffff88004ac58034 (virt) @4ac58034 (dma) 0x000000 - rsvd[0]
[ 3034.948927] xhci_hcd 0000:00:14.0: @ffff88004ac58038 (virt) @4ac58038 (dma) 0x000000 - rsvd[1]
[ 3034.948930] xhci_hcd 0000:00:14.0: @ffff88004ac5803c (virt) @4ac5803c (dma) 0x000000 - rsvd[2]
[ 3034.948934] xhci_hcd 0000:00:14.0: // Ding dong!
[ 3034.948966] xhci_hcd 0000:00:14.0: Successful evaluate context command
[ 3034.949395] xhci_hcd 0000:00:14.0: Stalled endpoint
[ 3034.949402] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[ 3034.949405] xhci_hcd 0000:00:14.0: Finding endpoint context
[ 3034.949407] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[ 3034.949410] xhci_hcd 0000:00:14.0: New dequeue segment = ffff880153a48d00 (virtual)
[ 3034.949412] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x377f7090 (DMA)
[ 3034.949414] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[ 3034.949418] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff880153a48d00 (0x377f7000 dma), new deq ptr = ffff8800377f7090 (0x377f7090 dma), new cycle = 1
[ 3034.949420] xhci_hcd 0000:00:14.0: // Ding dong!
[ 3034.949425] xhci_hcd 0000:00:14.0: Giveback URB ffff8800377baf00, len = 0, expected = 10, status = -32
[ 3034.949430] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[ 3034.949434] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @377f7090
[ 3034.949549] xhci_hcd 0000:00:14.0: Stalled endpoint
[ 3034.949553] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[ 3034.949555] xhci_hcd 0000:00:14.0: Finding endpoint context
[ 3034.949557] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[ 3034.949560] xhci_hcd 0000:00:14.0: New dequeue segment = ffff880153a48d00 (virtual)
[ 3034.949562] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x377f70c0 (DMA)
[ 3034.949564] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[ 3034.949567] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff880153a48d00 (0x377f7000 dma), new deq ptr = ffff8800377f70c0 (0x377f70c0 dma), new cycle = 1
[ 3034.949569] xhci_hcd 0000:00:14.0: // Ding dong!
[ 3034.949573] xhci_hcd 0000:00:14.0: Giveback URB ffff8800377baf00, len = 0, expected = 10, status = -32
[ 3034.949577] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[ 3034.949580] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @377f70c0
[ 3034.949643] xhci_hcd 0000:00:14.0: Stalled endpoint
[ 3034.949646] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[ 3034.949648] xhci_hcd 0000:00:14.0: Finding endpoint context
[ 3034.949650] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[ 3034.949653] xhci_hcd 0000:00:14.0: New dequeue segment = ffff880153a48d00 (virtual)
[ 3034.949655] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x377f70f0 (DMA)
[ 3034.949657] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[ 3034.949659] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff880153a48d00 (0x377f7000 dma), new deq ptr = ffff8800377f70f0 (0x377f70f0 dma), new cycle = 1
[ 3034.949662] xhci_hcd 0000:00:14.0: // Ding dong!
[ 3034.949665] xhci_hcd 0000:00:14.0: Giveback URB ffff8800377baf00, len = 0, expected = 10, status = -32
[ 3034.949669] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[ 3034.949672] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @377f70f0
[ 3034.949919] xhci_hcd 0000:00:14.0: Transfer error on endpoint
[ 3034.949923] xhci_hcd 0000:00:14.0: TRB error code 4, halted endpoint index = 0
[ 3034.949926] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[ 3034.949929] xhci_hcd 0000:00:14.0: Finding endpoint context
[ 3034.949931] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[ 3034.949933] xhci_hcd 0000:00:14.0: New dequeue segment = ffff880153a48d00 (virtual)
[ 3034.949935] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x377f7150 (DMA)
[ 3034.949937] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[ 3034.949940] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff880153a48d00 (0x377f7000 dma), new deq ptr = ffff8800377f7150 (0x377f7150 dma), new cycle = 1
[ 3034.949942] xhci_hcd 0000:00:14.0: // Ding dong!
[ 3034.949946] xhci_hcd 0000:00:14.0: Giveback URB ffff8800377baf00, len = 0, expected = 32, status = -71
[ 3034.949950] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[ 3034.949953] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @377f7150
[ 3034.950403] usb 2-5: config 1 interface 0 altsetting 0 endpoint 0x1 has an invalid bInterval 0, changing to 32
[ 3034.950408] usb 2-5: config 1 interface 0 altsetting 0 endpoint 0x81 has an invalid bInterval 0, changing to 32
[ 3034.950464] xhci_hcd 0000:00:14.0: Transfer error on endpoint
[ 3034.950467] xhci_hcd 0000:00:14.0: TRB error code 4, halted endpoint index = 0
[ 3034.950472] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[ 3034.950474] xhci_hcd 0000:00:14.0: Finding endpoint context
[ 3034.950476] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[ 3034.950479] xhci_hcd 0000:00:14.0: New dequeue segment = ffff880153a48d00 (virtual)
[ 3034.950481] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x377f71b0 (DMA)
[ 3034.950483] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[ 3034.950487] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff880153a48d00 (0x377f7000 dma), new deq ptr = ffff8800377f71b0 (0x377f71b0 dma), new cycle = 1
[ 3034.950489] xhci_hcd 0000:00:14.0: // Ding dong!
[ 3034.950493] xhci_hcd 0000:00:14.0: Giveback URB ffff8800377bacc0, len = 0, expected = 255, status = -71
[ 3034.950496] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[ 3034.950500] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @377f71b0
[ 3034.950691] xhci_hcd 0000:00:14.0: Transfer error on endpoint
[ 3034.950694] xhci_hcd 0000:00:14.0: TRB error code 4, halted endpoint index = 0
[ 3034.950697] xhci_hcd 0000:00:14.0: Cleaning up stalled endpoint ring
[ 3034.950699] xhci_hcd 0000:00:14.0: Finding endpoint context
[ 3034.950701] xhci_hcd 0000:00:14.0: Cycle state = 0x1
[ 3034.950703] xhci_hcd 0000:00:14.0: New dequeue segment = ffff880153a48d00 (virtual)
[ 3034.950706] xhci_hcd 0000:00:14.0: New dequeue pointer = 0x377f7210 (DMA)
[ 3034.950709] xhci_hcd 0000:00:14.0: Queueing new dequeue state
[ 3034.950712] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff880153a48d00 (0x377f7000 dma), new deq ptr = ffff8800377f7210 (0x377f7210 dma), new cycle = 1
[ 3034.950714] xhci_hcd 0000:00:14.0: // Ding dong!
[ 3034.950718] xhci_hcd 0000:00:14.0: Giveback URB ffff8800377bacc0, len = 0, expected = 4, status = -71
[ 3034.950721] xhci_hcd 0000:00:14.0: Ignoring reset ep completion code of 1
[ 3034.950724] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @377f7210
[ 3034.950729] usb 2-5: string descriptor 0 read error: -71
[ 3034.950734] usb 2-5: New USB device found, idVendor=1784, idProduct=0006
[ 3034.950737] usb 2-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[ 3034.951283] xhci_hcd 0000:00:14.0: add ep 0x1, slot id 5, new drop flags = 0x0, new add flags = 0x5
[ 3034.951290] xhci_hcd 0000:00:14.0: add ep 0x81, slot id 5, new drop flags = 0x0, new add flags = 0xd
[ 3034.951294] xhci_hcd 0000:00:14.0: xhci_check_bandwidth called for udev ffff88004ac16800
[ 3034.951297] xhci_hcd 0000:00:14.0: New Input Control Context:
[ 3034.951300] xhci_hcd 0000:00:14.0: @ffff88003750b000 (virt) @3750b000 (dma) 0x000000 - drop flags
[ 3034.951303] xhci_hcd 0000:00:14.0: @ffff88003750b004 (virt) @3750b004 (dma) 0x00000d - add flags
[ 3034.951305] xhci_hcd 0000:00:14.0: @ffff88003750b008 (virt) @3750b008 (dma) 0x000000 - rsvd2[0]
[ 3034.951307] xhci_hcd 0000:00:14.0: @ffff88003750b00c (virt) @3750b00c (dma) 0x000000 - rsvd2[1]
[ 3034.951310] xhci_hcd 0000:00:14.0: @ffff88003750b010 (virt) @3750b010 (dma) 0x000000 - rsvd2[2]
[ 3034.951312] xhci_hcd 0000:00:14.0: @ffff88003750b014 (virt) @3750b014 (dma) 0x000000 - rsvd2[3]
[ 3034.951314] xhci_hcd 0000:00:14.0: @ffff88003750b018 (virt) @3750b018 (dma) 0x000000 - rsvd2[4]
[ 3034.951317] xhci_hcd 0000:00:14.0: @ffff88003750b01c (virt) @3750b01c (dma) 0x000000 - rsvd2[5]
[ 3034.951319] xhci_hcd 0000:00:14.0: Slot Context:
[ 3034.951321] xhci_hcd 0000:00:14.0: @ffff88003750b020 (virt) @3750b020 (dma) 0x18100000 - dev_info
[ 3034.951324] xhci_hcd 0000:00:14.0: @ffff88003750b024 (virt) @3750b024 (dma) 0x050000 - dev_info2
[ 3034.951326] xhci_hcd 0000:00:14.0: @ffff88003750b028 (virt) @3750b028 (dma) 0x000000 - tt_info
[ 3034.951329] xhci_hcd 0000:00:14.0: @ffff88003750b02c (virt) @3750b02c (dma) 0x000000 - dev_state
[ 3034.951333] xhci_hcd 0000:00:14.0: @ffff88003750b030 (virt) @3750b030 (dma) 0x000000 - rsvd[0]
[ 3034.951336] xhci_hcd 0000:00:14.0: @ffff88003750b034 (virt) @3750b034 (dma) 0x000000 - rsvd[1]
[ 3034.951338] xhci_hcd 0000:00:14.0: @ffff88003750b038 (virt) @3750b038 (dma) 0x000000 - rsvd[2]
[ 3034.951340] xhci_hcd 0000:00:14.0: @ffff88003750b03c (virt) @3750b03c (dma) 0x000000 - rsvd[3]
[ 3034.951343] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
[ 3034.951345] xhci_hcd 0000:00:14.0: @ffff88003750b040 (virt) @3750b040 (dma) 0x000001 - ep_info
[ 3034.951348] xhci_hcd 0000:00:14.0: @ffff88003750b044 (virt) @3750b044 (dma) 0x080026 - ep_info2
[ 3034.951350] xhci_hcd 0000:00:14.0: @ffff88003750b048 (virt) @3750b048 (dma) 0x377f7031 - deq
[ 3034.951352] xhci_hcd 0000:00:14.0: @ffff88003750b050 (virt) @3750b050 (dma) 0x000000 - tx_info
[ 3034.951355] xhci_hcd 0000:00:14.0: @ffff88003750b054 (virt) @3750b054 (dma) 0x000000 - rsvd[0]
[ 3034.951357] xhci_hcd 0000:00:14.0: @ffff88003750b058 (virt) @3750b058 (dma) 0x000000 - rsvd[1]
[ 3034.951360] xhci_hcd 0000:00:14.0: @ffff88003750b05c (virt) @3750b05c (dma) 0x000000 - rsvd[2]
[ 3034.951362] xhci_hcd 0000:00:14.0: OUT Endpoint 01 Context (ep_index 01):
[ 3034.951364] xhci_hcd 0000:00:14.0: @ffff88003750b060 (virt) @3750b060 (dma) 0x080000 - ep_info
[ 3034.951367] xhci_hcd 0000:00:14.0: @ffff88003750b064 (virt) @3750b064 (dma) 0x20001e - ep_info2
[ 3034.951369] xhci_hcd 0000:00:14.0: @ffff88003750b068 (virt) @3750b068 (dma) 0x29d84001 - deq
[ 3034.951371] xhci_hcd 0000:00:14.0: @ffff88003750b070 (virt) @3750b070 (dma) 0x200020 - tx_info
[ 3034.951374] xhci_hcd 0000:00:14.0: @ffff88003750b074 (virt) @3750b074 (dma) 0x000000 - rsvd[0]
[ 3034.951376] xhci_hcd 0000:00:14.0: @ffff88003750b078 (virt) @3750b078 (dma) 0x000000 - rsvd[1]
[ 3034.951378] xhci_hcd 0000:00:14.0: @ffff88003750b07c (virt) @3750b07c (dma) 0x000000 - rsvd[2]
[ 3034.951381] xhci_hcd 0000:00:14.0: IN Endpoint 01 Context (ep_index 02):
[ 3034.951383] xhci_hcd 0000:00:14.0: @ffff88003750b080 (virt) @3750b080 (dma) 0x080000 - ep_info
[ 3034.951385] xhci_hcd 0000:00:14.0: @ffff88003750b084 (virt) @3750b084 (dma) 0x20003e - ep_info2
[ 3034.951387] xhci_hcd 0000:00:14.0: @ffff88003750b088 (virt) @3750b088 (dma) 0x52497001 - deq
[ 3034.951390] xhci_hcd 0000:00:14.0: @ffff88003750b090 (virt) @3750b090 (dma) 0x200020 - tx_info
[ 3034.951392] xhci_hcd 0000:00:14.0: @ffff88003750b094 (virt) @3750b094 (dma) 0x000000 - rsvd[0]
[ 3034.951394] xhci_hcd 0000:00:14.0: @ffff88003750b098 (virt) @3750b098 (dma) 0x000000 - rsvd[1]
[ 3034.951397] xhci_hcd 0000:00:14.0: @ffff88003750b09c (virt) @3750b09c (dma) 0x000000 - rsvd[2]
[ 3034.951401] xhci_hcd 0000:00:14.0: // Ding dong!
[ 3034.952625] xhci_hcd 0000:00:14.0: Successful Endpoint Configure command
[ 3034.952630] xhci_hcd 0000:00:14.0: Output context after successful config ep cmd:
[ 3034.952632] xhci_hcd 0000:00:14.0: Slot Context:
[ 3034.952636] xhci_hcd 0000:00:14.0: @ffff88004ac58000 (virt) @4ac58000 (dma) 0x18100000 - dev_info
[ 3034.952638] xhci_hcd 0000:00:14.0: @ffff88004ac58004 (virt) @4ac58004 (dma) 0x050000 - dev_info2
[ 3034.952641] xhci_hcd 0000:00:14.0: @ffff88004ac58008 (virt) @4ac58008 (dma) 0x000000 - tt_info
[ 3034.952643] xhci_hcd 0000:00:14.0: @ffff88004ac5800c (virt) @4ac5800c (dma) 0x18000005 - dev_state
[ 3034.952646] xhci_hcd 0000:00:14.0: @ffff88004ac58010 (virt) @4ac58010 (dma) 0x000000 - rsvd[0]
[ 3034.952648] xhci_hcd 0000:00:14.0: @ffff88004ac58014 (virt) @4ac58014 (dma) 0x000000 - rsvd[1]
[ 3034.952651] xhci_hcd 0000:00:14.0: @ffff88004ac58018 (virt) @4ac58018 (dma) 0x000000 - rsvd[2]
[ 3034.952653] xhci_hcd 0000:00:14.0: @ffff88004ac5801c (virt) @4ac5801c (dma) 0x000000 - rsvd[3]
[ 3034.952656] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
[ 3034.952658] xhci_hcd 0000:00:14.0: @ffff88004ac58020 (virt) @4ac58020 (dma) 0x000003 - ep_info
[ 3034.952661] xhci_hcd 0000:00:14.0: @ffff88004ac58024 (virt) @4ac58024 (dma) 0x080026 - ep_info2
[ 3034.952663] xhci_hcd 0000:00:14.0: @ffff88004ac58028 (virt) @4ac58028 (dma) 0x377f7211 - deq
[ 3034.952666] xhci_hcd 0000:00:14.0: @ffff88004ac58030 (virt) @4ac58030 (dma) 0x000000 - tx_info
[ 3034.952668] xhci_hcd 0000:00:14.0: @ffff88004ac58034 (virt) @4ac58034 (dma) 0x000000 - rsvd[0]
[ 3034.952670] xhci_hcd 0000:00:14.0: @ffff88004ac58038 (virt) @4ac58038 (dma) 0x000000 - rsvd[1]
[ 3034.952673] xhci_hcd 0000:00:14.0: @ffff88004ac5803c (virt) @4ac5803c (dma) 0x000000 - rsvd[2]
[ 3034.952675] xhci_hcd 0000:00:14.0: OUT Endpoint 01 Context (ep_index 01):
[ 3034.952677] xhci_hcd 0000:00:14.0: @ffff88004ac58040 (virt) @4ac58040 (dma) 0x080001 - ep_info
[ 3034.952680] xhci_hcd 0000:00:14.0: @ffff88004ac58044 (virt) @4ac58044 (dma) 0x20001e - ep_info2
[ 3034.952682] xhci_hcd 0000:00:14.0: @ffff88004ac58048 (virt) @4ac58048 (dma) 0x29d84001 - deq
[ 3034.952684] xhci_hcd 0000:00:14.0: @ffff88004ac58050 (virt) @4ac58050 (dma) 0x200020 - tx_info
[ 3034.952687] xhci_hcd 0000:00:14.0: @ffff88004ac58054 (virt) @4ac58054 (dma) 0x000000 - rsvd[0]
[ 3034.952689] xhci_hcd 0000:00:14.0: @ffff88004ac58058 (virt) @4ac58058 (dma) 0x000000 - rsvd[1]
[ 3034.952691] xhci_hcd 0000:00:14.0: @ffff88004ac5805c (virt) @4ac5805c (dma) 0x000000 - rsvd[2]
[ 3034.952694] xhci_hcd 0000:00:14.0: IN Endpoint 01 Context (ep_index 02):
[ 3034.952696] xhci_hcd 0000:00:14.0: @ffff88004ac58060 (virt) @4ac58060 (dma) 0x080001 - ep_info
[ 3034.952698] xhci_hcd 0000:00:14.0: @ffff88004ac58064 (virt) @4ac58064 (dma) 0x20003e - ep_info2
[ 3034.952700] xhci_hcd 0000:00:14.0: @ffff88004ac58068 (virt) @4ac58068 (dma) 0x52497001 - deq
[ 3034.952703] xhci_hcd 0000:00:14.0: @ffff88004ac58070 (virt) @4ac58070 (dma) 0x200020 - tx_info
[ 3034.952705] xhci_hcd 0000:00:14.0: @ffff88004ac58074 (virt) @4ac58074 (dma) 0x000000 - rsvd[0]
[ 3034.952707] xhci_hcd 0000:00:14.0: @ffff88004ac58078 (virt) @4ac58078 (dma) 0x000000 - rsvd[1]
[ 3034.952710] xhci_hcd 0000:00:14.0: @ffff88004ac5807c (virt) @4ac5807c (dma) 0x000000 - rsvd[2]
[ 3034.952715] xhci_hcd 0000:00:14.0: Endpoint 0x1 ep reset callback called
[ 3034.952717] xhci_hcd 0000:00:14.0: Endpoint 0x81 ep reset callback called
[ 3034.952956] mceusb 2-5:1.0: mceusb_dev_probe called
[ 3034.952961] mceusb 2-5:1.0: acceptable interrupt outbound endpoint found
[ 3034.952964] mceusb 2-5:1.0: acceptable interrupt inbound endpoint found
[ 3034.952974] Registered IR keymap rc-rc6-mce
[ 3034.953113] input: Media Center Ed. eHome Infrared Remote Transceiver (1784:0006) as /devices/pci0000:00/0000:00:14.0/usb2/2-5/2-5:1.0/rc/rc0/input18
[ 3034.953450] rc0: Media Center Ed. eHome Infrared Remote Transceiver (1784:0006) as /devices/pci0000:00/0000:00:14.0/usb2/2-5/2-5:1.0/rc/rc0
[ 3034.953921] rc rc0: lirc_dev: driver ir-lirc-codec (mceusb) registered at minor = 0
[ 3034.954006] input: MCE IR Keyboard/Mouse (mceusb) as /devices/virtual/input/input19
[ 3034.956765] mceusb 2-5:1.0: Flushing receive buffers
[ 3034.956770] mceusb 2-5:1.0: receive request called (size=0x20)
[ 3034.956785] xhci_queue_intr_tx: 4 callbacks suppressed
[ 3034.956789] usb 2-5: Driver uses different interval (8 microframes) than xHCI (256 microframes)
[ 3034.956794] mceusb 2-5:1.0: receive request complete (res=0)
[ 3034.956797] mceusb 2-5:1.0: receive request called (size=0x2)
[ 3034.956801] usb 2-5: Driver uses different interval (8 microframes) than xHCI (256 microframes)
[ 3034.956803] mceusb 2-5:1.0: receive request complete (res=0)
[ 3034.967806] mceusb 2-5:1.0: receive request called (size=0x3)
[ 3034.967817] usb 2-5: Driver uses different interval (8 microframes) than xHCI (256 microframes)
[ 3034.967822] mceusb 2-5:1.0: receive request complete (res=0)
[ 3034.975123] mceusb 2-5:1.0: tx data: ff 22 (length=2)
[ 3034.978817] mceusb 2-5:1.0: receive request called (size=0x2)
[ 3034.978828] usb 2-5: Driver uses different interval (8 microframes) than xHCI (256 microframes)
[ 3034.978833] mceusb 2-5:1.0: receive request complete (res=0)
[ 3034.989792] mceusb 2-5:1.0: receive request called (size=0x2)
[ 3034.989804] usb 2-5: Driver uses different interval (8 microframes) than xHCI (256 microframes)
[ 3034.989809] mceusb 2-5:1.0: receive request complete (res=0)
[ 3034.994788] xhci_hcd 0000:00:14.0: xhci_hub_status_data: stopping port polling.
[ 3035.000790] mceusb 2-5:1.0: receive request called (size=0x2)
[ 3035.000802] usb 2-5: Driver uses different interval (8 microframes) than xHCI (256 microframes)
[ 3035.000807] mceusb 2-5:1.0: receive request complete (res=0)
[ 3035.007111] mceusb 2-5:1.0: tx data: 00 ff aa (length=3)
[ 3035.007116] mceusb 2-5:1.0: Device resume requested
[ 3035.007121] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 30 bytes untransferred
[ 3035.007124] mceusb 2-5:1.0: setup answer received 2 bytes
[ 3035.007127] mceusb 2-5:1.0: rx data: ff fe (length=2)
[ 3035.007129] mceusb 2-5:1.0: Illegal PORT_SYS command
[ 3035.011783] mceusb 2-5:1.0: receive request called (size=0x3)
[ 3035.011794] usb 2-5: Driver uses different interval (8 microframes) than xHCI (256 microframes)
[ 3035.011798] mceusb 2-5:1.0: receive request complete (res=0)
[ 3035.023803] mceusb 2-5:1.0: receive request called (size=0x2)
[ 3035.023816] usb 2-5: Driver uses different interval (8 microframes) than xHCI (256 microframes)
[ 3035.023821] mceusb 2-5:1.0: receive request complete (res=0)
[ 3035.034785] mceusb 2-5:1.0: receive request called (size=0x2)
[ 3035.034795] usb 2-5: Driver uses different interval (8 microframes) than xHCI (256 microframes)
[ 3035.034799] mceusb 2-5:1.0: receive request complete (res=0)
[ 3035.039106] mceusb 2-5:1.0: tx data: ff 18 (length=2)
[ 3035.045793] mceusb 2-5:1.0: receive request called (size=0x2)
[ 3035.045805] usb 2-5: Driver uses different interval (8 microframes) than xHCI (256 microframes)
[ 3035.045810] mceusb 2-5:1.0: receive request complete (res=0)
[ 3035.056783] mceusb 2-5:1.0: receive request called (size=0x2)
[ 3035.056796] mceusb 2-5:1.0: receive request complete (res=0)
[ 3035.067787] mceusb 2-5:1.0: receive request called (size=0x3)
[ 3035.067799] mceusb 2-5:1.0: receive request complete (res=0)
[ 3035.071107] mceusb 2-5:1.0: tx data: 9f 05 (length=2)
[ 3035.071112] mceusb 2-5:1.0: Unknown command 0x9f 0x05
[ 3035.071117] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 30 bytes untransferred
[ 3035.071121] mceusb 2-5:1.0: rx data: ff fe (length=2)
[ 3035.071123] mceusb 2-5:1.0: Illegal PORT_SYS command
[ 3035.078791] mceusb 2-5:1.0: receive request called (size=0x3)
[ 3035.078799] mceusb 2-5:1.0: receive request complete (res=0)
[ 3035.089783] mceusb 2-5:1.0: receive request called (size=0x3)
[ 3035.089793] mceusb 2-5:1.0: receive request complete (res=0)
[ 3035.100807] mceusb 2-5:1.0: Registered  with mce emulator interface version 1
[ 3035.100812] mceusb 2-5:1.0: 2 tx ports (0x0 cabled) and 2 rx sensors (0x0 active)
[ 3035.103108] mceusb 2-5:1.0: tx data: 9f 16 (length=2)
[ 3035.135110] mceusb 2-5:1.0: tx data: 00 ff aa (length=3)
[ 3035.135116] mceusb 2-5:1.0: Device resume requested
[ 3035.167173] mceusb 2-5:1.0: tx data: 9f 07 (length=2)
[ 3035.167179] mceusb 2-5:1.0: Get carrier mode and freq
[ 3035.199170] mceusb 2-5:1.0: tx data: 9f 13 (length=2)
[ 3035.199176] mceusb 2-5:1.0: Get transmit blaster mask
[ 3035.199182] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 28 bytes untransferred
[ 3035.199186] mceusb 2-5:1.0: rx data: 9f 06 01 42 (length=4)
[ 3035.199189] mceusb 2-5:1.0: Got carrier of 37037 Hz (period 27us)
[ 3035.231169] mceusb 2-5:1.0: tx data: 9f 0d (length=2)
[ 3035.231175] mceusb 2-5:1.0: Get receive timeout
[ 3035.231181] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 29 bytes untransferred
[ 3035.231185] mceusb 2-5:1.0: rx data: 9f 08 03 (length=3)
[ 3035.231188] mceusb 2-5:1.0: Got transmit blaster mask of 0x03
[ 3035.263168] mceusb 2-5:1.0: tx data: 9f 15 (length=2)
[ 3035.263174] mceusb 2-5:1.0: Get receive sensor
[ 3035.263180] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 28 bytes untransferred
[ 3035.263184] mceusb 2-5:1.0: rx data: 9f 0c 07 d0 (length=4)
[ 3035.263187] mceusb 2-5:1.0: Got receive timeout of 100 ms
[ 3035.295168] mceusb 2-5:1.0: tx data: ff 11 00 (length=3)
[ 3035.295178] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 29 bytes untransferred
[ 3035.295182] mceusb 2-5:1.0: rx data: 9f 14 01 (length=3)
[ 3035.295185] mceusb 2-5:1.0: Got long-range receive sensor in use
[ 3035.327166] mceusb 2-5:1.0: tx data: 00 ff aa (length=3)
[ 3035.327172] mceusb 2-5:1.0: Device resume requested
[ 3035.327178] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 25 bytes untransferred
[ 3035.327182] mceusb 2-5:1.0: rx data: ff 11 00 03 ff 03 fd (length=7)
[ 3035.327185] mceusb 2-5:1.0: TX port 1: blaster is not connected
[ 3035.359165] mceusb 2-5:1.0: tx data: ff 11 01 (length=3)
[ 3035.391094] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 25 bytes untransferred
[ 3035.391105] mceusb 2-5:1.0: rx data: ff 11 01 03 ff 03 fd (length=7)
[ 3035.391109] mceusb 2-5:1.0: TX port 2: blaster is not connected
[ 3132.602967] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 30 bytes untransferred
[ 3132.602980] mceusb 2-5:1.0: rx data: 81 ff (length=2)
[ 3132.602983] mceusb 2-5:1.0: Raw IR data, 1 pulse/space samples
[ 3132.602986] mceusb 2-5:1.0: Storing pulse with duration 6350000
[ 3132.602988] mceusb 2-5:1.0: processed IR data
[ 3132.634981] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 30 bytes untransferred
[ 3132.634994] mceusb 2-5:1.0: rx data: 81 b5 (length=2)
[ 3132.634997] mceusb 2-5:1.0: Raw IR data, 1 pulse/space samples
[ 3132.634999] mceusb 2-5:1.0: Storing pulse with duration 2650000
[ 3132.635002] mceusb 2-5:1.0: processed IR data
[ 3132.666984] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 1 bytes untransferred
[ 3132.666997] mceusb 2-5:1.0: rx data: 9e 59 8c 20 8d 0a 8c 20 8c 0b 8c 0a 8c 0a 8c 0a 8c 21 8c 0a 8c 0a 8c 0b 8c 0a 8c 21 8b 21 8c (length=31)
[ 3132.667000] mceusb 2-5:1.0: Raw IR data, 30 pulse/space samples
[ 3132.667003] mceusb 2-5:1.0: Storing space with duration 4450000
[ 3132.667005] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3132.667008] mceusb 2-5:1.0: Storing space with duration 1600000
[ 3132.667010] mceusb 2-5:1.0: Storing pulse with duration 650000
[ 3132.667012] mceusb 2-5:1.0: Storing space with duration 500000
[ 3132.667014] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3132.667016] mceusb 2-5:1.0: Storing space with duration 1600000
[ 3132.667018] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3132.667020] mceusb 2-5:1.0: Storing space with duration 550000
[ 3132.667022] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3132.667024] mceusb 2-5:1.0: Storing space with duration 500000
[ 3132.667026] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3132.667028] mceusb 2-5:1.0: Storing space with duration 500000
[ 3132.667030] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3132.667032] mceusb 2-5:1.0: Storing space with duration 500000
[ 3132.667034] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3132.667036] mceusb 2-5:1.0: Storing space with duration 1650000
[ 3132.667038] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3132.667040] mceusb 2-5:1.0: Storing space with duration 500000
[ 3132.667042] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3132.667045] mceusb 2-5:1.0: Storing space with duration 500000
[ 3132.667047] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3132.667049] mceusb 2-5:1.0: Storing space with duration 550000
[ 3132.667051] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3132.667053] mceusb 2-5:1.0: Storing space with duration 500000
[ 3132.667055] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3132.667057] mceusb 2-5:1.0: Storing space with duration 1650000
[ 3132.667059] mceusb 2-5:1.0: Storing pulse with duration 550000
[ 3132.667061] mceusb 2-5:1.0: Storing space with duration 1650000
[ 3132.667063] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3132.667065] mceusb 2-5:1.0: processed IR data
[ 3132.698977] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 4 bytes untransferred
[ 3132.698988] mceusb 2-5:1.0: rx data: 9b 7f 54 8b 0b 8c 0a 8c 0b 8b 0b 8b 0b 8c 0a 8c 0b 8b 0b 8b 21 8c 21 8b 22 8b 7f 7f (length=28)
[ 3132.698991] mceusb 2-5:1.0: Raw IR data, 27 pulse/space samples
[ 3132.698994] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.698997] mceusb 2-5:1.0: Storing space with duration 4200000
[ 3132.698999] mceusb 2-5:1.0: Storing pulse with duration 550000
[ 3132.699001] mceusb 2-5:1.0: Storing space with duration 550000
[ 3132.699003] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3132.699005] mceusb 2-5:1.0: Storing space with duration 500000
[ 3132.699007] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3132.699009] mceusb 2-5:1.0: Storing space with duration 550000
[ 3132.699011] mceusb 2-5:1.0: Storing pulse with duration 550000
[ 3132.699013] mceusb 2-5:1.0: Storing space with duration 550000
[ 3132.699015] mceusb 2-5:1.0: Storing pulse with duration 550000
[ 3132.699017] mceusb 2-5:1.0: Storing space with duration 550000
[ 3132.699019] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3132.699021] mceusb 2-5:1.0: Storing space with duration 500000
[ 3132.699023] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3132.699025] mceusb 2-5:1.0: Storing space with duration 550000
[ 3132.699027] mceusb 2-5:1.0: Storing pulse with duration 550000
[ 3132.699029] mceusb 2-5:1.0: Storing space with duration 550000
[ 3132.699031] mceusb 2-5:1.0: Storing pulse with duration 550000
[ 3132.699033] mceusb 2-5:1.0: Storing space with duration 1650000
[ 3132.699036] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3132.699038] mceusb 2-5:1.0: Storing space with duration 1650000
[ 3132.699040] mceusb 2-5:1.0: Storing pulse with duration 550000
[ 3132.699042] mceusb 2-5:1.0: Storing space with duration 1700000
[ 3132.699044] mceusb 2-5:1.0: Storing pulse with duration 550000
[ 3132.699046] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.699049] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.699050] mceusb 2-5:1.0: processed IR data
[ 3132.730963] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 26 bytes untransferred
[ 3132.730973] mceusb 2-5:1.0: rx data: 85 7f 7f 7f 7f 7f (length=6)
[ 3132.730976] mceusb 2-5:1.0: Raw IR data, 5 pulse/space samples
[ 3132.730979] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.730981] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.730983] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.730985] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.730988] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.730989] mceusb 2-5:1.0: processed IR data
[ 3132.763031] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 23 bytes untransferred
[ 3132.763045] mceusb 2-5:1.0: rx data: 88 33 ff b4 2d 8b 7f 7f 7f (length=9)
[ 3132.763047] mceusb 2-5:1.0: Raw IR data, 8 pulse/space samples
[ 3132.763050] mceusb 2-5:1.0: Storing space with duration 2550000
[ 3132.763052] mceusb 2-5:1.0: Storing pulse with duration 6350000
[ 3132.763055] mceusb 2-5:1.0: Storing pulse with duration 2600000
[ 3132.763057] mceusb 2-5:1.0: Storing space with duration 2250000
[ 3132.763059] mceusb 2-5:1.0: Storing pulse with duration 550000
[ 3132.763061] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.763063] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.763065] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.763067] mceusb 2-5:1.0: processed IR data
[ 3132.795026] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 26 bytes untransferred
[ 3132.795039] mceusb 2-5:1.0: rx data: 85 7f 7f 7f 7f 7f (length=6)
[ 3132.795042] mceusb 2-5:1.0: Raw IR data, 5 pulse/space samples
[ 3132.795044] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.795047] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.795049] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.795051] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.795053] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.795055] mceusb 2-5:1.0: processed IR data
[ 3132.826959] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 26 bytes untransferred
[ 3132.826971] mceusb 2-5:1.0: rx data: 85 7f 7f 7f 7f 7f (length=6)
[ 3132.826974] mceusb 2-5:1.0: Raw IR data, 5 pulse/space samples
[ 3132.826977] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.826979] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.826981] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.826984] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.826985] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.826987] mceusb 2-5:1.0: processed IR data
[ 3132.858963] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 23 bytes untransferred
[ 3132.858975] mceusb 2-5:1.0: rx data: 88 7f 7f 1c ff b5 2c 8b 7f (length=9)
[ 3132.858978] mceusb 2-5:1.0: Raw IR data, 8 pulse/space samples
[ 3132.858981] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.858984] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.858986] mceusb 2-5:1.0: Storing space with duration 1400000
[ 3132.858988] mceusb 2-5:1.0: Storing pulse with duration 6350000
[ 3132.858990] mceusb 2-5:1.0: Storing pulse with duration 2650000
[ 3132.858992] mceusb 2-5:1.0: Storing space with duration 2200000
[ 3132.858995] mceusb 2-5:1.0: Storing pulse with duration 550000
[ 3132.858997] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.858999] mceusb 2-5:1.0: processed IR data
[ 3132.890990] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 26 bytes untransferred
[ 3132.891003] mceusb 2-5:1.0: rx data: 85 7f 7f 7f 7f 7f (length=6)
[ 3132.891006] mceusb 2-5:1.0: Raw IR data, 5 pulse/space samples
[ 3132.891009] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.891012] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.891015] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.891017] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.891020] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.891022] mceusb 2-5:1.0: processed IR data
[ 3132.923021] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 26 bytes untransferred
[ 3132.923034] mceusb 2-5:1.0: rx data: 85 7f 7f 7f 7f 7f (length=6)
[ 3132.923037] mceusb 2-5:1.0: Raw IR data, 5 pulse/space samples
[ 3132.923039] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.923042] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.923044] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.923046] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.923048] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.923050] mceusb 2-5:1.0: processed IR data
[ 3132.955021] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 25 bytes untransferred
[ 3132.955033] mceusb 2-5:1.0: rx data: 85 7f 7f 7f 7f 5f (length=6)
[ 3132.955036] mceusb 2-5:1.0: Raw IR data, 5 pulse/space samples
[ 3132.955039] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.955041] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.955043] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.955045] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3132.955047] mceusb 2-5:1.0: Storing space with duration 4750000
[ 3132.955050] mceusb 2-5:1.0: rx data: 85 (length=1)
[ 3132.955052] mceusb 2-5:1.0: End of raw IR data
[ 3132.955059] mceusb 2-5:1.0: processed IR data
[ 3133.307002] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 30 bytes untransferred
[ 3133.307015] mceusb 2-5:1.0: rx data: 81 ff (length=2)
[ 3133.307018] mceusb 2-5:1.0: Raw IR data, 1 pulse/space samples
[ 3133.307020] mceusb 2-5:1.0: Storing pulse with duration 6350000
[ 3133.307023] mceusb 2-5:1.0: processed IR data
[ 3133.339008] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 19 bytes untransferred
[ 3133.339021] mceusb 2-5:1.0: rx data: 8c b5 59 8c 20 8c 0a 8c 21 8c 0a 8c 0a (length=13)
[ 3133.339024] mceusb 2-5:1.0: Raw IR data, 12 pulse/space samples
[ 3133.339026] mceusb 2-5:1.0: Storing pulse with duration 2650000
[ 3133.339029] mceusb 2-5:1.0: Storing space with duration 4450000
[ 3133.339032] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3133.339034] mceusb 2-5:1.0: Storing space with duration 1600000
[ 3133.339036] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3133.339038] mceusb 2-5:1.0: Storing space with duration 500000
[ 3133.339040] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3133.339042] mceusb 2-5:1.0: Storing space with duration 1650000
[ 3133.339044] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3133.339046] mceusb 2-5:1.0: Storing space with duration 500000
[ 3133.339048] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3133.339051] mceusb 2-5:1.0: Storing space with duration 500000
[ 3133.339053] mceusb 2-5:1.0: processed IR data
[ 3133.371019] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 1 bytes untransferred
[ 3133.371032] mceusb 2-5:1.0: rx data: 9e 8c 0b 8c 0a 8c 21 8b 0b 8c 0a 8c 0a 8c 0b 8c 20 8c 21 8c 0a 8c 0a 8c 0b 8b 21 8c 21 8b 0b (length=31)
[ 3133.371035] mceusb 2-5:1.0: Raw IR data, 30 pulse/space samples
[ 3133.371037] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3133.371040] mceusb 2-5:1.0: Storing space with duration 550000
[ 3133.371042] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3133.371045] mceusb 2-5:1.0: Storing space with duration 500000
[ 3133.371047] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3133.371049] mceusb 2-5:1.0: Storing space with duration 1650000
[ 3133.371051] mceusb 2-5:1.0: Storing pulse with duration 550000
[ 3133.371053] mceusb 2-5:1.0: Storing space with duration 550000
[ 3133.371055] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3133.371057] mceusb 2-5:1.0: Storing space with duration 500000
[ 3133.371059] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3133.371061] mceusb 2-5:1.0: Storing space with duration 500000
[ 3133.371063] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3133.371066] mceusb 2-5:1.0: Storing space with duration 550000
[ 3133.371068] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3133.371070] mceusb 2-5:1.0: Storing space with duration 1600000
[ 3133.371072] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3133.371074] mceusb 2-5:1.0: Storing space with duration 1650000
[ 3133.371076] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3133.371078] mceusb 2-5:1.0: Storing space with duration 500000
[ 3133.371080] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3133.371082] mceusb 2-5:1.0: Storing space with duration 500000
[ 3133.371084] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3133.371086] mceusb 2-5:1.0: Storing space with duration 550000
[ 3133.371089] mceusb 2-5:1.0: Storing pulse with duration 550000
[ 3133.371091] mceusb 2-5:1.0: Storing space with duration 1650000
[ 3133.371093] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3133.371095] mceusb 2-5:1.0: Storing space with duration 1650000
[ 3133.371097] mceusb 2-5:1.0: Storing pulse with duration 550000
[ 3133.371099] mceusb 2-5:1.0: Storing space with duration 550000
[ 3133.371101] mceusb 2-5:1.0: processed IR data
[ 3133.403007] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 18 bytes untransferred
[ 3133.403020] mceusb 2-5:1.0: rx data: 8d ff d5 0b 8b 21 8c 21 8b 21 8c 7f 7f 7f (length=14)
[ 3133.403023] mceusb 2-5:1.0: Raw IR data, 13 pulse/space samples
[ 3133.403026] mceusb 2-5:1.0: Storing pulse with duration 6350000
[ 3133.403029] mceusb 2-5:1.0: Storing pulse with duration 4250000
[ 3133.403031] mceusb 2-5:1.0: Storing space with duration 550000
[ 3133.403033] mceusb 2-5:1.0: Storing pulse with duration 550000
[ 3133.403036] mceusb 2-5:1.0: Storing space with duration 1650000
[ 3133.403038] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3133.403040] mceusb 2-5:1.0: Storing space with duration 1650000
[ 3133.403042] mceusb 2-5:1.0: Storing pulse with duration 550000
[ 3133.403044] mceusb 2-5:1.0: Storing space with duration 1650000
[ 3133.403046] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3133.403048] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.403050] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.403052] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.403054] mceusb 2-5:1.0: processed IR data
[ 3133.435001] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 25 bytes untransferred
[ 3133.435015] mceusb 2-5:1.0: rx data: 86 7f 7f 7f 7f 33 ff (length=7)
[ 3133.435018] mceusb 2-5:1.0: Raw IR data, 6 pulse/space samples
[ 3133.435020] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.435023] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.435025] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.435027] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.435029] mceusb 2-5:1.0: Storing space with duration 2550000
[ 3133.435031] mceusb 2-5:1.0: Storing pulse with duration 6350000
[ 3133.435033] mceusb 2-5:1.0: processed IR data
[ 3133.467000] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 24 bytes untransferred
[ 3133.467013] mceusb 2-5:1.0: rx data: 87 b4 2c 8c 7f 7f 7f 7f (length=8)
[ 3133.467016] mceusb 2-5:1.0: Raw IR data, 7 pulse/space samples
[ 3133.467019] mceusb 2-5:1.0: Storing pulse with duration 2600000
[ 3133.467021] mceusb 2-5:1.0: Storing space with duration 2200000
[ 3133.467024] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3133.467026] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.467028] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.467030] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.467032] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.467034] mceusb 2-5:1.0: processed IR data
[ 3133.498998] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 26 bytes untransferred
[ 3133.499011] mceusb 2-5:1.0: rx data: 85 7f 7f 7f 7f 7f (length=6)
[ 3133.499014] mceusb 2-5:1.0: Raw IR data, 5 pulse/space samples
[ 3133.499016] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.499019] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.499021] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.499023] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.499025] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.499027] mceusb 2-5:1.0: processed IR data
[ 3133.530995] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 26 bytes untransferred
[ 3133.531008] mceusb 2-5:1.0: rx data: 85 7f 7f 7f 7f 7f (length=6)
[ 3133.531011] mceusb 2-5:1.0: Raw IR data, 5 pulse/space samples
[ 3133.531013] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.531016] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.531018] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.531020] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.531022] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.531024] mceusb 2-5:1.0: processed IR data
[ 3133.562997] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 23 bytes untransferred
[ 3133.563010] mceusb 2-5:1.0: rx data: 88 7f 18 ff b5 2c 8b 7f 7f (length=9)
[ 3133.563013] mceusb 2-5:1.0: Raw IR data, 8 pulse/space samples
[ 3133.563016] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.563019] mceusb 2-5:1.0: Storing space with duration 1200000
[ 3133.563021] mceusb 2-5:1.0: Storing pulse with duration 6350000
[ 3133.563023] mceusb 2-5:1.0: Storing pulse with duration 2650000
[ 3133.563025] mceusb 2-5:1.0: Storing space with duration 2200000
[ 3133.563027] mceusb 2-5:1.0: Storing pulse with duration 550000
[ 3133.563030] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.563032] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.563034] mceusb 2-5:1.0: processed IR data
[ 3133.594993] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 26 bytes untransferred
[ 3133.595006] mceusb 2-5:1.0: rx data: 85 7f 7f 7f 7f 7f (length=6)
[ 3133.595009] mceusb 2-5:1.0: Raw IR data, 5 pulse/space samples
[ 3133.595011] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.595014] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.595016] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.595018] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.595020] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.595022] mceusb 2-5:1.0: processed IR data
[ 3133.626992] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 26 bytes untransferred
[ 3133.627005] mceusb 2-5:1.0: rx data: 85 7f 7f 7f 7f 7f (length=6)
[ 3133.627008] mceusb 2-5:1.0: Raw IR data, 5 pulse/space samples
[ 3133.627011] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.627014] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.627016] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.627018] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.627020] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.627022] mceusb 2-5:1.0: processed IR data
[ 3133.658941] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 26 bytes untransferred
[ 3133.658954] mceusb 2-5:1.0: rx data: 84 7f 7f 7f 5f (length=5)
[ 3133.658957] mceusb 2-5:1.0: Raw IR data, 4 pulse/space samples
[ 3133.658960] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.658962] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.658964] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3133.658966] mceusb 2-5:1.0: Storing space with duration 4750000
[ 3133.658969] mceusb 2-5:1.0: rx data: 84 (length=1)
[ 3133.658971] mceusb 2-5:1.0: End of raw IR data
[ 3133.658975] mceusb 2-5:1.0: processed IR data
[ 3137.082843] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 30 bytes untransferred
[ 3137.082855] mceusb 2-5:1.0: rx data: 81 ff (length=2)
[ 3137.082858] mceusb 2-5:1.0: Raw IR data, 1 pulse/space samples
[ 3137.082861] mceusb 2-5:1.0: Storing pulse with duration 6350000
[ 3137.082863] mceusb 2-5:1.0: processed IR data
[ 3137.114840] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 30 bytes untransferred
[ 3137.114853] mceusb 2-5:1.0: rx data: 81 b5 (length=2)
[ 3137.114856] mceusb 2-5:1.0: Raw IR data, 1 pulse/space samples
[ 3137.114859] mceusb 2-5:1.0: Storing pulse with duration 2650000
[ 3137.114861] mceusb 2-5:1.0: processed IR data
[ 3137.146858] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 1 bytes untransferred
[ 3137.146871] mceusb 2-5:1.0: rx data: 9e 59 8c 21 8c 0a 8c 20 8c 0b 8c 0a 8c 0a 8c 0a 8c 21 8c 0a 8c 0b 8b 0b 8c 0a 8c 21 8b 21 8c (length=31)
[ 3137.146874] mceusb 2-5:1.0: Raw IR data, 30 pulse/space samples
[ 3137.146877] mceusb 2-5:1.0: Storing space with duration 4450000
[ 3137.146880] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3137.146882] mceusb 2-5:1.0: Storing space with duration 1650000
[ 3137.146884] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3137.146886] mceusb 2-5:1.0: Storing space with duration 500000
[ 3137.146888] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3137.146890] mceusb 2-5:1.0: Storing space with duration 1600000
[ 3137.146892] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3137.146894] mceusb 2-5:1.0: Storing space with duration 550000
[ 3137.146897] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3137.146899] mceusb 2-5:1.0: Storing space with duration 500000
[ 3137.146901] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3137.146903] mceusb 2-5:1.0: Storing space with duration 500000
[ 3137.146905] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3137.146907] mceusb 2-5:1.0: Storing space with duration 500000
[ 3137.146909] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3137.146911] mceusb 2-5:1.0: Storing space with duration 1650000
[ 3137.146913] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3137.146915] mceusb 2-5:1.0: Storing space with duration 500000
[ 3137.146917] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3137.146919] mceusb 2-5:1.0: Storing space with duration 550000
[ 3137.146922] mceusb 2-5:1.0: Storing pulse with duration 550000
[ 3137.146924] mceusb 2-5:1.0: Storing space with duration 550000
[ 3137.146926] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3137.146928] mceusb 2-5:1.0: Storing space with duration 500000
[ 3137.146930] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3137.146932] mceusb 2-5:1.0: Storing space with duration 1650000
[ 3137.146934] mceusb 2-5:1.0: Storing pulse with duration 550000
[ 3137.146936] mceusb 2-5:1.0: Storing space with duration 1650000
[ 3137.146938] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3137.146940] mceusb 2-5:1.0: processed IR data
[ 3137.178823] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 2 bytes untransferred
[ 3137.178836] mceusb 2-5:1.0: rx data: 9d 7f 27 8c 21 8b 0b 8c 0a 8c 0b 8b 0b 8b 0b 8c 0a 8c 0b 8b 0b 8b 22 8b 21 8c 21 8b 7f 7f (length=30)
[ 3137.178839] mceusb 2-5:1.0: Raw IR data, 29 pulse/space samples
[ 3137.178841] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.178844] mceusb 2-5:1.0: Storing space with duration 1950000
[ 3137.178847] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3137.178849] mceusb 2-5:1.0: Storing space with duration 1650000
[ 3137.178851] mceusb 2-5:1.0: Storing pulse with duration 550000
[ 3137.178853] mceusb 2-5:1.0: Storing space with duration 550000
[ 3137.178855] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3137.178857] mceusb 2-5:1.0: Storing space with duration 500000
[ 3137.178859] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3137.178861] mceusb 2-5:1.0: Storing space with duration 550000
[ 3137.178863] mceusb 2-5:1.0: Storing pulse with duration 550000
[ 3137.178865] mceusb 2-5:1.0: Storing space with duration 550000
[ 3137.178867] mceusb 2-5:1.0: Storing pulse with duration 550000
[ 3137.178869] mceusb 2-5:1.0: Storing space with duration 550000
[ 3137.178871] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3137.178873] mceusb 2-5:1.0: Storing space with duration 500000
[ 3137.178875] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3137.178878] mceusb 2-5:1.0: Storing space with duration 550000
[ 3137.178880] mceusb 2-5:1.0: Storing pulse with duration 550000
[ 3137.178882] mceusb 2-5:1.0: Storing space with duration 550000
[ 3137.178884] mceusb 2-5:1.0: Storing pulse with duration 550000
[ 3137.178886] mceusb 2-5:1.0: Storing space with duration 1700000
[ 3137.178888] mceusb 2-5:1.0: Storing pulse with duration 550000
[ 3137.178890] mceusb 2-5:1.0: Storing space with duration 1650000
[ 3137.178892] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3137.178894] mceusb 2-5:1.0: Storing space with duration 1650000
[ 3137.178896] mceusb 2-5:1.0: Storing pulse with duration 550000
[ 3137.178898] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.178900] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.178902] mceusb 2-5:1.0: processed IR data
[ 3137.210802] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 26 bytes untransferred
[ 3137.210813] mceusb 2-5:1.0: rx data: 85 7f 7f 7f 7f 7f (length=6)
[ 3137.210816] mceusb 2-5:1.0: Raw IR data, 5 pulse/space samples
[ 3137.210818] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.210821] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.210823] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.210825] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.210827] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.210829] mceusb 2-5:1.0: processed IR data
[ 3137.242786] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 24 bytes untransferred
[ 3137.242799] mceusb 2-5:1.0: rx data: 87 30 ff b4 2c 8c 7f 7f (length=8)
[ 3137.242802] mceusb 2-5:1.0: Raw IR data, 7 pulse/space samples
[ 3137.242805] mceusb 2-5:1.0: Storing space with duration 2400000
[ 3137.242807] mceusb 2-5:1.0: Storing pulse with duration 6350000
[ 3137.242810] mceusb 2-5:1.0: Storing pulse with duration 2600000
[ 3137.242812] mceusb 2-5:1.0: Storing space with duration 2200000
[ 3137.242814] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3137.242816] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.242818] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.242820] mceusb 2-5:1.0: processed IR data
[ 3137.274836] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 26 bytes untransferred
[ 3137.274850] mceusb 2-5:1.0: rx data: 85 7f 7f 7f 7f 7f (length=6)
[ 3137.274853] mceusb 2-5:1.0: Raw IR data, 5 pulse/space samples
[ 3137.274855] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.274858] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.274860] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.274862] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.274864] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.274866] mceusb 2-5:1.0: processed IR data
[ 3137.306836] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 25 bytes untransferred
[ 3137.306849] mceusb 2-5:1.0: rx data: 86 7f 7f 7f 7f 7f 7f (length=7)
[ 3137.306852] mceusb 2-5:1.0: Raw IR data, 6 pulse/space samples
[ 3137.306854] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.306857] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.306859] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.306861] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.306863] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.306865] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.306867] mceusb 2-5:1.0: processed IR data
[ 3137.338836] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 24 bytes untransferred
[ 3137.338849] mceusb 2-5:1.0: rx data: 87 7f 7f 1d ff b4 2c 8c (length=8)
[ 3137.338852] mceusb 2-5:1.0: Raw IR data, 7 pulse/space samples
[ 3137.338854] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.338857] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.338859] mceusb 2-5:1.0: Storing space with duration 1450000
[ 3137.338861] mceusb 2-5:1.0: Storing pulse with duration 6350000
[ 3137.338863] mceusb 2-5:1.0: Storing pulse with duration 2600000
[ 3137.338865] mceusb 2-5:1.0: Storing space with duration 2200000
[ 3137.338867] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3137.338870] mceusb 2-5:1.0: processed IR data
[ 3137.370833] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 25 bytes untransferred
[ 3137.370846] mceusb 2-5:1.0: rx data: 86 7f 7f 7f 7f 7f 7f (length=7)
[ 3137.370849] mceusb 2-5:1.0: Raw IR data, 6 pulse/space samples
[ 3137.370852] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.370855] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.370856] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.370858] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.370860] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.370862] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.370864] mceusb 2-5:1.0: processed IR data
[ 3137.402791] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 26 bytes untransferred
[ 3137.402803] mceusb 2-5:1.0: rx data: 85 7f 7f 7f 7f 7f (length=6)
[ 3137.402806] mceusb 2-5:1.0: Raw IR data, 5 pulse/space samples
[ 3137.402809] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.402811] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.402813] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.402815] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.402818] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.402820] mceusb 2-5:1.0: processed IR data
[ 3137.434831] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 25 bytes untransferred
[ 3137.434844] mceusb 2-5:1.0: rx data: 85 7f 7f 7f 7f 5f (length=6)
[ 3137.434847] mceusb 2-5:1.0: Raw IR data, 5 pulse/space samples
[ 3137.434850] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.434853] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.434855] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.434857] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3137.434858] mceusb 2-5:1.0: Storing space with duration 4750000
[ 3137.434861] mceusb 2-5:1.0: rx data: 85 (length=1)
[ 3137.434863] mceusb 2-5:1.0: End of raw IR data
[ 3137.434870] mceusb 2-5:1.0: processed IR data
[ 3181.432961] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 30 bytes untransferred
[ 3181.432974] mceusb 2-5:1.0: rx data: 81 ff (length=2)
[ 3181.432977] mceusb 2-5:1.0: Raw IR data, 1 pulse/space samples
[ 3181.432979] mceusb 2-5:1.0: Storing pulse with duration 6350000
[ 3181.432982] mceusb 2-5:1.0: processed IR data
[ 3181.464970] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 14 bytes untransferred
[ 3181.464983] mceusb 2-5:1.0: rx data: 91 b5 59 8c 20 8d 0a 8c 20 8c 0b 8c 0a 8c 0a 8c 0a 8c (length=18)
[ 3181.464986] mceusb 2-5:1.0: Raw IR data, 17 pulse/space samples
[ 3181.464989] mceusb 2-5:1.0: Storing pulse with duration 2650000
[ 3181.464991] mceusb 2-5:1.0: Storing space with duration 4450000
[ 3181.464994] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3181.464996] mceusb 2-5:1.0: Storing space with duration 1600000
[ 3181.464998] mceusb 2-5:1.0: Storing pulse with duration 650000
[ 3181.465000] mceusb 2-5:1.0: Storing space with duration 500000
[ 3181.465002] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3181.465004] mceusb 2-5:1.0: Storing space with duration 1600000
[ 3181.465006] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3181.465008] mceusb 2-5:1.0: Storing space with duration 550000
[ 3181.465011] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3181.465013] mceusb 2-5:1.0: Storing space with duration 500000
[ 3181.465015] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3181.465017] mceusb 2-5:1.0: Storing space with duration 500000
[ 3181.465019] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3181.465021] mceusb 2-5:1.0: Storing space with duration 500000
[ 3181.465023] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3181.465025] mceusb 2-5:1.0: processed IR data
[ 3181.496981] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 1 bytes untransferred
[ 3181.496994] mceusb 2-5:1.0: rx data: 9e 21 8c 0a 8c 0a 8c 0b 8c 0a 8c 21 8b 21 8c 0a 8c 0b 8b 0b 8c 20 8c 21 8c 0a 8c 21 8b 0b 8c (length=31)
[ 3181.496997] mceusb 2-5:1.0: Raw IR data, 30 pulse/space samples
[ 3181.497000] mceusb 2-5:1.0: Storing space with duration 1650000
[ 3181.497003] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3181.497005] mceusb 2-5:1.0: Storing space with duration 500000
[ 3181.497007] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3181.497009] mceusb 2-5:1.0: Storing space with duration 500000
[ 3181.497011] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3181.497014] mceusb 2-5:1.0: Storing space with duration 550000
[ 3181.497016] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3181.497018] mceusb 2-5:1.0: Storing space with duration 500000
[ 3181.497020] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3181.497022] mceusb 2-5:1.0: Storing space with duration 1650000
[ 3181.497024] mceusb 2-5:1.0: Storing pulse with duration 550000
[ 3181.497026] mceusb 2-5:1.0: Storing space with duration 1650000
[ 3181.497028] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3181.497030] mceusb 2-5:1.0: Storing space with duration 500000
[ 3181.497032] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3181.497034] mceusb 2-5:1.0: Storing space with duration 550000
[ 3181.497036] mceusb 2-5:1.0: Storing pulse with duration 550000
[ 3181.497039] mceusb 2-5:1.0: Storing space with duration 550000
[ 3181.497041] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3181.497043] mceusb 2-5:1.0: Storing space with duration 1600000
[ 3181.497045] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3181.497047] mceusb 2-5:1.0: Storing space with duration 1650000
[ 3181.497049] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3181.497051] mceusb 2-5:1.0: Storing space with duration 500000
[ 3181.497053] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3181.497055] mceusb 2-5:1.0: Storing space with duration 1650000
[ 3181.497057] mceusb 2-5:1.0: Storing pulse with duration 550000
[ 3181.497059] mceusb 2-5:1.0: Storing space with duration 550000
[ 3181.497061] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3181.497064] mceusb 2-5:1.0: processed IR data
[ 3181.528964] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 20 bytes untransferred
[ 3181.528977] mceusb 2-5:1.0: rx data: 8b 7f 3d 8c 21 8b 22 8b 7f 7f 7f 7f (length=12)
[ 3181.528979] mceusb 2-5:1.0: Raw IR data, 11 pulse/space samples
[ 3181.528982] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3181.528985] mceusb 2-5:1.0: Storing space with duration 3050000
[ 3181.528987] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3181.528990] mceusb 2-5:1.0: Storing space with duration 1650000
[ 3181.528992] mceusb 2-5:1.0: Storing pulse with duration 550000
[ 3181.528994] mceusb 2-5:1.0: Storing space with duration 1700000
[ 3181.528996] mceusb 2-5:1.0: Storing pulse with duration 550000
[ 3181.528998] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3181.529000] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3181.529002] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3181.529004] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3181.529006] mceusb 2-5:1.0: processed IR data
[ 3181.560959] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 23 bytes untransferred
[ 3181.560973] mceusb 2-5:1.0: rx data: 88 7f 7f 7f 29 ff b5 2c 8c (length=9)
[ 3181.560976] mceusb 2-5:1.0: Raw IR data, 8 pulse/space samples
[ 3181.560978] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3181.560981] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3181.560983] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3181.560985] mceusb 2-5:1.0: Storing space with duration 2050000
[ 3181.560987] mceusb 2-5:1.0: Storing pulse with duration 6350000
[ 3181.560989] mceusb 2-5:1.0: Storing pulse with duration 2650000
[ 3181.560991] mceusb 2-5:1.0: Storing space with duration 2200000
[ 3181.560993] mceusb 2-5:1.0: Storing pulse with duration 600000
[ 3181.560995] mceusb 2-5:1.0: processed IR data
[ 3181.592914] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 26 bytes untransferred
[ 3181.592928] mceusb 2-5:1.0: rx data: 85 7f 7f 7f 7f 7f (length=6)
[ 3181.592932] mceusb 2-5:1.0: Raw IR data, 5 pulse/space samples
[ 3181.592935] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3181.592939] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3181.592941] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3181.592943] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3181.592945] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3181.592947] mceusb 2-5:1.0: processed IR data
[ 3181.624895] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 26 bytes untransferred
[ 3181.624909] mceusb 2-5:1.0: rx data: 85 7f 7f 7f 7f 7f (length=6)
[ 3181.624911] mceusb 2-5:1.0: Raw IR data, 5 pulse/space samples
[ 3181.624914] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3181.624916] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3181.624918] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3181.624920] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3181.624922] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3181.624924] mceusb 2-5:1.0: processed IR data
[ 3181.656959] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 26 bytes untransferred
[ 3181.656973] mceusb 2-5:1.0: rx data: 85 7f 7f 7f 7f 7f (length=6)
[ 3181.656976] mceusb 2-5:1.0: Raw IR data, 5 pulse/space samples
[ 3181.656979] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3181.656981] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3181.656983] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3181.656986] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3181.656988] mceusb 2-5:1.0: Storing space with duration 6350000
[ 3181.656990] mceusb 2-5:1.0: processed IR data
[ 3181.688951] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 32 bytes, 29 bytes untransferred
[ 3181.688965] mceusb 2-5:1.0: rx data: 81 5f (length=2)
[ 3181.688968] mceusb 2-5:1.0: Raw IR data, 1 pulse/space samples
[ 3181.688970] mceusb 2-5:1.0: Storing space with duration 4750000
[ 3181.688974] mceusb 2-5:1.0: rx data: 81 (length=1)
[ 3181.688976] mceusb 2-5:1.0: End of raw IR data
[ 3181.688983] mceusb 2-5:1.0: processed IR data

I'm not sure what to look for... ?

> 
> >       Endpoint Descriptor:
> >         bLength                 7
> >         bDescriptorType         5
> >         bEndpointAddress     0x81  EP 1 IN
> >         bmAttributes            3
> >           Transfer Type            Interrupt
> >           Synch Type               None
> >           Usage Type               Data
> >         wMaxPacketSize     0x0020  1x 32 bytes
> >         bInterval               0
> > Device Status:     0x0001
> >   Self Powered
> > 
> > -------------------
> > 
> > Also, here's a link to a response on the lirc list:
> > 
> > https://sourceforge.net/p/lirc/mailman/message/35039126/
> 
> That seems suggest that mode2 works but lirc does not. It would be nice
> if that could be narrowed down a bit.

That message above links to some other threads describing the issue.
Here's a post with a patch that supposedly works:

http://www.gossamer-threads.com/lists/mythtv/users/587930

No idea if that's the "correct" way to fix this.

I'll be trying that out and then report back...

Wade
