Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34845 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbbDXNTi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2015 09:19:38 -0400
Received: by pabtp1 with SMTP id tp1so48423184pab.2
        for <linux-media@vger.kernel.org>; Fri, 24 Apr 2015 06:19:38 -0700 (PDT)
MIME-Version: 1.0
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Fri, 24 Apr 2015 18:49:17 +0530
Message-ID: <CAO_48GHWHTCaRzwF+yd-kNA48HHfaLSJ6aFP75rmjVXxim+BTA@mail.gmail.com>
Subject: [GIT PULL]: dma-buf updates for 4.1-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Tom Gall <tom.gall@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

May I request you to pull a few dma-buf changes for 4.1-rc1? minor
cleanup only; this could've gone in for the 4.0 merge window, but for
a copy-paste stupidity from me.

It has been in the for-next since then, and no issues reported.

Thanks and best regards,
Sumit.


The following changes since commit 646da63172f660ba84f195c1165360a9b73583ee:

  Merge tag 'remoteproc-4.1-next' of
git://git.kernel.org/pub/scm/linux/kernel/git/ohad/remoteproc
(2015-04-20 15:40:10 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/sumits/dma-buf.git
tags/dma-buf-for-4.1

for you to fetch changes up to 72449cb47b0104c32ff8fb9380ade9113375d8d1:

  staging: android: ion: fix wrong init of dma_buf_export_info
(2015-04-21 14:47:16 +0530)

----------------------------------------------------------------
- cleanup of dma_buf_export()
- correction of copy-paste stupidity while doing the cleanup

----------------------------------------------------------------
Sumit Semwal (2):
      dma-buf: cleanup dma_buf_export() to make it easily extensible
      staging: android: ion: fix wrong init of dma_buf_export_info

 Documentation/dma-buf-sharing.txt              | 23 +++++++------
 drivers/dma-buf/dma-buf.c                      | 47 ++++++++++++--------------
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
 15 files changed, 152 insertions(+), 63 deletions(-)
