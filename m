Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:55834 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730515AbeG0MWg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 08:22:36 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] media.h.rst.exceptions: fix MEDIA_ENT_F_DTV_DECODER warning
Message-ID: <6d447eec-a320-7040-fbba-526adbe37bd0@xs4all.nl>
Date: Fri, 27 Jul 2018 13:01:10 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix this warning for this legacy define:

media.h.rst:6: WARNING: undefined label: media-ent-f-dtv-decoder (if the link has no caption the label must precede a section header)

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/media.h.rst.exceptions b/Documentation/media/media.h.rst.exceptions
index 83d7f7c722fb..2dfab155c8e8 100644
--- a/Documentation/media/media.h.rst.exceptions
+++ b/Documentation/media/media.h.rst.exceptions
@@ -28,3 +28,4 @@ ignore define MEDIA_ENT_T_V4L2_SUBDEV_FLASH
 ignore define MEDIA_ENT_T_V4L2_SUBDEV_LENS
 ignore define MEDIA_ENT_T_V4L2_SUBDEV_DECODER
 ignore define MEDIA_ENT_T_V4L2_SUBDEV_TUNER
+ignore define MEDIA_ENT_F_DTV_DECODER
