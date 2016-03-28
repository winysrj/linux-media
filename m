Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0a-001ae601.pphosted.com ([67.231.149.25]:50787 "EHLO
	mx0a-001ae601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755132AbcC1NMY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Mar 2016 09:12:24 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: <mchehab@osg.samsung.com>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@opensource.wolfsonmicro.com>
Subject: [PATCH] [media] v4l: Remove unused variable
Date: Mon, 28 Mar 2016 14:12:27 +0100
Message-ID: <1459170747-4964-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/media/v4l2-core/v4l2-mc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Based off Linus's tree, apologies but I was having some difficulty
finding the correct tree/branch to base this on, but it is causing
a warning on Linus's tree.

Thanks,
Charles

diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index 2a7b79b..2228cd3 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -34,7 +34,7 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 {
 	struct media_entity *entity;
 	struct media_entity *if_vid = NULL, *if_aud = NULL;
-	struct media_entity *tuner = NULL, *decoder = NULL, *dtv_demod = NULL;
+	struct media_entity *tuner = NULL, *decoder = NULL;
 	struct media_entity *io_v4l = NULL, *io_vbi = NULL, *io_swradio = NULL;
 	bool is_webcam = false;
 	u32 flags;
-- 
2.1.4

