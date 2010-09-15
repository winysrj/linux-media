Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3829 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab0IOUAv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 16:00:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.37] Remove v4l2-i2c-drv.h and most of i2c-id.h
Date: Wed, 15 Sep 2010 22:00:26 +0200
Cc: Jean Delvare <khali@linux-fr.org>, Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009152200.27132.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Mauro, Jean, Janne,

This patch series finally retires the hackish v4l2-i2c-drv.h. It served honorably,
but now that the hg repository no longer supports kernels <2.6.26 it is time to
remove it.

Note that this patch series builds on the vtx-removal patch series.

Several patches at the end remove unused i2c-id.h includes and remove bogus uses
of the I2C_HW_ defines (as found in i2c-id.h).

After applying this patch series I get the following if I grep for
I2C_HW_ in the kernel sources:

<skip some false positives in drivers/gpu>
drivers/staging/lirc/lirc_i2c.c:                if (adap->id == I2C_HW_B_CX2388x)
drivers/staging/lirc/lirc_i2c.c:                if (adap->id == I2C_HW_B_CX2388x) {
drivers/staging/lirc/lirc_zilog.c:#ifdef I2C_HW_B_HDPVR
drivers/staging/lirc/lirc_zilog.c:              if (ir->c_rx.adapter->id == I2C_HW_B_HDPVR) {
drivers/staging/lirc/lirc_zilog.c:#ifdef I2C_HW_B_HDPVR
drivers/staging/lirc/lirc_zilog.c:      if (ir->c_rx.adapter->id == I2C_HW_B_HDPVR)
drivers/video/riva/rivafb-i2c.c:        chan->adapter.id                = I2C_HW_B_RIVA;
drivers/media/video/ir-kbd-i2c.c:       if (ir->c->adapter->id == I2C_HW_SAA7134 && ir->c->addr == 0x30)
drivers/media/video/ir-kbd-i2c.c:               if (adap->id == I2C_HW_B_CX2388x) {
drivers/media/video/saa7134/saa7134-i2c.c:      .id            = I2C_HW_SAA7134,
drivers/media/video/cx88/cx88-i2c.c:    core->i2c_adap.id = I2C_HW_B_CX2388x;
drivers/media/video/cx88/cx88-vp3054-i2c.c:     vp3054_i2c->adap.id = I2C_HW_B_CX2388x;

Jean, I guess the one in rivafb-i2c.c can just be removed, right?

Janne, the HDPVR checks in lirc no longer work since hdpvr never sets the
adapter ID (nor should it). This lirc code should be checked. I haven't
been following the IR changes, but there must be a better way of doing this.

The same is true for the CX2388x and SAA7134 checks. These all relate to the
IR subsystem.

Once we fixed these remaining users of the i2c-id.h defines, then Jean can
remove that header together with the adapter's 'id' field.

Regards,

	Hans

The following changes since commit 991403c594f666a2ed46297c592c60c3b9f4e1e2:
  Mauro Carvalho Chehab (1):
        V4L/DVB: cx231xx: Avoid an OOPS when card is unknown (card=0)

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/v4l-dvb.git i2c

Hans Verkuil (49):
      saa5246a/saa5249: Remove obsolete teletext drivers
      videotext: remove this obsolete API
      Documentation: update now that the vtx/videotext API has been removed.
      Merge branch 'vtx' into i2c

The patches above are the same as the vtx patch series posted before. This
patch series requires that vtx is merged first as there is no point to convert
i2c drivers that are going to be removed anyway!

      vp27smpx: remove obsolete v4l2-i2c-drv.h header
      wm8739: remove obsolete v4l2-i2c-drv.h header
      cs5345: remove obsolete v4l2-i2c-drv.h header
      saa717x: remove obsolete v4l2-i2c-drv.h header
      saa7115: remove obsolete v4l2-i2c-drv.h header.
      tda9840: remove obsolete v4l2-i2c-drv.h header
      ov7670: remove obsolete v4l2-i2c-drv.h header
      mt9v011: remove obsolete v4l2-i2c-drv.h header
      upd64031a: remove obsolete v4l2-i2c-drv.h header
      saa6588: remove obsolete v4l2-i2c-drv.h header
      saa6752hs: remove obsolete v4l2-i2c-drv.h header
      bt819: remove obsolete v4l2-i2c-drv.h header
      indycam: remove obsolete v4l2-i2c-drv.h header
      m52790: remove obsolete v4l2-i2c-drv.h header
      saa7185: remove obsolete v4l2-i2c-drv.h header
      msp3400: remove obsolete v4l2-i2c-drv.h header
      bt866: remove obsolete v4l2-i2c-drv.h header
      tea6415c: remove obsolete v4l2-i2c-drv.h header
      tvaudio: remove obsolete v4l2-i2c-drv.h header
      wm8775: remove obsolete v4l2-i2c-drv.h header
      adv7175: remove obsolete v4l2-i2c-drv.h header
      saa7191: remove obsolete v4l2-i2c-drv.h header
      bt856: remove obsolete v4l2-i2c-drv.h header
      tlv320aic23b: remove obsolete v4l2-i2c-drv.h header
      tuner: remove obsolete v4l2-i2c-drv.h header
      tda9875: remove obsolete v4l2-i2c-drv.h header
      saa7110: remove obsolete v4l2-i2c-drv.h header
      tda7432: remove obsolete v4l2-i2c-drv.h header
      tea6420: remove obsolete v4l2-i2c-drv.h header
      cs53l32a: remove obsolete v4l2-i2c-drv.h header
      vpx3220: remove obsolete v4l2-i2c-drv.h header
      tvp5150: remove obsolete v4l2-i2c-drv.h header
      upd64083: remove obsolete v4l2-i2c-drv.h header
      saa7127: remove obsolete v4l2-i2c-drv.h header
      cx25840: remove obsolete v4l2-i2c-drv.h header
      adv7170: remove obsolete v4l2-i2c-drv.h header
      ks0127: remove obsolete v4l2_i2c_drv.h header
      au8522_decoder: remove obsolete v4l2-i2c-drv.h header
      s2250: remove obsolete v4l2-i2c-drv.h header
      v4l: remove unused i2c-id.h headers
      tvaudio: remove obsolete tda8425 initialization
      saa7146/tuner: remove mxb hack
      ir-kbd-i2c: remove obsolete I2C_HW_B_CX2341X test
      tm6000: removed unused i2c adapter ID
      v4l: remove obsolete include/media/v4l2-i2c-drv.h file

 Documentation/DocBook/v4l/compat.xml         |   24 +-
 Documentation/DocBook/v4l/dev-teletext.xml   |   29 +-
 Documentation/DocBook/v4l/v4l2.xml           |   10 +-
 Documentation/feature-removal-schedule.txt   |   23 -
 Documentation/ioctl/ioctl-number.txt         |    1 -
 Documentation/video4linux/bttv/MAKEDEV       |    1 -
 Documentation/video4linux/v4l2-framework.txt |    5 +-
 drivers/media/common/saa7146_i2c.c           |    1 -
 drivers/media/dvb/frontends/au8522_decoder.c |   27 +-
 drivers/media/radio/tef6862.c                |    1 -
 drivers/media/video/Kconfig                  |   20 -
 drivers/media/video/Makefile                 |    2 -
 drivers/media/video/adv7170.c                |   28 +-
 drivers/media/video/adv7175.c                |   28 +-
 drivers/media/video/adv7180.c                |    1 -
 drivers/media/video/bt819.c                  |   28 +-
 drivers/media/video/bt856.c                  |   28 +-
 drivers/media/video/bt866.c                  |   28 +-
 drivers/media/video/cs5345.c                 |   27 +-
 drivers/media/video/cs53l32a.c               |   27 +-
 drivers/media/video/cx18/cx18-ioctl.c        |    1 -
 drivers/media/video/cx25840/cx25840-core.c   |   27 +-
 drivers/media/video/indycam.c                |   27 +-
 drivers/media/video/ir-kbd-i2c.c             |    6 +-
 drivers/media/video/ivtv/ivtv-ioctl.c        |    1 -
 drivers/media/video/ks0127.c                 |   27 +-
 drivers/media/video/m52790.c                 |   28 +-
 drivers/media/video/msp3400-driver.c         |   31 +-
 drivers/media/video/mt9v011.c                |   29 +-
 drivers/media/video/mxb.c                    |    5 -
 drivers/media/video/ov7670.c                 |   27 +-
 drivers/media/video/saa5246a.c               | 1123 --------------------------
 drivers/media/video/saa5249.c                |  650 ---------------
 drivers/media/video/saa6588.c                |   27 +-
 drivers/media/video/saa7110.c                |   27 +-
 drivers/media/video/saa7115.c                |   33 +-
 drivers/media/video/saa7127.c                |   27 +-
 drivers/media/video/saa7134/saa6752hs.c      |   27 +-
 drivers/media/video/saa717x.c                |   27 +-
 drivers/media/video/saa7185.c                |   28 +-
 drivers/media/video/saa7191.c                |   27 +-
 drivers/media/video/tda7432.c                |   27 +-
 drivers/media/video/tda9840.c                |   27 +-
 drivers/media/video/tda9875.c                |   27 +-
 drivers/media/video/tea6415c.c               |   27 +-
 drivers/media/video/tea6420.c                |   27 +-
 drivers/media/video/tlv320aic23b.c           |   28 +-
 drivers/media/video/tuner-core.c             |   39 +-
 drivers/media/video/tvaudio.c                |   40 +-
 drivers/media/video/tvp5150.c                |   27 +-
 drivers/media/video/upd64031a.c              |   27 +-
 drivers/media/video/upd64083.c               |   27 +-
 drivers/media/video/v4l2-dev.c               |   11 +-
 drivers/media/video/vp27smpx.c               |   28 +-
 drivers/media/video/vpx3220.c                |   27 +-
 drivers/media/video/wm8739.c                 |   27 +-
 drivers/media/video/wm8775.c                 |   28 +-
 drivers/staging/go7007/s2250-board.c         |   27 +-
 drivers/staging/tm6000/tm6000-i2c.c          |    3 -
 include/linux/Kbuild                         |    1 -
 include/linux/videotext.h                    |  125 ---
 include/media/v4l2-dev.h                     |    3 +-
 include/media/v4l2-i2c-drv.h                 |   80 --
 63 files changed, 872 insertions(+), 2355 deletions(-)
 delete mode 100644 drivers/media/video/saa5246a.c
 delete mode 100644 drivers/media/video/saa5249.c
 delete mode 100644 include/linux/videotext.h
 delete mode 100644 include/media/v4l2-i2c-drv.h

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
