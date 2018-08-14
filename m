Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:51334 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727701AbeHNKiT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 06:38:19 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec-func-poll.rst/func-poll.rst: update EINVAL description
Message-ID: <a0f13617-7c7b-6155-d384-78f0c204d512@xs4all.nl>
Date: Tue, 14 Aug 2018 09:52:17 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

nfds depends on RLIMIT_NOFILE, not OPEN_MAX. Update the description
for cec and v4l2.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/uapi/cec/cec-func-poll.rst b/Documentation/media/uapi/cec/cec-func-poll.rst
index d49f1ee0742d..c698c969635c 100644
--- a/Documentation/media/uapi/cec/cec-func-poll.rst
+++ b/Documentation/media/uapi/cec/cec-func-poll.rst
@@ -74,4 +74,5 @@ is returned, and the ``errno`` variable is set appropriately:
     The call was interrupted by a signal.

 ``EINVAL``
-    The ``nfds`` argument is greater than ``OPEN_MAX``.
+    The ``nfds`` value exceeds the ``RLIMIT_NOFILE`` value. Use
+    ``getrlimit()`` to obtain this value.
diff --git a/Documentation/media/uapi/v4l/func-poll.rst b/Documentation/media/uapi/v4l/func-poll.rst
index 360bc6523ae2..967fe8920729 100644
--- a/Documentation/media/uapi/v4l/func-poll.rst
+++ b/Documentation/media/uapi/v4l/func-poll.rst
@@ -113,4 +113,5 @@ EINTR
     The call was interrupted by a signal.

 EINVAL
-    The ``nfds`` argument is greater than ``OPEN_MAX``.
+    The ``nfds`` value exceeds the ``RLIMIT_NOFILE`` value. Use
+    ``getrlimit()`` to obtain this value.
