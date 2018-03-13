Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:59262 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751996AbeCMSeT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 14:34:19 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] pixfmt-v4l2.rst: fix broken enum :c:type:
Message-ID: <7f33d0c1-a087-c2a8-3453-1f2cf65e1d39@xs4all.nl>
Date: Tue, 13 Mar 2018 11:34:12 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

:c:type:: -> :c:type:

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/uapi/v4l/pixfmt-v4l2.rst b/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
index 2ee164c25637..6622938c1b41 100644
--- a/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
@@ -40,7 +40,7 @@ Single-planar format structure
 	RGB formats in :ref:`rgb-formats`, YUV formats in
 	:ref:`yuv-formats`, and reserved codes in
 	:ref:`reserved-formats`
-    * - enum :c:type::`v4l2_field`
+    * - enum :c:type:`v4l2_field`
       - ``field``
       - Video images are typically interlaced. Applications can request to
 	capture or output only the top or bottom field, or both fields
