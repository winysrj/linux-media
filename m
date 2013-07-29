Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:35121 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab3G2QCy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jul 2013 12:02:54 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQP007VJGJBZFB0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 29 Jul 2013 17:02:52 +0100 (BST)
Message-id: <51F6922B.8020901@samsung.com>
Date: Mon, 29 Jul 2013 18:02:51 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: [GIT PULL] v4l2-async API updates
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This includes a couple updates to the v4l2-async API: an addition
of a method of matching subdevs by device tree node pointer, some
cleanups and a fix of typo in JPEG controls documentation.


The following changes since commit 51dd4d70fc59564454a4dcb90d6d46d39a4a97ef:

  [media] em28xx: Fix vidioc fmt vid cap v4l2 compliance (2013-07-26 13:35:02 -0300)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git for-v3.12

for you to fetch changes up to 6d4ba88a0a3a0debaadc444e9c3b03f61701226c:

  DocBook: Fix typo in V4L2_CID_JPEG_COMPRESSION_QUALITY reference (2013-07-29 16:13:10 +0200)

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
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    6 +-
 drivers/media/platform/soc_camera/soc_camera.c     |    4 +-
 drivers/media/v4l2-core/v4l2-async.c               |  106 ++++++++++----------
 include/media/v4l2-async.h                         |   36 +++----
 include/media/v4l2-subdev.h                        |   13 ++-
 8 files changed, 81 insertions(+), 92 deletions(-)

--
Regards,
Sylwester
