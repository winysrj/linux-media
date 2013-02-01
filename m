Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:13030 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766Ab3BAOBv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 09:01:51 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MHJ00BH7O6RIK70@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Feb 2013 14:01:48 +0000 (GMT)
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MHJ00BKEOB0K690@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Feb 2013 14:01:48 +0000 (GMT)
Message-id: <510BCACB.5090502@samsung.com>
Date: Fri, 01 Feb 2013 15:01:47 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	'Arun Kumar K' <arun.kk@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [GIT PULL FOR 3.9] Samsung media driver updates
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following change set includes various fixes and cleanups for the
S5P/Exynos SoC media drivers (camera, video codec, g2d), some Samsung
camera sensor driver updates and a new driver for the S5C73M3 camera.
The branch is on top of staging/for_v3.9 branch and a bugfix patch
that was in my previous pull request [1].

[1] http://patchwork.linuxtv.org/patch/16317

The following changes since commit 520f1fdfb9378b3718c6ce1c3ced5e784cfcaee0:

  s5p-csis: Fix clock handling on error path in probe() (2013-01-30 18:41:12 +0100)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git for_v3.9

for you to fetch changes up to 50c26256ca6bb8723da296edb8df0863663d871c:

  MAINTAINERS: Add s5c73m3 driver entry (2013-02-01 13:50:51 +0100)

----------------------------------------------------------------
Andrzej Hajda (2):
      V4L: Add S5C73M3 camera driver
      MAINTAINERS: Add s5c73m3 driver entry

Arun Kumar K (1):
      s5p-mfc: Fix kernel warning on memory init

Kamil Debski (1):
      s5p-mfc: Fix a watchdog bug

Sachin Kamat (7):
      s5p-mfc: Use NULL instead of 0 for pointer
      s5p-g2d: Add support for G2D H/W Rev.4.1
      s5k6aa: Use devm_regulator_bulk_get API
      s5p-mfc: Use WARN_ON(condition) directly
      s5p-csis: Use devm_regulator_bulk_get API
      s5c73m3: Staticize some symbols
      s5c73m3: Use devm_regulator_bulk_get API

Sylwester Nawrocki (12):
      s5p-fimc: Fix bytesperline value for V4L2_PIX_FMT_YUV420M format
      noon010p30: Remove unneeded v4l2 control compatibility ops
      s5p-fimc: fimc-lite: Remove empty s_power subdev callback
      s5p-fimc: fimc-lite: Prevent deadlock at STREAMON/OFF ioctls
      s5p-fimc: Add missing line breaks
      s5p-fimc: Change platform subdevs registration method
      s5p-fimc: Check return value of clk_enable/clk_set_rate
      s5p-csis: Check return value of clk_enable/clk_set_rate
      s5p-fimc: Avoid null pointer dereference in fimc_capture_ctrls_create()
      s5p-fimc: Set default image format at device open()
      s5p-fimc: Fix FIMC.n subdev set_selection ioctl handler
      s5p-fimc: Add clk_prepare/unprepare for sclk_cam clocks

 MAINTAINERS                                     |    7 +
 drivers/media/i2c/Kconfig                       |    7 +
 drivers/media/i2c/Makefile                      |    1 +
 drivers/media/i2c/noon010pc30.c                 |    7 -
 drivers/media/i2c/s5c73m3/Makefile              |    2 +
 drivers/media/i2c/s5c73m3/s5c73m3-core.c        | 1704 +++++++++++++++++++++++
 drivers/media/i2c/s5c73m3/s5c73m3-ctrls.c       |  563 ++++++++
 drivers/media/i2c/s5c73m3/s5c73m3-spi.c         |  156 +++
 drivers/media/i2c/s5c73m3/s5c73m3.h             |  459 ++++++
 drivers/media/i2c/s5k6aa.c                      |    7 +-
 drivers/media/platform/s5p-fimc/fimc-capture.c  |   27 +-
 drivers/media/platform/s5p-fimc/fimc-core.c     |   75 +-
 drivers/media/platform/s5p-fimc/fimc-core.h     |    9 +-
 drivers/media/platform/s5p-fimc/fimc-lite-reg.c |    2 +-
 drivers/media/platform/s5p-fimc/fimc-lite.c     |   60 +-
 drivers/media/platform/s5p-fimc/fimc-lite.h     |    2 +-
 drivers/media/platform/s5p-fimc/fimc-m2m.c      |  134 +-
 drivers/media/platform/s5p-fimc/fimc-mdevice.c  |  260 ++--
 drivers/media/platform/s5p-fimc/mipi-csis.c     |   37 +-
 drivers/media/platform/s5p-g2d/g2d-hw.c         |   16 +-
 drivers/media/platform/s5p-g2d/g2d-regs.h       |    7 +
 drivers/media/platform/s5p-g2d/g2d.c            |   31 +-
 drivers/media/platform/s5p-g2d/g2d.h            |   17 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |   81 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c    |    2 +-
 include/media/s5c73m3.h                         |   55 +
 27 files changed, 3385 insertions(+), 345 deletions(-)
 create mode 100644 drivers/media/i2c/s5c73m3/Makefile
 create mode 100644 drivers/media/i2c/s5c73m3/s5c73m3-core.c
 create mode 100644 drivers/media/i2c/s5c73m3/s5c73m3-ctrls.c
 create mode 100644 drivers/media/i2c/s5c73m3/s5c73m3-spi.c
 create mode 100644 drivers/media/i2c/s5c73m3/s5c73m3.h
 create mode 100644 include/media/s5c73m3.h

The corresponding patchwork commands are:

pwclient -s accepted 16219
pwclient -s accepted 16588
pwclient -s accepted 16311
pwclient -s accepted 16221
pwclient -s superseded 16159
pwclient -s accepted 16289
pwclient -s accepted 16179
pwclient -s accepted 16180
pwclient -s accepted 16250
pwclient -s accepted 16390
pwclient -s accepted 16511
pwclient -s accepted 16569
pwclient -s accepted 16205
pwclient -s accepted 16345
pwclient -s accepted 16312
pwclient -s accepted 16313
pwclient -s accepted 16431
pwclient -s accepted 16432
pwclient -s accepted 16556
pwclient -s accepted 16557
pwclient -s accepted 16558
pwclient -s accepted 16559
pwclient -s accepted 16561


---

Thanks,
Sylwester
