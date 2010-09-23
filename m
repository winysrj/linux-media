Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3978 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab0IWGPC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Sep 2010 02:15:02 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCHES FOR 2.6.37] Remove v4l2-i2c-drv.h and most of i2c-id.h
Date: Thu, 23 Sep 2010 08:14:43 +0200
Cc: linux-media@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
	Janne Grunau <j@jannau.net>, Jarod Wilson <jarod@redhat.com>
References: <201009152200.27132.hverkuil@xs4all.nl> <4C9AD51D.2010400@redhat.com>
In-Reply-To: <4C9AD51D.2010400@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009230814.43504.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday, September 23, 2010 06:18:37 Mauro Carvalho Chehab wrote:
> Em 15-09-2010 17:00, Hans Verkuil escreveu:
> > Mauro, Jean, Janne,
> 
> > After applying this patch series I get the following if I grep for
> > I2C_HW_ in the kernel sources:
> > 
> > <skip some false positives in drivers/gpu>
> > drivers/staging/lirc/lirc_zilog.c:#ifdef I2C_HW_B_HDPVR
> > drivers/staging/lirc/lirc_zilog.c:              if (ir->c_rx.adapter->id == I2C_HW_B_HDPVR) {
> > drivers/staging/lirc/lirc_zilog.c:#ifdef I2C_HW_B_HDPVR
> > drivers/staging/lirc/lirc_zilog.c:      if (ir->c_rx.adapter->id == I2C_HW_B_HDPVR)
> 
> Those are with Janne ;)

Since I2C_HW_B_HDPVR is not actually set anywhere and because it's staging, I'd
propose that we just ignore this. It's under an #ifdef, so removing i2c-id.h will
not affect this code.

> > drivers/video/riva/rivafb-i2c.c:        chan->adapter.id                = I2C_HW_B_RIVA;
> 
> No idea about this one.

This can be removed.

> 
> > drivers/media/video/ir-kbd-i2c.c:       if (ir->c->adapter->id == I2C_HW_SAA7134 && ir->c->addr == 0x30)
> > drivers/media/video/saa7134/saa7134-i2c.c:      .id            = I2C_HW_SAA7134,
> 
> Those are easy: just add the polling interval into the platform_data. If zero,
> uses the default value. I'll write a patch for it.

Nice!

> > drivers/media/video/ir-kbd-i2c.c:               if (adap->id == I2C_HW_B_CX2388x) {
> 
> This is not hard to solve. I' ll write a patch for it.

Nice!

> > drivers/staging/lirc/lirc_i2c.c:                if (adap->id == I2C_HW_B_CX2388x)
> > drivers/staging/lirc/lirc_i2c.c:                if (adap->id == I2C_HW_B_CX2388x) {
> > drivers/media/video/cx88/cx88-i2c.c:    core->i2c_adap.id = I2C_HW_B_CX2388x;
> > drivers/media/video/cx88/cx88-vp3054-i2c.c:     vp3054_i2c->adap.id = I2C_HW_B_CX2388x;
> 
> We need to solve lirc_i2c.c issues before being able to remove those. As lirc_i2c has
> the same implementation as ir-kbd-i2c, it is probably easier to just get rid of it,
> and then remove those two references. Jarod is working on it.
> 
> While touching it, I'll move PV951 to bttv driver, and move all IR initialization code to 
> bttv-input and cx88-input on those two drivers. This will make life easier when porting
> the code to rc-core, as everything that needs to be changed will be at the same file.

So after my pending tvaudio/tda8425 patch goes in and your patches, then the only
remaining user of I2C_HW_B_ is lirc_i2c.c, right? Jean will like that :-)

Jean, I did a grep of who is still including i2c-id.h (excluding media drivers):

drivers/gpu/drm/nouveau/nouveau_i2c.h:#include <linux/i2c-id.h>
drivers/gpu/drm/radeon/radeon_mode.h:#include <linux/i2c-id.h>
drivers/gpu/drm/i915/intel_drv.h:#include <linux/i2c-id.h>
drivers/gpu/drm/i915/intel_i2c.c:#include <linux/i2c-id.h>
drivers/video/i810/i810.h:#include <linux/i2c-id.h>
drivers/video/intelfb/intelfb_i2c.c:#include <linux/i2c-id.h>
drivers/video/savage/savagefb.h:#include <linux/i2c-id.h>
drivers/video/aty/radeon_i2c.c:#include <linux/i2c-id.h>
drivers/i2c/busses/i2c-s3c2410.c:#include <linux/i2c-id.h>
drivers/i2c/busses/i2c-pxa.c:#include <linux/i2c-id.h>
drivers/i2c/busses/i2c-ibm_iic.c:#include <linux/i2c-id.h>

AFAIK none of these actually need this include. It's probably a good idea for
you to remove together with this obsolete I2C_HW_B_RIVA:

drivers/video/riva/rivafb-i2c.c:        chan->adapter.id                = I2C_HW_B_RIVA;

Regards,

	Hans

> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
