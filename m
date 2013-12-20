Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4141 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014Ab3LTJcC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:32:02 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 24/50] adv7604: sync polarities from platform data
Date: Fri, 20 Dec 2013 10:31:17 +0100
Message-Id: <1387531903-20496-25-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 5 +++--
 include/media/adv7604.h     | 4 ++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 0bc9e1a..be9699e 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2126,9 +2126,10 @@ static int adv7604_core_init(struct v4l2_subdev *sd)
 					pdata->replicate_av_codes << 1 |
 					pdata->invert_cbcr << 0);
 
-	/* TODO from platform data */
 	cp_write(sd, 0x69, 0x30);   /* Enable CP CSC */
-	io_write(sd, 0x06, 0xa6);   /* positive VS and HS */
+
+	/* VS, HS polarities */
+	io_write(sd, 0x06, 0xa0 | pdata->inv_vs_pol << 2 | pdata->inv_hs_pol << 1);
 
 	/* Adjust drive strength */
 	io_write(sd, 0x14, 0x40 | pdata->dr_str_data << 4 |
diff --git a/include/media/adv7604.h b/include/media/adv7604.h
index baf7250..d262a3a 100644
--- a/include/media/adv7604.h
+++ b/include/media/adv7604.h
@@ -113,6 +113,10 @@ struct adv7604_platform_data {
 	unsigned replicate_av_codes:1;
 	unsigned invert_cbcr:1;
 
+	/* IO register 0x06 */
+	unsigned inv_vs_pol:1;
+	unsigned inv_hs_pol:1;
+
 	/* IO register 0x14 */
 	enum adv7604_drive_strength dr_str_data;
 	enum adv7604_drive_strength dr_str_clk;
-- 
1.8.4.4

