Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751053AbeBIOuk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Feb 2018 09:50:40 -0500
From: Kieran Bingham <kbingham@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        "Stable v4.14+" <stable@vger.kernel.org>
Subject: [PATCH] v4l: vsp1: Fix header display list status check in continuous mode
Date: Fri,  9 Feb 2018 14:50:34 +0000
Message-Id: <1518187834-21267-1-git-send-email-kbingham@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

To allow dual pipelines utilising two WPF entities when available, the
VSP was updated to support header-mode display list in continuous
pipelines.

A small bug in the status check of the command register causes the
second pipeline to be directly afflicted by the running of the first;
appearing as a perceived performance issue with stuttering display.

Fix the vsp1_dl_list_hw_update_pending() call to ensure that the read
comparison corresponds to the correct pipeline.

Fixes: eaf4bfad6ad8 ("v4l: vsp1: Add support for header display
lists in continuous mode")
Cc: "Stable v4.14+" <stable@vger.kernel.org>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 8cd03ee45f79..34b5ed2592f8 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -509,7 +509,8 @@ static bool vsp1_dl_list_hw_update_pending(struct vsp1_dl_manager *dlm)
 		return !!(vsp1_read(vsp1, VI6_DL_BODY_SIZE)
 			  & VI6_DL_BODY_SIZE_UPD);
 	else
-		return !!(vsp1_read(vsp1, VI6_CMD(dlm->index) & VI6_CMD_UPDHDR));
+		return !!(vsp1_read(vsp1, VI6_CMD(dlm->index))
+			  & VI6_CMD_UPDHDR);
 }
 
 static bool vsp1_dl_hw_active(struct vsp1_dl_manager *dlm)
-- 
2.7.4
