Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:44663 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729790AbeIRSsF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 14:48:05 -0400
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc: kernel@pengutronix.de, devicetree@vger.kernel.org,
        p.zabel@pengutronix.de, javierm@redhat.com,
        laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
        afshin.nasser@gmail.com, linux-media@vger.kernel.org
Subject: [PATCH v3 6/9] media: v4l2-subdev: fix v4l2_subdev_get_try_* dependency
Date: Tue, 18 Sep 2018 15:14:50 +0200
Message-Id: <20180918131453.21031-7-m.felsch@pengutronix.de>
In-Reply-To: <20180918131453.21031-1-m.felsch@pengutronix.de>
References: <20180918131453.21031-1-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These helpers make us of the media-controller entity which is only
available if the CONFIG_MEDIA_CONTROLLER is enabled.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
Changelog:

v3:
- add CONFIG_MEDIA_CONTROLLER switch instead of moving the
  v4l2_subdev_get_try_* APIs into the existing one.

v2:
- Initial commit

 include/media/v4l2-subdev.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index ce48f1fcf295..d2479d5ebca8 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -912,6 +912,8 @@ struct v4l2_subdev_fh {
 #define to_v4l2_subdev_fh(fh)	\
 	container_of(fh, struct v4l2_subdev_fh, vfh)
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+
 /**
  * v4l2_subdev_get_try_format - ancillary routine to call
  *	&struct v4l2_subdev_pad_config->try_fmt
@@ -978,6 +980,8 @@ static inline struct v4l2_rect
 #endif
 }
 
+#endif
+
 extern const struct v4l2_file_operations v4l2_subdev_fops;
 
 /**
-- 
2.19.0
