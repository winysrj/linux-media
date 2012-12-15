Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756820Ab2LOAes (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Dec 2012 19:34:48 -0500
Date: Fri, 14 Dec 2012 22:34:18 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>,
	Antti Palosaari <crope@iki.fi>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Matthew Gyurgyik <matthew@pyther.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
Message-ID: <20121214223418.6485a7cb@redhat.com>
In-Reply-To: <20121214222631.1f191d6e@redhat.com>
References: <50B5779A.9090807@pyther.net>
	<50C12302.80603@pyther.net>
	<50C34628.5030407@googlemail.com>
	<50C34A50.6000207@pyther.net>
	<50C35AD1.3040000@googlemail.com>
	<50C48891.2050903@googlemail.com>
	<50C4A520.6020908@pyther.net>
	<CAGoCfiwL3pCEr2Ys48pODXqkxrmXSntH+Tf1AwCT+MEgS-_FRw@mail.gmail.com>
	<50C4BA20.8060003@googlemail.com>
	<50C4BAFB.60304@googlemail.com>
	<50C4C525.6020006@googlemail.com>
	<50C4D011.6010700@pyther.net>
	<50C60220.8050908@googlemail.com>
	<CAGoCfizTfZVFkNvdQuuisOugM2BGipYd_75R63nnj=K7E8ULWQ@mail.gmail.com>
	<50C60772.2010904@googlemail.com>
	<CAGoCfizmchN0Lg1E=YmcoPjW3PXUsChb3JtDF20MrocvwV6+BQ@mail.gmail.com>
	<50C6226C.8090302@iki! .fi>
	<50C636E7.8060003@googlemail.com>
	<50C64AB0.7020407@iki.fi>
	<50C79CD6.4060501@googlemail.com>
	<50C79E9A.3050301@iki.fi>
	<20121213182336.2cca9da6@redhat.!
 com>
	<50CB46CE.60407@googlemail.com>
	<20121214173950.79bb963e@redhat.com>
	<20121214222631.1f191d6e@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 14 Dec 2012 22:26:31 -0200
Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:

> Em Fri, 14 Dec 2012 17:39:50 -0200
> Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:
> 
> > > Anyway, first we have to GET the bytes from the hardware. That's our
> > > current problem !
> > > And the hardware seems to need a different setup for reg 0x50 for the
> > > different NEC sub protocols.
> > > Which means that the we need to know the sub protocol BEFORE we get any
> > > bytes from the device.
> > 
> > No. All em28xx needs is to make sure that the NEC protocol will return
> > the full 32 bits scancode.
> 
> It seems a way easier/quicker to just add the proper support there at the
> driver than keep answering to this thread ;)
> 
> Tested here with a Terratec HTC stick, and using two different IR's:
> 	- a Terratec IR (address code 0x14 - standard NEC);
> 	- a Pixelview IR (address code 0x866b - 24 bits NEC).

Just in case, I tested also that RC5 keeps working, by using a
Hauppauge grey control:

	# ir-keytable  -c -w /etc/rc_keymaps/hauppauge 
	Read hauppauge table
	Old keytable cleared
	Wrote 136 keycode(s) to driver
	Protocols changed to RC-5 

	# sudo ir-keytable  -t 
	Testing events. Please, press CTRL-C to abort.
	1355531445.443208: event type EV_MSC(0x04): scancode = 0x1e02
	1355531445.443208: event type EV_KEY(0x01) key_down: KEY_2(0x0001)
	1355531445.443208: event type EV_SYN(0x00).
	21355531445.543207: event type EV_MSC(0x04): scancode = 0x1e02
	1355531445.543207: event type EV_SYN(0x00).
	1355531445.793072: event type EV_KEY(0x01) key_up: KEY_2(0x0001)
	1355531445.793072: event type EV_SYN(0x00).
	1355531446.643224: event type EV_MSC(0x04): scancode = 0x1e02
	1355531446.643224: event type EV_KEY(0x01) key_down: KEY_2(0x0001)
	1355531446.643224: event type EV_SYN(0x00).
	21355531446.743205: event type EV_MSC(0x04): scancode = 0x1e02
	1355531446.743205: event type EV_SYN(0x00).


Cheers,
Mauro
