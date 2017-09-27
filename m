Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33408
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752356AbdI0VrH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:47:07 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH v2 02/17] media: v4l2-common: get rid of v4l2_routing dead struct
Date: Wed, 27 Sep 2017 18:46:45 -0300
Message-Id: <a47fda6dbbdf84a9bdc607acfc769d00e8cb22f6.1506548682.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506548682.git.mchehab@s-opensource.com>
References: <cover.1506548682.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506548682.git.mchehab@s-opensource.com>
References: <cover.1506548682.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This struct is not used anymore. Get rid of it and update
the documentation about what should still be converted.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-common.h | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index aac8b7b6e691..7dbecbe3009c 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -224,10 +224,11 @@ void v4l2_spi_subdev_init(struct v4l2_subdev *sd, struct spi_device *spi,
 
 /* ------------------------------------------------------------------------- */
 
-/* Note: these remaining ioctls/structs should be removed as well, but they are
-   still used in tuner-simple.c (TUNER_SET_CONFIG), cx18/ivtv (RESET) and
-   v4l2-int-device.h (v4l2_routing). To remove these ioctls some more cleanup
-   is needed in those modules. */
+/*
+ * FIXME: these remaining ioctls/structs should be removed as well, but they
+ * are still used in tuner-simple.c (TUNER_SET_CONFIG) and cx18/ivtv (RESET).
+ * To remove these ioctls some more cleanup is needed in those modules.
+ */
 
 /* s_config */
 struct v4l2_priv_tun_config {
@@ -238,11 +239,6 @@ struct v4l2_priv_tun_config {
 
 #define VIDIOC_INT_RESET            	_IOW ('d', 102, u32)
 
-struct v4l2_routing {
-	u32 input;
-	u32 output;
-};
-
 /* ------------------------------------------------------------------------- */
 
 /* Miscellaneous helper functions */
-- 
2.13.5
