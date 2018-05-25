Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:46427 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964823AbeEYPdo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 11:33:44 -0400
From: Oleksandr Andrushchenko <andr2000@gmail.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, andr2000@gmail.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Subject: [PATCH 0/8] xen: dma-buf support for grant device
Date: Fri, 25 May 2018 18:33:23 +0300
Message-Id: <20180525153331.31188-1-andr2000@gmail.com>
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

The first four patches are in preparation for Xen dma-buf support,
but I consider those usable regardless of the dma-buf use-case,
e.g. other frontend/backend kernel modules may also benefit from these
for better code reuse:
   0001-xen-grant-table-Make-set-clear-page-private-code-sha.patch
   0002-xen-balloon-Move-common-memory-reservation-routines-.patch
   0003-xen-grant-table-Allow-allocating-buffers-suitable-fo.patch
   0004-xen-gntdev-Allow-mappings-for-DMA-buffers.patch

The next three patches are Xen implementation of dma-buf as part of
the grant device:
   0005-xen-gntdev-Add-initial-support-for-dma-buf-UAPI.patch
   0006-xen-gntdev-Implement-dma-buf-export-functionality.patch
   0007-xen-gntdev-Implement-dma-buf-import-functionality.patch

The last patch makes it possible for in-kernel use of Xen dma-buf API:
  0008-xen-gntdev-Expose-gntdev-s-dma-buf-API-for-in-kernel.patch

The corresponding libxengnttab changes are available at [6].

All the above was tested with display backend [7] and its accompanying
helper library [8] on Renesas ARM64 based board.

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

Oleksandr Andrushchenko (8):
  xen/grant-table: Make set/clear page private code shared
  xen/balloon: Move common memory reservation routines to a module
  xen/grant-table: Allow allocating buffers suitable for DMA
  xen/gntdev: Allow mappings for DMA buffers
  xen/gntdev: Add initial support for dma-buf UAPI
  xen/gntdev: Implement dma-buf export functionality
  xen/gntdev: Implement dma-buf import functionality
  xen/gntdev: Expose gntdev's dma-buf API for in-kernel use

 drivers/xen/Kconfig           |   23 +
 drivers/xen/Makefile          |    1 +
 drivers/xen/balloon.c         |   71 +--
 drivers/xen/gntdev.c          | 1025 ++++++++++++++++++++++++++++++++-
 drivers/xen/grant-table.c     |  176 +++++-
 drivers/xen/mem-reservation.c |  134 +++++
 include/uapi/xen/gntdev.h     |  106 ++++
 include/xen/grant_dev.h       |   37 ++
 include/xen/grant_table.h     |   28 +
 include/xen/mem_reservation.h |   29 +
 10 files changed, 1527 insertions(+), 103 deletions(-)
 create mode 100644 drivers/xen/mem-reservation.c
 create mode 100644 include/xen/grant_dev.h
 create mode 100644 include/xen/mem_reservation.h

-- 
2.17.0
