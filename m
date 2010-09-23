Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:12895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab0IWES5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Sep 2010 00:18:57 -0400
Message-ID: <4C9AD51D.2010400@redhat.com>
Date: Thu, 23 Sep 2010 01:18:37 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
	Janne Grunau <j@jannau.net>, Jarod Wilson <jarod@redhat.com>
Subject: Re: [GIT PATCHES FOR 2.6.37] Remove v4l2-i2c-drv.h and most of i2c-id.h
References: <201009152200.27132.hverkuil@xs4all.nl>
In-Reply-To: <201009152200.27132.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 15-09-2010 17:00, Hans Verkuil escreveu:
> Mauro, Jean, Janne,

> After applying this patch series I get the following if I grep for
> I2C_HW_ in the kernel sources:
> 
> <skip some false positives in drivers/gpu>
> drivers/staging/lirc/lirc_zilog.c:#ifdef I2C_HW_B_HDPVR
> drivers/staging/lirc/lirc_zilog.c:              if (ir->c_rx.adapter->id == I2C_HW_B_HDPVR) {
> drivers/staging/lirc/lirc_zilog.c:#ifdef I2C_HW_B_HDPVR
> drivers/staging/lirc/lirc_zilog.c:      if (ir->c_rx.adapter->id == I2C_HW_B_HDPVR)

Those are with Janne ;)

> drivers/video/riva/rivafb-i2c.c:        chan->adapter.id                = I2C_HW_B_RIVA;

No idea about this one.

> drivers/media/video/ir-kbd-i2c.c:       if (ir->c->adapter->id == I2C_HW_SAA7134 && ir->c->addr == 0x30)
> drivers/media/video/saa7134/saa7134-i2c.c:      .id            = I2C_HW_SAA7134,

Those are easy: just add the polling interval into the platform_data. If zero,
uses the default value. I'll write a patch for it.

> drivers/media/video/ir-kbd-i2c.c:               if (adap->id == I2C_HW_B_CX2388x) {

This is not hard to solve. I' ll write a patch for it.

> drivers/staging/lirc/lirc_i2c.c:                if (adap->id == I2C_HW_B_CX2388x)
> drivers/staging/lirc/lirc_i2c.c:                if (adap->id == I2C_HW_B_CX2388x) {
> drivers/media/video/cx88/cx88-i2c.c:    core->i2c_adap.id = I2C_HW_B_CX2388x;
> drivers/media/video/cx88/cx88-vp3054-i2c.c:     vp3054_i2c->adap.id = I2C_HW_B_CX2388x;

We need to solve lirc_i2c.c issues before being able to remove those. As lirc_i2c has
the same implementation as ir-kbd-i2c, it is probably easier to just get rid of it,
and then remove those two references. Jarod is working on it.

While touching it, I'll move PV951 to bttv driver, and move all IR initialization code to 
bttv-input and cx88-input on those two drivers. This will make life easier when porting
the code to rc-core, as everything that needs to be changed will be at the same file.

Cheers,
Mauro
