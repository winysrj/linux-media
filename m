Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:36741 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933054AbcJMAZI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 20:25:08 -0400
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: linux-mm@kvack.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        ceph-devel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-cris-kernel@axis.com, linux-fbdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mips@linux-mips.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-sh@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, sparclinux@vger.kernel.org, x86@kernel.org
Subject: [PATCH 00/10] mm: adjust get_user_pages* functions to explicitly pass FOLL_* flags
Date: Thu, 13 Oct 2016 01:20:10 +0100
Message-Id: <20161013002020.3062-1-lstoakes@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adjusts functions in the get_user_pages* family such that
desired FOLL_* flags are passed as an argument rather than implied by flags.

The purpose of this change is to make the use of FOLL_FORCE explicit so it is
easier to grep for and clearer to callers that this flag is being used. The use
of FOLL_FORCE is an issue as it overrides missing VM_READ/VM_WRITE flags for the
VMA whose pages we are reading from/writing to, which can result in surprising
behaviour.

The patch series came out of the discussion around commit 38e0885, which
addressed a BUG_ON() being triggered when a page was faulted in with PROT_NONE
set but having been overridden by FOLL_FORCE. do_numa_page() was run on the
assumption the page _must_ be one marked for NUMA node migration as an actual
PROT_NONE page would have been dealt with prior to this code path, however
FOLL_FORCE introduced a situation where this assumption did not hold.

See https://marc.info/?l=linux-mm&m=147585445805166 for the patch proposal.

Lorenzo Stoakes (10):
  mm: remove write/force parameters from __get_user_pages_locked()
  mm: remove write/force parameters from __get_user_pages_unlocked()
  mm: replace get_user_pages_unlocked() write/force parameters with gup_flags
  mm: replace get_user_pages_locked() write/force parameters with gup_flags
  mm: replace get_vaddr_frames() write/force parameters with gup_flags
  mm: replace get_user_pages() write/force parameters with gup_flags
  mm: replace get_user_pages_remote() write/force parameters with gup_flags
  mm: replace __access_remote_vm() write parameter with gup_flags
  mm: replace access_remote_vm() write parameter with gup_flags
  mm: replace access_process_vm() write parameter with gup_flags

 arch/alpha/kernel/ptrace.c                         |  9 ++--
 arch/blackfin/kernel/ptrace.c                      |  5 ++-
 arch/cris/arch-v32/drivers/cryptocop.c             |  4 +-
 arch/cris/arch-v32/kernel/ptrace.c                 |  4 +-
 arch/ia64/kernel/err_inject.c                      |  2 +-
 arch/ia64/kernel/ptrace.c                          | 14 +++---
 arch/m32r/kernel/ptrace.c                          | 15 ++++---
 arch/mips/kernel/ptrace32.c                        |  5 ++-
 arch/mips/mm/gup.c                                 |  2 +-
 arch/powerpc/kernel/ptrace32.c                     |  5 ++-
 arch/s390/mm/gup.c                                 |  3 +-
 arch/score/kernel/ptrace.c                         | 10 +++--
 arch/sh/mm/gup.c                                   |  3 +-
 arch/sparc/kernel/ptrace_64.c                      | 24 +++++++----
 arch/sparc/mm/gup.c                                |  3 +-
 arch/x86/kernel/step.c                             |  3 +-
 arch/x86/mm/gup.c                                  |  2 +-
 arch/x86/mm/mpx.c                                  |  5 +--
 arch/x86/um/ptrace_32.c                            |  3 +-
 arch/x86/um/ptrace_64.c                            |  3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |  7 ++-
 drivers/gpu/drm/etnaviv/etnaviv_gem.c              |  7 ++-
 drivers/gpu/drm/exynos/exynos_drm_g2d.c            |  3 +-
 drivers/gpu/drm/i915/i915_gem_userptr.c            |  6 ++-
 drivers/gpu/drm/radeon/radeon_ttm.c                |  3 +-
 drivers/gpu/drm/via/via_dmablit.c                  |  4 +-
 drivers/infiniband/core/umem.c                     |  6 ++-
 drivers/infiniband/core/umem_odp.c                 |  7 ++-
 drivers/infiniband/hw/mthca/mthca_memfree.c        |  2 +-
 drivers/infiniband/hw/qib/qib_user_pages.c         |  3 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c           |  5 ++-
 drivers/media/pci/ivtv/ivtv-udma.c                 |  4 +-
 drivers/media/pci/ivtv/ivtv-yuv.c                  |  5 ++-
 drivers/media/platform/omap/omap_vout.c            |  2 +-
 drivers/media/v4l2-core/videobuf-dma-sg.c          |  7 ++-
 drivers/media/v4l2-core/videobuf2-memops.c         |  6 ++-
 drivers/misc/mic/scif/scif_rma.c                   |  3 +-
 drivers/misc/sgi-gru/grufault.c                    |  2 +-
 drivers/platform/goldfish/goldfish_pipe.c          |  3 +-
 drivers/rapidio/devices/rio_mport_cdev.c           |  3 +-
 drivers/scsi/st.c                                  |  5 +--
 .../interface/vchiq_arm/vchiq_2835_arm.c           |  3 +-
 .../vc04_services/interface/vchiq_arm/vchiq_arm.c  |  3 +-
 drivers/video/fbdev/pvr2fb.c                       |  4 +-
 drivers/virt/fsl_hypervisor.c                      |  4 +-
 fs/exec.c                                          |  9 +++-
 fs/proc/base.c                                     | 19 +++++---
 include/linux/mm.h                                 | 18 ++++----
 kernel/events/uprobes.c                            |  6 ++-
 kernel/ptrace.c                                    | 16 ++++---
 mm/frame_vector.c                                  |  9 ++--
 mm/gup.c                                           | 50 ++++++++++------------
 mm/memory.c                                        | 16 ++++---
 mm/mempolicy.c                                     |  2 +-
 mm/nommu.c                                         | 38 +++++++---------
 mm/process_vm_access.c                             |  7 ++-
 mm/util.c                                          |  8 ++--
 net/ceph/pagevec.c                                 |  2 +-
 security/tomoyo/domain.c                           |  2 +-
 virt/kvm/async_pf.c                                |  3 +-
 virt/kvm/kvm_main.c                                | 11 +++--
 61 files changed, 260 insertions(+), 187 deletions(-)
