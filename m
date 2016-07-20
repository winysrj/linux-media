Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:44731 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752409AbcGTMjr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 08:39:47 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id E163C180496
	for <linux-media@vger.kernel.org>; Wed, 20 Jul 2016 14:39:42 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] media: doc-rst: document ENODATA for cropping ioctls
Message-ID: <cbe431c5-4a01-1af5-6ba3-cf3f5d6a725d@xs4all.nl>
Date: Wed, 20 Jul 2016 14:39:42 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document that the cropping ioctls can return ENODATA if the operation isn't supported
for the current input or output.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/uapi/v4l/vidioc-cropcap.rst b/Documentation/media/uapi/v4l/vidioc-cropcap.rst
index 8dcbe6d..54382cd 100644
--- a/Documentation/media/uapi/v4l/vidioc-cropcap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-cropcap.rst
@@ -165,3 +165,6 @@ appropriately. The generic error codes are described at the
 EINVAL
     The struct :ref:`v4l2_cropcap <v4l2-cropcap>` ``type`` is
     invalid.
+
+ENODATA
+    Cropping is not supported for this input or output.
diff --git a/Documentation/media/uapi/v4l/vidioc-g-crop.rst b/Documentation/media/uapi/v4l/vidioc-g-crop.rst
index 6cf7649..075e87a 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-crop.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-crop.rst
@@ -111,3 +111,6 @@ Return Value
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
+
+ENODATA
+    Cropping is not supported for this input or output.
diff --git a/Documentation/media/uapi/v4l/vidioc-g-selection.rst b/Documentation/media/uapi/v4l/vidioc-g-selection.rst
index 953931f..3f38a83 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-selection.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-selection.rst
@@ -204,6 +204,9 @@ ERANGE
     ``r`` rectangle to satisfy all constraints given in the ``flags``
     argument.

+ENODATA
+    Selection is not supported for this input or output.
+
 EBUSY
     It is not possible to apply change of the selection rectangle at the
     moment. Usually because streaming is in progress.
