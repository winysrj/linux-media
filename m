Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:37294 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab3JLMcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Oct 2013 08:32:12 -0400
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, pawel@osciak.com,
	javier.martin@vista-silicon.com, m.szyprowski@samsung.com,
	shaik.ameer@samsung.com, arun.kk@samsung.com, k.debski@samsung.com,
	p.zabel@pengutronix.de, kyungmin.park@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v2 00/10] V4L2 mem-to-mem ioctl helpers
Date: Sat, 12 Oct 2013 14:31:50 +0200
Message-Id: <1381581120-26883-1-git-send-email-s.nawrocki@samsung.com>
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

I have only tested the first four patches in this series, Tested-by
for the mx2-emmaprp, exynos-gsc, s5p-g2d drivers are appreciated.

This patch series can be also found at:
 git://linuxtv.org/snawrocki/samsung.git m2m-helpers-v3

Changes since original version include addition of related cleanup
patches, added helper function for create_buf ioctl and m2m context
pointer from struct v4l2_fh is now reused and related field from the
drivers' private data structure is removed.

Thank you for all reviews. I plan to queue the first four patches for
next kernel release early this week. For the mx2-emmaprp, exynos-gsc,
s5p-g2d driver feedback is needed from someone who can actually test
the changes. Any Tested-by for those drivers would be appreciated.

Thanks,
Sylwester

Sylwester Nawrocki (10):
  V4L: Add mem2mem ioctl and file operation helpers
  mem2mem_testdev: Use mem-to-mem ioctl and vb2 helpers
  exynos4-is: Use mem-to-mem ioctl helpers
  s5p-jpeg: Use mem-to-mem ioctl helpers
  mx2-emmaprp: Use struct v4l2_fh
  mx2-emmaprp: Use mem-to-mem ioctl helpers
  exynos-gsc: Configure default image format at device open()
  exynos-gsc: Remove GSC_{SRC, DST}_FMT flags
  exynos-gsc: Use mem-to-mem ioctl helpers
  s5p-g2d: Use mem-to-mem ioctl helpers

 drivers/media/platform/exynos-gsc/gsc-core.c  |   10 +-
 drivers/media/platform/exynos-gsc/gsc-core.h  |   14 --
 drivers/media/platform/exynos-gsc/gsc-m2m.c   |  232 ++++++++-----------------
 drivers/media/platform/exynos4-is/fimc-core.h |    2 -
 drivers/media/platform/exynos4-is/fimc-m2m.c  |  148 +++-------------
 drivers/media/platform/mem2mem_testdev.c      |  152 +++-------------
 drivers/media/platform/mx2_emmaprp.c          |  185 ++++++--------------
 drivers/media/platform/s5p-g2d/g2d.c          |  124 +++-----------
 drivers/media/platform/s5p-g2d/g2d.h          |    1 -
 drivers/media/platform/s5p-jpeg/jpeg-core.c   |  134 +++------------
 drivers/media/platform/s5p-jpeg/jpeg-core.h   |    2 -
 drivers/media/v4l2-core/v4l2-mem2mem.c        |  118 +++++++++++++
 include/media/v4l2-fh.h                       |    4 +
 include/media/v4l2-mem2mem.h                  |   24 +++
 14 files changed, 382 insertions(+), 768 deletions(-)

--
1.7.4.1

