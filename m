Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45270 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932953AbdC2V0P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 17:26:15 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 2C8AD60097
        for <linux-media@vger.kernel.org>; Thu, 30 Mar 2017 00:26:10 +0300 (EEST)
Date: Thu, 30 Mar 2017 00:25:39 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for v4.12] Make use of refcount_t in V4L2
Message-ID: <20170329212539.GI16657@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

These patches begin using refcount_t in counting references to VB2 buffers
as well as cx88 core.

Please pull.


The following changes since commit c3d4fb0fb41f4b5eafeee51173c14e50be12f839:

  [media] rc: sunxi-cir: simplify optional reset handling (2017-03-24 08:30:03 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git refcount_t

for you to fetch changes up to e1588d503639483a5a826dc0a2cd17eab0e44504:

  vb2: convert vb2_vmarea_handler refcount from atomic_t to refcount_t (2017-03-27 19:55:35 +0300)

----------------------------------------------------------------
Elena Reshetova (2):
      cx88: convert struct cx88_core.refcount from atomic_t to refcount_t
      vb2: convert vb2_vmarea_handler refcount from atomic_t to refcount_t

 drivers/media/pci/cx88/cx88-cards.c            |  2 +-
 drivers/media/pci/cx88/cx88-core.c             |  4 ++--
 drivers/media/pci/cx88/cx88.h                  |  3 ++-
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 11 ++++++-----
 drivers/media/v4l2-core/videobuf2-dma-sg.c     | 11 ++++++-----
 drivers/media/v4l2-core/videobuf2-memops.c     |  6 +++---
 drivers/media/v4l2-core/videobuf2-vmalloc.c    | 11 ++++++-----
 include/media/videobuf2-memops.h               |  3 ++-
 8 files changed, 28 insertions(+), 23 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
