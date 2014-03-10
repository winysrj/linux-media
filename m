Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48727 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbaCJXO4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 19:14:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 47/48] adv7604: Add LLC polarity configuration
Date: Tue, 11 Mar 2014 00:15:58 +0100
Message-Id: <1394493359-14115-48-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an inv_llc_pol field to platform data to control the clock polarity.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/adv7604.c | 3 ++-
 include/media/adv7604.h     | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index de44213..95cc911 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2429,7 +2429,8 @@ static int adv7604_core_init(struct v4l2_subdev *sd)
 	cp_write(sd, 0x69, 0x30);   /* Enable CP CSC */
 
 	/* VS, HS polarities */
-	io_write(sd, 0x06, 0xa0 | pdata->inv_vs_pol << 2 | pdata->inv_hs_pol << 1);
+	io_write(sd, 0x06, 0xa0 | pdata->inv_vs_pol << 2 |
+		 pdata->inv_hs_pol << 1 | pdata->inv_llc_pol);
 
 	/* Adjust drive strength */
 	io_write(sd, 0x14, 0x40 | pdata->dr_str_data << 4 |
diff --git a/include/media/adv7604.h b/include/media/adv7604.h
index 6d69207..7a8462f 100644
--- a/include/media/adv7604.h
+++ b/include/media/adv7604.h
@@ -114,6 +114,7 @@ struct adv7604_platform_data {
 	/* IO register 0x06 */
 	unsigned inv_vs_pol:1;
 	unsigned inv_hs_pol:1;
+	unsigned inv_llc_pol:1;
 
 	/* IO register 0x14 */
 	enum adv7604_drive_strength dr_str_data;
-- 
1.8.3.2

