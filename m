Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([80.229.237.210]:45158 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362Ab3LENYY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Dec 2013 08:24:24 -0500
Date: Thu, 5 Dec 2013 13:24:22 +0000
From: Sean Young <sean@mess.org>
To: Rajil Saraswat <rajil.s@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: IR devices refuses to generate events
Message-ID: <20131205132422.GA2031@pequod.mess.org>
References: <CAFoaQoAFnaO68VTOyoTpM58V6W5P+PTFQso=B99tt5dcu2O9Aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFoaQoAFnaO68VTOyoTpM58V6W5P+PTFQso=B99tt5dcu2O9Aw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 30, 2013 at 12:52:17AM +0530, Rajil Saraswat wrote:
>  i have an Asus H87 Pro motherboard on which i am trying to use my
> mceusb receiver. The device refuses to generate any events. Strangely,
> it does work on one of my laptops.
> 
>  I have attached usbmon traces of it working and not working. Any idea
> what may be the problem?

The first command the mceusb driver sends is get 0xff22, get emulator 
version. In the usbmon output where it works, this gets an answer. In the
output where it does not work this command and nothing following it gets
answered.

--works log--
driver starts here:
> ddec7b40 2117802193 S Ii:2:009:1 -115:1 16 <
> ddec7a80 2117802245 S Io:2:009:1 -115:1 2 = ff22
and gets an answer:
> ddec7a80 2117803457 C Io:2:009:1 0:1 2 >
> ddec7b40 2117804472 C Ii:2:009:1 0:1 2 = fffe

-notworks log--
driver starts here:
> ffff880129745480 1549633365 S Ii:3:011:1 -115:1 16 <
> ffff880110cce900 1549633377 S Io:3:011:1 -115:1 2 = ff22

If I read the usbmon log correctly the result is -EPROTO.

> ffff880129745480 1549633448 C Ii:3:011:1 -71:0 0
> ffff880110cce900 1549633486 C Io:3:011:1 -71:0 0

And the same for the following commands.

> ffff880110ccecc0 1549643496 S Io:3:011:1 -115:1 3 = 00ffaa
> ffff880110ccecc0 1549643563 C Io:3:011:1 -71:0 0
> ffff880113aabb40 1549654508 S Io:3:011:1 -115:1 2 = ff18
> ffff880113aabb40 1549654567 C Io:3:011:1 -71:0 0
> ffff880129be6a80 1549665495 S Io:3:011:1 -115:1 2 = 9f05
> ffff880129be6a80 1549665554 C Io:3:011:1 -71:0 0
> ffff880129745540 1549676497 S Io:3:011:1 -115:1 2 = 9f16
> ffff880129745540 1549676557 C Io:3:011:1 -71:0 0
> ffff880110ccecc0 1549687510 S Io:3:011:1 -115:1 2 = 9f07
> ffff880110ccecc0 1549687570 C Io:3:011:1 -71:0 0
> ffff880113aab6c0 1549698509 S Io:3:011:1 -115:1 2 = 9f13
> ffff880113aab6c0 1549698569 C Io:3:011:1 -71:0 0
> ffff880129be60c0 1549709510 S Io:3:011:1 -115:1 2 = 9f0d
> ffff880129be60c0 1549709570 C Io:3:011:1 -71:0 0
> ffff880129745e40 1549720510 S Io:3:011:1 -115:1 2 = 9f15
> ffff880129745e40 1549720570 C Io:3:011:1 -71:0 0
> ffff880110cce900 1549731510 S Io:3:011:1 -115:1 3 = ff1100
> ffff880110cce900 1549731573 C Io:3:011:1 -71:0 0
> ffff880113aab9c0 1549742511 S Io:3:011:1 -115:1 3 = ff1101
> ffff880113aab9c0 1549742573 C Io:3:011:1 -71:0 0

I really don't know why that would happen. If I understand it correctly
this is an error that is returned by the usb host controller driver.

Could you set CONFIG_USB_DEBUG and see if you get more information?


Sean
