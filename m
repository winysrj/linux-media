Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:40851 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1759860AbcLPJXg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 04:23:36 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] gen-errors.rst: document EIO
Message-ID: <3c05072b-f3ee-4018-d5a8-d341e66fedfe@xs4all.nl>
Date: Fri, 16 Dec 2016 10:22:08 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the EIO error since this can happen anywhere anytime and applications
should be aware of this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/uapi/gen-errors.rst b/Documentation/media/uapi/gen-errors.rst
index 6e983b9..ee224b9 100644
--- a/Documentation/media/uapi/gen-errors.rst
+++ b/Documentation/media/uapi/gen-errors.rst
@@ -94,6 +94,14 @@ Generic Error Codes
         -  Permission denied. Can be returned if the device needs write
  	  permission, or some special capabilities is needed (e. g. root)

+    -  .. row 11
+
+       -  ``EIO``
+
+       -  I/O error. Typically used when there are problems communicating with
+          a hardware device. This could indicate broken or flaky hardware.
+	  It's a 'Something is wrong, I give up!' type of error.
+
  .. note::

    #. This list is not exaustive; ioctls may return other error codes.
