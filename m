Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:58886 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab2EDPbE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2012 11:31:04 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M3I006GH8FKT8@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 May 2012 16:30:56 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3I006C18FQGM@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 May 2012 16:31:02 +0100 (BST)
Date: Fri, 04 May 2012 17:31:01 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PULL FOR 3.5] s5p-fimc driver updates
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Message-id: <4FA3F635.60409@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 34b2debaa62bfa384ef91b61cf2c40c48e86a5e2:

  s5p-fimc: Correct memory allocation for VIDIOC_CREATE_BUFS (2012-05-04 17:07:24 +0200)

are available in the git repository at:

  git://git.infradead.org/users/kmpark/linux-samsung v4l-fimc-exynos4x12

for you to fetch changes up to bab96b068afa07105139be09d3830cc9ed580382:

  s5p-fimc: Use selection API in place of crop operations (2012-05-04 17:18:38 +0200)

----------------------------------------------------------------
Sylwester Nawrocki (14):
      V4L: Extend V4L2_CID_COLORFX with more image effects
      s5p-fimc: Avoid crash with null platform_data
      s5p-fimc: Move m2m node driver into separate file
      s5p-fimc: Use v4l2_subdev internal ops to register video nodes
      s5p-fimc: Refactor the register interface functions
      s5p-fimc: Add FIMC-LITE register definitions
      s5p-fimc: Rework the video pipeline control functions
      s5p-fimc: Prefix format enumerations with FIMC_FMT_
      s5p-fimc: Minor cleanups
      s5p-fimc: Make sure an interrupt is properly requested
      s5p-fimc: Add support for Exynos4x12 FIMC-LITE
      s5p-fimc: Update copyright notices
      s5p-fimc: Add color effect control
      s5p-fimc: Use selection API in place of crop operations

 Documentation/DocBook/media/v4l/compat.xml   |   13 +
 Documentation/DocBook/media/v4l/controls.xml |   98 ++-
 Documentation/DocBook/media/v4l/v4l2.xml     |    5 +-
 drivers/media/video/Kconfig                  |   24 +-
 drivers/media/video/s5p-fimc/Kconfig         |   48 ++
 drivers/media/video/s5p-fimc/Makefile        |    6 +-
 drivers/media/video/s5p-fimc/fimc-capture.c  |  473 ++++++++-----
 drivers/media/video/s5p-fimc/fimc-core.c     | 1096 +++++-----------------------
 drivers/media/video/s5p-fimc/fimc-core.h     |  254 ++-----
 drivers/media/video/s5p-fimc/fimc-lite-reg.c |  300 ++++++++
 drivers/media/video/s5p-fimc/fimc-lite-reg.h |  150 ++++
 drivers/media/video/s5p-fimc/fimc-lite.c     | 1576 +++++++++++++++++++++++++++++++++++++++++
 drivers/media/video/s5p-fimc/fimc-lite.h     |  213 ++++++
 drivers/media/video/s5p-fimc/fimc-m2m.c      |  820 +++++++++++++++++++++
 drivers/media/video/s5p-fimc/fimc-mdevice.c  |  407 +++++++----
 drivers/media/video/s5p-fimc/fimc-mdevice.h  |   18 +-
 drivers/media/video/s5p-fimc/fimc-reg.c      |  613 ++++++++--------
 drivers/media/video/s5p-fimc/fimc-reg.h      |  326 +++++++++
 drivers/media/video/s5p-fimc/regs-fimc.h     |  301 --------
 drivers/media/video/v4l2-ctrls.c             |    7 +
 include/linux/videodev2.h                    |   29 +-
 include/media/s5p_fimc.h                     |   16 +
 22 files changed, 4734 insertions(+), 2059 deletions(-)
 create mode 100644 drivers/media/video/s5p-fimc/Kconfig
 create mode 100644 drivers/media/video/s5p-fimc/fimc-lite-reg.c
 create mode 100644 drivers/media/video/s5p-fimc/fimc-lite-reg.h
 create mode 100644 drivers/media/video/s5p-fimc/fimc-lite.c
 create mode 100644 drivers/media/video/s5p-fimc/fimc-lite.h
 create mode 100644 drivers/media/video/s5p-fimc/fimc-m2m.c
 create mode 100644 drivers/media/video/s5p-fimc/fimc-reg.h
 delete mode 100644 drivers/media/video/s5p-fimc/regs-fimc.h

I have added following 2 patches, from my previous pull request for 3.4-rc
(http://patchwork.linuxtv.org/patch/10888/), on top of staging/for_v3.5 
as a base for this patch set:

34b2deb s5p-fimc: Correct memory allocation for VIDIOC_CREATE_BUFS
157495a s5p-fimc: Fix locking in subdev set_crop op


Regards
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
