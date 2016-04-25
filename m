Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:39189 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932130AbcDYRPJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 13:15:09 -0400
Date: Mon, 25 Apr 2016 18:15:06 +0100
From: Sean Young <sean@mess.org>
To: Wade Berrier <wberrier@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: mceusb xhci issue?
Message-ID: <20160425171506.GA25277@gofer.mess.org>
References: <20160425040632.GD15140@berrier.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160425040632.GD15140@berrier.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Apr 24, 2016 at 10:06:33PM -0600, Wade Berrier wrote:
> Hello,
> 
> I have a mceusb compatible transceiver that only seems to work with
> certain computers.  I'm testing this on centos7 (3.10.0) and fedora23
> (4.4.7).
> 
> The only difference I can see is that the working computer shows
> "using uhci_hcd" and the non working shows "using xhci_hcd".
> 
> Here's the dmesg output of the non-working version:
> 
> ---------------------
> 
> [  217.951079] usb 1-5: new full-speed USB device number 10 using xhci_hcd
> [  218.104087] usb 1-5: device descriptor read/64, error -71
> [  218.371010] usb 1-5: config 1 interface 0 altsetting 0 endpoint 0x1 has an invalid bInterval 0, changing to 32
> [  218.371019] usb 1-5: config 1 interface 0 altsetting 0 endpoint 0x81 has an invalid bInterval 0, changing to 32

That's odd. Can you post a "lsusb -vvv" of the device please?

Thanks,

Sean
