Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:49538 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab2K2QMQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Nov 2012 11:12:16 -0500
Received: from eusync1.samsung.com (mailout4.w1.samsung.com [210.118.77.14])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ME9002RRBP8GN60@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Nov 2012 16:12:44 +0000 (GMT)
Received: from [106.116.147.32] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0ME9006VSBOD7L00@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Nov 2012 16:12:14 +0000 (GMT)
Message-id: <50B7895D.5010707@samsung.com>
Date: Thu, 29 Nov 2012 17:12:13 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: [GIT PULL FOR 3.8] exynos-gsc driver updates
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit d8658bca2e5696df2b6c69bc5538f8fe54e4a01e:

  [media] omap3isp: Replace cpu_is_omap3630() with ISP revision check (2012-11-28 10:54:46 -0200)

are available in the git repository at:

  git://git.infradead.org/users/kmpark/linux-samsung exynos_gsc_v3.8

for you to fetch changes up to db40d9baead29e1e0efdfbd9e4f03d0f65457bdf:

  exynos-gsc: modify number of output/capture buffers (2012-11-29 11:49:59 +0100)

----------------------------------------------------------------
Sachin Kamat (3):
      exynos-gsc: Fix checkpatch warning in gsc-m2m.c
      exynos-gsc: Rearrange error messages for valid prints
      exynos-gsc: Use devm_clk_get()

Shaik Ameer Basha (3):
      exynos-gsc: Adding tiled multi-planar format to G-Scaler
      exynos-gsc: propagate timestamps from src to dst buffers
      exynos-gsc: modify number of output/capture buffers

Sylwester Nawrocki (1):
      exynos-gsc: Correct the clock handling

 drivers/media/platform/exynos-gsc/gsc-core.c |   48 ++++++++++++++------------
 drivers/media/platform/exynos-gsc/gsc-core.h |    5 +++
 drivers/media/platform/exynos-gsc/gsc-m2m.c  |   22 +++++++-----
 drivers/media/platform/exynos-gsc/gsc-regs.c |    6 ++++
 4 files changed, 50 insertions(+), 31 deletions(-)

---

Regards,
Sylwester
