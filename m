Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:42920 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932386AbcGDNfI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 09:35:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/7] adv7604/adv7842: drop unused op_656_range and alt_data_sat fields.
Date: Mon,  4 Jul 2016 15:34:50 +0200
Message-Id: <1467639292-1066-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1467639292-1066-1-git-send-email-hverkuil@xs4all.nl>
References: <1467639292-1066-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These platform_data fields are no longer needed, drop them.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/i2c/adv7604.h | 2 --
 include/media/i2c/adv7842.h | 2 --
 2 files changed, 4 deletions(-)

diff --git a/include/media/i2c/adv7604.h b/include/media/i2c/adv7604.h
index a913859..2e6857d 100644
--- a/include/media/i2c/adv7604.h
+++ b/include/media/i2c/adv7604.h
@@ -121,8 +121,6 @@ struct adv76xx_platform_data {
 
 	/* IO register 0x02 */
 	unsigned alt_gamma:1;
-	unsigned op_656_range:1;
-	unsigned alt_data_sat:1;
 
 	/* IO register 0x05 */
 	unsigned blank_data:1;
diff --git a/include/media/i2c/adv7842.h b/include/media/i2c/adv7842.h
index bc24970..7f53ada 100644
--- a/include/media/i2c/adv7842.h
+++ b/include/media/i2c/adv7842.h
@@ -165,8 +165,6 @@ struct adv7842_platform_data {
 
 	/* IO register 0x02 */
 	unsigned alt_gamma:1;
-	unsigned op_656_range:1;
-	unsigned alt_data_sat:1;
 
 	/* IO register 0x05 */
 	unsigned blank_data:1;
-- 
2.8.1

