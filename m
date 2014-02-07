Return-path: <linux-media-owner@vger.kernel.org>
Received: from [173.38.203.53] ([173.38.203.53]:39935 "EHLO
	aer-iport-3.cisco.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751666AbaBGILW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Feb 2014 03:11:22 -0500
From: Martin Bugge <marbugge@cisco.com>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>
Subject: [PATCH 1/3] [media] ths8200: Zero blanking level for RGB.
Date: Fri,  7 Feb 2014 09:11:03 +0100
Message-Id: <1391760665-24784-2-git-send-email-marbugge@cisco.com>
In-Reply-To: <1391760665-24784-1-git-send-email-marbugge@cisco.com>
References: <1391760665-24784-1-git-send-email-marbugge@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently only RGB444 input data is supported so set to zero.

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Signed-off-by: Martin Bugge <marbugge@cisco.com>
---
 drivers/media/i2c/ths8200.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ths8200.c b/drivers/media/i2c/ths8200.c
index 04139ee..5c7dca3 100644
--- a/drivers/media/i2c/ths8200.c
+++ b/drivers/media/i2c/ths8200.c
@@ -217,8 +217,8 @@ static void ths8200_core_init(struct v4l2_subdev *sd)
 	/* Disable embedded syncs on the output by setting
 	 * the amplitude to zero for all channels.
 	 */
-	ths8200_write(sd, THS8200_DTG1_Y_SYNC_MSB, 0x2a);
-	ths8200_write(sd, THS8200_DTG1_CBCR_SYNC_MSB, 0x2a);
+	ths8200_write(sd, THS8200_DTG1_Y_SYNC_MSB, 0x00);
+	ths8200_write(sd, THS8200_DTG1_CBCR_SYNC_MSB, 0x00);
 }
 
 static void ths8200_setup(struct v4l2_subdev *sd, struct v4l2_bt_timings *bt)
-- 
1.8.1.4

