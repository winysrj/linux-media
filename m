Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58891 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698Ab0HCJik (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 05:38:40 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: baruch@tkos.co.il, g.liakhovetski@gmx.de, s.hauer@pengutronix.de,
	Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH 3/5] mx2_camera: fix for list bufnum in frame_done_emma
Date: Tue,  3 Aug 2010 11:37:54 +0200
Message-Id: <1280828276-483-4-git-send-email-m.grzeschik@pengutronix.de>
In-Reply-To: <1280828276-483-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1280828276-483-1-git-send-email-m.grzeschik@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The emma uses bufnum 1 and 0. This patch tells the bufqueue to change
the next buffer to the next one and not the current one.
Otherwise the BUG_ON above will trigger everytime.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/media/video/mx2_camera.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index ae27640..cf9a604 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -1193,7 +1193,7 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 	buf = list_entry(pcdev->capture.next,
 			struct mx2_buffer, vb.queue);
 
-	buf->bufnum = bufnum;
+	buf->bufnum = !bufnum;
 
 	list_move_tail(pcdev->capture.next, &pcdev->active_bufs);
 
-- 
1.7.1

