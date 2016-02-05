Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55761 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684AbcBET7G (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2016 14:59:06 -0500
Date: Fri, 5 Feb 2016 17:59:00 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.5-rc3] media fixes
Message-ID: <20160205175900.3a239ace@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.5-3

For the following fixes:
  * vb2: fix a vb2_thread regression and DVB read() breakages;
  * vsp1: fix compilation and links creation;
  * s5k6a3: Fix VIDIOC_SUBDEV_G_FMT ioctl for TRY format
  * exynos4-is: fix a build issue, format negotiation and sensor detection
  * Fix a regression with pvrusb2 and ir-kbd-i2c
  * atmel-isi: fix debug message which only show the first format
  * tda1004x: fix a tuning bug if G_PROPERTY is called too early
  * saa7134-alsa: fix a bug at device unbinding/driver removal
  * Fix build of one driver if !HAS_DMA
  * soc_camera: cleanup control device on async_unbind

Thanks!
Mauro

-

The following changes since commit 92e963f50fc74041b5e9e744c330dca48e04f08d:

  Linux 4.5-rc1 (2016-01-24 13:06:47 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.5-3

for you to fetch changes up to ac75fe5d8fe4a0bf063be18fb29684405279e79e:

  [media] saa7134-alsa: Only frees registered sound cards (2016-02-04 16:26:10 -0200)

----------------------------------------------------------------
media fixes for v4.5-rc3

----------------------------------------------------------------
Anders Roxell (1):
      [media] drivers/media: vsp1_video: fix compile error

Arnd Bergmann (1):
      [media] exynos4-is: make VIDEO_SAMSUNG_EXYNOS4_IS tristate

Hans Verkuil (1):
      [media] vb2: fix nasty vb2_thread regression

Jacek Anaszewski (3):
      [media] s5k6a3: Fix VIDIOC_SUBDEV_G_FMT ioctl for TRY format
      [media] exynos4-is: Open shouldn't fail when sensor entity is not linked
      [media] exynos4-is: Wait for 100us before opening sensor

Javier Martinez Canillas (2):
      [media] v4l: vsp1: Fix wrong entities links creation
      [media] media: i2c: Don't export ir-kbd-i2c module alias

Josh Wu (1):
      [media] atmel-isi: fix debug message which only show the first format

Mauro Carvalho Chehab (3):
      [media] tda1004x: only update the frontend properties if locked
      [media] vb2-core: call threadio->fnc() if !VB2_BUF_STATE_ERROR
      [media] saa7134-alsa: Only frees registered sound cards

Rasmus Villemoes (1):
      [media] exynos4-is: fix a format string bug

Sudip Mukherjee (1):
      [media] media: Kconfig: add dependency of HAS_DMA

Wolfram Sang (1):
      [media] soc_camera: cleanup control device on async_unbind

 drivers/media/dvb-frontends/tda1004x.c             |  9 ++
 drivers/media/i2c/ir-kbd-i2c.c                     |  1 -
 drivers/media/i2c/s5k6a3.c                         |  3 +-
 drivers/media/pci/saa7134/saa7134-alsa.c           |  5 +-
 drivers/media/platform/Kconfig                     |  1 +
 drivers/media/platform/exynos4-is/Kconfig          |  2 +-
 drivers/media/platform/exynos4-is/fimc-is.c        |  6 ++
 drivers/media/platform/exynos4-is/fimc-isp-video.c |  4 +-
 drivers/media/platform/exynos4-is/media-dev.c      | 95 +++++++++++++++++-----
 drivers/media/platform/soc_camera/atmel-isi.c      |  2 +-
 drivers/media/platform/soc_camera/soc_camera.c     |  2 +
 drivers/media/platform/vsp1/vsp1_drv.c             |  7 +-
 drivers/media/platform/vsp1/vsp1_video.c           |  2 +-
 drivers/media/v4l2-core/videobuf2-core.c           | 95 ++++++++++------------
 drivers/media/v4l2-core/videobuf2-v4l2.c           |  2 +-
 include/media/videobuf2-core.h                     |  3 +-
 16 files changed, 155 insertions(+), 84 deletions(-)

