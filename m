Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:50856 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbZDNQV0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Apr 2009 12:21:26 -0400
Received: by yx-out-2324.google.com with SMTP id 31so2731567yxl.1
        for <linux-media@vger.kernel.org>; Tue, 14 Apr 2009 09:21:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49E4B5D9.20101@orthfamily.net>
References: <49E40322.5040600@orthfamily.net>
	 <412bdbff0904140552m52c0106q960f7c0ee40757c@mail.gmail.com>
	 <49E492D0.3070101@orthfamily.net>
	 <412bdbff0904140854x69a700a5pcbff84853ef9f8dd@mail.gmail.com>
	 <49E4B5D9.20101@orthfamily.net>
Date: Tue, 14 Apr 2009 12:21:24 -0400
Message-ID: <412bdbff0904140921q412bbb04o7126011539680518@mail.gmail.com>
Subject: Re: [linux-dvb] Pinnacle HD Stick (801e SE) and i2c issues
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: John Orth <john@orthfamily.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 14, 2009 at 12:12 PM, John Orth <john@orthfamily.net> wrote:
> That was my initial thought as well, but I don't have a great understanding
> of what exactly the i2c bus does and how it works with the other hardware.
>  Is it possible that some other piece of hardware (non-USB, and non-USB host
> chipset) is impacting this?  The only reason I ask is that I have a PCI
> wireless card that is using the kernel rtl8185 driver (which thus far could
> best be described as "functional") and network traffic often gets dropped
> for several seconds.  Is it worth unloading the rtl8185 module and seeing if
> that makes a difference?

It's possible.  Since the issue is highly reproducible, I would
suggest you pull the card and see if it makes any difference.  Same
goes for any other suspect hardware.

To be fair though (and I hope nobody from Realtek is listening), the
rtl8185 isn't the most reliable card around.  I have a couple I bought
a couple of years ago, and they only stopped panic'ing the kernel in
recent versions (at least for Ubuntu).

> Also, would more output from dmesg (or any other command) be helpful?

Yeah, if you could pastebin the full dmesg output, I can see if there
is anything else that jumps out at me.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
