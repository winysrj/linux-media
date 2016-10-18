Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:45364 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755114AbcJRNRf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 09:17:35 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Subject: [PATCH v2 1/1] v4l: Document that m2m devices have a file handle specific context
Date: Tue, 18 Oct 2016 16:15:32 +0300
Message-Id: <1476796532-23010-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1476794913-22870-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1476794913-22870-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Memory-to-memory V4L2 devices all have file handle specific context.
Say this in the API documentation so that the user space may rely on it
being the case.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
since v1:

- Added a note to struct v4l2_m2m_queue_ctx documentation as well.

 Documentation/media/uapi/v4l/dev-codec.rst | 2 +-
 include/media/v4l2-mem2mem.h               | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

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
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index 1b35534..3ccd01b 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -90,6 +90,9 @@ struct v4l2_m2m_queue_ctx {
  *		%TRANS_QUEUED, %TRANS_RUNNING and %TRANS_ABORT.
  * @finished: Wait queue used to signalize when a job queue finished.
  * @priv: Instance private data
+ *
+ * The memory to memory context is specific to a file handle, NOT to e.g.
+ * a device.
  */
 struct v4l2_m2m_ctx {
 	/* optional cap/out vb2 queues lock */
-- 
2.7.4

