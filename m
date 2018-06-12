Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:42523 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933088AbeFLNmK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 09:42:10 -0400
From: Oleksandr Andrushchenko <andr2000@gmail.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, andr2000@gmail.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Subject: [PATCH v3 0/9] xen: dma-buf support for grant device
Date: Tue, 12 Jun 2018 16:41:51 +0300
Message-Id: <20180612134200.17456-1-andr2000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>

This work is in response to my previous attempt to introduce Xen/DRM
zero-copy driver [1] to enable Linux dma-buf API [2] for Xen based
frontends/backends. There is also an existing hyper_dmabuf approach
available [3] which, if reworked to utilize the proposed solution,
can greatly benefit as well.

RFC for this series was published and discussed [9], comments addressed.

The original rationale behind this work was to enable zero-copying
use-cases while working with Xen para-virtual display driver [4]:
when using Xen PV DRM frontend driver then on backend side one will
need to do copying of display buffers' contents (filled by the
frontend's user-space) into buffers allocated at the backend side.
Taking into account the size of display buffers and frames per
second it may result in unneeded huge data bus occupation and
performance loss.

The helper driver [4] allows implementing zero-copying use-cases
when using Xen para-virtualized frontend display driver by implementing
a DRM/KMS helper driver running on backend's side.
It utilizes PRIME buffers API (implemented on top of Linux dma-buf)
to share frontend's buffers with physical device drivers on
backend's side:

 - a dumb buffer created on backend's side can be shared
   with the Xen PV frontend driver, so it directly writes
   into backend's domain memory (into the buffer exported from
   DRM/KMS driver of a physical display device)
 - a dumb buffer allocated by the frontend can be imported
   into physical device DRM/KMS driver, thus allowing to
   achieve no copying as well

Finally, it was discussed and decided ([1], [5]) that it is worth
implementing such use-cases via extension of the existing Xen gntdev
driver instead of introducing new DRM specific driver.
Please note, that the support of dma-buf is Linux only,
as dma-buf is a Linux only thing.

Now to the proposed solution. The changes  to the existing Xen drivers
in the Linux kernel fall into 2 categories:
1. DMA-able memory buffer allocation and increasing/decreasing memory
   reservation of the pages of such a buffer.
   This is required if we are about to share dma-buf with the hardware
   that does require those to be allocated with dma_alloc_xxx API.
   (It is still possible to allocate a dma-buf from any system memory,
   e.g. system pages).
2. Extension of the gntdev driver to enable it to import/export dma-buf’s.

The first six patches are in preparation for Xen dma-buf support,
but I consider those usable regardless of the dma-buf use-case,
e.g. other frontend/backend kernel modules may also benefit from these
for better code reuse:
    0001-xen-grant-table-Export-gnttab_-alloc-free-_pages-as-.patch
    0002-xen-grant-table-Make-set-clear-page-private-code-sha.patch
    0003-xen-balloon-Share-common-memory-reservation-routines.patch
    0004-xen-grant-table-Allow-allocating-buffers-suitable-fo.patch
    0005-xen-gntdev-Allow-mappings-for-DMA-buffers.patch
    0006-xen-gntdev-Make-private-routines-structures-accessib.patch

The next three patches are Xen implementation of dma-buf as part of
the grant device:
    0007-xen-gntdev-Add-initial-support-for-dma-buf-UAPI.patch
    0008-xen-gntdev-Implement-dma-buf-export-functionality.patch
    0009-xen-gntdev-Implement-dma-buf-import-functionality.patch

The corresponding libxengnttab changes are available at [6].

All the above was tested with display backend [7] and its accompanying
helper library [8] on Renesas ARM64 based board.
Basic balloon tests on x86.

*To all the communities*: I would like to ask you to review the proposed
solution and give feedback on it, so I can improve and send final
patches for review (this is still work in progress, but enough to start
discussing the implementation).

Thank you in advance,
Oleksandr Andrushchenko

[1] https://lists.freedesktop.org/archives/dri-devel/2018-April/173163.html
[2] https://elixir.bootlin.com/linux/v4.17-rc5/source/Documentation/driver-api/dma-buf.rst
[3] https://lists.xenproject.org/archives/html/xen-devel/2018-02/msg01202.html
[4] https://cgit.freedesktop.org/drm/drm-misc/tree/drivers/gpu/drm/xen
[5] https://patchwork.kernel.org/patch/10279681/
[6] https://github.com/andr2000/xen/tree/xen_dma_buf_v1
[7] https://github.com/andr2000/displ_be/tree/xen_dma_buf_v1
[8] https://github.com/andr2000/libxenbe/tree/xen_dma_buf_v1
[9] https://lkml.org/lkml/2018/5/17/215

Changes since v2:
*****************
- fixed missed break in dmabuf_exp_wait_obj_signal
- re-worked debug and error messages, be less verbose
- removed patch for making gntdev functions available to other drivers
- removed WARN_ON's in dma-buf code
- moved all dma-buf related code into gntdev-dmabuf
- introduced gntdev-common.h with common structures and function prototypes
- added additional checks for number of grants in IOCTLs
- gnttab patch cleanup
- made xenmem_reservation_scrub_page defined in the header as inline
- fixed __pfn_to_mfn use to pfn_to_bfn
- no changes to patches 1-2

Changes since v1:
*****************
- Define GNTDEV_DMA_FLAG_XXX starting from bit 0
- Rename mem_reservation.h to mem-reservation.h
- Remove usless comments
- Change licenses from GPLv2 OR MIT to GPLv2 only
- Make xenmem_reservation_va_mapping_{update|clear} inline
- Change EXPORT_SYMBOL to EXPORT_SYMBOL_GPL for new functions
- Make gnttab_dma_{alloc|free}_pages to request frames array
  be allocated outside
- Fixe gnttab_dma_alloc_pages fail path (added xenmem_reservation_increase)
- Move most of dma-buf from gntdev.c to gntdev-dmabuf.c
- Add required dependencies to Kconfig
- Rework "#ifdef CONFIG_XEN_XXX" for if/else
- Export gnttab_{alloc|free}_pages as GPL symbols (patch 1)

Oleksandr Andrushchenko (9):
  xen/grant-table: Export gnttab_{alloc|free}_pages as GPL
  xen/grant-table: Make set/clear page private code shared
  xen/balloon: Share common memory reservation routines
  xen/grant-table: Allow allocating buffers suitable for DMA
  xen/gntdev: Allow mappings for DMA buffers
  xen/gntdev: Make private routines/structures accessible
  xen/gntdev: Add initial support for dma-buf UAPI
  xen/gntdev: Implement dma-buf export functionality
  xen/gntdev: Implement dma-buf import functionality

 drivers/xen/Kconfig           |  23 +
 drivers/xen/Makefile          |   2 +
 drivers/xen/balloon.c         |  71 +---
 drivers/xen/gntdev-common.h   |  96 +++++
 drivers/xen/gntdev-dmabuf.c   | 774 ++++++++++++++++++++++++++++++++++
 drivers/xen/gntdev-dmabuf.h   |  39 ++
 drivers/xen/gntdev.c          | 329 ++++++++++++---
 drivers/xen/grant-table.c     | 153 ++++++-
 drivers/xen/mem-reservation.c | 112 +++++
 include/uapi/xen/gntdev.h     | 106 +++++
 include/xen/grant_table.h     |  21 +
 include/xen/mem-reservation.h |  64 +++
 12 files changed, 1635 insertions(+), 155 deletions(-)
 create mode 100644 drivers/xen/gntdev-common.h
 create mode 100644 drivers/xen/gntdev-dmabuf.c
 create mode 100644 drivers/xen/gntdev-dmabuf.h
 create mode 100644 drivers/xen/mem-reservation.c
 create mode 100644 include/xen/mem-reservation.h

-- 
2.17.1
