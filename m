Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:60053 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932827AbdC3Q6j (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 12:58:39 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0ONN007YK0HOSOA0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 Mar 2017 01:58:36 +0900 (KST)
To: LMML <linux-media@vger.kernel.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PULL] Samsung SoC related updates
Message-id: <7c57cc72-6412-650b-2365-a70a916b7e40@samsung.com>
Date: Thu, 30 Mar 2017 18:58:31 +0200
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <CGME20170330165835epcas1p4330a88d7f9a1ca09f91e5bc8ad167752@epcas1p4.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit c3d4fb0fb41f4b5eafeee51173c14e50be12f839:

  [media] rc: sunxi-cir: simplify optional reset handling (2017-03-24 08:30:03 -0300)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git for-v4.12/media/next

for you to fetch changes up to b51f9a138838daeed695af086167eaf51cd905d8:

  s5p-g2d: Fix error handling (2017-03-30 18:13:18 +0200)

----------------------------------------------------------------
Christophe JAILLET (1):
      s5p-g2d: Fix error handling

Marek Szyprowski (19):
      s5p-mfc: Fix initialization of internal structures
      s5p-mfc: Fix race between interrupt routine and device functions
      s5p-mfc: Remove unused structures and dead code
      s5p-mfc: Use generic of_device_get_match_data helper
      s5p-mfc: Replace mem_dev_* entries with an array
      s5p-mfc: Replace bank1/bank2 entries with an array
      s5p-mfc: Simplify alloc/release private buffer functions
      s5p-mfc: Move setting DMA max segment size to DMA configure function
      s5p-mfc: Put firmware to private buffer structure
      s5p-mfc: Move firmware allocation to DMA configure function
      s5p-mfc: Allocate firmware with internal private buffer alloc function
      s5p-mfc: Reduce firmware buffer size for MFC v6+ variants
      s5p-mfc: Split variant DMA memory configuration into separate functions
      s5p-mfc: Add support for probe-time preallocated block based allocator
      s5p-mfc: Remove special configuration of IOMMU domain
      s5p-mfc: Use preallocated block allocator always for MFC v6+
      s5p-mfc: Rename BANK1/2 to BANK_L/R to better match documentation
      s5p-mfc: Fix unbalanced call to clock management
      s5p-mfc: Don't allocate codec buffers from pre-allocated region

Shuah Khan (2):
      s5p_mfc: Remove unneeded io_modes initialization in s5p_mfc_open()
      s5p-mfc: Print buf pointer in hex constistently

 .../devicetree/bindings/media/s5p-mfc.txt       |   2 +-
 drivers/media/platform/s5p-g2d/g2d.c            |   2 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h    |   2 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v7.h    |   2 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v8.h    |   2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c        | 245 ++++++++++++-------
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c |   2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  43 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   |  72 ++----
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h   |   1 -
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |   8 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |  10 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_iommu.h  |  51 +---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c    |  93 +++++--
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h    |  12 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |  48 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |  16 +-
 17 files changed, 316 insertions(+), 295 deletions(-)

-- 
Thanks,
Sylwester
