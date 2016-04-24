Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35726 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbcDXVK3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 17:10:29 -0400
Received: by mail-wm0-f66.google.com with SMTP id e201so17587521wme.2
        for <linux-media@vger.kernel.org>; Sun, 24 Apr 2016 14:10:28 -0700 (PDT)
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org
Subject: [RFC PATCH 15/24] media: add subdev type for bus switch
Date: Mon, 25 Apr 2016 00:08:15 +0300
Message-Id: <1461532104-24032-16-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sebastian Reichel <sre@kernel.org>

---
 include/uapi/linux/media.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index df59ede..244bea1 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -137,6 +137,7 @@ struct media_device_info {
  * MEDIA_ENT_F_IF_VID_DECODER and/or MEDIA_ENT_F_IF_AUD_DECODER.
  */
 #define MEDIA_ENT_F_TUNER		(MEDIA_ENT_F_OLD_SUBDEV_BASE + 5)
+#define MEDIA_ENT_F_SWITCH		(MEDIA_ENT_F_OLD_SUBDEV_BASE + 6)
 
 #define MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN	MEDIA_ENT_F_OLD_SUBDEV_BASE
 
-- 
1.9.1

