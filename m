Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:55799 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753558AbcHQG3z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2016 02:29:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Songjun Wu <songjun.wu@microchip.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 2/7] ov7670: call v4l2_async_register_subdev
Date: Wed, 17 Aug 2016 08:29:38 +0200
Message-Id: <1471415383-38531-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1471415383-38531-1-git-send-email-hverkuil@xs4all.nl>
References: <1471415383-38531-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add v4l2-async support for this driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ov7670.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 25f46c7..26ad1a2 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1662,6 +1662,14 @@ static int ov7670_probe(struct i2c_client *client,
 	v4l2_ctrl_cluster(2, &info->saturation);
 	v4l2_ctrl_handler_setup(&info->hdl);
 
+	ret = v4l2_async_register_subdev(&info->sd);
+	if (ret < 0) {
+#if defined(CONFIG_MEDIA_CONTROLLER)
+		media_entity_cleanup(&info->sd.entity);
+#endif
+		return ret;
+	}
+
 	return 0;
 }
 
-- 
2.8.1

