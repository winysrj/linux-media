Return-Path: <ricardo.ribalda@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>, Pawel Osciak <pawel@osciak.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Kyungmin Park <kyungmin.park@samsung.com>,
 Mauro Carvalho Chehab <mchehab@osg.samsung.com>, linux-media@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [RESEND PATCH v2 0/3] Fix handling of sg_table struct
Date: Wed, 29 Apr 2015 14:00:44 +0200
Message-id: <1430308847-32140-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-version: 1.0
Content-type: text/plain
List-ID: <linux-media.vger.kernel.org>

This is just a resend of the previous patches, cherry-picked to
the last master media tree.

I have also added the Reviewed-by: Marek

Thanks

Ricardo Ribalda Delgado (3):
  media/videobuf2-dma-sg: Fix handling of sg_table structure
  media/videobuf2-dma-contig: Save output from dma_map_sg
  media/videobuf2-dma-vmalloc: Save output from dma_map_sg

 drivers/media/v4l2-core/videobuf2-dma-contig.c |  6 +++---
 drivers/media/v4l2-core/videobuf2-dma-sg.c     | 22 +++++++++++++---------
 drivers/media/v4l2-core/videobuf2-vmalloc.c    |  6 +++---
 3 files changed, 19 insertions(+), 15 deletions(-)

-- 
2.1.4
