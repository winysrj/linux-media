Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:45406 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726022AbeJJOYc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Oct 2018 10:24:32 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Helen Koike <helen.koike@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vicodec: lower minimum height to 360
Message-ID: <42690466-7b3e-acd6-de8e-d55cbe96dcf4@xs4all.nl>
Date: Wed, 10 Oct 2018 09:03:43 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Lower the minimum height to 360 to be consistent with the webcam input of vivid.

The 480 was rather arbitrary but it made it harder to use vivid as a source for
encoding since the default resolution when you load vivid is 640x360.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 1eb9132bfc85..b292cff26c86 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -42,7 +42,7 @@ MODULE_PARM_DESC(debug, " activates debug info");
 #define MAX_WIDTH		4096U
 #define MIN_WIDTH		640U
 #define MAX_HEIGHT		2160U
-#define MIN_HEIGHT		480U
+#define MIN_HEIGHT		360U

 #define dprintk(dev, fmt, arg...) \
 	v4l2_dbg(1, debug, &dev->v4l2_dev, "%s: " fmt, __func__, ## arg)
