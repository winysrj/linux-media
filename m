Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39610 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932678Ab2JYQBU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 12:01:20 -0400
Received: from eusync4.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MCG003GWHUODN10@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Oct 2012 17:01:36 +0100 (BST)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MCG0081OHU6FW70@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Oct 2012 17:01:18 +0100 (BST)
Message-id: <5089624D.2000903@samsung.com>
Date: Thu, 25 Oct 2012 18:01:17 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 3.7] Samsung media drivers fixes
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

please pull following fixes for v3.7-rc.

The following changes since commit 1fdead8ad31d3aa833bc37739273fcde89ace93c:

  [media] m5mols: Add missing #include <linux/sizes.h> (2012-10-10 08:17:16 -0300)

are available in the git repository at:

  git://git.infradead.org/users/kmpark/linux-samsung v4l_fixes_for_v3.7

for you to fetch changes up to df79eb9e19331685e509d62112972b3c35569f0b:

  s5p-fimc: Fix potential NULL pointer dereference (2012-10-25 16:08:12 +0200)

----------------------------------------------------------------
Jesper Juhl (1):
      s5p-tv: don't include linux/version.h in mixer_video.c

Sachin Kamat (5):
      s5p-mfc: Fix compilation warning
      exynos-gsc: Fix compilation warning
      s5p-mfc: Make 'clk_ref' static in s5p_mfc_pm.c
      s5p-fimc: Make 'fimc_pipeline_s_stream' function static
      s5p-fimc: Fix potential NULL pointer dereference

Shaik Ameer Basha (3):
      exynos-gsc: change driver compatible string
      exynos-gsc: fix variable type in gsc_m2m_device_run()
      s5p-fimc: fix variable type in fimc_device_run()

Sylwester Nawrocki (4):
      s5p-fimc: Don't ignore return value of vb2_queue_init()
      s5p-csis: Select S5P_SETUP_MIPIPHY
      s5p-fimc: Add missing new line character
      s5p-fimc: Fix platform entities registration

 drivers/media/platform/exynos-gsc/gsc-core.c   |    8 +++--
 drivers/media/platform/exynos-gsc/gsc-m2m.c    |    2 +-
 drivers/media/platform/s5p-fimc/Kconfig        |    1 +
 drivers/media/platform/s5p-fimc/fimc-capture.c |    4 ++-
 drivers/media/platform/s5p-fimc/fimc-lite.c    |    4 ++-
 drivers/media/platform/s5p-fimc/fimc-m2m.c     |    2 +-
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |   45 ++++++++++++------------
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c   |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c    |    2 +-
 drivers/media/platform/s5p-tv/mixer_video.c    |    1 -
 10 files changed, 38 insertions(+), 33 deletions(-)


Thanks,
Sylwester
