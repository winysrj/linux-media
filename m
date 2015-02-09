Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:52423 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933400AbbBIQOe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Feb 2015 11:14:34 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 3/3] media/videobuf2-dma-vmalloc: Save output from dma_map_sg
Date: Mon,  9 Feb 2015 17:14:26 +0100
Message-Id: <1423498466-16718-3-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1423498466-16718-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1423498466-16718-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dma_map_sg returns the actual number of areas mapped. Save it on nents.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/v4l2-core/videobuf2-vmalloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index bcde885..fe18e79 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -312,6 +312,7 @@ static struct sg_table *vb2_vmalloc_dmabuf_ops_map(
 		mutex_unlock(lock);
 		return ERR_PTR(-EIO);
 	}
+	sgt->nents = ret;
 
 	attach->dma_dir = dma_dir;
 
-- 
2.1.4

