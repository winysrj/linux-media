Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:54369 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728231AbeIQRES (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 13:04:18 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vidioc-dqevent.rst: clarify V4L2_EVENT_SRC_CH_RESOLUTION
Message-ID: <c93de92e-443f-9597-268f-d68294b2f42d@xs4all.nl>
Date: Mon, 17 Sep 2018 13:37:18 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clarify that when you receive V4L2_EVENT_SOURCE_CHANGE with flag
V4L2_EVENT_SRC_CH_RESOLUTION set, and the new resolution appears
identical to the old resolution, then you still must restart the
streaming I/O.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/uapi/v4l/vidioc-dqevent.rst b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
index cb3565f36793..04416b6943c0 100644
--- a/Documentation/media/uapi/v4l/vidioc-dqevent.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
@@ -379,7 +379,17 @@ call.
       - 0x0001
       - This event gets triggered when a resolution change is detected at
 	an input. This can come from an input connector or from a video
-	decoder.
+	decoder. Applications will have to query the new resolution (if
+	any, the signal may also have been lost).
+
+	*Important*: even if the new video timings appear identical to the old
+	ones, receiving this event indicates that there was an issue with the
+	video signal and you must stop and restart streaming
+	(:ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>`
+	followed by :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>`). The reason is
+	that many devices are not able to recover from a temporary loss of
+	signal and so restarting streaming I/O is required in order for the
+	hardware to synchronize to the video signal.


 Return Value
