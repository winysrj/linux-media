Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54170 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750880AbeEDK3m (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 06:29:42 -0400
Date: Fri, 4 May 2018 07:29:34 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.17-rc4] media fixes and a MAINTAINERS file update
 with my email
Message-ID: <20180504072934.3a5b9a3f@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.17-4


For:

- a trivial one-line fix addressing a PTR_ERR() getting value from a wrong
  var at imx driver;

- a patch changing my e-mail at the Kernel tree to mchehab@kernel.org.
  no code changes.

Thanks!
Mauro  


The following changes since commit 6da6c0db5316275015e8cc2959f12a17584aeb64:

  Linux v4.17-rc3 (2018-04-29 14:17:42 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.17-4

for you to fetch changes up to 3259081991a9398434f6f49468b960f136ac0158:

  MAINTAINERS & files: Canonize the e-mails I use at files (2018-05-04 06:21:06 -0400)

----------------------------------------------------------------
media fixes for v4.17-rc4

----------------------------------------------------------------
From: Gustavo A. R. Silva (1):
      media: imx-media-csi: Fix inconsistent IS_ERR and PTR_ERR

Mauro Carvalho Chehab (1):
      MAINTAINERS & files: Canonize the e-mails I use at files

 Documentation/doc-guide/parse-headers.rst               |  4 ++--
 Documentation/media/uapi/rc/keytable.c.rst              |  2 +-
 Documentation/media/uapi/v4l/v4l2grab.c.rst             |  2 +-
 Documentation/sphinx/parse-headers.pl                   |  4 ++--
 .../translations/zh_CN/video4linux/v4l2-framework.txt   |  4 ++--
 MAINTAINERS                                             | 17 -----------------
 drivers/media/i2c/saa7115.c                             |  2 +-
 drivers/media/i2c/saa711x_regs.h                        |  2 +-
 drivers/media/i2c/tda7432.c                             |  2 +-
 drivers/media/i2c/tvp5150.c                             |  2 +-
 drivers/media/i2c/tvp5150_reg.h                         |  2 +-
 drivers/media/i2c/tvp7002.c                             |  2 +-
 drivers/media/i2c/tvp7002_reg.h                         |  2 +-
 drivers/media/media-devnode.c                           |  2 +-
 drivers/media/pci/bt8xx/bttv-audio-hook.c               |  2 +-
 drivers/media/pci/bt8xx/bttv-audio-hook.h               |  2 +-
 drivers/media/pci/bt8xx/bttv-cards.c                    |  4 ++--
 drivers/media/pci/bt8xx/bttv-driver.c                   |  2 +-
 drivers/media/pci/bt8xx/bttv-i2c.c                      |  2 +-
 drivers/media/pci/cx23885/cx23885-input.c               |  2 +-
 drivers/media/pci/cx88/cx88-alsa.c                      |  4 ++--
 drivers/media/pci/cx88/cx88-blackbird.c                 |  2 +-
 drivers/media/pci/cx88/cx88-core.c                      |  2 +-
 drivers/media/pci/cx88/cx88-i2c.c                       |  2 +-
 drivers/media/pci/cx88/cx88-video.c                     |  2 +-
 drivers/media/radio/radio-aimslab.c                     |  2 +-
 drivers/media/radio/radio-aztech.c                      |  2 +-
 drivers/media/radio/radio-gemtek.c                      |  2 +-
 drivers/media/radio/radio-maxiradio.c                   |  2 +-
 drivers/media/radio/radio-rtrack2.c                     |  2 +-
 drivers/media/radio/radio-sf16fmi.c                     |  2 +-
 drivers/media/radio/radio-terratec.c                    |  2 +-
 drivers/media/radio/radio-trust.c                       |  2 +-
 drivers/media/radio/radio-typhoon.c                     |  2 +-
 drivers/media/radio/radio-zoltrix.c                     |  2 +-
 drivers/media/rc/keymaps/rc-avermedia-m135a.c           |  2 +-
 drivers/media/rc/keymaps/rc-encore-enltv-fm53.c         |  2 +-
 drivers/media/rc/keymaps/rc-encore-enltv2.c             |  2 +-
 drivers/media/rc/keymaps/rc-kaiomy.c                    |  2 +-
 drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c     |  2 +-
 drivers/media/rc/keymaps/rc-pixelview-new.c             |  2 +-
 drivers/media/tuners/tea5761.c                          |  4 ++--
 drivers/media/tuners/tea5767.c                          |  4 ++--
 drivers/media/tuners/tuner-xc2028-types.h               |  2 +-
 drivers/media/tuners/tuner-xc2028.c                     |  4 ++--
 drivers/media/tuners/tuner-xc2028.h                     |  2 +-
 drivers/media/usb/em28xx/em28xx-camera.c                |  2 +-
 drivers/media/usb/em28xx/em28xx-cards.c                 |  2 +-
 drivers/media/usb/em28xx/em28xx-core.c                  |  4 ++--
 drivers/media/usb/em28xx/em28xx-dvb.c                   |  4 ++--
 drivers/media/usb/em28xx/em28xx-i2c.c                   |  2 +-
 drivers/media/usb/em28xx/em28xx-input.c                 |  2 +-
 drivers/media/usb/em28xx/em28xx-video.c                 |  4 ++--
 drivers/media/usb/em28xx/em28xx.h                       |  2 +-
 drivers/media/usb/gspca/zc3xx-reg.h                     |  2 +-
 drivers/media/usb/tm6000/tm6000-cards.c                 |  2 +-
 drivers/media/usb/tm6000/tm6000-core.c                  |  2 +-
 drivers/media/usb/tm6000/tm6000-i2c.c                   |  2 +-
 drivers/media/usb/tm6000/tm6000-regs.h                  |  2 +-
 drivers/media/usb/tm6000/tm6000-usb-isoc.h              |  2 +-
 drivers/media/usb/tm6000/tm6000-video.c                 |  2 +-
 drivers/media/usb/tm6000/tm6000.h                       |  2 +-
 drivers/media/v4l2-core/v4l2-dev.c                      |  4 ++--
 drivers/media/v4l2-core/v4l2-ioctl.c                    |  2 +-
 drivers/media/v4l2-core/videobuf-core.c                 |  6 +++---
 drivers/media/v4l2-core/videobuf-dma-contig.c           |  2 +-
 drivers/media/v4l2-core/videobuf-dma-sg.c               |  6 +++---
 drivers/media/v4l2-core/videobuf-vmalloc.c              |  4 ++--
 drivers/staging/media/imx/imx-media-csi.c               |  2 +-
 include/media/i2c/tvp7002.h                             |  2 +-
 include/media/videobuf-core.h                           |  4 ++--
 include/media/videobuf-dma-sg.h                         |  4 ++--
 include/media/videobuf-vmalloc.h                        |  2 +-
 scripts/extract_xc3028.pl                               |  2 +-
 scripts/split-man.pl                                    |  2 +-
 75 files changed, 93 insertions(+), 110 deletions(-)




Thanks,
Mauro
