Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:22364 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab3G2MCX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jul 2013 08:02:23 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQP007WD5FBR480@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 29 Jul 2013 13:02:21 +0100 (BST)
Received: from [106.116.147.32] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MQP004ZA5FWTT10@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 29 Jul 2013 13:02:21 +0100 (BST)
Message-id: <51F659C9.7000208@samsung.com>
Date: Mon, 29 Jul 2013 14:02:17 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] v4l2-async API updates
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This includes a couple updates to the v4l2-async API: an addition
of a method of matching subdevs by device tree node pointer, some
cleanups and a typo fix for the JPEG controls documentation.

The following changes since commit 51dd4d70fc59564454a4dcb90d6d46d39a4a97ef:

  [media] em28xx: Fix vidioc fmt vid cap v4l2 compliance (2013-07-26 13:35:02
-0300)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git for-v3.12

for you to fetch changes up to 3d7d76fe1bf5b9f64ea3f718aec51a75e856a463:

  DocBook: Fix typo in V4L2_CID_JPEG_COMPRESSION_QUALITY reference (2013-07-29
13:44:54 +0200)

----------------------------------------------------------------
Sylwester Nawrocki (6):
      V4L: Drop bus_type check in v4l2-async match functions
      V4L: Rename v4l2_async_bus_* to v4l2_async_match_*
      V4L: Add V4L2_ASYNC_MATCH_OF subdev matching type
      V4L: Rename subdev field of struct v4l2_async_notifier
      V4L: Merge struct v4l2_async_subdev_list with struct v4l2_subdev
      DocBook: Fix typo in V4L2_CID_JPEG_COMPRESSION_QUALITY reference

 .../DocBook/media/v4l/vidioc-g-jpegcomp.xml        |    4 +-
 drivers/media/platform/davinci/vpif_capture.c      |    2 +-
 drivers/media/platform/davinci/vpif_display.c      |    2 +-
 drivers/media/platform/soc_camera/soc_camera.c     |    4 +-
 drivers/media/v4l2-core/v4l2-async.c               |  106 ++++++++++----------
 include/media/v4l2-async.h                         |   36 +++----
 include/media/v4l2-subdev.h                        |   13 ++-
 7 files changed, 78 insertions(+), 89 deletions(-)

--
Regards,
Sylwester
