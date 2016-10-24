Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37221 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932486AbcJXQKI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Oct 2016 12:10:08 -0400
From: Thierry Escande <thierry.escande@collabora.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 0/2] [media] videobuf2-dc: Add support for cacheable MMAP
Date: Mon, 24 Oct 2016 18:09:58 +0200
Message-Id: <1477325400-26450-1-git-send-email-thierry.escande@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset = "utf-8"
Content-Transfert-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This series adds support for cacheable MMAP in DMA coherent allocator.

The first patch moves the vb2_dc_get_base_sgt() function above mmap
callbacks for calls introduced by the second patch. This avoids a
forward declaration.

Changes in v2:
- Put function move in a separate patch
- Added comments

Heng-Ruey Hsu (1):
  [media] videobuf2-dc: Support cacheable MMAP

Thierry Escande (1):
  [media] videobuf2-dc: Move vb2_dc_get_base_sgt() above mmap callbacks

 drivers/media/v4l2-core/videobuf2-dma-contig.c | 62 +++++++++++++++++---------
 1 file changed, 40 insertions(+), 22 deletions(-)

-- 
2.7.4

