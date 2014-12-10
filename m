Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:33444 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757726AbaLJOYb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Dec 2014 09:24:31 -0500
Received: from [10.54.92.107] (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id 311532A1A5B
	for <linux-media@vger.kernel.org>; Wed, 10 Dec 2014 15:24:25 +0100 (CET)
Message-ID: <54885751.4010704@xs4all.nl>
Date: Wed, 10 Dec 2014 15:23:13 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.20] Media cleanups
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patch series contains a bunch of cleanups:

- Remove emacs editor comments throughout drivers/media
- Switch last users of the deprecated get/set_crop pad ops to
  get/set_selection.
- Drop obsolete get/set_crop and the unused enum_mbus_fmt ops.
- Small Kconfig improvement.

This used to be part of a 3.19 pull request, but that missed the
cut, so here it is again for 3.20.

Regards,

	Hans

The following changes since commit 71947828caef0c83d4245f7d1eaddc799b4ff1d1:

  [media] mn88473: One function call less in mn88473_init() after error (2014-12-04 16:00:47 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.20b

for you to fetch changes up to 5579ceff0a6e2a8a6793302409c10f5968070d6a:

  media/i2c/Kconfig: drop superfluous MEDIA_CONTROLLER (2014-12-10 15:19:17 +0100)

----------------------------------------------------------------
Hans Verkuil (5):
      media: remove emacs editor variables
      v4l2 subdevs: replace get/set_crop by get/set_selection
      v4l2-subdev: drop get/set_crop pad ops
      v4l2-subdev: drop unused op enum_mbus_fmt
      media/i2c/Kconfig: drop superfluous MEDIA_CONTROLLER

 Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml  |  8 -------
 Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml |  8 -------
 drivers/media/common/btcx-risc.c                           |  6 -----
 drivers/media/common/btcx-risc.h                           |  6 -----
 drivers/media/dvb-frontends/au8522.h                       |  5 -----
 drivers/media/dvb-frontends/lg2160.c                       |  6 -----
 drivers/media/dvb-frontends/lgdt3305.c                     |  6 -----
 drivers/media/dvb-frontends/lgdt330x.c                     |  6 -----
 drivers/media/dvb-frontends/lgdt330x.h                     |  6 -----
 drivers/media/dvb-frontends/lgdt330x_priv.h                |  6 -----
 drivers/media/dvb-frontends/nxt200x.h                      |  6 -----
 drivers/media/dvb-frontends/or51132.c                      |  6 -----
 drivers/media/dvb-frontends/or51132.h                      |  6 -----
 drivers/media/dvb-frontends/s5h1409.c                      |  6 -----
 drivers/media/dvb-frontends/s5h1409.h                      |  5 -----
 drivers/media/dvb-frontends/s5h1411.c                      |  5 -----
 drivers/media/dvb-frontends/s5h1411.h                      |  5 -----
 drivers/media/i2c/Kconfig                                  |  6 ++---
 drivers/media/i2c/msp3400-driver.c                         |  8 -------
 drivers/media/i2c/mt9m032.c                                | 42 ++++++++++++++++++++---------------
 drivers/media/i2c/mt9p031.c                                | 41 +++++++++++++++++++---------------
 drivers/media/i2c/mt9t001.c                                | 41 +++++++++++++++++++---------------
 drivers/media/i2c/mt9v032.c                                | 43 +++++++++++++++++++----------------
 drivers/media/i2c/s5k6aa.c                                 | 44 +++++++++++++++++++++---------------
 drivers/media/pci/bt8xx/bt878.c                            |  6 -----
 drivers/media/pci/bt8xx/bttv-cards.c                       |  7 ------
 drivers/media/pci/bt8xx/bttv-driver.c                      |  6 -----
 drivers/media/pci/bt8xx/bttv-gpio.c                        |  6 -----
 drivers/media/pci/bt8xx/bttv-if.c                          |  6 -----
 drivers/media/pci/bt8xx/bttv-risc.c                        |  6 -----
 drivers/media/pci/bt8xx/bttv-vbi.c                         |  7 ------
 drivers/media/pci/bt8xx/bttv.h                             |  5 -----
 drivers/media/pci/bt8xx/bttvp.h                            |  6 -----
 drivers/media/pci/cx88/cx88-core.c                         |  7 ------
 drivers/media/pci/cx88/cx88-mpeg.c                         |  7 ------
 drivers/media/pci/cx88/cx88-tvaudio.c                      |  7 ------
 drivers/media/tuners/mt20xx.c                              |  8 -------
 drivers/media/tuners/mt2131.c                              |  5 -----
 drivers/media/tuners/mt2131.h                              |  5 -----
 drivers/media/tuners/mt2131_priv.h                         |  5 -----
 drivers/media/tuners/mxl5007t.c                            |  8 -------
 drivers/media/tuners/mxl5007t.h                            |  9 --------
 drivers/media/tuners/tda18271-fe.c                         |  8 -------
 drivers/media/tuners/tda18271-maps.c                       |  8 -------
 drivers/media/tuners/tda18271-priv.h                       |  8 -------
 drivers/media/tuners/tda827x.c                             |  8 -------
 drivers/media/tuners/tda8290.c                             |  8 -------
 drivers/media/tuners/tda9887.c                             |  8 -------
 drivers/media/tuners/tuner-simple.c                        |  8 -------
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c              |  6 -----
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h              |  6 -----
 drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.c               |  6 -----
 drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.h               |  6 -----
 drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c                |  6 -----
 drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.h                |  6 -----
 drivers/media/usb/dvb-usb-v2/mxl111sf-phy.c                |  6 -----
 drivers/media/usb/dvb-usb-v2/mxl111sf-phy.h                |  6 -----
 drivers/media/usb/dvb-usb-v2/mxl111sf-reg.h                |  6 -----
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c              |  8 -------
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h              |  9 --------
 drivers/media/usb/dvb-usb-v2/mxl111sf.c                    |  6 -----
 drivers/media/usb/dvb-usb-v2/mxl111sf.h                    |  6 -----
 drivers/media/usb/dvb-usb/m920x.c                          |  5 -----
 drivers/media/usb/pvrusb2/pvrusb2-audio.c                  | 10 ---------
 drivers/media/usb/pvrusb2/pvrusb2-audio.h                  | 10 ---------
 drivers/media/usb/pvrusb2/pvrusb2-context.c                | 11 ---------
 drivers/media/usb/pvrusb2/pvrusb2-context.h                |  9 --------
 drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.c               | 11 ---------
 drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.h               | 10 ---------
 drivers/media/usb/pvrusb2/pvrusb2-ctrl.c                   | 11 ---------
 drivers/media/usb/pvrusb2/pvrusb2-ctrl.h                   | 10 ---------
 drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c            | 12 ----------
 drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.h            | 10 ---------
 drivers/media/usb/pvrusb2/pvrusb2-debug.h                  | 10 ---------
 drivers/media/usb/pvrusb2/pvrusb2-debugifc.c               | 11 ---------
 drivers/media/usb/pvrusb2/pvrusb2-debugifc.h               | 10 ---------
 drivers/media/usb/pvrusb2/pvrusb2-devattr.c                | 10 ---------
 drivers/media/usb/pvrusb2/pvrusb2-devattr.h                | 10 ---------
 drivers/media/usb/pvrusb2/pvrusb2-eeprom.c                 | 10 ---------
 drivers/media/usb/pvrusb2/pvrusb2-eeprom.h                 | 10 ---------
 drivers/media/usb/pvrusb2/pvrusb2-encoder.c                | 11 ---------
 drivers/media/usb/pvrusb2/pvrusb2-encoder.h                | 10 ---------
 drivers/media/usb/pvrusb2/pvrusb2-fx2-cmd.h                | 10 ---------
 drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h           | 10 ---------
 drivers/media/usb/pvrusb2/pvrusb2-hdw.h                    | 10 ---------
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c               | 10 ---------
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.h               | 11 ---------
 drivers/media/usb/pvrusb2/pvrusb2-io.c                     | 11 ---------
 drivers/media/usb/pvrusb2/pvrusb2-io.h                     | 10 ---------
 drivers/media/usb/pvrusb2/pvrusb2-ioread.c                 | 11 ---------
 drivers/media/usb/pvrusb2/pvrusb2-ioread.h                 | 10 ---------
 drivers/media/usb/pvrusb2/pvrusb2-main.c                   | 11 ---------
 drivers/media/usb/pvrusb2/pvrusb2-std.c                    | 11 ---------
 drivers/media/usb/pvrusb2/pvrusb2-std.h                    | 10 ---------
 drivers/media/usb/pvrusb2/pvrusb2-sysfs.c                  | 11 ---------
 drivers/media/usb/pvrusb2/pvrusb2-sysfs.h                  | 10 ---------
 drivers/media/usb/pvrusb2/pvrusb2-util.h                   | 10 ---------
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c                   | 10 ---------
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.h                   | 10 ---------
 drivers/media/usb/pvrusb2/pvrusb2-video-v4l.c              | 11 ---------
 drivers/media/usb/pvrusb2/pvrusb2-video-v4l.h              | 10 ---------
 drivers/media/usb/pvrusb2/pvrusb2-wm8775.c                 | 12 ----------
 drivers/media/usb/pvrusb2/pvrusb2-wm8775.h                 | 10 ---------
 drivers/media/usb/pvrusb2/pvrusb2.h                        | 10 ---------
 drivers/media/usb/usbvision/usbvision-core.c               |  8 -------
 drivers/media/usb/usbvision/usbvision-i2c.c                |  8 -------
 drivers/media/usb/usbvision/usbvision-video.c              |  8 -------
 drivers/media/usb/usbvision/usbvision.h                    |  8 -------
 drivers/media/v4l2-core/v4l2-dev.c                         |  7 ------
 drivers/media/v4l2-core/v4l2-subdev.c                      |  8 -------
 drivers/staging/media/davinci_vpfe/dm365_isif.c            | 69 ++++++++++++++++++++++++++++++---------------------------
 include/media/v4l2-subdev.h                                |  6 -----
 include/media/videobuf-dvb.h                               |  6 -----
 113 files changed, 159 insertions(+), 981 deletions(-)
