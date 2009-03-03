Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.renesas.com ([202.234.163.13]:60536 "EHLO
	mail02.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751474AbZCCAsC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2009 19:48:02 -0500
Date: Tue, 03 Mar 2009 09:27:19 +0900
From: Kuninori Morimoto <morimoto.kuninori@renesas.com>
Subject: [PATCH] ov772x: Add extra setting method
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Magnus <magnus.damm@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Message-id: <u63irl9dx.wl%morimoto.kuninori@renesas.com>
MIME-version: 1.0 (generated by SEMI 1.14.6 - "Maruoka")
Content-type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch add support extra register settings for platform.
For instance, platform comes to be able to use the
special setting like lens.

Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
---
Thank you Magnus for your nice comment.

 drivers/media/video/ov772x.c |   15 ++++++++-------
 include/media/ov772x.h       |    7 +++++++
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index 84b0fc1..f07d558 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -368,11 +368,6 @@
 /*
  * struct
  */
-struct regval_list {
-	unsigned char reg_num;
-	unsigned char value;
-};
-
 struct ov772x_color_format {
 	char                     *name;
 	__u32                     fourcc;
@@ -400,8 +395,6 @@ struct ov772x_priv {
 	unsigned int                      flag_hflip:1;
 };
 
-#define ENDMARKER { 0xff, 0xff }
-
 /*
  * register setting for window size
  */
@@ -815,6 +808,14 @@ static int ov772x_set_params(struct ov772x_priv *priv, u32 width, u32 height,
 	 */
 	ov772x_reset(priv->client);
 
+	/* set extra setting */
+	if (priv->info->extra) {
+		ret = ov772x_write_array(priv->client,
+					 priv->info->extra);
+		if (ret < 0)
+			goto ov772x_set_fmt_error;
+	}
+
 	/*
 	 * set size format
 	 */
diff --git a/include/media/ov772x.h b/include/media/ov772x.h
index 57db48d..8a20a1e 100644
--- a/include/media/ov772x.h
+++ b/include/media/ov772x.h
@@ -13,6 +13,12 @@
 
 #include <media/soc_camera.h>
 
+#define ENDMARKER { 0xff, 0xff }
+struct regval_list {
+	unsigned char reg_num;
+	unsigned char value;
+};
+
 /* for flags */
 #define OV772X_FLAG_VFLIP     0x00000001 /* Vertical flip image */
 #define OV772X_FLAG_HFLIP     0x00000002 /* Horizontal flip image */
@@ -21,6 +27,7 @@ struct ov772x_camera_info {
 	unsigned long          buswidth;
 	unsigned long          flags;
 	struct soc_camera_link link;
+	const struct regval_list     *extra;
 };
 
 #endif /* __OV772X_H__ */
-- 
1.5.6.3

