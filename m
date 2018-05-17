Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36381 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752173AbeEQI0O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 04:26:14 -0400
From: Oleksandr Andrushchenko <andr2000@gmail.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, andr2000@gmail.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Subject: [Xen-devel][RFC 0/3] dma-buf support for gntdev
Date: Thu, 17 May 2018 11:26:01 +0300
Message-Id: <20180517082604.14828-1-andr2000@gmail.com>
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
1. DMA-able memory buffer allocation and ballooning in/out the pages
   of such a buffer.
   This is required if we are about to share dma-buf with the hardware
   that does require those to be allocated with dma_alloc_xxx API.
   (It is still possible to allocate a dma-buf from any other memory,
   e.g. system pages).
2. Extension of the gntdev driver to enable it to import/export dma-buf’s.

The first two patches in this series solve #1 and the last one is for #2.
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

Oleksandr Andrushchenko (3):
  xen/balloon: Allow allocating DMA buffers
  xen/grant-table: Extend API to work with DMA buffers
  xen/gntdev: Add support for Linux dma buffers

 drivers/xen/balloon.c     | 214 +++++++--
 drivers/xen/gntdev.c      | 954 +++++++++++++++++++++++++++++++++++++-
 drivers/xen/grant-table.c |  49 ++
 drivers/xen/xen-balloon.c |   2 +
 include/uapi/xen/gntdev.h | 101 ++++
 include/xen/balloon.h     |  11 +-
 include/xen/gntdev_exp.h  |  23 +
 include/xen/grant_table.h |   7 +
 8 files changed, 1310 insertions(+), 51 deletions(-)
 create mode 100644 include/xen/gntdev_exp.h

-- 
2.17.0
