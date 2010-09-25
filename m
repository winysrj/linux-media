Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:39004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949Ab0IYGJY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Sep 2010 02:09:24 -0400
Message-ID: <4C9D9200.60306@redhat.com>
Date: Sat, 25 Sep 2010 03:09:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
	Janne Grunau <j@jannau.net>, Jarod Wilson <jarod@redhat.com>
Subject: Re: [GIT PATCHES FOR 2.6.37] Remove v4l2-i2c-drv.h and most of i2c-id.h
References: <201009152200.27132.hverkuil@xs4all.nl> <4C9AD51D.2010400@redhat.com> <201009230814.43504.hverkuil@xs4all.nl>
In-Reply-To: <201009230814.43504.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 23-09-2010 03:14, Hans Verkuil escreveu:
> On Thursday, September 23, 2010 06:18:37 Mauro Carvalho Chehab wrote:
>> Em 15-09-2010 17:00, Hans Verkuil escreveu:
>>> Mauro, Jean, Janne,
>>
>>> After applying this patch series I get the following if I grep for
>>> I2C_HW_ in the kernel sources:
>>>
>>> <skip some false positives in drivers/gpu>
>>> drivers/staging/lirc/lirc_zilog.c:#ifdef I2C_HW_B_HDPVR
>>> drivers/staging/lirc/lirc_zilog.c:              if (ir->c_rx.adapter->id == I2C_HW_B_HDPVR) {
>>> drivers/staging/lirc/lirc_zilog.c:#ifdef I2C_HW_B_HDPVR
>>> drivers/staging/lirc/lirc_zilog.c:      if (ir->c_rx.adapter->id == I2C_HW_B_HDPVR)
>>
>> Those are with Janne ;)
> 
> Since I2C_HW_B_HDPVR is not actually set anywhere and because it's staging, I'd
> propose that we just ignore this. It's under an #ifdef, so removing i2c-id.h will
> not affect this code.
> 
>>> drivers/video/riva/rivafb-i2c.c:        chan->adapter.id                = I2C_HW_B_RIVA;
>>
>> No idea about this one.
> 
> This can be removed.
> 
>>
>>> drivers/media/video/ir-kbd-i2c.c:       if (ir->c->adapter->id == I2C_HW_SAA7134 && ir->c->addr == 0x30)
>>> drivers/media/video/saa7134/saa7134-i2c.c:      .id            = I2C_HW_SAA7134,
>>
>> Those are easy: just add the polling interval into the platform_data. If zero,
>> uses the default value. I'll write a patch for it.
> 
> Nice!
> 
>>> drivers/media/video/ir-kbd-i2c.c:               if (adap->id == I2C_HW_B_CX2388x) {
>>
>> This is not hard to solve. I' ll write a patch for it.
> 
> Nice!
> 
>>> drivers/staging/lirc/lirc_i2c.c:                if (adap->id == I2C_HW_B_CX2388x)
>>> drivers/staging/lirc/lirc_i2c.c:                if (adap->id == I2C_HW_B_CX2388x) {
>>> drivers/media/video/cx88/cx88-i2c.c:    core->i2c_adap.id = I2C_HW_B_CX2388x;
>>> drivers/media/video/cx88/cx88-vp3054-i2c.c:     vp3054_i2c->adap.id = I2C_HW_B_CX2388x;
>>
>> We need to solve lirc_i2c.c issues before being able to remove those. As lirc_i2c has
>> the same implementation as ir-kbd-i2c, it is probably easier to just get rid of it,
>> and then remove those two references. Jarod is working on it.
>>
>> While touching it, I'll move PV951 to bttv driver, and move all IR initialization code to 
>> bttv-input and cx88-input on those two drivers. This will make life easier when porting
>> the code to rc-core, as everything that needs to be changed will be at the same file.

The above were already merged.
> 
> So after my pending tvaudio/tda8425 patch goes in and your patches, then the only
> remaining user of I2C_HW_B_ is lirc_i2c.c, right? Jean will like that :-)

Patch applied. The remaining places are:

drivers/media/video/cx88/cx88-i2c.c:      core->i2c_adap.id = I2C_HW_B_CX2388x;
drivers/media/video/cx88/cx88-vp3054-i2c.c:       vp3054_i2c->adap.id = I2C_HW_B_CX2388x;
drivers/staging/lirc/lirc_i2c.c:          if (adap->id == I2C_HW_B_CX2388x)
drivers/staging/lirc/lirc_i2c.c:          if (adap->id == I2C_HW_B_CX2388x) {
drivers/staging/lirc/lirc_zilog.c:#ifdef I2C_HW_B_HDPVR
drivers/staging/lirc/lirc_zilog.c:                if (ir->c_rx.adapter->id == I2C_HW_B_HDPVR) {
drivers/staging/lirc/lirc_zilog.c:#ifdef I2C_HW_B_HDPVR
drivers/staging/lirc/lirc_zilog.c:        if (ir->c_rx.adapter->id == I2C_HW_B_HDPVR)
drivers/video/riva/rivafb-i2c.c:  chan->adapter.id                = I2C_HW_B_RIVA;

I'll try to review lirc_i2c. Maybe we can just remove it entirely, and then remove the entries
on cx88 driver.

Cheers,
Mauro.
