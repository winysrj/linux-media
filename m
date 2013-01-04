Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:40411 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab3ADSwR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 13:52:17 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MG400553733R780@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 Jan 2013 18:52:15 +0000 (GMT)
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MG4000XN7322L00@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 Jan 2013 18:52:15 +0000 (GMT)
Message-id: <50E724DE.1020408@samsung.com>
Date: Fri, 04 Jan 2013 19:52:14 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 3.8] vb2 and Exynos SoC driver fixes
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull for 3.8-rc. This includes the vb2 data_offset fix from
Laurent, which looked fine after I reviewed it more carefully, and
Exynos SoC/m5mols driver bug fixes.

The following changes since commit d1c3ed669a2d452cacfb48c2d171a1f364dae2ed:

  Linux 3.8-rc2 (2013-01-02 18:13:21 -0800)

are available in the git repository at:

  git://git.infradead.org/users/kmpark/linux-samsung v4l_fixes_for_v3.8

for you to fetch changes up to 5e5b9c5179887e08a3ba4a94f08dc616c69ff49f:

  s5p-mfc: Fix interrupt error handling routine (2013-01-04 11:32:45 +0100)

----------------------------------------------------------------
Kamil Debski (1):
      s5p-mfc: Fix interrupt error handling routine

Laurent Pinchart (1):
      v4l: vb2: Set data_offset to 0 for single-plane output buffers

Sylwester Nawrocki (2):
      m5mols: Fix typo in get_fmt callback
      s5p-fimc: Fix return value of __fimc_md_create_flite_source_links()

 drivers/media/i2c/m5mols/m5mols_core.c         |    2 +-
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c       |   88 ++++++++++--------------
 drivers/media/v4l2-core/videobuf2-core.c       |    4 +-
 4 files changed, 42 insertions(+), 54 deletions(-)

Regards,
Sylwester


-- 
Sylwester Nawrocki
Samsung Poland R&D Center
