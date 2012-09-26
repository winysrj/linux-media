Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:29908 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757106Ab2IZPyh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 11:54:37 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MAY00F2NS6UKE21@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 27 Sep 2012 00:54:35 +0900 (KST)
Received: from amdc248.digital.local ([106.116.147.32])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MAY000JLS6LTOA0@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 27 Sep 2012 00:54:35 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: a.hajda@samsung.com, sakari.ailus@iki.fi,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v3 0/5] s5p-fimc: Add interleaved image data capture support
Date: Wed, 26 Sep 2012 17:54:08 +0200
Message-id: <1348674853-24596-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

This patch series adds device/vendor specific media bus pixel code section
and defines S5C73MX camera specific media bus pixel code, along with
corresponding fourcc.

The third patch adds support for MIPI-CSI2 Embedded Data capture in
Samsung S5P/Exynos MIPI-CSIS device. It depends on patch
"[PATCH RFC] V4L: Add s_rx_buffer subdev video operation".

The fourth patch extends s5p-fimc driver to allow it to support
2-planar V4L2_PIX_FMT_S5C_UYVY_JPG format. More details can be found
in the patch summary. The [get/set]_frame_desc subdev callback are
used only to retrieve from a sensor subdev required buffer size.
It depends on patch
"[PATCH RFC] V4L: Add get/set_frame_desc subdev callbacks"

The fifth patch adds [get/set]_frame_desc op handlers to the m5mols
driver as an example. I prepared also similar patch for S5C73M3
sensor where 2 frame description entries are used, but that driver
is not yet mainlined due to a few missing items in V4L2 required
to fully control it, so I didn't include that patch in this series.

Changes since v2:
 - addressed review comments on patches adding the media bus pixel code
   and the fourcc,
 - minor cleanup of patch 4/5.

This series with all dependencies can be found in git repository
git://git.infradead.org/users/kmpark/linux-samsung v4l-framedesc

(http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/v4l-framedesc)

Thanks,
Sylwester

Sylwester Nawrocki (5):
  V4L: Add V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8 media bus format
  V4L: Add V4L2_PIX_FMT_S5C_UYVY_JPG fourcc definition
  s5p-csis: Add support for non-image data packets capture
  s5p-fimc: Add support for V4L2_PIX_FMT_S5C_UYVY_JPG fourcc
  m5mols: Implement .get_frame_desc subdev callback

 Documentation/DocBook/media/v4l/compat.xml         |   4 +
 Documentation/DocBook/media/v4l/pixfmt.xml         |  28 +++++
 Documentation/DocBook/media/v4l/subdev-formats.xml |  44 +++++++
 drivers/media/i2c/m5mols/m5mols.h                  |   9 ++
 drivers/media/i2c/m5mols/m5mols_capture.c          |   3 +
 drivers/media/i2c/m5mols/m5mols_core.c             |  47 +++++++
 drivers/media/i2c/m5mols/m5mols_reg.h              |   1 +
 drivers/media/platform/s5p-fimc/fimc-capture.c     | 135 ++++++++++++++++++---
 drivers/media/platform/s5p-fimc/fimc-core.c        |  19 ++-
 drivers/media/platform/s5p-fimc/fimc-core.h        |  28 ++++-
 drivers/media/platform/s5p-fimc/fimc-reg.c         |  23 +++-
 drivers/media/platform/s5p-fimc/fimc-reg.h         |   3 +-
 drivers/media/platform/s5p-fimc/mipi-csis.c        |  59 ++++++++-
 include/linux/v4l2-mediabus.h                      |   5 +
 include/linux/videodev2.h                          |   1 +
 15 files changed, 376 insertions(+), 33 deletions(-)

--
1.7.11.3
