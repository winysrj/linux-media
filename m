Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:48186 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbZHDOd3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2009 10:33:29 -0400
Received: by gxk9 with SMTP id 9so6864530gxk.13
        for <linux-media@vger.kernel.org>; Tue, 04 Aug 2009 07:33:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A78454B.309@ferrari3200.optiplex-networks.com>
References: <4A782DC0.2080905@netscape.net>
	 <829197380908040603l484a4c2el528fbeff937bc8b6@mail.gmail.com>
	 <4A783459.6040507@netscape.net>
	 <829197380908040623q40503e8ct1384d904f4139950@mail.gmail.com>
	 <4A78454B.309@ferrari3200.optiplex-networks.com>
Date: Tue, 4 Aug 2009 10:33:28 -0400
Message-ID: <829197380908040733s4bbadf4bmcf009fc9004000a9@mail.gmail.com>
Subject: Re: Hauppauge WinTV usb 1 not working?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Kaya Saman <kaya.saman@ferrari3200.optiplex-networks.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 4, 2009 at 10:27 AM, Kaya
Saman<kaya.saman@ferrari3200.optiplex-networks.com> wrote:
> Hi Devin,
>
> sorry for the late reply had to go out to pick up some groceries!
>
> the link is here: http://www.hauppauge.com/site/support/support_usb.html
>
> It's the WinTV USB which has USB1.1 compliency and 640x480 res for tv
> watching although can do full screen on it.
>
> Pre WinTV USB2 model :-)

Ok, so it is indeed very similar to the USB-live, but with a coax
input I guess.  Well, what I said before still applies - the 640x480
support was never added to the Linux driver for the usbvision chipset,
and it doesn't surprise me that the driver performs poorly for you as
it did for me with the USB-live.

The driver overall is a mess and I don't foresee anybody spending the
cycles to clean it up.  Unless you can find someone willing to do the
work I would suggest just getting a newer product.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
