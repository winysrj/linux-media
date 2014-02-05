Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59504 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbaBEQmK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 11:42:10 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 46/47] adv7604: Add LLC polarity configuration
Date: Wed,  5 Feb 2014 17:42:37 +0100
Message-Id: <1391618558-5580-47-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an inv_llc_pol field to platform data to control the clock polarity.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/adv7604.c | 3 ++-
 include/media/adv7604.h     | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index cd8a2dc..064e57e 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2445,7 +2445,8 @@ static int adv7604_core_init(struct v4l2_subdev *sd)
 	cp_write(sd, 0x69, 0x30);   /* Enable CP CSC */
 
 	/* VS, HS polarities */
-	io_write(sd, 0x06, 0xa0 | pdata->inv_vs_pol << 2 | pdata->inv_hs_pol << 1);
+	io_write(sd, 0x06, 0xa0 | pdata->inv_vs_pol << 2 |
+		 pdata->inv_hs_pol << 1 | pdata->inv_llc_pol);
 
 	/* Adjust drive strength */
 	io_write(sd, 0x14, 0x40 | pdata->dr_str_data << 4 |
diff --git a/include/media/adv7604.h b/include/media/adv7604.h
index 0cad7a7..7c8b4e9 100644
--- a/include/media/adv7604.h
+++ b/include/media/adv7604.h
@@ -118,6 +118,7 @@ struct adv7604_platform_data {
 	/* IO register 0x06 */
 	unsigned inv_vs_pol:1;
 	unsigned inv_hs_pol:1;
+	unsigned inv_llc_pol:1;
 
 	/* IO register 0x14 */
 	enum adv7604_drive_strength dr_str_data;
-- 
1.8.3.2

