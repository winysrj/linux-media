Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:55131 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab3GVSFF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jul 2013 14:05:05 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQC001SUNKEF9H0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 23 Jul 2013 03:05:03 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, prabhakar.csengg@gmail.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 0/5] v4l2-async DT support improvement and cleanups
Date: Mon, 22 Jul 2013 20:04:42 +0200
Message-id: <1374516287-7638-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This is a few patches for the v4l2-async API I wrote while adding
the asynchronous subdev registration support to the exynos4-is
driver.

The most significant change is addition of V4L2_ASYNC_MATCH_OF
subdev matching method, where host driver can pass a list of
of_node pointers identifying its subdevs.

I thought it's a reasonable and simple enough way to support device
tree based systems. Comments/other ideas are of course welcome.

Thanks,
Sylwester

Sylwester Nawrocki (5):
  V4L2: Drop bus_type check in v4l2-async match functions
  V4L2: Rename v4l2_async_bus_* to v4l2_async_match_*
  V4L2: Add V4L2_ASYNC_MATCH_OF subdev matching type
  V4L2: Rename subdev field of struct v4l2_async_notifier
  V4L2: Fold struct v4l2_async_subdev_list with struct v4l2_subdev

 drivers/media/platform/soc_camera/soc_camera.c |    4 +-
 drivers/media/v4l2-core/v4l2-async.c           |  106 ++++++++++++------------
 include/media/v4l2-async.h                     |   36 ++++----
 include/media/v4l2-subdev.h                    |   13 ++-
 4 files changed, 74 insertions(+), 85 deletions(-)

--
1.7.9.5

