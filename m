Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([80.229.237.210]:41562 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075Ab3HEL3k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Aug 2013 07:29:40 -0400
Date: Mon, 5 Aug 2013 12:29:37 +0100
From: Sean Young <sean@mess.org>
To: Rajil Saraswat <rajil.s@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: mceusb Fintek ir transmitter only works when X is not running
Message-ID: <20130805112937.GA5216@pequod.mess.org>
References: <CAFoaQoAjc-v6UiYxu8ZzaOQi4g8GurYdCB6JM8-GKQbYugJwTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFoaQoAjc-v6UiYxu8ZzaOQi4g8GurYdCB6JM8-GKQbYugJwTw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 04, 2013 at 01:56:49PM +0100, Rajil Saraswat wrote:
> Hi,
> 
> I have a HP MCE ir transreceiver which is recognised as Fintek device.
> The receiver works fine, however the transmitter only works when there
> is no X session running.
> 
> 
> When X is stopped and the following command is issued from the virtual
> console (tty1), then the transmitter works:
> 
> irsend SEND_ONCE mceusb KEY_1
> 
> 
> However, as soon as X is started even though irsend goes through, the
> transmitter led's dont go through. Any idea why this may be happening?
> 
> 
> 
> These are the system details:
> #uname -a
> Linux localhost 3.10.4-gentoo #7 SMP Sun Aug 4 12:07:08 BST 2013
> x86_64 Intel(R) Core(TM) i5 CPU M 520 @ 2.40GHz GenuineIntel GNU/Linux
> 
> # lsusb
> Bus 002 Device 008: ID 1934:5168 Feature Integration Technology Inc.
> (Fintek) F71610A or F71612A Consumer Infrared Receiver/Transceiver

I have the exact same device and it works fine with 3.10.4 vanilla,
whether X is running out or not. Please can you send the output of
usbmon while issuing irsend (just the interface with the mce device).


Thanks
Sean
