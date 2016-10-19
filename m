Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:60058 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933718AbcJSONA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 10:13:00 -0400
From: Thierry Escande <thierry.escande@collabora.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 0/2] [media] DMA direction support in vb2_queue
Date: Wed, 19 Oct 2016 10:24:15 +0200
Message-Id: <1476865457-506-1-git-send-email-thierry.escande@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset = "utf-8"
Content-Transfert-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This series adds a dma_dir field to the vb2_queue structure in order to
store the DMA direction once for all in vb2_queue_init();

It also adds a new capture_dma_bidirectional flag to the vb2_queue
structure allowing the hardware to read from the CAPTURE buffer. This
flag is ignored for OUTPUT queues. This is used on ChromeOS by the
rockchip-vpu driver.

Changes since v1:
- Renamed use_dma_bidirectional field as capture_dma_bidirectional
- Added a VB2_DMA_DIR() macro

Pawel Osciak (2):
  [media] vb2: Store dma_dir in vb2_queue
  [media] vb2: Add support for capture_dma_bidirectional queue flag

 drivers/media/v4l2-core/videobuf2-core.c | 12 +++---------
 drivers/media/v4l2-core/videobuf2-v4l2.c |  6 ++++++
 include/media/videobuf2-core.h           |  6 ++++++
 3 files changed, 15 insertions(+), 9 deletions(-)

-- 
2.7.4

