Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:39533 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934333AbdC3QCh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 12:02:37 -0400
From: Helen Koike <helen.koike@collabora.com>
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org, jgebben@codeaurora.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 2/2] [media] docs-rst: add V4L2_INPUT_TYPE_DEFAULT
Date: Thu, 30 Mar 2017 13:02:18 -0300
Message-Id: <1490889738-30009-2-git-send-email-helen.koike@collabora.com>
In-Reply-To: <1490889738-30009-1-git-send-email-helen.koike@collabora.com>
References: <1490889738-30009-1-git-send-email-helen.koike@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

add documentation for V4L2_INPUT_TYPE_DEFAULT

Signed-off-by: Helen Koike <helen.koike@collabora.com>
---
 Documentation/media/uapi/v4l/vidioc-enuminput.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/media/uapi/v4l/vidioc-enuminput.rst b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
index 17aaaf9..0237e10 100644
--- a/Documentation/media/uapi/v4l/vidioc-enuminput.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
@@ -112,6 +112,9 @@ at index zero, incrementing by one until the driver returns ``EINVAL``.
     :stub-columns: 0
     :widths:       3 1 4
 
+    * - ``V4L2_INPUT_TYPE_DEFAULT``
+      - 0
+      - This is the default value returned when no input is supported.
     * - ``V4L2_INPUT_TYPE_TUNER``
       - 1
       - This input uses a tuner (RF demodulator).
-- 
2.7.4
