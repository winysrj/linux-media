Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:49732 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757573AbcIPIfL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 04:35:11 -0400
Received: from [192.168.1.137] (marune.xs4all.nl [80.101.105.217])
        by tschai.lan (Postfix) with ESMTPSA id 9F97018021F
        for <linux-media@vger.kernel.org>; Fri, 16 Sep 2016 10:35:05 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.9] Various fixes
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Message-ID: <5a7e1782-f0ec-2ecf-8fd3-e71273902f11@xs4all.nl>
Date: Fri, 16 Sep 2016 10:35:05 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit c3b809834db8b1a8891c7ff873a216eac119628d:

  [media] pulse8-cec: fix compiler warning (2016-09-12 06:42:44 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.9f

for you to fetch changes up to c0d54b8bbf842ff8ce6eaccdb1173ebbf387e691:

  hva: fix sparse warnings (2016-09-16 10:23:53 +0200)

----------------------------------------------------------------
Arnd Bergmann (5):
      Input: atmel_mxt: disallow impossible configuration
      Input: synaptics-rmi4: disallow impossible configuration
      ad5820: use __maybe_unused for PM functions
      atmel-isc: mark PM functions as __maybe_unused
      usb: gadget: uvc: add V4L2 dependency

Baoyou Xie (1):
      staging: media: omap4iss: mark omap4iss_flush() static

Colin Ian King (2):
      rc/streamzap: fix spelling mistake "sumbiting" -> "submitting"
      lgdt3306a: fix spelling mistake "supportted" -> "supported"

Hans Verkuil (1):
      hva: fix sparse warnings

Javier Martinez Canillas (1):
      ov9650: add support for asynchronous probing

Julia Lawall (10):
      pci: constify snd_pcm_ops structures
      usb: constify snd_pcm_ops structures
      usb: constify vb2_ops structures
      platform: constify vb2_ops structures
      pci: constify vb2_ops structures
      constify local structures
      dvb-frontends: constify dvb_tuner_ops structures
      tuners: constify dvb_tuner_ops structures
      constify i2c_algorithm structures
      mxl111sf-tuner: constify dvb_tuner_ops structures

Nick Dyer (1):
      Input: v4l-touch - add copyright lines

 drivers/input/rmi4/Kconfig                               |  2 +-
 drivers/input/rmi4/rmi_f54.c                             |  1 +
 drivers/input/touchscreen/Kconfig                        |  3 ++-
 drivers/input/touchscreen/atmel_mxt_ts.c                 |  1 +
 drivers/media/dvb-frontends/ascot2e.c                    |  2 +-
 drivers/media/dvb-frontends/dvb-pll.c                    |  2 +-
 drivers/media/dvb-frontends/helene.c                     |  4 ++--
 drivers/media/dvb-frontends/horus3a.c                    |  2 +-
 drivers/media/dvb-frontends/ix2505v.c                    |  2 +-
 drivers/media/dvb-frontends/lgdt3306a.c                  |  2 +-
 drivers/media/dvb-frontends/stb6000.c                    |  2 +-
 drivers/media/dvb-frontends/stb6100.c                    |  2 +-
 drivers/media/dvb-frontends/stv6110.c                    |  2 +-
 drivers/media/dvb-frontends/stv6110x.c                   |  2 +-
 drivers/media/dvb-frontends/tda18271c2dd.c               |  2 +-
 drivers/media/dvb-frontends/tda665x.c                    |  2 +-
 drivers/media/dvb-frontends/tda8261.c                    |  2 +-
 drivers/media/dvb-frontends/tda826x.c                    |  2 +-
 drivers/media/dvb-frontends/ts2020.c                     |  2 +-
 drivers/media/dvb-frontends/tua6100.c                    |  2 +-
 drivers/media/dvb-frontends/zl10036.c                    |  2 +-
 drivers/media/dvb-frontends/zl10039.c                    |  2 +-
 drivers/media/i2c/ad5820.c                               | 13 ++-----------
 drivers/media/i2c/ov9650.c                               |  7 ++++++-
 drivers/media/i2c/tvp514x.c                              |  2 +-
 drivers/media/pci/cobalt/cobalt-alsa-pcm.c               |  4 ++--
 drivers/media/pci/cx18/cx18-alsa-pcm.c                   |  2 +-
 drivers/media/pci/cx23885/cx23885-417.c                  |  2 +-
 drivers/media/pci/cx23885/cx23885-alsa.c                 |  2 +-
 drivers/media/pci/cx23885/cx23885-dvb.c                  |  2 +-
 drivers/media/pci/cx23885/cx23885-i2c.c                  |  2 +-
 drivers/media/pci/cx23885/cx23885-video.c                |  2 +-
 drivers/media/pci/cx25821/cx25821-alsa.c                 |  2 +-
 drivers/media/pci/cx25821/cx25821-i2c.c                  |  2 +-
 drivers/media/pci/cx25821/cx25821-video.c                |  2 +-
 drivers/media/pci/cx88/cx88-alsa.c                       |  2 +-
 drivers/media/pci/cx88/cx88-blackbird.c                  |  2 +-
 drivers/media/pci/cx88/cx88-dvb.c                        |  2 +-
 drivers/media/pci/cx88/cx88-video.c                      |  2 +-
 drivers/media/pci/ddbridge/ddbridge-core.c               | 18 +++++++++---------
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c                   |  2 +-
 drivers/media/pci/ivtv/ivtv-i2c.c                        |  2 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c       |  2 +-
 drivers/media/pci/ngene/ngene-cards.c                    | 14 +++++++-------
 drivers/media/pci/saa7134/saa7134-alsa.c                 |  2 +-
 drivers/media/pci/saa7134/saa7134-empress.c              |  2 +-
 drivers/media/pci/saa7134/saa7134-i2c.c                  |  2 +-
 drivers/media/pci/saa7134/saa7134-video.c                |  2 +-
 drivers/media/pci/saa7164/saa7164-i2c.c                  |  2 +-
 drivers/media/pci/smipcie/smipcie-main.c                 |  8 ++++----
 drivers/media/pci/solo6x10/solo6x10-g723.c               |  2 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c           |  2 +-
 drivers/media/pci/tw68/tw68-video.c                      |  2 +-
 drivers/media/pci/tw686x/tw686x-audio.c                  |  2 +-
 drivers/media/pci/tw686x/tw686x-video.c                  |  2 +-
 drivers/media/platform/atmel/atmel-isc.c                 |  4 ++--
 drivers/media/platform/exynos-gsc/gsc-m2m.c              |  2 +-
 drivers/media/platform/exynos4-is/fimc-capture.c         |  2 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c             |  2 +-
 drivers/media/platform/m2m-deinterlace.c                 |  2 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c       |  2 +-
 drivers/media/platform/mx2_emmaprp.c                     |  2 +-
 drivers/media/platform/rcar-vin/rcar-dma.c               |  2 +-
 drivers/media/platform/rcar_jpu.c                        |  2 +-
 drivers/media/platform/s5p-g2d/g2d.c                     |  2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c              |  2 +-
 drivers/media/platform/sh_vou.c                          |  2 +-
 drivers/media/platform/soc_camera/atmel-isi.c            |  2 +-
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c |  2 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c            |  2 +-
 drivers/media/platform/sti/hva/hva-v4l2.c                |  4 ++--
 drivers/media/platform/ti-vpe/cal.c                      |  2 +-
 drivers/media/platform/ti-vpe/vpe.c                      |  2 +-
 drivers/media/platform/vim2m.c                           |  2 +-
 drivers/media/platform/xilinx/xilinx-dma.c               |  2 +-
 drivers/media/radio/si4713/radio-usb-si4713.c            |  2 +-
 drivers/media/rc/streamzap.c                             |  2 +-
 drivers/media/tuners/mt2063.c                            |  2 +-
 drivers/media/tuners/mt20xx.c                            |  4 ++--
 drivers/media/tuners/mxl5007t.c                          |  2 +-
 drivers/media/tuners/tda827x.c                           |  4 ++--
 drivers/media/tuners/tea5761.c                           |  2 +-
 drivers/media/tuners/tea5767.c                           |  2 +-
 drivers/media/tuners/tuner-simple.c                      |  2 +-
 drivers/media/usb/airspy/airspy.c                        |  2 +-
 drivers/media/usb/au0828/au0828-video.c                  |  2 +-
 drivers/media/usb/cx231xx/cx231xx-audio.c                |  2 +-
 drivers/media/usb/cx231xx/cx231xx-i2c.c                  |  2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c            |  2 +-
 drivers/media/usb/em28xx/em28xx-audio.c                  |  2 +-
 drivers/media/usb/em28xx/em28xx-i2c.c                    |  2 +-
 drivers/media/usb/em28xx/em28xx-video.c                  |  2 +-
 drivers/media/usb/go7007/go7007-i2c.c                    |  2 +-
 drivers/media/usb/go7007/go7007-usb.c                    |  2 +-
 drivers/media/usb/go7007/go7007-v4l2.c                   |  2 +-
 drivers/media/usb/go7007/snd-go7007.c                    |  2 +-
 drivers/media/usb/hackrf/hackrf.c                        |  2 +-
 drivers/media/usb/hdpvr/hdpvr-i2c.c                      |  2 +-
 drivers/media/usb/msi2500/msi2500.c                      |  2 +-
 drivers/media/usb/pwc/pwc-if.c                           |  2 +-
 drivers/media/usb/s2255/s2255drv.c                       |  2 +-
 drivers/media/usb/stk1160/stk1160-i2c.c                  |  2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c                  |  2 +-
 drivers/media/usb/tm6000/tm6000-alsa.c                   |  2 +-
 drivers/media/usb/usbtv/usbtv-audio.c                    |  2 +-
 drivers/media/usb/usbtv/usbtv-video.c                    |  2 +-
 drivers/media/usb/uvc/uvc_queue.c                        |  2 +-
 drivers/staging/media/omap4iss/iss.c                     |  2 +-
 drivers/usb/gadget/Kconfig                               |  1 +
 109 files changed, 139 insertions(+), 139 deletions(-)
