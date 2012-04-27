Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29704 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528Ab2D0JxQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 05:53:16 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M34007HVU3UH000@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 10:52:42 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M34009K4U4JNJ@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 10:53:12 +0100 (BST)
Date: Fri, 27 Apr 2012 11:52:53 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 00/13] V4L: Exynos 4x12 camera host interface (FIMC-LITE) driver
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	sungchun.kang@samsung.com, subash.ramaswamy@linaro.org,
	s.nawrocki@samsung.com
Message-id: <1335520386-20835-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This change set adds support for FIMC-LITE devices, available in Exynos4x12
(and Exynos5) SoCs, to the existing s5p-fimc driver.
I have tested only DMA output operation (through a corresponding video node).

The FIMC-LITE differs from regular FIMC in that it doesn't have a scaler,
rotator and color converter and a DMA input. So it's just basic camera host 
interface, with additional internal FIFO data output to other SoC sub-modules.

Cropping at the host interface input is exposed on a subdev sink pad through
the selection API, and composition performed by the output DMA engine can be
controlled through selection compose targets on the video node.

I tried to make the exynos-fimc-lite module as much independent as possible,
to allow its reuse on any other SoCs that have same IP block.

This change set also includes small enhancement of V4L2_CID_COLORFX and
a patch adding support for this control at the s5p-fimc driver.

Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center


Sylwester Nawrocki (13):
  V4L: Extend V4L2_CID_COLORFX with more image effects
  s5p-fimc: Move m2m node driver into separate file
  s5p-fimc: Simplify the variant data structure
  s5p-fimc: Use v4l2_subdev internal ops to register video nodes
  s5p-fimc: Refactor the register interface functions
  s5p-fimc: Add FIMC-LITE register definitions
  s5p-fimc: Rework the video pipeline control functions
  s5p-fimc: Prefix format enumerations with FIMC_FMT_
  s5p-fimc: Make sure the interrupt is properly requested
  s5p-fimc: Minor cleanups
  s5p-fimc: Add support for Exynos4x12 FIMC-LITE
  s5p-fimc: Update copyright notices
  s5p-fimc: Add color effect control

 Documentation/DocBook/media/v4l/compat.xml   |   10 +
 Documentation/DocBook/media/v4l/controls.xml |   92 +-
 Documentation/DocBook/media/v4l/v4l2.xml     |    5 +-
 drivers/media/video/Kconfig                  |   24 +-
 drivers/media/video/s5p-fimc/Kconfig         |   47 +
 drivers/media/video/s5p-fimc/Makefile        |    6 +-
 drivers/media/video/s5p-fimc/fimc-capture.c  |  301 +++--
 drivers/media/video/s5p-fimc/fimc-core.c     | 1099 +++---------------
 drivers/media/video/s5p-fimc/fimc-core.h     |  251 ++--
 drivers/media/video/s5p-fimc/fimc-lite-reg.c |  301 +++++
 drivers/media/video/s5p-fimc/fimc-lite-reg.h |  153 +++
 drivers/media/video/s5p-fimc/fimc-lite.c     | 1589 ++++++++++++++++++++++++++
 drivers/media/video/s5p-fimc/fimc-lite.h     |  212 ++++
 drivers/media/video/s5p-fimc/fimc-m2m.c      |  820 +++++++++++++
 drivers/media/video/s5p-fimc/fimc-mdevice.c  |  405 ++++---
 drivers/media/video/s5p-fimc/fimc-mdevice.h  |   18 +-
 drivers/media/video/s5p-fimc/fimc-reg.c      |  613 +++++-----
 drivers/media/video/s5p-fimc/fimc-reg.h      |  326 ++++++
 drivers/media/video/s5p-fimc/regs-fimc.h     |  301 -----
 drivers/media/video/v4l2-ctrls.c             |    6 +
 include/linux/videodev2.h                    |   26 +-
 include/media/s5p_fimc.h                     |   16 +
 22 files changed, 4628 insertions(+), 1993 deletions(-)
 create mode 100644 drivers/media/video/s5p-fimc/Kconfig
 create mode 100644 drivers/media/video/s5p-fimc/fimc-lite-reg.c
 create mode 100644 drivers/media/video/s5p-fimc/fimc-lite-reg.h
 create mode 100644 drivers/media/video/s5p-fimc/fimc-lite.c
 create mode 100644 drivers/media/video/s5p-fimc/fimc-lite.h
 create mode 100644 drivers/media/video/s5p-fimc/fimc-m2m.c
 create mode 100644 drivers/media/video/s5p-fimc/fimc-reg.h
 delete mode 100644 drivers/media/video/s5p-fimc/regs-fimc.h

-- 
1.7.10

