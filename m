Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([80.229.237.210]:54324 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111Ab3HEVPH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Aug 2013 17:15:07 -0400
Date: Mon, 5 Aug 2013 22:15:05 +0100
From: Sean Young <sean@mess.org>
To: Rajil Saraswat <rajil.s@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: mceusb Fintek ir transmitter only works when X is not running
Message-ID: <20130805211505.GA8094@pequod.mess.org>
References: <CAFoaQoAjc-v6UiYxu8ZzaOQi4g8GurYdCB6JM8-GKQbYugJwTw@mail.gmail.com>
 <20130805112937.GA5216@pequod.mess.org>
 <CAFoaQoCpNxcqQjCt4KVPvSCOXKoOFeUs-qV7d04GSw0PyPcFEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFoaQoCpNxcqQjCt4KVPvSCOXKoOFeUs-qV7d04GSw0PyPcFEQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 05, 2013 at 07:17:10PM +0100, Rajil Saraswat wrote:
> Please find attached two traces.
> - X.txt from inside an X session where irsend doesnt trigger ir led.
> -noX.txt from virtual console with X stopped. irsend triggers the ir led.
> 
> Also, i have made sure input for this device is disabled in X.
> -----------------------------------------
> #cat /etc/X11/xorg.conf.d/5-evdev.conf
> Section "InputClass"
>         Identifier "Media Center Ed. eHome Infrared Remote Transceiver
> (1934:5168)"
>         MatchProduct "Media Center Ed. eHome Infrared Remote
> Transceiver (1934:5168)"
>         MatchDevicePath "/dev/input/event*"
> #MatchIsKeyboard "on"
>         Option "Ignore"
>         #Driver "null"
> EndSection
> 
> which leads to
> 
> [  2845.548] (II) config/udev: Adding input device Media Center Ed.
> eHome Infrared Remote Transceiver (1934:5168) (/dev/input/event11)
> [  2845.548] (**) Media Center Ed. eHome Infrared Remote Transceiver
> (1934:5168): Ignoring device from InputClass "Media Center Ed. eHome
> Infrared Remote Transceiver (1934:5168)"
> -----------------------------------------

Why are you doing this? 

-snip-

X case where it does not work:

> ffff880118d1f240 2548275209 S Io:2:008:1 -115:1 3 = 9f0802
> ffff880118d1f240 2548275281 E Io:2:008:1 -28 0
> ffff880118d1fb40 2548286204 S Io:2:008:1 -115:1 86 = 84ffb458 8b840a8b 0a8b8420 8b0a8b84 0a8b0a8b 840a8b0a 8b84208b 208b840a
> ffff880118d1fb40 2548286310 E Io:2:008:1 -28 0

All the urb submissions result in an error -28: ENOSPC. These errors aren't
logged by default. I'm not sure about why this would happen.

According to Documentation/usb/error-codes.txt:

-ENOSPC         This request would overcommit the usb bandwidth reserved
                for periodic transfers (interrupt, isochronous).

Could you try putting the device on its own bus (i.e root hub which does
not share bus with another device, see lsusb output). 

If that does not work, could you capture the usbmon output while starting 
X and then irsend, to see if your X config somehow affects it.


Sean
