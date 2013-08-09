Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58938 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab3HIRRy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 13:17:54 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MR900CRZXDSAC10@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 09 Aug 2013 18:17:52 +0100 (BST)
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MR9000RJXDSA400@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 09 Aug 2013 18:17:52 +0100 (BST)
Message-id: <52052440.6070704@samsung.com>
Date: Fri, 09 Aug 2013 19:17:52 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 3.12] v4l2-async and Samsung driver fixes
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This includes v4l2-async regression fix introduced in my previous patch
series - sorry about that omission, and couple Samsung SoC driver fixes.

The following changes since commit dfb9f94e8e5e7f73c8e2bcb7d4fb1de57e7c333d:

  [media] stk1160: Build as a module if SND is m and audio support is selected
(2013-08-01 14:55:25 -0300)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git for-v3.12-2

for you to fetch changes up to 886976a6db6c7bf1aaeb181e2b5fafb7e0d0e5d4:

  exynos-gsc: fix s2r functionality (2013-08-09 18:54:41 +0200)

----------------------------------------------------------------
Andrzej Hajda (1):
      V4L: s5c73m3: Add format propagation for TRY formats

Prathyush K (1):
      exynos-gsc: fix s2r functionality

Sachin Kamat (2):
      exynos4-is: Fix potential NULL pointer dereference
      exynos4-is: Staticize local symbol

Sylwester Nawrocki (1):
      v4l2-async: Use proper list head for iteration over registered subdevs

 drivers/media/i2c/s5c73m3/s5c73m3-core.c          |    5 +++++
 drivers/media/platform/exynos-gsc/gsc-core.c      |   13 ++++++++-----
 drivers/media/platform/exynos4-is/fimc-is-param.c |    2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c     |   13 +++++++------
 drivers/media/v4l2-core/v4l2-async.c              |    2 +-
 5 files changed, 22 insertions(+), 13 deletions(-)

--
Regards,
Sylwester
