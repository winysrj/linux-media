Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:41915 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750934Ab0ALDRT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2010 22:17:19 -0500
Subject: Re: How to use saa7134 gpio via gpio-sysfs?
From: hermann pitton <hermann-pitton@arcor.de>
To: Gordon Smith <spider.karma+linux-media@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <2df568dc1001111059p54de8635k6c207fb3f4d96a14@mail.gmail.com>
References: <2df568dc1001111012u627f07b8p9ec0c2577f14b5d9@mail.gmail.com>
	 <2df568dc1001111059p54de8635k6c207fb3f4d96a14@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 12 Jan 2010 04:13:40 +0100
Message-Id: <1263266020.3198.37.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Am Montag, den 11.01.2010, 11:59 -0700 schrieb Gordon Smith: 
> I need to bit twiddle saa7134 gpio pins from userspace.
> To use gpio-sysfs, I need a "GPIO number" to export each pin, but I
> do not know how to find such a number.
> 
> Card is RTD Embedded Technologies VFG7350 [card=72,autodetected].
> GPIO uses pcf8574 chip.
> Kernel is 2.6.30.
> 
> gpio-sysfs creates
>     /sys/class/gpio/export
>     /sys/class/gpio/import
> but no gpio<n> entries so far.
> 
> >From dmesg ("gpiotracking=1")
>     saa7133[0]: board init: gpio is 10000
>     saa7133[0]: gpio: mode=0x0000000 in=0x4011000 out=0x0000000 [pre-init]
>     saa7133[1]: board init: gpio is 10000
>     saa7133[1]: gpio: mode=0x0000000 in=0x4010f00 out=0x0000000 [pre-init]
> 
> How may I find each "GPIO number" for this board?
> 
> Thanks in advance for any help.

There are 28 (0-27) gpio pins on each saa713x chip.

Documentation about possible use cases is publicly available via
nxp.com.

You can do what ever you want with them, but to export them to userland
seems to be a very bad idea to me.

Likely soon some "advanced hackers" will damage ;) all kind of hardware
around and others will claim it as being a GNU/Linux problem within the
same time such stuff appears, and of course it will.

In fact these days, only one to three users are involved hacking on a
board. It is much cheaper for all involved to give the serial number of
those than to imagine every day, what all could happen.

For all others not yet active, avoiding any worst case through
contributing is the way to go.

For the rest, we likely should have some fund, for worst cases, payed by
themselves.

Cheers,
Hermann






