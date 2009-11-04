Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56557 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbZKDW5F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2009 17:57:05 -0500
Date: Wed, 4 Nov 2009 20:56:30 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Magnus Alm <magnus.alm@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Patch for "Leadtek Winfast TV USB II Deluxe" (with IR)
Message-ID: <20091104205630.585fac72@pedra.chehab.org>
In-Reply-To: <156a113e0910290641n348a8500v7f1a3df3ddd395d9@mail.gmail.com>
References: <156a113e0910290641n348a8500v7f1a3df3ddd395d9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Magnus,

Em Thu, 29 Oct 2009 14:41:15 +0100
Magnus Alm <magnus.alm@gmail.com> escreveu:

> Hi!
> 
> I managed to get the remote working now in both in Ubuntu 9.04 (kernel
> 2.6.28-16) and Ubuntu 9.10 (kernel 2.6.31-14).
> 
> There is one difference tho, in the 2.6.28-16 kernel the remote
> doesn't do anything without configuring lirc.
> In 2.6.31-14 I can for example adjust volume in X and use the numeric
> keys to change channels in tvtime without lirc.
> Don't know why, it just works like that.
> 
> I've added 3 different examples for a patch as attachment, since the
> remote can be enabled different ways.
> (They also changes the basic config for my board.)
> 
> ex1.patch only works for kernel 2.6.31.
> 
> ex2.patch works for both 2.6.31 and 2.6.28 but can in the future cause
> problems for boards that would like to use adress 0x1f (0x3e) for IR.
> (Because of the "case 0x1f" for my board.)
> 
> ex3.patch is a combination of ex1 and ex2. where it is depending on if
> kernel version is higher or lower than 2.6.30.
> 
> Dunno which one that would be most suitable.

The better is to follow what's specified at the InfraRed section of the API
spec:
	http://www.linuxtv.org/downloads/v4l-dvb-apis/ch17.html

It is up to the userspace apps to adopt the standard.

Also, you can easily replace the table at userspace or use lirc.

> Another thing is that my board finds an IR device at 0x18 (0x30), but
> ir-polling doesn't work at that address, so if any board in the future
> needs that added
> 0x1f needs to stand before 0x18.
> This is for the funtion in em28xx-cards if kernel higher than 2.6.30:
> 
> 	const unsigned short addr_list[] = {
> 		 0x1f, 0x30, 0x47, I2C_CLIENT_END			
> 	};
> 
> or in  ir-kbd-i2c for kernel lower than 2.6.30:
> 
> static const int probe_em28XX[] = { 0x1f, 0x30, 0x47, -1 };

Please send a patch for it.

> 
> I guess you also might have objections in how I'm naming stuff like
> "get_key_lwtu2d", maybe it's a bit obscure...

Yes, it is. Please choose a better name ;)

Also, please don't add two separate functions (one for 2.6.30 or lower and
another for upper kernels).

The most important thing is to send the patches at -p1 format, and to send
your Signed-off-by. Please read 
	http://www.linuxtv.org/hg/v4l-dvb/raw-file/tip/README.patches

For more info about how to submit a patch.



Cheers,
Mauro
