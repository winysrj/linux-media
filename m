Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:26156 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab2HVIcf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 04:32:35 -0400
Received: from eusync4.samsung.com (mailout4.w1.samsung.com [210.118.77.14])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M95008QYEF92030@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Aug 2012 09:33:09 +0100 (BST)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0M9500EUFEE8V770@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Aug 2012 09:32:32 +0100 (BST)
Message-id: <5034991F.5040403@samsung.com>
Date: Wed, 22 Aug 2012 10:32:31 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: [GIT PATCHES FOR v3.6] Samsung media driver fixes
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit f9cd49033b349b8be3bb1f01b39eed837853d880:

  Merge tag 'v3.6-rc1' into staging/for_v3.6 (2012-08-03 22:41:33 -0300)

are available in the git repository at:


  git://git.infradead.org/users/kmpark/linux-samsung v4l-fixes

for you to fetch changes up to 0e59db054e30658c6955d6e27b0a252cef9bfafc:

  s5p-mfc: Fix second memory bank alignment (2012-08-16 19:12:19 +0200)

----------------------------------------------------------------
Kamil Debski (1):
      s5p-mfc: Fix second memory bank alignment

Sylwester Nawrocki (7):
      s5p-fimc: Enable FIMC-LITE driver only for SOC_EXYNOS4x12
      s5p-fimc: Don't allocate fimc-lite video device structure dynamically
      s5p-fimc: Don't allocate fimc-capture video device dynamically
      s5p-fimc: Don't allocate fimc-m2m video device dynamically
      m5mols: Add missing free_irq() on error path
      m5mols: Fix cast warnings from m5mols_[set/get]_ctrl_mode
      s5p-fimc: Fix setup of initial links to FIMC entities

 drivers/media/video/m5mols/m5mols.h          |  4 +--
 drivers/media/video/m5mols/m5mols_controls.c |  4 +--
 drivers/media/video/m5mols/m5mols_core.c     |  4 ++-
 drivers/media/video/s5p-fimc/Kconfig         |  2 +-
 drivers/media/video/s5p-fimc/fimc-capture.c  | 31 +++++++-----------
 drivers/media/video/s5p-fimc/fimc-core.h     |  4 +--
 drivers/media/video/s5p-fimc/fimc-lite-reg.c |  2 +-
 drivers/media/video/s5p-fimc/fimc-lite.c     | 42 ++++++++++---------------
 drivers/media/video/s5p-fimc/fimc-lite.h     |  2 +-
 drivers/media/video/s5p-fimc/fimc-m2m.c      | 40 ++++++++---------------
 drivers/media/video/s5p-fimc/fimc-mdevice.c  |  9 ++++--
 drivers/media/video/s5p-fimc/fimc-mdevice.h  |  6 ++--
 drivers/media/video/s5p-fimc/fimc-reg.c      |  6 ++--
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c   |  2 +-
 14 files changed, 65 insertions(+), 93 deletions(-)

---

Thanks,
Sylwester
