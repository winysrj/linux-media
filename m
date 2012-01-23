Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43016 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab2AWOff (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 09:35:35 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org
Subject: [PATCH] media: vb2-memops: Export vb2_get_vma symbol
Date: Mon, 23 Jan 2012 15:35:38 +0100
Message-Id: <1327329338-18374-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1327326675-8431-9-git-send-email-t.stanislaws@samsung.com>
References: <1327326675-8431-9-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vb2_get_vma() function is called by videobuf2-dma-contig. Export it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/videobuf2-memops.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

Hi Thomas,

The following patch is needed to compile videobuf2-dma-contig as a module.

diff --git a/drivers/media/video/videobuf2-memops.c b/drivers/media/video/videobuf2-memops.c
index 71a7a78..718f70e 100644
--- a/drivers/media/video/videobuf2-memops.c
+++ b/drivers/media/video/videobuf2-memops.c
@@ -55,6 +55,7 @@ struct vm_area_struct *vb2_get_vma(struct vm_area_struct *vma)
 
 	return vma_copy;
 }
+EXPORT_SYMBOL_GPL(vb2_get_vma);
 
 /**
  * vb2_put_userptr() - release a userspace virtual memory area
-- 
Regards,

Laurent Pinchart

