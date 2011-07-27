Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37452 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab1G0Qfm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 12:35:42 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LP000JI23FGKX@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 27 Jul 2011 17:35:40 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LP000I0V3FFW5@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 27 Jul 2011 17:35:39 +0100 (BST)
Date: Wed, 27 Jul 2011 18:35:39 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PATCHES FOR 3.1] s5p-fimc and noon010pc30 driver updates
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Message-id: <4E303E5B.9050701@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit f0a21151140da01c71de636f482f2eddec2840cc:

  Merge tag 'v3.0' into staging/for_v3.1 (2011-07-22 13:33:14 -0300)

are available in the git repository at:

  git://git.infradead.org/users/kmpark/linux-2.6-samsung fimc-for-mauro

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
      s5p-fimc: Conversion to the control framework
      s5p-fimc: Add media operations in the capture entity driver
      s5p-fimc: Add PM helper function for streaming control
      s5p-fimc: Correct color format enumeration
      s5p-fimc: Convert to use media pipeline operations
      s5p-fimc: Add subdev for the FIMC processing block
      s5p-fimc: Add support for camera capture in JPEG format
      s5p-fimc: Add v4l2_device notification support for single frame capture
      s5p-fimc: Use consistent names for the buffer list functions
      s5p-fimc: Add runtime PM support in the camera capture driver
      s5p-fimc: Correct crop offset alignment on exynos4
      s5p-fimc: Remove single-planar capability flags
      noon010pc30: Do not ignore errors in initial controls setup
      noon010pc30: Convert to the pad level ops
      noon010pc30: Clean up the s_power callback
      noon010pc30: Remove g_chip_ident operation handler
      s5p-csis: Handle all available power supplies
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

-- 
Regards,

Sylwester Nawrocki
Samsung Poland R&D Center
