Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:51534 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685Ab3CZSig (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 14:38:36 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 0/4] exynos4-is updates
Date: Tue, 26 Mar 2013 19:38:12 +0100
Message-id: <1364323101-22046-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series includes YUV order handling fix for the FIMC
and FIMC-LITE, a fix for media entity ref_count issue, minor
refactoring and removal of some static data that will no longer
be needed since starting from 3.10 Exynos platform is going to
be DT only.

All dependencies of this series are available at:
git://linuxtv.org/snawrocki/samsung.git exynos4-fimc-is-v2

Sylwester Nawrocki (5):
  exynos4-is: Remove static driver data for Exynos4210 FIMC variants
  exynos4-is: Use common driver data for all FIMC-LITE IP instances
  exynos4-is: Allow colorspace conversion at fimc-lite
  exynos4-is: Correct input DMA YUV order configuration
  exynos4-is: Ensure proper media pipeline state on device close

 drivers/media/platform/exynos4-is/fimc-capture.c  |   18 ++-
 drivers/media/platform/exynos4-is/fimc-core.c     |   51 ++-------
 drivers/media/platform/exynos4-is/fimc-core.h     |    1 +
 drivers/media/platform/exynos4-is/fimc-lite-reg.c |    4 +-
 drivers/media/platform/exynos4-is/fimc-lite-reg.h |    8 +-
 drivers/media/platform/exynos4-is/fimc-lite.c     |  127 +++++++++++++--------
 drivers/media/platform/exynos4-is/fimc-lite.h     |   15 +--
 drivers/media/platform/exynos4-is/fimc-reg.c      |    3 +-
 drivers/media/platform/exynos4-is/fimc-reg.h      |   16 +--
 include/media/s5p_fimc.h                          |    2 +
 10 files changed, 124 insertions(+), 121 deletions(-)

--
1.7.9.5

