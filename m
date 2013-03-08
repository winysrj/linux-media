Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1760 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933473Ab3CHQOx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 11:14:53 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.10] vb2 enhancements
Date: Fri, 8 Mar 2013 17:14:34 +0100
Cc: Federico Vaga <federico.vaga@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303081714.34667.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patch series adds the gfp_flags field to vb2 in order to be able to
use GFP_DMA or __GFP_DMA32 for PCI drivers like the solo that can only do
32-bit DMA. This is a temporary fix, Marek is working on a better solution,
but that won't happen during this kernel cycle. It's blocking work Federico
and myself are doing though, so he is OK with this going in and he'll adapt
it later. It's an internal API only and easy enough to change later.

The second vb2 patch silences some debug messages that the dma-sg allocator
kept sending out every time a buffer was allocated or freed. Only do that
if the debug option is set. Those messages really started to annoy me.

Regards,

	Hans

The following changes since commit 457ba4ce4f435d0b4dd82a0acc6c796e541a2ea7:

  [media] bttv: move fini_bttv_i2c() from bttv-input.c to bttv-i2c.c (2013-03-05 17:11:12 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git vb2

for you to fetch changes up to c366a106a6c0c7345cdbf532b0d543696f16ec76:

  vb2-dma-sg: add debug module option. (2013-03-08 13:22:35 +0100)

----------------------------------------------------------------
Hans Verkuil (2):
      videobuf2: add gfp_flags.
      vb2-dma-sg: add debug module option.

 drivers/media/v4l2-core/videobuf2-core.c       |    2 +-
 drivers/media/v4l2-core/videobuf2-dma-contig.c |    5 +++--
 drivers/media/v4l2-core/videobuf2-dma-sg.c     |   22 ++++++++++++++++------
 drivers/media/v4l2-core/videobuf2-vmalloc.c    |    4 ++--
 include/media/videobuf2-core.h                 |   10 ++++++++--
 5 files changed, 30 insertions(+), 13 deletions(-)
