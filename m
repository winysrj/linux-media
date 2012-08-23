Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:19495 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758145Ab2HWJwJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Aug 2012 05:52:09 -0400
Received: from epcpsbgm1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M9700EG3CQH07Z0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 23 Aug 2012 18:52:07 +0900 (KST)
Received: from amdc248.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M9700GHMCQHII60@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 23 Aug 2012 18:52:07 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: riverful.kim@samsung.com, sw0312.kim@samsung.com,
	sakari.ailus@iki.fi, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 0/4] V4L2: Vendor specific media bus formats/ frame size
 control
Date: Thu, 23 Aug 2012 11:51:25 +0200
Message-id: <1345715489-30158-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series introduces new image source class control - V4L2_CID_FRAMESIZE
and vendor or device specific media bus format section.

There was already a discussion WRT handling interleaved image data [1].
I'm not terribly happy with those vendor specific media bus formats but I
couldn't find better solution that would comply with the V4L2 API concepts
and would work reliably.

What could be improved is lookup of media bus code based on fourcc, it could
probably be moved to some common module. But with only one driver it might
not make currently much sense to add it. Especially that there had to be
a lookup entry added in the private format info array in the s5p-fimc.


Comments ?


--
Regards,
Sylwester

Sylwester Nawrocki (4):
  V4L: Add V4L2_CID_FRAMESIZE image source class control
  V4L: Add V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8 media bus format
  V4L: Add V4L2_PIX_FMT_S5C_UYVY_JPG fourcc definition
  s5p-fimc: Add support for V4L2_PIX_FMT_S5C_UYVY_JPG fourcc

 Documentation/DocBook/media/v4l/compat.xml         |  4 +
 Documentation/DocBook/media/v4l/controls.xml       | 12 +++
 Documentation/DocBook/media/v4l/pixfmt.xml         | 10 +++
 Documentation/DocBook/media/v4l/subdev-formats.xml | 45 +++++++++++
 drivers/media/platform/s5p-fimc/fimc-capture.c     | 86 +++++++++++++++++-----
 drivers/media/platform/s5p-fimc/fimc-core.c        | 16 +++-
 drivers/media/platform/s5p-fimc/fimc-core.h        | 26 +++++--
 drivers/media/platform/s5p-fimc/fimc-reg.c         |  3 +-
 drivers/media/platform/s5p-fimc/mipi-csis.c        |  6 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |  2 +
 include/linux/v4l2-mediabus.h                      |  5 ++
 include/linux/videodev2.h                          |  2 +
 12 files changed, 191 insertions(+), 26 deletions(-)

--
1.7.11.3

[1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg42707.html
