Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:30565 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932449AbdJaX2A (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Oct 2017 19:28:00 -0400
Subject: [PATCH 00/15] dax: prep work for fixing dax-dma vs truncate
 collisions
From: Dan Williams <dan.j.williams@intel.com>
To: linux-nvdimm@lists.01.org
Cc: Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-mm@kvack.org,
        Paul Mackerras <paulus@samba.org>,
        Sean Hefty <sean.hefty@intel.com>, hch@lst.de,
        Matthew Wilcox <mawilcox@microsoft.com>,
        linux-rdma@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Jeff Moyer <jmoyer@redhat.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Doug Ledford <dledford@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        linux-media@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        =?utf-8?b?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-xfs@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        akpm@linux-foundation.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Tue, 31 Oct 2017 16:21:33 -0700
Message-ID: <150949209290.24061.6283157778959640151.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is hopefully the uncontroversial lead-in set of changes that lay
the groundwork for solving the dax-dma vs truncate problem. The overview
of the changes is:

1/ Disable DAX when we do not have struct page entries backing dax
   mappings, or otherwise allow limited DAX support for axonram and
   dcssblk. Is anyone actually using the DAX capability of axonram
   dcssblk?

2/ Disable code paths that establish potentially long lived DMA
   access to a filesystem-dax memory mapping, i.e. RDMA and V4L2. In the
   4.16 timeframe the plan is to introduce a "register memory for DMA
   with a lease" mechanism for userspace to establish mappings but also
   be responsible for tearing down the mapping when the kernel needs to
   invalidate the mapping due to truncate or hole-punch.

3/ Add a wakeup mechanism for awaiting for DAX pages to be released
   from DMA access.

This overall effort started when Christoph noted during the review of
the MAP_DIRECT proposal:

    get_user_pages on DAX doesn't give the same guarantees as on
    pagecache or anonymous memory, and that is the problem we need to
    fix. In fact I'm pretty sure if we try hard enough (and we might
    have to try very hard) we can see the same problem with plain direct
    I/O and without any RDMA involved, e.g. do a larger direct I/O write
    to memory that is mmap()ed from a DAX file, then truncate the DAX
    file and reallocate the blocks, and we might corrupt that new file.
    We'll probably need a special setup where there is little other
    chance but to reallocate those used blocks.

    So what we need to do first is to fix get_user_pages vs unmapping
    DAX mmap()ed blocks, be that from a hole punch, truncate, COW
    operation, etc.

Included in the changes is a nfit_test mechanism to trivially trigger
this collision by delaying the put_page() that the block layer performs
after performing direct-I/O to a filesystem-DAX page.

Given the ongoing coordination of this set across multiple sub-systems
and the dax core my proposal is to manage this as a branch in the nvdimm
tree with acks from mm, rdma, v4l2, ext4, and xfs.

---

Dan Williams (15):
      dax: quiet bdev_dax_supported()
      mm, dax: introduce pfn_t_special()
      dax: require 'struct page' by default for filesystem dax
      brd: remove dax support
      dax: stop using VM_MIXEDMAP for dax
      dax: stop using VM_HUGEPAGE for dax
      dax: stop requiring a live device for dax_flush()
      dax: store pfns in the radix
      tools/testing/nvdimm: add 'bio_delay' mechanism
      IB/core: disable memory registration of fileystem-dax vmas
      [media] v4l2: disable filesystem-dax mapping support
      mm, dax: enable filesystems to trigger page-idle callbacks
      mm, devmap: introduce CONFIG_DEVMAP_MANAGED_PAGES
      dax: associate mappings with inodes, and warn if dma collides with truncate
      wait_bit: introduce {wait_on,wake_up}_devmap_idle


 arch/powerpc/platforms/Kconfig            |    1 
 arch/powerpc/sysdev/axonram.c             |    3 -
 drivers/block/Kconfig                     |   12 ---
 drivers/block/brd.c                       |   65 --------------
 drivers/dax/device.c                      |    1 
 drivers/dax/super.c                       |  113 +++++++++++++++++++++----
 drivers/infiniband/core/umem.c            |   49 ++++++++---
 drivers/media/v4l2-core/videobuf-dma-sg.c |   39 ++++++++-
 drivers/nvdimm/pmem.c                     |   13 +++
 drivers/s390/block/Kconfig                |    1 
 drivers/s390/block/dcssblk.c              |    4 +
 fs/Kconfig                                |    8 ++
 fs/dax.c                                  |  131 +++++++++++++++++++----------
 fs/ext2/file.c                            |    1 
 fs/ext2/super.c                           |    6 +
 fs/ext4/file.c                            |    1 
 fs/ext4/super.c                           |    6 +
 fs/xfs/xfs_file.c                         |    2 
 fs/xfs/xfs_super.c                        |   20 ++--
 include/linux/dax.h                       |   17 ++--
 include/linux/memremap.h                  |   24 +++++
 include/linux/mm.h                        |   47 ++++++----
 include/linux/mm_types.h                  |   20 +++-
 include/linux/pfn_t.h                     |   13 +++
 include/linux/vma.h                       |   33 +++++++
 include/linux/wait_bit.h                  |   10 ++
 kernel/memremap.c                         |   36 ++++++--
 kernel/sched/wait_bit.c                   |   64 ++++++++++++--
 mm/Kconfig                                |    5 +
 mm/hmm.c                                  |   13 ---
 mm/huge_memory.c                          |    8 +-
 mm/ksm.c                                  |    3 +
 mm/madvise.c                              |    2 
 mm/memory.c                               |   22 ++++-
 mm/migrate.c                              |    3 -
 mm/mlock.c                                |    5 +
 mm/mmap.c                                 |    8 +-
 mm/swap.c                                 |    3 -
 tools/testing/nvdimm/Kbuild               |    1 
 tools/testing/nvdimm/test/iomap.c         |   62 ++++++++++++++
 tools/testing/nvdimm/test/nfit.c          |   34 ++++++++
 tools/testing/nvdimm/test/nfit_test.h     |    1 
 42 files changed, 650 insertions(+), 260 deletions(-)
 create mode 100644 include/linux/vma.h
