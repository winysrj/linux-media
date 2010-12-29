Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:58833 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752239Ab0L2OOK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 09:14:10 -0500
Subject: Re: [PATCH 2/3] ir-kbd-i2c: Add HD PVR IR Rx support to ir-kbd-i2c
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
	Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>
In-Reply-To: <4D1B17A1.1010803@redhat.com>
References: <1293587067.3098.10.camel@localhost>
	 <1293587266.3098.14.camel@localhost>  <4D1B17A1.1010803@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Dec 2010 09:14:18 -0500
Message-ID: <1293632058.2091.74.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Wed, 2010-12-29 at 09:12 -0200, Mauro Carvalho Chehab wrote:
> Em 28-12-2010 23:47, Andy Walls escreveu:
> > 
> > Add HD PVR IR Rx support to ir-kbd-i2c
> 
> Hmm... I know nothing about the hardware designs used on hd-pvr, but
> it seems wrong to have both lirc-zilog and ir-kbd-i2c registering for
> RX for the same device.

There are some historical reasons for why that is the case

1. ir-kbd-i2c:
	a. was in kernel
	b. provides Rx keycodes using the linux input subsystem
	c. the program in the Z8 outputs RX data that is compatible
	    with the Rx data output by IR microcontrollers on older
	    Hauppauge designs.
	d. the keymap was relatively fixed

2. lirc_i2c:
	a. was not in kernel
	b. provided Rx data the "LIRC way" via /dev/lirc
	c. the program in the Z8 outputs RX data that is compatible
	    with the Rx data output by IR microcontrollers on older
	    Hauppauge designs.
	d. the LIRC keymap could be changed by the user

3. lirc_pvr150 (aka lirc_zilog):
	a. was not in kernel and was not in LIRC
	b. provided both Rx and Tx interfaces the "LIRC way"
	    via /dev/lirc
	c. Any user who whats to use the Z8 for IR Tx has to use this
	    module
	d. old linux kernels had problems with the Z8 getting
	    hung up on the I2C bus when doing Tx and RX, and Z8
	    chip resets to recover from than hang affected Rx.



> There are variants with hd-pvr that uses ir-kbd-i2c and others
> that use another I2C chipset? 
> Or, for some versions of Z8, the RX logic
> is identical to the one provided by ir-kbd-i2c?

There are no real variants AFAIK.  All HD PVRs should have a Z8 chip and
are capable of IR Tx and Rx

The program in the Z8 outputs RX data that is compatible with the Rx
data output by IR microcontrollers on older Hauppauge designs.

The lirc_zilog.c code implies some Z8's might not support Tx, but I
suspect that case is really just another chip at the same Z8 Rx I2C
address (0x71) that is not actually a Z8.  


Having multiple modules support the device gives the end user some
choice.

1. ir-kbd-i2c supports the "it just works" use case that was discussed
when implementing the new IR/RC core.


2. A user that only wants Rx with the Z8, uses either ir-kbd-i2c or
lirc_i2c.  They are more reliable.

Since the keymaps for ir-kbd-i2c are now modifiable from userspace,  and
if "cooked" IR Rx data is not passed out via /dev/lirc anymore, then Z8
support can be pulled out of lirc_i2c.  Most or all of lirc_i2c can be
collapsed into ir-kbd-i2c anyway.


3. A user that wants Tx with the Z8 must use lirc_zilog, which needs a
"firmware" and which also handles Rx at the moment.

The reasons for keeping Rx and Tx coupled in lirc_zilog are getting
thin, so it may be possible to convert lirc_zilog to only handle Tx, but
I'm not sure yet.  There may still need to be some sort of locking
between accessing the Tx and Rx I2C addresses of the Z8.

Regards,
Andy

> > 
> > Signed-off-by: Andy Walls <awalls@md.metrocast.net>
> > 
> > ---
> >  drivers/media/video/ir-kbd-i2c.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
> > index dd54c3d..c87b6bc 100644
> > --- a/drivers/media/video/ir-kbd-i2c.c
> > +++ b/drivers/media/video/ir-kbd-i2c.c
> > @@ -449,6 +449,7 @@ static const struct i2c_device_id ir_kbd_id[] = {
> >  	{ "ir_video", 0 },
> >  	/* IR device specific entries should be added here */
> >  	{ "ir_rx_z8f0811_haup", 0 },
> > +	{ "ir_rx_z8f0811_hdpvr", 0 },
> >  	{ }
> >  };
> >  
> 


