Return-path: <mchehab@pedra>
Received: from zone0.gcu-squad.org ([212.85.147.21]:22357 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab1AMNcT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jan 2011 08:32:19 -0500
Date: Thu, 13 Jan 2011 14:31:29 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org,
	Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>
Subject: Re: [PATCH 3/3] lirc_zilog: Remove use of deprecated struct
 i2c_adapter.id   field
Message-ID: <20110113143129.117053ef@endymion.delvare>
In-Reply-To: <4D24EA81.8080205@redhat.com>
References: <1293587067.3098.10.camel@localhost>
	<1293587390.3098.16.camel@localhost>
	<20110105154553.546998bf@endymion.delvare>
	<4D24ABA4.5070100@redhat.com>
	<20110105225149.1145420b@endymion.delvare>
	<4D24EA81.8080205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 05 Jan 2011 20:02:41 -0200, Mauro Carvalho Chehab wrote:
> Em 05-01-2011 19:51, Jean Delvare escreveu:
> > If you have specific cases you don't know how to solve, please point me
> > to them and I'll take a look.
> 
> You can take a look at saa7134-cards.c, for example. saa7134_tuner_setup()
> has several examples. It starts with this one:
> 
> 	switch (dev->board) {
> 	case SAA7134_BOARD_BMK_MPEX_NOTUNER:
> 	case SAA7134_BOARD_BMK_MPEX_TUNER:
> 		/* Checks if the device has a tuner at 0x60 addr
> 		   If the device doesn't have a tuner, TUNER_ABSENT
> 		   will be used at tuner_type, avoiding loading tuner
> 		   without needing it
> 		 */
> 		dev->i2c_client.addr = 0x60;
> 		board = (i2c_master_recv(&dev->i2c_client, &buf, 0) < 0)
> 			? SAA7134_BOARD_BMK_MPEX_NOTUNER
> 			: SAA7134_BOARD_BMK_MPEX_TUNER;
> 
> In this specific case, it is simply a probe for a device at address 0x60, but

This call to i2c_master_recv() could be replaced easily with
i2c_transfer(), which doesn't require an i2c_client.

Alternatively, you could delay the probe until you are ready to
instantiate the tuner device, and use i2c_new_device() when you're sure
it's there, and i2c_new_probed_device() when you aren't. This would be
nicer, but this also requires non-trivial changes.

> there are more complex cases there, with eeprom reads and/or some random init
> that happens before actually attaching some driver at the i2c address.
> It is known to work, but it sounds like a hack.

For eeprom reads, I would definitely recommend getting a clean
i2c_client from i2c-core using i2c_new_dummy() or i2c_new_device().

For "random init", well, I guess each case is different, so I can't
make a general statement.

-- 
Jean Delvare
