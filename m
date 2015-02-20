Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:47905 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246AbbBTQ1c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2015 11:27:32 -0500
Received: by mail-ob0-f176.google.com with SMTP id wo20so25171607obc.7
        for <linux-media@vger.kernel.org>; Fri, 20 Feb 2015 08:27:32 -0800 (PST)
MIME-Version: 1.0
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Fri, 20 Feb 2015 21:57:11 +0530
Message-ID: <CAO_48GGT6C8-7gnKMcQ+rAQfvkEmyNzUmJAB=uJUJrFZSNo5sg@mail.gmail.com>
Subject: [GIT PULL]: few dma-buf updates for 3.20-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Tom Gall <tom.gall@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Could you please pull a few dma-buf changes for 3.20-rc1? Nothing
fancy, minor cleanups.

The following changes since commit b942c653ae265abbd31032f3b4f5f857e5c7c723:

  Merge tag 'trace-sh-3.19' of
git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace
(2015-01-22 06:26:07 +1200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/sumits/dma-buf.git
tags/dma-buf-for-3.20

for you to fetch changes up to 817bd7253291fc69d83d4340a7e186f3e6933169:

  dma-buf: cleanup dma_buf_export() to make it easily extensible
(2015-02-18 20:16:20 +0530)

----------------------------------------------------------------
dma-buf pull request for 3.20
- minor timeout & other cleanups on reservation/fence
- cleanup of dma_buf_export()

----------------------------------------------------------------
Jammy Zhou (2):
      reservation: wait only with non-zero timeout specified (v3)
      dma-buf/fence: don't wait when specified timeout is zero

Michel Dänzer (1):
      reservation: Remove shadowing local variable 'ret'

Sumit Semwal (1):
      dma-buf: cleanup dma_buf_export() to make it easily extensible

 Documentation/dma-buf-sharing.txt              | 23 +++++++------
 drivers/dma-buf/dma-buf.c                      | 47 ++++++++++++--------------
 drivers/dma-buf/fence.c                        |  3 ++
 drivers/dma-buf/reservation.c                  |  5 +--
 drivers/gpu/drm/armada/armada_gem.c            | 10 ++++--
 drivers/gpu/drm/drm_prime.c                    | 12 ++++---
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c     |  9 +++--
 drivers/gpu/drm/i915/i915_gem_dmabuf.c         | 10 ++++--
 drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c      |  9 ++++-
 drivers/gpu/drm/tegra/gem.c                    | 10 ++++--
 drivers/gpu/drm/ttm/ttm_object.c               |  9 +++--
 drivers/gpu/drm/udl/udl_dmabuf.c               |  9 ++++-
 drivers/media/v4l2-core/videobuf2-dma-contig.c |  8 ++++-
 drivers/media/v4l2-core/videobuf2-dma-sg.c     |  8 ++++-
 drivers/media/v4l2-core/videobuf2-vmalloc.c    |  8 ++++-
 drivers/staging/android/ion/ion.c              |  9 +++--
 include/linux/dma-buf.h                        | 34 +++++++++++++++----
 17 files changed, 158 insertions(+), 65 deletions(-)


Thanks, and best regards,
Sumit.
