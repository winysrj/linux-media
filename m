Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34061 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752167AbeBECYr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 4 Feb 2018 21:24:47 -0500
Received: by mail-pg0-f66.google.com with SMTP id s73so2913898pgc.1
        for <linux-media@vger.kernel.org>; Sun, 04 Feb 2018 18:24:47 -0800 (PST)
From: Alexandre Courbot <acourbot@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [PATCH] v4l: vidioc-prepare-buf.rst: fix link to VIDIOC_QBUF
Date: Mon,  5 Feb 2018 11:24:43 +0900
Message-Id: <20180205022443.154105-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The description for VIDIOC_PREPARE_BUF results in the following
sentence: "...before actually enqueuing it, using the ioctl VIDIOC_QBUF,
VIDIOC_DQBUF ioctl...".

The intent is to only refer to VIDIOC_QBUF though, so fix this.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 Documentation/media/uapi/v4l/vidioc-prepare-buf.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst b/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
index 70687a86ae38..49f9f4c181de 100644
--- a/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
@@ -34,7 +34,7 @@ Description
 
 Applications can optionally call the :ref:`VIDIOC_PREPARE_BUF` ioctl to
 pass ownership of the buffer to the driver before actually enqueuing it,
-using the :ref:`VIDIOC_QBUF` ioctl, and to prepare it for future I/O. Such
+using the :ref:`VIDIOC_QBUF <VIDIOC_QBUF>` ioctl, and to prepare it for future I/O. Such
 preparations may include cache invalidation or cleaning. Performing them
 in advance saves time during the actual I/O. In case such cache
 operations are not required, the application can use one of
-- 
2.16.0.rc1.238.g530d649a79-goog
