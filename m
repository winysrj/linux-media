Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38905 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291AbaDQONo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 10:13:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v4 46/49] adv7604: Add LLC polarity configuration
Date: Thu, 17 Apr 2014 16:13:17 +0200
Message-Id: <1397744000-23967-47-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an inv_llc_pol field to platform data to control the clock polarity.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/i2c/adv7604.c | 3 ++-
 include/media/adv7604.h     | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 061794e..fd0c646 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2466,7 +2466,8 @@ static int adv7604_core_init(struct v4l2_subdev *sd)
 	cp_write(sd, 0x69, 0x30);   /* Enable CP CSC */
 
 	/* VS, HS polarities */
-	io_write(sd, 0x06, 0xa0 | pdata->inv_vs_pol << 2 | pdata->inv_hs_pol << 1);
+	io_write(sd, 0x06, 0xa0 | pdata->inv_vs_pol << 2 |
+		 pdata->inv_hs_pol << 1 | pdata->inv_llc_pol);
 
 	/* Adjust drive strength */
 	io_write(sd, 0x14, 0x40 | pdata->dr_str_data << 4 |
diff --git a/include/media/adv7604.h b/include/media/adv7604.h
index 40b4ae0..aa1c447 100644
--- a/include/media/adv7604.h
+++ b/include/media/adv7604.h
@@ -131,6 +131,7 @@ struct adv7604_platform_data {
 	/* IO register 0x06 */
 	unsigned inv_vs_pol:1;
 	unsigned inv_hs_pol:1;
+	unsigned inv_llc_pol:1;
 
 	/* IO register 0x14 */
 	enum adv7604_drive_strength dr_str_data;
-- 
1.8.3.2

