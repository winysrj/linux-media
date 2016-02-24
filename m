Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38426 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285AbcBXVMR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2016 16:12:17 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 1/2] v4l: vsp1: Fix vsp1_du_atomic_(begin|flush) declarations
Date: Wed, 24 Feb 2016 23:12:09 +0200
Message-Id: <1456348330-28928-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1456348330-28928-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1456348330-28928-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The functions are void, make the declaration match the definition.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 include/media/vsp1.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/media/vsp1.h b/include/media/vsp1.h
index cc541753896f..d01f7cb8f691 100644
--- a/include/media/vsp1.h
+++ b/include/media/vsp1.h
@@ -23,11 +23,11 @@ int vsp1_du_init(struct device *dev);
 int vsp1_du_setup_lif(struct device *dev, unsigned int width,
 		      unsigned int height);
 
-int vsp1_du_atomic_begin(struct device *dev);
+void vsp1_du_atomic_begin(struct device *dev);
 int vsp1_du_atomic_update(struct device *dev, unsigned int rpf, u32 pixelformat,
 			  unsigned int pitch, dma_addr_t mem[2],
 			  const struct v4l2_rect *src,
 			  const struct v4l2_rect *dst);
-int vsp1_du_atomic_flush(struct device *dev);
+void vsp1_du_atomic_flush(struct device *dev);
 
 #endif /* __MEDIA_VSP1_H__ */
-- 
2.4.10

