Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60123 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266Ab2JCReF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2012 13:34:05 -0400
Received: from eusync1.samsung.com (mailout3.w1.samsung.com [210.118.77.13])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBB0014UVHJYW00@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 03 Oct 2012 18:34:31 +0100 (BST)
Received: from [106.116.147.32] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MBB00IHLVGQZJ80@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 03 Oct 2012 18:34:02 +0100 (BST)
Message-id: <506C7709.8030905@samsung.com>
Date: Wed, 03 Oct 2012 19:34:01 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.7] V4L: s5p-fimc: support for interleaved image data
 capture
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 2425bb3d4016ed95ce83a90b53bd92c7f31091e4:

  em28xx: regression fix: use DRX-K sync firmware requests on em28xx (2012-10-02 17:15:22 -0300)

are available in the git repository at:

  git://git.infradead.org/users/kmpark/linux-samsung v4l_for_mauro

for you to fetch changes up to 7f06319c3a6e99fcdf9774556384c62661a31940:

  m5mols: Implement .get_frame_desc subdev callback (2012-10-03 13:01:25 +0200)

This includes a few more s5p-* driver updates and fixes, addition of 
a fourcc and media bus pixel code for S5C73M3 camera, some new v4l2 
subdev callbacks for low level media bus frame parameters and a helper
for capture of frame embedded data.

----------------------------------------------------------------
Hans Verkuil (2):
      s5p-g2d: fix compiler warning
      s5p-fimc: fix compiler warning

Sylwester Nawrocki (7):
      V4L: Add s_rx_buffer subdev video operation
      V4L: Add [get/set]_frame_desc subdev callbacks
      V4L: Add V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8 media bus format
      V4L: Add V4L2_PIX_FMT_S5C_UYVY_JPG fourcc definition
      s5p-csis: Add support for non-image data packets capture
      s5p-fimc: Add support for V4L2_PIX_FMT_S5C_UYVY_JPG fourcc
      m5mols: Implement .get_frame_desc subdev callback

Thomas Abraham (1):
      s5p-jpeg: use clk_prepare_enable and clk_disable_unprepare

 Documentation/DocBook/media/v4l/compat.xml         |    4 +
 Documentation/DocBook/media/v4l/pixfmt.xml         |   28 ++++
 Documentation/DocBook/media/v4l/subdev-formats.xml |   44 +++++++
 drivers/media/i2c/m5mols/m5mols.h                  |    9 ++
 drivers/media/i2c/m5mols/m5mols_capture.c          |    3 +
 drivers/media/i2c/m5mols/m5mols_core.c             |   47 +++++++
 drivers/media/i2c/m5mols/m5mols_reg.h              |    1 +
 drivers/media/platform/s5p-fimc/fimc-capture.c     |  135 +++++++++++++++++---
 drivers/media/platform/s5p-fimc/fimc-core.c        |   19 ++-
 drivers/media/platform/s5p-fimc/fimc-core.h        |   28 +++-
 drivers/media/platform/s5p-fimc/fimc-m2m.c         |   25 ++--
 drivers/media/platform/s5p-fimc/fimc-reg.c         |   23 +++-
 drivers/media/platform/s5p-fimc/fimc-reg.h         |    3 +-
 drivers/media/platform/s5p-fimc/mipi-csis.c        |   52 +++++++-
 drivers/media/platform/s5p-g2d/g2d.c               |    2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |    6 +-
 include/linux/v4l2-mediabus.h                      |    5 +
 include/linux/videodev2.h                          |    1 +
 include/media/v4l2-subdev.h                        |   48 +++++++
 19 files changed, 433 insertions(+), 50 deletions(-)

---

Thanks,
Sylwester
