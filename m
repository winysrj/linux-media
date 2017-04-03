Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:36367 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751649AbdDCS6U (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Apr 2017 14:58:20 -0400
Received: by mail-qk0-f171.google.com with SMTP id p22so122959871qka.3
        for <linux-media@vger.kernel.org>; Mon, 03 Apr 2017 11:58:20 -0700 (PDT)
From: Laura Abbott <labbott@redhat.com>
To: Sumit Semwal <sumit.semwal@linaro.org>,
        Riley Andrews <riandrews@android.com>, arve@android.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Laura Abbott <labbott@redhat.com>, romlem@google.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Brian Starkey <brian.starkey@arm.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-mm@kvack.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCHv3 00/22] Ion clean up in preparation in moving out of staging
Date: Mon,  3 Apr 2017 11:57:42 -0700
Message-Id: <1491245884-15852-1-git-send-email-labbott@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This is v3 of the series to do some serious Ion cleanup in preparation for
moving out of staging. I didn't hear much on v2 so I'm going to assume
people are okay with the series as is. I know there were still some open
questions about moving away from /dev/ion but in the interest of small
steps I'd like to go ahead and merge this series assuming there are no more
major objections. More work can happen on top of this.

Changes from v2:
- Dropped the RFC tag
- Minor bisectability fixes
- Sumit's comment about CMA naming
- Updated the TODO list

Thanks,
Laura

Laura Abbott (22):
  cma: Store a name in the cma structure
  cma: Introduce cma_for_each_area
  staging: android: ion: Remove dmap_cnt
  staging: android: ion: Remove alignment from allocation field
  staging: android: ion: Duplicate sg_table
  staging: android: ion: Call dma_map_sg for syncing and mapping
  staging: android: ion: Remove page faulting support
  staging: android: ion: Remove crufty cache support
  staging: android: ion: Remove custom ioctl interface
  staging: android: ion: Remove import interface
  staging: android: ion: Remove duplicate ION_IOC_MAP
  staging: android: ion: Remove old platform support
  staging: android: ion: Use CMA APIs directly
  staging: android: ion: Stop butchering the DMA address
  staging: android: ion: Break the ABI in the name of forward progress
  staging: android: ion: Get rid of ion_phys_addr_t
  staging: android: ion: Collapse internal header files
  staging: android: ion: Rework heap registration/enumeration
  staging: android: ion: Drop ion_map_kernel interface
  staging: android: ion: Remove ion_handle and ion_client
  staging: android: ion: Set query return value
  staging/android: Update Ion TODO list

 arch/powerpc/kvm/book3s_hv_builtin.c               |    3 +-
 drivers/base/dma-contiguous.c                      |    5 +-
 drivers/staging/android/TODO                       |   21 +-
 drivers/staging/android/ion/Kconfig                |   56 +-
 drivers/staging/android/ion/Makefile               |   18 +-
 drivers/staging/android/ion/compat_ion.c           |  195 ----
 drivers/staging/android/ion/compat_ion.h           |   29 -
 drivers/staging/android/ion/hisilicon/Kconfig      |    5 -
 drivers/staging/android/ion/hisilicon/Makefile     |    1 -
 drivers/staging/android/ion/hisilicon/hi6220_ion.c |  113 --
 drivers/staging/android/ion/ion-ioctl.c            |   85 +-
 drivers/staging/android/ion/ion.c                  | 1168 +++-----------------
 drivers/staging/android/ion/ion.h                  |  389 +++++--
 drivers/staging/android/ion/ion_carveout_heap.c    |   37 +-
 drivers/staging/android/ion/ion_chunk_heap.c       |   27 +-
 drivers/staging/android/ion/ion_cma_heap.c         |  125 +--
 drivers/staging/android/ion/ion_dummy_driver.c     |  155 ---
 drivers/staging/android/ion/ion_heap.c             |   68 --
 drivers/staging/android/ion/ion_of.c               |  184 ---
 drivers/staging/android/ion/ion_of.h               |   37 -
 drivers/staging/android/ion/ion_page_pool.c        |    6 +-
 drivers/staging/android/ion/ion_priv.h             |  473 --------
 drivers/staging/android/ion/ion_system_heap.c      |   53 +-
 drivers/staging/android/ion/ion_test.c             |  305 -----
 drivers/staging/android/ion/tegra/Makefile         |    1 -
 drivers/staging/android/ion/tegra/tegra_ion.c      |   80 --
 drivers/staging/android/uapi/ion.h                 |   86 +-
 drivers/staging/android/uapi/ion_test.h            |   69 --
 include/linux/cma.h                                |    6 +-
 mm/cma.c                                           |   31 +-
 mm/cma.h                                           |    1 +
 mm/cma_debug.c                                     |    2 +-
 32 files changed, 620 insertions(+), 3214 deletions(-)
 delete mode 100644 drivers/staging/android/ion/compat_ion.c
 delete mode 100644 drivers/staging/android/ion/compat_ion.h
 delete mode 100644 drivers/staging/android/ion/hisilicon/Kconfig
 delete mode 100644 drivers/staging/android/ion/hisilicon/Makefile
 delete mode 100644 drivers/staging/android/ion/hisilicon/hi6220_ion.c
 delete mode 100644 drivers/staging/android/ion/ion_dummy_driver.c
 delete mode 100644 drivers/staging/android/ion/ion_of.c
 delete mode 100644 drivers/staging/android/ion/ion_of.h
 delete mode 100644 drivers/staging/android/ion/ion_priv.h
 delete mode 100644 drivers/staging/android/ion/ion_test.c
 delete mode 100644 drivers/staging/android/ion/tegra/Makefile
 delete mode 100644 drivers/staging/android/ion/tegra/tegra_ion.c
 delete mode 100644 drivers/staging/android/uapi/ion_test.h

-- 
2.7.4
