Return-Path: <ricardo.ribalda@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
 Andy Walls <awalls@md.metrocast.net>, Hans Verkuil <hans.verkuil@cisco.com>,
 "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
 Boris BREZILLON <boris.brezillon@free-electrons.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>,
 Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
 Scott Jiang <scott.jiang.linux@gmail.com>, Axel Lin <axel.lin@ingics.com>,
 linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 00/12] media/subdevices: Remove unused compat control ops
Date: Fri, 12 Jun 2015 18:31:06 +0200
Message-id: <1434126678-7978-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-version: 1.0
Content-type: text/plain
List-ID: <linux-media.vger.kernel.org>

Remove no longer used compat control ops, as they are not used in their
bridge drivers.

Working tree can be found at
https://github.com/ribalda/linux/tree/compat_control_clean

Ricardo Ribalda Delgado (12):
  media/i2c/adv7343: Remove compat control ops
  media/i2c/adv7393: Remove compat control ops
  media/i2c/cs5345: Remove compat control ops
  media/i2c/saa717x: Remove compat control ops
  media/i2c/sr030pc30: Remove compat control ops
  media/i2c/tda7432: Remove compat control ops
  media/i2c/tlv320aic23: Remove compat control ops
  media/i2c/tvp514x: Remove compat control ops
  media/i2c/tvp7002: Remove compat control ops
  i2c/wm8739: Remove compat control ops
  pci/ivtv/ivtv-gpio: Remove compat control ops
  media/radio/saa7706h: Remove compat control ops

 drivers/media/i2c/adv7343.c        |  7 -------
 drivers/media/i2c/adv7393.c        |  7 -------
 drivers/media/i2c/cs5345.c         |  7 -------
 drivers/media/i2c/saa717x.c        |  7 -------
 drivers/media/i2c/sr030pc30.c      |  7 -------
 drivers/media/i2c/tda7432.c        |  7 -------
 drivers/media/i2c/tlv320aic23b.c   |  7 -------
 drivers/media/i2c/tvp514x.c        | 11 -----------
 drivers/media/i2c/tvp7002.c        |  7 -------
 drivers/media/i2c/wm8739.c         |  7 -------
 drivers/media/pci/ivtv/ivtv-gpio.c |  7 -------
 drivers/media/radio/saa7706h.c     | 16 ++--------------
 12 files changed, 2 insertions(+), 95 deletions(-)

-- 
2.1.4
