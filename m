Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 036FFC43381
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 23:08:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6DE521924
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 23:08:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404313AbfBMXFP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Feb 2019 18:05:15 -0500
Received: from mga12.intel.com ([192.55.52.136]:55768 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726323AbfBMXFO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Feb 2019 18:05:14 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Feb 2019 15:05:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,366,1544515200"; 
   d="scan'208";a="138415564"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.157])
  by orsmga001.jf.intel.com with ESMTP; 13 Feb 2019 15:05:10 -0800
From:   ira.weiny@intel.com
To:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        sparclinux@vger.kernel.org, kvm@vger.kernel.org,
        linux-fpga@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        linux-scsi@vger.kernel.org, devel@driverdev.osuosl.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-fbdev@vger.kernel.org, xen-devel@lists.xenproject.org,
        devel@lists.orangefs.org, linux-mm@kvack.org,
        ceph-devel@vger.kernel.org, rds-devel@oss.oracle.com
Cc:     Ira Weiny <ira.weiny@intel.com>,
        John Hubbard <jhubbard@nvidia.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <joro@8bytes.org>, Wu Hao <hao.wu@intel.com>,
        Alan Tull <atull@kernel.org>, Moritz Fischer <mdf@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Christian Benvenuti <benve@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Rob Springer <rspringer@google.com>,
        Todd Poynor <toddpoynor@google.com>,
        Ben Chan <benchan@chromium.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Martin Brandenburg <martin@omnibond.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH V2 0/7] Add FOLL_LONGTERM to GUP fast and use it
Date:   Wed, 13 Feb 2019 15:04:48 -0800
Message-Id: <20190213230455.5605-1-ira.weiny@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190211201643.7599-1-ira.weiny@intel.com>
References: <20190211201643.7599-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

NOTE: This series depends on my clean up patch to remove the write parameter
from gup_fast_permitted()[1]

HFI1, qib, and mthca, use get_user_pages_fast() due to it performance
advantages.  These pages can be held for a significant time.  But
get_user_pages_fast() does not protect against mapping of FS DAX pages.

Introduce FOLL_LONGTERM and use this flag in get_user_pages_fast() which
retains the performance while also adding the FS DAX checks.  XDP has also
shown interest in using this functionality.[2]

In addition we change get_user_pages() to use the new FOLL_LONGTERM flag and
remove the specialized get_user_pages_longterm call.

[1] https://lkml.org/lkml/2019/2/11/237
[2] https://lkml.org/lkml/2019/2/11/1789

Ira Weiny (7):
  mm/gup: Replace get_user_pages_longterm() with FOLL_LONGTERM
  mm/gup: Change write parameter to flags in fast walk
  mm/gup: Change GUP fast to use flags rather than a write 'bool'
  mm/gup: Add FOLL_LONGTERM capability to GUP fast
  IB/hfi1: Use the new FOLL_LONGTERM flag to get_user_pages_fast()
  IB/qib: Use the new FOLL_LONGTERM flag to get_user_pages_fast()
  IB/mthca: Use the new FOLL_LONGTERM flag to get_user_pages_fast()

 arch/mips/mm/gup.c                          |  11 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c         |   4 +-
 arch/powerpc/kvm/e500_mmu.c                 |   2 +-
 arch/powerpc/mm/mmu_context_iommu.c         |   4 +-
 arch/s390/kvm/interrupt.c                   |   2 +-
 arch/s390/mm/gup.c                          |  12 +-
 arch/sh/mm/gup.c                            |  11 +-
 arch/sparc/mm/gup.c                         |   9 +-
 arch/x86/kvm/paging_tmpl.h                  |   2 +-
 arch/x86/kvm/svm.c                          |   2 +-
 drivers/fpga/dfl-afu-dma-region.c           |   2 +-
 drivers/gpu/drm/via/via_dmablit.c           |   3 +-
 drivers/infiniband/core/umem.c              |   5 +-
 drivers/infiniband/hw/hfi1/user_pages.c     |   5 +-
 drivers/infiniband/hw/mthca/mthca_memfree.c |   3 +-
 drivers/infiniband/hw/qib/qib_user_pages.c  |   8 +-
 drivers/infiniband/hw/qib/qib_user_sdma.c   |   2 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c    |   9 +-
 drivers/media/v4l2-core/videobuf-dma-sg.c   |   6 +-
 drivers/misc/genwqe/card_utils.c            |   2 +-
 drivers/misc/vmw_vmci/vmci_host.c           |   2 +-
 drivers/misc/vmw_vmci/vmci_queue_pair.c     |   6 +-
 drivers/platform/goldfish/goldfish_pipe.c   |   3 +-
 drivers/rapidio/devices/rio_mport_cdev.c    |   4 +-
 drivers/sbus/char/oradax.c                  |   2 +-
 drivers/scsi/st.c                           |   3 +-
 drivers/staging/gasket/gasket_page_table.c  |   4 +-
 drivers/tee/tee_shm.c                       |   2 +-
 drivers/vfio/vfio_iommu_spapr_tce.c         |   3 +-
 drivers/vfio/vfio_iommu_type1.c             |   3 +-
 drivers/vhost/vhost.c                       |   2 +-
 drivers/video/fbdev/pvr2fb.c                |   2 +-
 drivers/virt/fsl_hypervisor.c               |   2 +-
 drivers/xen/gntdev.c                        |   2 +-
 fs/orangefs/orangefs-bufmap.c               |   2 +-
 include/linux/mm.h                          |  17 +-
 kernel/futex.c                              |   2 +-
 lib/iov_iter.c                              |   7 +-
 mm/gup.c                                    | 220 ++++++++++++--------
 mm/gup_benchmark.c                          |   5 +-
 mm/util.c                                   |   8 +-
 net/ceph/pagevec.c                          |   2 +-
 net/rds/info.c                              |   2 +-
 net/rds/rdma.c                              |   3 +-
 44 files changed, 232 insertions(+), 180 deletions(-)

-- 
2.20.1

