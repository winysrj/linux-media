Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40282 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbcCXX2c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 19:28:32 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 46/51] v4l: vsp1: dl: Make reg_count field unsigned
Date: Fri, 25 Mar 2016 01:27:42 +0200
Message-Id: <1458862067-19525-47-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The field takes positive values only, make it unsigned.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 5a24d494059b..8efa5447c1b3 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -60,7 +60,7 @@ struct vsp1_dl_list {
 	dma_addr_t dma;
 	size_t size;
 
-	int reg_count;
+	unsigned int reg_count;
 };
 
 enum vsp1_dl_mode {
-- 
2.7.3

