Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50684 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751769AbaDLNYP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Apr 2014 09:24:15 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [yavta PATCH v3 02/11] Provide functions for setting the buffer type and checking its validity
Date: Sat, 12 Apr 2014 16:23:54 +0300
Message-Id: <1397309043-8322-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1397309043-8322-1-git-send-email-sakari.ailus@iki.fi>
References: <1397309043-8322-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 yavta.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/yavta.c b/yavta.c
index c7ad7b4..d8f0c59 100644
--- a/yavta.c
+++ b/yavta.c
@@ -220,6 +220,16 @@ static const char *v4l2_format_name(unsigned int fourcc)
 	return name;
 }
 
+static void video_set_buf_type(struct device *dev, enum v4l2_buf_type type)
+{
+	dev->type = type;
+}
+
+static bool video_has_valid_buf_type(struct device *dev)
+{
+	return (int)dev->type != -1;
+}
+
 static void video_init(struct device *dev)
 {
 	memset(dev, 0, sizeof *dev);
-- 
1.7.10.4

