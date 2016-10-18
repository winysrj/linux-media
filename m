Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45406 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755282AbcJRMwF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 08:52:05 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Subject: [PATCH 1/1] v4l: Document that m2m devices have a file handle specific context
Date: Tue, 18 Oct 2016 15:48:33 +0300
Message-Id: <1476794913-22870-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Memory-to-memory V4L2 devices all have file handle specific context.
Say this in the API documentation so that the user space may rely on it
being the case.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/media/uapi/v4l/dev-codec.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/v4l/dev-codec.rst b/Documentation/media/uapi/v4l/dev-codec.rst
index d9f2184..c61e938 100644
--- a/Documentation/media/uapi/v4l/dev-codec.rst
+++ b/Documentation/media/uapi/v4l/dev-codec.rst
@@ -26,7 +26,7 @@ parameters
    The MPEG controls actually support many more codecs than
    just MPEG. See :ref:`mpeg-controls`.
 
-Memory-to-memory devices can often be used as a shared resource: you can
+Memory-to-memory devices function as a shared resource: you can
 open the video node multiple times, each application setting up their
 own codec properties that are local to the file handle, and each can use
 it independently from the others. The driver will arbitrate access to
-- 
2.7.4

