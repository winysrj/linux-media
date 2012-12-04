Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53841 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab2LDQyH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Dec 2012 11:54:07 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MEI00196N1IEKB0@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 04 Dec 2012 16:56:43 +0000 (GMT)
Received: from [106.116.147.32] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MEI00EU2MY4NG00@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 04 Dec 2012 16:54:04 +0000 (GMT)
Message-id: <50BE2AAC.9040603@samsung.com>
Date: Tue, 04 Dec 2012 17:54:04 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] s5p-fimc driver updates for Exynos4x12 SoC support
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This series is mainly prerequisite patches for camera devices (FIMC, FIMC-LITE,
MIPI-CSIS, FIMC-IS) support on Exynos4x12 (two- and quad-core) SoCs. Exynos4412
is a processor found on Origen 4 Quad dev board for example.
It would have been good to have this series in 3.8, however if it is already
not reachable then please pull for 3.9.

The following changes since commit df5450d51945b4a1a506200e11267626a6d324e3:

  Merge tag 'v3.7-rc8' into staging/for_v3.8 (2012-12-04 10:46:21 -0200)

are available in the git repository at:


  git://git.infradead.org/users/kmpark/linux-samsung v4l_s5p_fimc

for you to fetch changes up to c78a1a3584a7a2b89e84e57382abec9153a477fe:

  s5p-fimc: Improved pipeline try format routine (2012-12-04 16:47:27 +0100)

----------------------------------------------------------------
Andrzej Hajda (1):
      s5p-fimc: Add support for sensors with multiple pads

Sylwester Nawrocki (10):
      V4L: DocBook: Add V4L2_MBUS_FMT_YUV10_1X30 media bus pixel code
      fimc-lite: Register dump function cleanup
      s5p-fimc: Clean up capture enable/disable helpers
      s5p-fimc: Add variant data structure for Exynos4x12
      s5p-csis: Add support for raw Bayer pixel formats
      s5p-csis: Enable only data lanes that are actively used
      s5p-csis: Add registers logging for debugging
      s5p-fimc: Add sensor group ids for fimc-is
      fimc-lite: Add ISP FIFO output support
      s5p-fimc: Improved pipeline try format routine

 Documentation/DocBook/media/v4l/subdev-formats.xml |  718 ++++++--------------
 Documentation/DocBook/media_api.tmpl               |    1 +
 drivers/media/platform/s5p-fimc/fimc-capture.c     |  105 ++-
 drivers/media/platform/s5p-fimc/fimc-core.c        |   90 ++-
 drivers/media/platform/s5p-fimc/fimc-core.h        |    8 +-
 drivers/media/platform/s5p-fimc/fimc-lite-reg.c    |    6 +-
 drivers/media/platform/s5p-fimc/fimc-lite.c        |  146 +++-
 drivers/media/platform/s5p-fimc/fimc-lite.h        |    7 +-
 drivers/media/platform/s5p-fimc/fimc-m2m.c         |    2 +-
 drivers/media/platform/s5p-fimc/fimc-mdevice.c     |   26 +-
 drivers/media/platform/s5p-fimc/fimc-mdevice.h     |   12 +-
 drivers/media/platform/s5p-fimc/fimc-reg.c         |   40 +-
 drivers/media/platform/s5p-fimc/fimc-reg.h         |    4 +-
 drivers/media/platform/s5p-fimc/mipi-csis.c        |   52 +-
 include/uapi/linux/v4l2-mediabus.h                 |    3 +-
 15 files changed, 548 insertions(+), 672 deletions(-)

---

Regards,
Sylwester
