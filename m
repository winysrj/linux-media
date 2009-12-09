Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966236AbZLIAFK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2009 19:05:10 -0500
Message-ID: <4B1EE9A7.70609@redhat.com>
Date: Tue, 08 Dec 2009 22:04:55 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Jon Smirl <jonsmirl@gmail.com>, Andy Walls <awalls@radix.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Christoph Bartelmus <lirc@bartelmus.de>, j@jannau.net,
	jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
  Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDRae8rZjFB@christoph>	<1260240142.3086.14.camel@palomino.walls.org>	<20091208042210.GA11147@core.coreip.homeip.net>	<1260275743.3094.6.camel@palomino.walls.org>	<9e4733910912080452p42efa794mb7fd608fa4fbad7c@mail.gmail.com>	<4B1E5746.7010305@redhat.com>	<9e4733910912080601s1a814720qd909e47ac09f91fc@mail.gmail.com>	<4B1E5FAF.40201@redhat.com>	<9e4733910912080631r6fd306c5tdfd56482583b9bf5@mail.gmail.com>	<4B1E656F.3020507@redhat.com>	<9e4733910912080819l2ffc88fes894d02dc8b834ef@mail.gmail.com> <m3ljhdqc11.fsf@intrepid.localdomain>
In-Reply-To: <m3ljhdqc11.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Krzysztof Halasa wrote:
> Jon Smirl <jonsmirl@gmail.com> writes:
> 
>> Why do you want to pull the 1KB default mapping table out of the
>> device driver __init section and more it to a udev script? Now we will
>> have to maintain a parallel udev script for ever receiver's device
>> driver.
> 
> Of course no. We will need a single program (script etc.) for all
> devices. And we will need a database of the known remotes (scan and key
> codes).

The keycode database can be easily extracted from kernel drivers by script.
I have it already at V4L/DVB development tree.

>> You can handle that with __devinit
> 
> __devinit is NOP with hot-plug.
> 
> Fortunately we don't need the keymaps in the kernel.
> For certain uses we may (and may not) need to have one keymap built-in,
> perhaps something similar to the embedded initrd.

I still think the better is to have them in kernel, but compiled only
if selected at Kbuild.

Cheers,
Mauro.
