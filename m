Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42395 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895AbcA2MML (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2016 07:12:11 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 00/13] Add media controller support to em28xx driver
Date: Fri, 29 Jan 2016 10:10:50 -0200
Message-Id: <cover.1454067262.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series add MC support to the em28xx driver. Among the hybrid TV USB
drivers, this is the most complex one, as there are lots of different hardware
options that are compatible with this driver.

Yet, it is used with only two analog TV demod drivers (tvp5150 and saa7115)
and, optionally, one IF-PLL audio decoder (msp3400). It means that there aren't
many I2C drivers that need to be touched.

The PCI drivers are a way more complex, as they may have audio processors and 
may use a wide range of other I2C drivers. So, it is wise to implement MC support
at em28xx before those, as it helps to address some issues before extending
MC to the wild.

The two patches in this series are actually unrelated to MC. The first one is a cleanup
at em28xx, and the second patch fixes one KASAN error.

The next patches make the Media Controller aware of the existence of IF-PLL
drivers, commonly found on older designs. They also standardize the pad index
for tuners, IF-PLLs and demods.

Finally, MC support for tda9887, tvp5150, saa7115 and msp3400 is added, making
those drivers to properly report the MC function supported by the driver and
creating the source/sink pads for them.

The last patch finally add em28xx MC support.

I opted to not add any helper function for now at v4l2-mc.c, putting all needed code
at em28xx, because I didn't want to cause hard to find conflicts with Shuah's patches,
that are touching the routines at au0828. After having Shuah patches merged, I'll
work to move the generic code to v4l2-mc.c (yet to be created).

This series was tested on the following devices:

Hauppauge HVR-950 (2040:6513):
	https://mchehab.fedorapeople.org/mc-next-gen/hvr_950.png

Haupauge WinTV USB2 (2040:4200):
	https://mchehab.fedorapeople.org/mc-next-gen/wintv_usb2.png

KWorld USB ATSC TV Stick UB435-Q V3 (1b80:e34c):
	https://mchehab.fedorapeople.org/mc-next-gen/kworld_435q.png

PCTV 261e (2013:0258):
	https://mchehab.fedorapeople.org/mc-next-gen/pctv_261e.png

PCTV 290e (2013:024f):
	https://mchehab.fedorapeople.org/mc-next-gen/pctv_290e.png

Pixelview PlayTV USB2 (eb1a:2821):
	https://mchehab.fedorapeople.org/mc-next-gen/playtv_usb.png

	(an extra patch was needed for it to detect the tuner - I'll send it in separate)

Regards,
Mauro

Mauro Carvalho Chehab (13):
  [media] em28xx: remove unused input types
  [media] xc2028: avoid use after free
  [media] tuner.h: rename TUNER_PAD_IF_OUTPUT to TUNER_PAD_OUTPUT
  [media] v4l2-mc.h: move tuner PAD definitions to this new header
  [media] v4l2-mc.h: Split audio from baseband output
  [media] media.h: add support for IF-PLL video/sound decoder
  [media] v4l2-mc.h Add pads for audio and video IF-PLL decoders
  [media] v4l2-mc: add analog TV demodulator pad index macros
  [media] tvp5150: create the expected number of pads
  [media] msp3400: initialize MC data
  [media] tvp5150: identify it as a MEDIA_ENT_F_ATV_DECODER
  [media] saa7115: initialize demod type and add the needed pads
  [media] em28xx: add media controller support

 Documentation/DocBook/device-drivers.tmpl       |   1 +
 Documentation/DocBook/media/v4l/media-types.xml |  29 ++-
 drivers/media/dvb-core/dvbdev.c                 |   2 +-
 drivers/media/i2c/msp3400-driver.c              |  14 ++
 drivers/media/i2c/msp3400-driver.h              |   5 +
 drivers/media/i2c/saa7115.c                     |  19 ++
 drivers/media/i2c/tvp5150.c                     |  14 +-
 drivers/media/tuners/tuner-xc2028.c             |   5 +-
 drivers/media/usb/au0828/au0828-core.c          |   2 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c       |   2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c         |   2 +-
 drivers/media/usb/em28xx/em28xx-cards.c         | 189 ++++++++++------
 drivers/media/usb/em28xx/em28xx-dvb.c           |  10 +
 drivers/media/usb/em28xx/em28xx-video.c         | 279 ++++++++++++++++++++++--
 drivers/media/usb/em28xx/em28xx.h               |  21 +-
 drivers/media/v4l2-core/tuner-core.c            |  26 ++-
 include/media/tuner.h                           |   9 +-
 include/media/v4l2-mc.h                         |  91 ++++++++
 include/uapi/linux/media.h                      |  17 +-
 19 files changed, 621 insertions(+), 116 deletions(-)
 create mode 100644 include/media/v4l2-mc.h

-- 
2.5.0


