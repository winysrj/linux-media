Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:62278 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaBGILY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Feb 2014 03:11:24 -0500
From: Martin Bugge <marbugge@cisco.com>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>
Subject: [PATCH 2/3] [media] ths8200: Corrected sync polarities setting.
Date: Fri,  7 Feb 2014 09:11:04 +0100
Message-Id: <1391760665-24784-3-git-send-email-marbugge@cisco.com>
In-Reply-To: <1391760665-24784-1-git-send-email-marbugge@cisco.com>
References: <1391760665-24784-1-git-send-email-marbugge@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HS_IN/VS_IN was always set to positive.

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Signed-off-by: Martin Bugge <marbugge@cisco.com>
---
 drivers/media/i2c/ths8200.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ths8200.c b/drivers/media/i2c/ths8200.c
index 5c7dca3..bcacf52 100644
--- a/drivers/media/i2c/ths8200.c
+++ b/drivers/media/i2c/ths8200.c
@@ -356,7 +356,7 @@ static void ths8200_setup(struct v4l2_subdev *sd, struct v4l2_bt_timings *bt)
 	/* Timing of video input bus is derived from HS, VS, and FID dedicated
 	 * inputs
 	 */
-	ths8200_write(sd, THS8200_DTG2_CNTL, 0x47 | polarity);
+	ths8200_write(sd, THS8200_DTG2_CNTL, 0x44 | polarity);
 
 	/* leave reset */
 	ths8200_s_stream(sd, true);
-- 
1.8.1.4

