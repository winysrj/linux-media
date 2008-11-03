Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA32PRBr012147
	for <video4linux-list@redhat.com>; Sun, 2 Nov 2008 21:25:27 -0500
Received: from mail-in-10.arcor-online.net (mail-in-10.arcor-online.net
	[151.189.21.50])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA32Ovmu015437
	for <video4linux-list@redhat.com>; Sun, 2 Nov 2008 21:24:57 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: dabby bentam <db260179@hotmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <COL112-W41AFDEC22E57E0DCCB846DC2220@phx.gbl>
References: <BLU116-W2692D2A8C4E7BB23724BF9C23E0@phx.gbl>
	<1223198717.2674.3.camel@pc10.localdom.local>
	<BLU116-W12E3BA0B30923254200482C23E0@phx.gbl>
	<1225496636.3552.13.camel@pc10.localdom.local>
	<COL112-W41AFDEC22E57E0DCCB846DC2220@phx.gbl>
Content-Type: text/plain
Date: Mon, 03 Nov 2008 03:24:28 +0100
Message-Id: <1225679068.10293.9.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: RE: [PATCH] saa7134: add support for IR interface on the	Avermedia
	Super 007
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hello,

Am Sonntag, den 02.11.2008, 10:49 +0000 schrieb dabby bentam:
> > 
> > after a break I started to look at remaining issues.
> > 
> > If we are not restricted by limitations I don't have in mind
> offhand,
> > changing mask_keycode to 0x13f should give also unique keycodes for
> > such, which seem to be duplicate currently. (0x00, 0x03, IIRC)
> > 
> > Another question is on what the gpio_mask in the card's entry in
> > saa7134-cards.c is needed you introduced now.

for what you need this?

> > If the board has no analog support, we should also drop the TV
> section
> > entirely instead of adding comments there about DVB-T only.
> > 
> > Cheers,
> > Hermann
> > 
> 
> Ok, will try. Thanks, i'll drop the comments.

Drop the whole analog TV/tuner stuff section, if not supported.

> Is that 0x0000013f

The driver is aware of the 28 gpio pins anyway.
The last pin is 0x8000000.

If the above doesn't work, it must be a limitation within the new nec
remote stuff.

Please stop to drop lists/people in CC.

I already asked for that.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
