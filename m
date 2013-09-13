Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:63932 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab3IMM4n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Sep 2013 08:56:43 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, kyungmin.park@samsung.com, pawel@osciak.com,
	javier.martin@vista-silicon.com, m.szyprowski@samsung.com,
	shaik.ameer@samsung.com, arun.kk@samsung.com, k.debski@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 0/7] V4L2 mem-to-mem ioctl helpers
Date: Fri, 13 Sep 2013 14:56:19 +0200
Message-id: <1379076986-10446-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch set adds ioctl helpers to the v4l2-mem2mem module so the
video mem-to-mem drivers can be simplified by removing functions that
are only a pass-through to the v4l2_m2m_* calls. In addition some of
the vb2 helper functions can be used as well.

These helpers are similar to the videobuf2 ioctl helpers introduced
in commit 4c1ffcaad5 "[media] videobuf2-core: add helper functions".

Currently the requirements to use helper function introduced in this
patch set is that both OUTPUT and CAPTURE vb2 buffer queues must use
same lock and the driver uses struct v4l2_fh.

I have only tested the first three patches in this series, Tested-by
for the mx2-emmaprp and exynos-gsc drivers are appreciated.

This patch series can be also found at:
 git://linuxtv.org/snawrocki/samsung.git m2m-helpers-v2

Thanks,
Sylwester

Sylwester Nawrocki (7):
  V4L: Add mem2mem ioctl and file operation helpers
  mem2mem_testdev: Use mem-to-mem ioctl and vb2 helpers
  exynos4-is: Use mem-to-mem ioctl helpers
  s5p-jpeg: Use mem-to-mem ioctl helpers
  mx2-emmaprp: Use mem-to-mem ioctl helpers
  exynos-gsc: Use mem-to-mem ioctl helpers
  s5p-g2d: Use mem-to-mem ioctl helpers

 drivers/media/platform/exynos-gsc/gsc-core.h |   12 ---
 drivers/media/platform/exynos-gsc/gsc-m2m.c  |  109 ++++-------------------
 drivers/media/platform/exynos4-is/fimc-m2m.c |  119 +++-----------------------
 drivers/media/platform/mem2mem_testdev.c     |   94 +++-----------------
 drivers/media/platform/mx2_emmaprp.c         |  108 +++--------------------
 drivers/media/platform/s5p-g2d/g2d.c         |  103 +++-------------------
 drivers/media/platform/s5p-jpeg/jpeg-core.c  |  111 +++---------------------
 drivers/media/v4l2-core/v4l2-mem2mem.c       |  110 ++++++++++++++++++++++++
 include/media/v4l2-fh.h                      |    4 +
 include/media/v4l2-mem2mem.h                 |   22 +++++
 10 files changed, 212 insertions(+), 580 deletions(-)

--
1.7.9.5

