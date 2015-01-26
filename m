Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41508 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbbAZMr1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jan 2015 07:47:27 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-api@vger.kernel.org
Subject: [PATCH 3/3] media: add a subdev type for tuner
Date: Mon, 26 Jan 2015 10:47:12 -0200
Message-Id: <93d041fb91938618339acebc8fd6023fb4c7c3f4.1422273497.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1422273497.git.mchehab@osg.samsung.com>
References: <cover.1422273497.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1422273497.git.mchehab@osg.samsung.com>
References: <cover.1422273497.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add MEDIA_ENT_T_V4L2_SUBDEV_TUNER to represent the V4L2
(and dvb) tuner subdevices.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 4c8f26243252..52cc2a6b19b7 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -66,6 +66,8 @@ struct media_device_info {
 /* A converter of analogue video to its digital representation. */
 #define MEDIA_ENT_T_V4L2_SUBDEV_DECODER	(MEDIA_ENT_T_V4L2_SUBDEV + 4)
 
+#define MEDIA_ENT_T_V4L2_SUBDEV_TUNER	(MEDIA_ENT_T_V4L2_SUBDEV + 5)
+
 #define MEDIA_ENT_FL_DEFAULT		(1 << 0)
 
 struct media_entity_desc {
-- 
2.1.0

