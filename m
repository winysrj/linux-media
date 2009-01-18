Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57810 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756830AbZARNiU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jan 2009 08:38:20 -0500
From: Oliver Endriss <o.endriss@gmx.de>
To: Tony Broad <tony@byteworkshop.co.uk>
Subject: Re: budget.c driver: Kernel oops: "BUG: unable to handle kernel paging request at ffffffff"
Date: Sun, 18 Jan 2009 14:36:52 +0100
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <49730AAA.4030209@byteworkshop.co.uk>
In-Reply-To: <49730AAA.4030209@byteworkshop.co.uk>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_1BzcJTDS8zUW9QG"
Message-Id: <200901181436.53820@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_1BzcJTDS8zUW9QG
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Tony Broad wrote:
> I'm using a "Hauppauge WinTV-NOVA-T DVB card" of PCI id "13c2:1005" with
> kernel 2.6.27.9.
> 
> I've recently experienced the following fairly consistent kernel oops on
> startup in grundig_29504_401_tuner_set_params from budget.c. As you
> might expect, following this failure, the card doesn't work.
> 
> I'm not a kernel developer, nevertheless I seem to have managed to track
> this down to a non-existent initialisation of
> budget->dvb_frontend->tuner_priv.
> 
> The attached patch fixes the problem for me (and I've managed to tune
> the card successfully as a result), but I don't know of anyone else
> using the driver so I can't test it on other people.
> 
> Please let me know if this works for you or if I've done something
> terribly wrong ;-(

Hi,

you are right, and your patch is basically correct.

Anyway, the l64781 frontend driver is a better place to fix the bug:
Initializing the frontend struct at allocation time will prevent this
kind of problem for all card drivers now and forever...

Signed-off-by: Oliver Endriss <o.endriss@gmx.de> 

Btw, this fix should be applied to all kernels >= 2.6.26.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

--Boundary-00=_1BzcJTDS8zUW9QG
Content-Type: text/x-diff;
  charset="us-ascii";
  name="l64781-initfix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="l64781-initfix.diff"

diff -r 1930f80b6970 linux/drivers/media/dvb/frontends/l64781.c
--- a/linux/drivers/media/dvb/frontends/l64781.c	Sun Dec 14 15:38:29 2008 +0100
+++ b/linux/drivers/media/dvb/frontends/l64781.c	Sun Jan 18 14:04:39 2009 +0100
@@ -501,7 +501,7 @@ struct dvb_frontend* l64781_attach(const
 			   { .addr = config->demod_address, .flags = I2C_M_RD, .buf = b1, .len = 1 } };
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct l64781_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct l64781_state), GFP_KERNEL);
 	if (state == NULL) goto error;
 
 	/* setup the state */

--Boundary-00=_1BzcJTDS8zUW9QG--
