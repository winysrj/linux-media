Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:57040 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752612AbeBEJax (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 04:30:53 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] media.h: fix confusing typo in comment
Message-ID: <f4812344-1b4e-9c8b-4345-cf45c9a31e0f@xs4all.nl>
Date: Mon, 5 Feb 2018 10:30:48 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Subdevs are initialized with MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN, not
MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index b9b9446095e9..573da38a21c3 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -131,7 +131,7 @@ struct media_device_info {
  * with the legacy v1 API.The number range is out of range by purpose:
  * several previously reserved numbers got excluded from this range.
  *
- * Subdevs are initialized with MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN,
+ * Subdevs are initialized with MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN,
  * in order to preserve backward compatibility.
  * Drivers must change to the proper subdev type before
  * registering the entity.
