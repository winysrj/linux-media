Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:30314 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaA2Juc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jan 2014 04:50:32 -0500
From: Martin Bugge <marbugge@cisco.com>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH] [media] adv7842: Composite free-run platfrom-data fix
Date: Wed, 29 Jan 2014 10:50:20 +0100
Message-Id: <1390989020-14444-1-git-send-email-marbugge@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Incorrectly setting of free-run for Composite.
Copy/paste regression fix.

Should go to kernel 3.14.

Cc: Hans Verkuil <hansverk@cisco.com>
Signed-off-by: Martin Bugge <marbugge@cisco.com>
---
 drivers/media/i2c/adv7842.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 1effc21..9bbd665 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -2554,7 +2554,7 @@ static int adv7842_core_init(struct v4l2_subdev *sd)
 	sdp_write_and_or(sd, 0xdd, 0xf0, pdata->sdp_free_run_force |
 					 (pdata->sdp_free_run_cbar_en << 1) |
 					 (pdata->sdp_free_run_man_col_en << 2) |
-					 (pdata->sdp_free_run_force << 3));
+					 (pdata->sdp_free_run_auto << 3));
 
 	/* TODO from platform data */
 	cp_write(sd, 0x69, 0x14);   /* Enable CP CSC */
-- 
1.8.1.4

