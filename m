Return-path: <mchehab@localhost>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9185 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab1GHPZk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2011 11:25:40 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LO000K8GTIPOR40@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 08 Jul 2011 16:25:37 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LO0006KPTIO00@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 08 Jul 2011 16:25:36 +0100 (BST)
Date: Fri, 08 Jul 2011 17:25:35 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PATCHES FOR 3.1] s5p-fimc and noon010pc30 drivers conversion to
 media controller API
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Message-id: <4E17216F.7030200@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hi Mauro,

The following changes since commit 6068c012c3741537c9f965be5b4249f989aa5efc:

  [media] v4l: Document V4L2 control endianness as machine endianness (2011-07-07 19:26:11 -0300)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-2.6-samsung s5p-fimc-next

These patches convert FIMC and the sensor driver to media controller API,
i.e. a top level media device is added to be able to manage at runtime
attached sensors and all video processing entities present in the SoC.
An additional subdev at FIMC capture driver exposes the scaler and
composing functionality of the video capture IP.
The previously existing functionality is entirely retained.

I have introduced a few changes comparing to the last version (v3) sent
to the ML, as commented below.

Sylwester Nawrocki (28):
      s5p-fimc: Add support for runtime PM in the mem-to-mem driver
      s5p-fimc: Add media entity initialization
      s5p-fimc: Remove registration of video nodes from probe()
      s5p-fimc: Remove sclk_cam clock handling
      s5p-fimc: Limit number of available inputs to one
      s5p-fimc: Remove sensor management code from FIMC capture driver
      s5p-fimc: Remove v4l2_device from video capture and m2m driver
      s5p-fimc: Add the media device driver
      s5p-fimc: Conversion to use struct v4l2_fh
	-> removed the check of return value from v4l2_fh_init as its
	   signature has changed

      s5p-fimc: Conversion to the control framework
      s5p-fimc: Add media operations in the capture entity driver
      s5p-fimc: Add PM helper function for streaming control
      s5p-fimc: Correct color format enumeration
      s5p-fimc: Convert to use media pipeline operations
      s5p-fimc: Add subdev for the FIMC processing block
	-> added setting of a default capture format in device open()

      s5p-fimc: Add support for camera capture in JPEG format
      s5p-fimc: Add v4l2_device notification support for single frame capture
      s5p-fimc: Use consistent names for the buffer list functions
      s5p-fimc: Add runtime PM support in the camera capture driver
      s5p-fimc: Correct crop offset alignment on exynos4
      s5p-fimc: Remove single-planar capability flags
      noon010pc30: Do not ignore errors in initial controls setup
      noon010pc30: Convert to the pad level ops
	-> removed unused variable and pad number prerequisite check 
	   in noon010_set_fmt

      noon010pc30: Clean up the s_power callback
      noon010pc30: Remove g_chip_ident operation handler
      s5p-csis: Handle all available power supplies
	-> renamed 'supply' to 'supplies' in s5p-csis as per Laurent's
	   suggestion

      s5p-csis: Rework of the system suspend/resume helpers
      s5p-csis: Enable v4l subdev device node

 drivers/media/video/Kconfig                 |    4 +-
 drivers/media/video/noon010pc30.c           |  173 ++--
 drivers/media/video/s5p-fimc/Makefile       |    2 +-
 drivers/media/video/s5p-fimc/fimc-capture.c | 1424 +++++++++++++++++++--------
 drivers/media/video/s5p-fimc/fimc-core.c    | 1119 +++++++++++----------
 drivers/media/video/s5p-fimc/fimc-core.h    |  222 +++--
 drivers/media/video/s5p-fimc/fimc-mdevice.c |  859 ++++++++++++++++
 drivers/media/video/s5p-fimc/fimc-mdevice.h |  118 +++
 drivers/media/video/s5p-fimc/fimc-reg.c     |   76 +-
 drivers/media/video/s5p-fimc/mipi-csis.c    |   84 +-
 drivers/media/video/s5p-fimc/regs-fimc.h    |    8 +-
 include/media/s5p_fimc.h                    |   11 +
 include/media/v4l2-chip-ident.h             |    3 -
 13 files changed, 2921 insertions(+), 1182 deletions(-)
 create mode 100644 drivers/media/video/s5p-fimc/fimc-mdevice.c
 create mode 100644 drivers/media/video/s5p-fimc/fimc-mdevice.h


Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
