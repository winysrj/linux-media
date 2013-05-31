Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:23538 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab3EaQrU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 12:47:20 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNO004HT9AVI5T0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Sat, 01 Jun 2013 01:47:19 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hj210.choi@samsung.com, yhwan.joo@samsung.com, arun.kk@samsung.com,
	shaik.ameer@samsung.com, kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [REVIEW PATCH 0/7] exynos4-is cleanup and ISP capture video driver
 addition
Date: Fri, 31 May 2013 18:46:58 +0200
Message-id: <1370018825-13088-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an initial version of the output DMA driver of the Exynos4x12 FIMC-IS
ISP IP block. First 6 patches are mostly cleanups, the actual driver is added
in the last patch.
There is one issue in those DMA interfaces - the DMA addresses of all buffers
need to be preconfigured before streaming is started. The VIDIOC_CREATE_BUFS
ioctl is not yet supported.

Thanks,
Sylwester

Phil Carmody (1):
  exynos4-is: Simplify bitmask usage

Sylwester Nawrocki (6):
  exynos4-is: Remove leftovers of non-dt FIMC-LITE support
  exynos4-is: Remove unused code
  exynos4-is: Refactor vidioc_s_fmt, vidioc_try_fmt handlers
  exynos4-is: Move __fimc_videoc_querycap() function to the common
    module
  exynos4-is: Add isp_dbg() macro
  exynos4-is: Add the FIMC-IS ISP capture DMA driver

 drivers/media/platform/exynos4-is/Kconfig          |    9 +
 drivers/media/platform/exynos4-is/Makefile         |    4 +
 drivers/media/platform/exynos4-is/common.c         |   12 +
 drivers/media/platform/exynos4-is/common.h         |    4 +
 drivers/media/platform/exynos4-is/fimc-capture.c   |  158 +++--
 drivers/media/platform/exynos4-is/fimc-core.c      |   11 -
 drivers/media/platform/exynos4-is/fimc-core.h      |    2 -
 drivers/media/platform/exynos4-is/fimc-is-param.c  |   80 ++-
 drivers/media/platform/exynos4-is/fimc-is-param.h  |    5 +
 drivers/media/platform/exynos4-is/fimc-is-regs.c   |   18 +-
 drivers/media/platform/exynos4-is/fimc-is-regs.h   |    1 +
 drivers/media/platform/exynos4-is/fimc-is.c        |   11 +-
 drivers/media/platform/exynos4-is/fimc-is.h        |   13 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |  650 ++++++++++++++++++++
 drivers/media/platform/exynos4-is/fimc-isp-video.h |   44 ++
 drivers/media/platform/exynos4-is/fimc-isp.c       |   49 +-
 drivers/media/platform/exynos4-is/fimc-isp.h       |   45 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |    1 +
 drivers/media/platform/exynos4-is/media-dev.c      |   21 +-
 drivers/media/platform/exynos4-is/media-dev.h      |    8 -
 20 files changed, 957 insertions(+), 189 deletions(-)
 create mode 100644 drivers/media/platform/exynos4-is/fimc-isp-video.c
 create mode 100644 drivers/media/platform/exynos4-is/fimc-isp-video.h

--
1.7.9.5

