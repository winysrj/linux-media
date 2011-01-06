Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:63521 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753080Ab1AFBUI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Jan 2011 20:20:08 -0500
Subject: Re: [PATCH 3/3] lirc_zilog: Remove use of deprecated struct
 i2c_adapter.id field
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jean Delvare <khali@linux-fr.org>, linux-media@vger.kernel.org,
	Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>
In-Reply-To: <4D24EA81.8080205@redhat.com>
References: <1293587067.3098.10.camel@localhost>
	 <1293587390.3098.16.camel@localhost>
	 <20110105154553.546998bf@endymion.delvare>	<4D24ABA4.5070100@redhat.com>
	 <20110105225149.1145420b@endymion.delvare>  <4D24EA81.8080205@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Jan 2011 20:20:35 -0500
Message-ID: <1294276835.9672.99.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Wed, 2011-01-05 at 20:02 -0200, Mauro Carvalho Chehab wrote:
> Em 05-01-2011 19:51, Jean Delvare escreveu:
> > Hi Mauro,
> > 
> > On Wed, 05 Jan 2011 15:34:28 -0200, Mauro Carvalho Chehab wrote:
> >> Hi Jean,
> >>
> >> Thanks for your acks for patches 1 and 2. I've already applied the patches 
> >> on my tree and at linux-next. I'll try to add the acks on it before sending
> >> upstream.
> > 
> > If you can't, it's fine. I merely wanted to show my support to Andy's
> > work, I don't care if I'm not counted as a reviewer for these small
> > patches.
> 
> Ok. So, it is probably better to keep it as-is, to avoid rebasing and having
> to wait for a couple days at linux-next before sending the git pull request.
> 
> > 
> >> Em 05-01-2011 12:45, Jean Delvare escreveu:
> >>> From a purely technical perspective, changing client->addr in the
> >>> probe() function is totally prohibited.
> >>
> >> Agreed. Btw, there are some other hacks with client->addr abuse on some 
> >> other random places at drivers/media, mostly at the device bridge code, 
> >> used to test if certain devices are present and/or to open some I2C gates 
> >> before doing some init code. People use this approach as it provides a
> >> fast way to do some things. On several cases, the amount of code for
> >> doing such hack is very small, when compared to writing a new I2C driver
> >> just to do some static initialization code. Not sure what would be the 
> >> better approach to fix them.
> > 
> > Hard to tell without seeing the exact code. Ideally,
> > i2c_new_dummy() would cover these cases: you don't need to write an
> > actual driver for the device, it's perfectly OK to use the freshly
> > instantiated i2c_client from the bridge driver directly. Alternatively,
> > i2c_smbus_xfer() or i2c_transfer() can be used for one-time data
> > exchange with any slave on the bus as long as you know what you're
> > doing (i.e. you know that no i2c_client will ever be instantiated for
> > this slave.)
> > 
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
> there are more complex cases there, with eeprom reads and/or some random init
> that happens before actually attaching some driver at the i2c address.
> It is known to work, but it sounds like a hack.

The cx18 driver has a function scope i2c_client for reading the EEPROM,
and there's a good reason for it.  We don't want to register the EEPROM
with the I2C system and make it visible to the rest of the system,
including i2c-dev and user-space tools.  To avoid EEPROM corruption,
it's better keep communication with EEPROMs to a very limited scope.

Regards,
Andy

> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


