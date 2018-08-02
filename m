Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57070 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727369AbeHCB3e (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2018 21:29:34 -0400
Date: Thu, 2 Aug 2018 20:36:04 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.18-rc8] media fixes
Message-ID: <20180802203604.1d219a10@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.18-3

For:

  - a dead lock regression at vsp1 driver;
  - some Remote Controller fixes related to the new BPF filter
    logic added on it for Kernel 4.18.

Thanks!
Mauro

-

The following changes since commit 7daf201d7fe8334e2d2364d4e8ed3394ec9af819:

  Linux 4.18-rc2 (2018-06-24 20:54:29 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.18-3

for you to fetch changes up to 8eb0e6421958e9777db98448a4030d8ae940c9a0:

  media: v4l: vsp1: Fix deadlock in VSPDL DRM pipelines (2018-07-30 08:22:59 -0400)

----------------------------------------------------------------
media fixes for v4.18-rc8

----------------------------------------------------------------
Laurent Pinchart (1):
      media: v4l: vsp1: Fix deadlock in VSPDL DRM pipelines

Sean Young (3):
      media: rc: be less noisy when driver misbehaves
      media: bpf: ensure bpf program is freed on detach
      media: rc: read out of bounds if bpf reports high protocol number

 drivers/media/platform/vsp1/vsp1_drm.c |  4 +---
 drivers/media/rc/bpf-lirc.c            |  1 +
 drivers/media/rc/rc-ir-raw.c           |  8 ++++----
 drivers/media/rc/rc-main.c             | 12 ++++++++++--
 4 files changed, 16 insertions(+), 9 deletions(-)
