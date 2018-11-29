Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:40394 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727160AbeK2Vzl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Nov 2018 16:55:41 -0500
From: Colin King <colin.king@canonical.com>
To: Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][media-next] media: sun6i: fix spelling mistake "droped" -> "dropped"
Date: Thu, 29 Nov 2018 10:50:38 +0000
Message-Id: <20181129105038.17902-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

There are spelling mistakes in dev_dbg messages, fix them.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
index 37c85b8f37a9..b04300c3811f 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
@@ -261,7 +261,7 @@ void sun6i_video_frame_done(struct sun6i_video *video)
 	buf = list_first_entry(&video->dma_queue,
 			       struct sun6i_csi_buffer, list);
 	if (list_is_last(&buf->list, &video->dma_queue)) {
-		dev_dbg(video->csi->dev, "Frame droped!\n");
+		dev_dbg(video->csi->dev, "Frame dropped!\n");
 		goto unlock;
 	}
 
@@ -274,7 +274,7 @@ void sun6i_video_frame_done(struct sun6i_video *video)
 	if (!next_buf->queued_to_csi) {
 		next_buf->queued_to_csi = true;
 		sun6i_csi_update_buf_addr(video->csi, next_buf->dma_addr);
-		dev_dbg(video->csi->dev, "Frame droped!\n");
+		dev_dbg(video->csi->dev, "Frame dropped!\n");
 		goto unlock;
 	}
 
-- 
2.19.1
