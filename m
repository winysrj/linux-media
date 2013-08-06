Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([80.229.237.210]:53368 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472Ab3HFIbZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Aug 2013 04:31:25 -0400
Date: Tue, 6 Aug 2013 09:31:23 +0100
From: Sean Young <sean@mess.org>
To: Rajil Saraswat <rajil.s@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: mceusb Fintek ir transmitter only works when X is not running
Message-ID: <20130806083123.GA11080@pequod.mess.org>
References: <CAFoaQoAjc-v6UiYxu8ZzaOQi4g8GurYdCB6JM8-GKQbYugJwTw@mail.gmail.com>
 <20130805112937.GA5216@pequod.mess.org>
 <CAFoaQoCpNxcqQjCt4KVPvSCOXKoOFeUs-qV7d04GSw0PyPcFEQ@mail.gmail.com>
 <20130805211505.GA8094@pequod.mess.org>
 <CAFoaQoBFVJ+pKHtJncyLxH5tjLDeR5v5fQ4VqGx0Yoko_tiN2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFoaQoBFVJ+pKHtJncyLxH5tjLDeR5v5fQ4VqGx0Yoko_tiN2w@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 05, 2013 at 11:57:58PM +0100, Rajil Saraswat wrote:
> >
> > Why are you doing this?
> >
> > -snip-
> 
> My initial guess was that X was claiming over the ir device, so I
> wanted to disable ir device as an input device.

X may open the input device, but that does not affect IR transmission.

> > X case where it does not work:
> >
> >> ffff880118d1f240 2548275209 S Io:2:008:1 -115:1 3 = 9f0802
> >> ffff880118d1f240 2548275281 E Io:2:008:1 -28 0
> >> ffff880118d1fb40 2548286204 S Io:2:008:1 -115:1 86 = 84ffb458 8b840a8b 0a8b8420 8b0a8b84 0a8b0a8b 840a8b0a 8b84208b 208b840a
> >> ffff880118d1fb40 2548286310 E Io:2:008:1 -28 0
> >
> > All the urb submissions result in an error -28: ENOSPC. These errors aren't
> > logged by default. I'm not sure about why this would happen.
> >
> > According to Documentation/usb/error-codes.txt:
> >
> > -ENOSPC         This request would overcommit the usb bandwidth reserved
> >                 for periodic transfers (interrupt, isochronous).
> >
> > Could you try putting the device on its own bus (i.e root hub which does
> > not share bus with another device, see lsusb output).
> >
> 
> 
> Unfortunately, this is a laptop with few usb ports. I have tried
> moving devices around but still end-up on the same bus (02). I am
> running the OS off the 1TB usb harddisk ( Western Digital
> Technologies) connected on the same bus.
> 
> # lsusb
> Bus 001 Device 002: ID 8087:0020 Intel Corp. Integrated Rate Matching Hub
> Bus 002 Device 002: ID 8087:0020 Intel Corp. Integrated Rate Matching Hub
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 001 Device 003: ID 05ca:1814 Ricoh Co., Ltd HD Webcam
> Bus 002 Device 003: ID 046d:c00c Logitech, Inc. Optical Wheel Mouse
> Bus 002 Device 009: ID 1934:5168 Feature Integration Technology Inc.
> (Fintek) F71610A or F71612A Consumer Infrared Receiver/Transceiver
> Bus 002 Device 005: ID 1058:0748 Western Digital Technologies, Inc. My
> Passport 1TB USB 3.0
> Bus 002 Device 006: ID 413c:8187 Dell Computer Corp. DW375 Bluetooth Module
> Bus 002 Device 007: ID 0a5c:5800 Broadcom Corp. BCM5880 Secure
> Applications Processor

That is a lot devices, can you try with less devices connected? 

> The disk is quite responsive
> #hdparm -Tt /dev/sdb3
> 
> /dev/sdb3:
>  Timing cached reads:   4896 MB in  2.00 seconds = 2449.42 MB/sec
>  Timing buffered disk reads:  90 MB in  3.04 seconds =  29.58 MB/sec

It's not about whether there is enough bandwidth, it's about whether
issuing more usb urbs would overflow the bandwidth allocated to other
devices (whether in use or not). Make sure you have 
CONFIG_USB_EHCI_TT_NEWSCHED defined in your kernel.

> > If that does not work, could you capture the usbmon output while starting
> > X and then irsend, to see if your X config somehow affects it.
> 
> The usbmon capture (Xstart.txt) is attached as requested. I ran a
> script which rotated on channel numbers and simultaneously started X.
> The channels initially changed but stopped when I logged into the X
> session.

Thanks. Only the IR transmit urb submits results in error ENOSPC.


Sean
