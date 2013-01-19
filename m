Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f44.google.com ([209.85.216.44]:64739 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab3ASXnF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jan 2013 18:43:05 -0500
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: mchehab@redhat.com
Cc: hans.verkuil@cisco.com, sakari.ailus@iki.fi, dhowells@redhat.com,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH V2 24/24] v4l2-core/v4l2-common.c: use IS_ENABLED() macro
Date: Sat, 19 Jan 2013 21:41:31 -0200
Message-Id: <1358638891-4775-25-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1358638891-4775-1-git-send-email-peter.senna@gmail.com>
References: <1358638891-4775-1-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

replace:
 #if defined(CONFIG_MEDIA_TUNER_TEA5761) || \
     defined(CONFIG_MEDIA_TUNER_TEA5761_MODULE)
with:
 #if IS_ENABLED(CONFIG_MEDIA_TUNER_TEA5761)

This change was made for: CONFIG_MEDIA_TUNER_TEA5761

Also replaced:
 #if defined(CONFIG_I2C) || (defined(CONFIG_I2C_MODULE) && defined(MODULE))
with:
 #if IS_ENABLED(CONFIG_I2C)

Reported-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
Changes from V1:
   Updated subject
   Fixed commit message

 drivers/media/v4l2-core/v4l2-common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index 614316f..aa044f4 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -238,7 +238,7 @@ int v4l2_chip_match_host(const struct v4l2_dbg_match *match)
 }
 EXPORT_SYMBOL(v4l2_chip_match_host);
 
-#if defined(CONFIG_I2C) || (defined(CONFIG_I2C_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_I2C)
 int v4l2_chip_match_i2c_client(struct i2c_client *c, const struct v4l2_dbg_match *match)
 {
 	int len;
@@ -384,7 +384,7 @@ EXPORT_SYMBOL_GPL(v4l2_i2c_subdev_addr);
 const unsigned short *v4l2_i2c_tuner_addrs(enum v4l2_i2c_tuner_type type)
 {
 	static const unsigned short radio_addrs[] = {
-#if defined(CONFIG_MEDIA_TUNER_TEA5761) || defined(CONFIG_MEDIA_TUNER_TEA5761_MODULE)
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_TEA5761)
 		0x10,
 #endif
 		0x60,
-- 
1.7.11.7

