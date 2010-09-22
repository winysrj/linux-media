Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:64883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab0IVWPr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Sep 2010 18:15:47 -0400
Message-ID: <4C9A7FF5.60701@redhat.com>
Date: Wed, 22 Sep 2010 19:15:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
	Janne Grunau <j@jannau.net>
Subject: Re: [GIT PATCHES FOR 2.6.37] Remove v4l2-i2c-drv.h and most of i2c-id.h
References: <201009152200.27132.hverkuil@xs4all.nl>
In-Reply-To: <201009152200.27132.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 15-09-2010 17:00, Hans Verkuil escreveu:
> Mauro, Jean, Janne,
> 
> This patch series finally retires the hackish v4l2-i2c-drv.h. It served honorably,
> but now that the hg repository no longer supports kernels <2.6.26 it is time to
> remove it.
> 
> Note that this patch series builds on the vtx-removal patch series.
> 
> Several patches at the end remove unused i2c-id.h includes and remove bogus uses
> of the I2C_HW_ defines (as found in i2c-id.h).
> 
> After applying this patch series I get the following if I grep for
> I2C_HW_ in the kernel sources:
> 
> <skip some false positives in drivers/gpu>
> drivers/staging/lirc/lirc_i2c.c:                if (adap->id == I2C_HW_B_CX2388x)
> drivers/staging/lirc/lirc_i2c.c:                if (adap->id == I2C_HW_B_CX2388x) {
> drivers/staging/lirc/lirc_zilog.c:#ifdef I2C_HW_B_HDPVR
> drivers/staging/lirc/lirc_zilog.c:              if (ir->c_rx.adapter->id == I2C_HW_B_HDPVR) {
> drivers/staging/lirc/lirc_zilog.c:#ifdef I2C_HW_B_HDPVR
> drivers/staging/lirc/lirc_zilog.c:      if (ir->c_rx.adapter->id == I2C_HW_B_HDPVR)
> drivers/video/riva/rivafb-i2c.c:        chan->adapter.id                = I2C_HW_B_RIVA;
> drivers/media/video/ir-kbd-i2c.c:       if (ir->c->adapter->id == I2C_HW_SAA7134 && ir->c->addr == 0x30)
> drivers/media/video/ir-kbd-i2c.c:               if (adap->id == I2C_HW_B_CX2388x) {
> drivers/media/video/saa7134/saa7134-i2c.c:      .id            = I2C_HW_SAA7134,
> drivers/media/video/cx88/cx88-i2c.c:    core->i2c_adap.id = I2C_HW_B_CX2388x;
> drivers/media/video/cx88/cx88-vp3054-i2c.c:     vp3054_i2c->adap.id = I2C_HW_B_CX2388x;
> 
> Jean, I guess the one in rivafb-i2c.c can just be removed, right?
> 
> Janne, the HDPVR checks in lirc no longer work since hdpvr never sets the
> adapter ID (nor should it). This lirc code should be checked. I haven't
> been following the IR changes, but there must be a better way of doing this.
> 
> The same is true for the CX2388x and SAA7134 checks. These all relate to the
> IR subsystem.
> 
> Once we fixed these remaining users of the i2c-id.h defines, then Jean can
> remove that header together with the adapter's 'id' field.
> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit 991403c594f666a2ed46297c592c60c3b9f4e1e2:
>   Mauro Carvalho Chehab (1):
>         V4L/DVB: cx231xx: Avoid an OOPS when card is unknown (card=0)
> 
> are available in the git repository at:
> 
>   ssh://linuxtv.org/git/hverkuil/v4l-dvb.git i2c
> 
...
>       tvaudio: remove obsolete tda8425 initialization
...

This patch is incomplete. It removes the initialization, but it forgets to remove other references.
This is what grep says about tda8425:

drivers/media/video/Kconfig:		   tea6320, tea6420, tda8425, ta8874z.
drivers/media/video/tda7432.c: * Which was based on tda8425.c by Greg Alexander (c) 1998
drivers/media/video/tda9875.c: * Which was based on tda8425.c by Greg Alexander (c) 1998
drivers/media/video/tvaudio.c:/* audio chip descriptions - defines+functions for tda8425                */
drivers/media/video/tvaudio.c:#define TDA8425_VL         0x00  /* volume left */
drivers/media/video/tvaudio.c:#define TDA8425_VR         0x01  /* volume right */
drivers/media/video/tvaudio.c:#define TDA8425_BA         0x02  /* bass */
drivers/media/video/tvaudio.c:#define TDA8425_TR         0x03  /* treble */
drivers/media/video/tvaudio.c:#define TDA8425_S1         0x08  /* switch functions */
drivers/media/video/tvaudio.c:#define TDA8425_S1_OFF     0xEE  /* audio off (mute on) */
drivers/media/video/tvaudio.c:#define TDA8425_S1_CH1     0xCE  /* audio channel 1 (mute off) - "linear stereo" mode */
drivers/media/video/tvaudio.c:#define TDA8425_S1_CH2     0xCF  /* audio channel 2 (mute off) - "linear stereo" mode */
drivers/media/video/tvaudio.c:#define TDA8425_S1_MU      0x20  /* mute bit */
drivers/media/video/tvaudio.c:#define TDA8425_S1_STEREO  0x18  /* stereo bits */
drivers/media/video/tvaudio.c:#define TDA8425_S1_STEREO_SPATIAL 0x18 /* spatial stereo */
drivers/media/video/tvaudio.c:#define TDA8425_S1_STEREO_LINEAR  0x08 /* linear stereo */
drivers/media/video/tvaudio.c:#define TDA8425_S1_STEREO_PSEUDO  0x10 /* pseudo stereo */
drivers/media/video/tvaudio.c:#define TDA8425_S1_STEREO_MONO    0x00 /* forced mono */
drivers/media/video/tvaudio.c:#define TDA8425_S1_ML      0x06        /* language selector */
drivers/media/video/tvaudio.c:#define TDA8425_S1_ML_SOUND_A 0x02     /* sound a */
drivers/media/video/tvaudio.c:#define TDA8425_S1_ML_SOUND_B 0x04     /* sound b */
drivers/media/video/tvaudio.c:#define TDA8425_S1_ML_STEREO  0x06     /* stereo */
drivers/media/video/tvaudio.c:#define TDA8425_S1_IS      0x01        /* channel selector */
drivers/media/video/tvaudio.c:static int tda8425_shift10(int val) { return (val >> 10) | 0xc0; }
drivers/media/video/tvaudio.c:static int tda8425_shift12(int val) { return (val >> 12) | 0xf0; }
drivers/media/video/tvaudio.c:static int tda8425_initialize(struct CHIPSTATE *chip)
drivers/media/video/tvaudio.c:	int inputmap[4] = { /* tuner	*/ TDA8425_S1_CH2, /* radio  */ TDA8425_S1_CH1,
drivers/media/video/tvaudio.c:			    /* extern	*/ TDA8425_S1_CH1, /* intern */ TDA8425_S1_OFF};
drivers/media/video/tvaudio.c:static void tda8425_setmode(struct CHIPSTATE *chip, int mode)
drivers/media/video/tvaudio.c:	int s1 = chip->shadow.bytes[TDA8425_S1+1] & 0xe1;
drivers/media/video/tvaudio.c:		s1 |= TDA8425_S1_ML_SOUND_A;
drivers/media/video/tvaudio.c:		s1 |= TDA8425_S1_STEREO_PSEUDO;
drivers/media/video/tvaudio.c:		s1 |= TDA8425_S1_ML_SOUND_B;
drivers/media/video/tvaudio.c:		s1 |= TDA8425_S1_STEREO_PSEUDO;
drivers/media/video/tvaudio.c:		s1 |= TDA8425_S1_ML_STEREO;
drivers/media/video/tvaudio.c:			s1 |= TDA8425_S1_STEREO_MONO;
drivers/media/video/tvaudio.c:			s1 |= TDA8425_S1_STEREO_SPATIAL;
drivers/media/video/tvaudio.c:	chip_write(chip,TDA8425_S1,s1);
drivers/media/video/tvaudio.c:static int tda8425  = 1;
drivers/media/video/tvaudio.c:module_param(tda8425, int, 0444);
drivers/media/video/tvaudio.c:		.name       = "tda8425",
drivers/media/video/tvaudio.c:		.insmodopt  = &tda8425,
drivers/media/video/tvaudio.c:		.addr_lo    = I2C_ADDR_TDA8425 >> 1,
drivers/media/video/tvaudio.c:		.addr_hi    = I2C_ADDR_TDA8425 >> 1,
drivers/media/video/tvaudio.c:		.leftreg    = TDA8425_VL,
drivers/media/video/tvaudio.c:		.rightreg   = TDA8425_VR,
drivers/media/video/tvaudio.c:		.bassreg    = TDA8425_BA,
drivers/media/video/tvaudio.c:		.treblereg  = TDA8425_TR,
drivers/media/video/tvaudio.c:		.initialize = tda8425_initialize,
drivers/media/video/tvaudio.c:		.volfunc    = tda8425_shift10,
drivers/media/video/tvaudio.c:		.bassfunc   = tda8425_shift12,
drivers/media/video/tvaudio.c:		.treblefunc = tda8425_shift12,
drivers/media/video/tvaudio.c:		.setmode    = tda8425_setmode,
drivers/media/video/tvaudio.c:		.inputreg   = TDA8425_S1,
drivers/media/video/tvaudio.c:		.inputmap   = { TDA8425_S1_CH1, TDA8425_S1_CH1, TDA8425_S1_CH1 },
drivers/media/video/tvaudio.c:		.inputmute  = TDA8425_S1_OFF,

I didn't actually saw what you left behind on tvaudio (as it might eventually be used
by some other part of the code), but keeping it mentioned in Kconfig is not ok ;)

The rest of the series seem ok.

Applied, thanks!

Cheers,
Mauro
