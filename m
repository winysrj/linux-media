Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbaHaKTf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Aug 2014 06:19:35 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Nicolas Dufresne <nicolas.dufresne@collabora.co.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] videobuf: Allow reqbufs(0) to free current buffers
Date: Sun, 31 Aug 2014 12:19:21 +0200
Message-Id: <1409480361-12821-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All the infrastructure for this is already there, and despite our desires for
the old videobuf code to go away, it is currently still in use in 18 drivers.

Allowing reqbufs(0) makes these drivers behave consistent with modern drivers,
making live easier for userspace, see e.g. :
https://bugzilla.gnome.org/show_bug.cgi?id=735660

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/v4l2-core/videobuf-core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf-core.c b/drivers/media/v4l2-core/videobuf-core.c
index fb5ee5d..b91a266 100644
--- a/drivers/media/v4l2-core/videobuf-core.c
+++ b/drivers/media/v4l2-core/videobuf-core.c
@@ -441,11 +441,6 @@ int videobuf_reqbufs(struct videobuf_queue *q,
 	unsigned int size, count;
 	int retval;
 
-	if (req->count < 1) {
-		dprintk(1, "reqbufs: count invalid (%d)\n", req->count);
-		return -EINVAL;
-	}
-
 	if (req->memory != V4L2_MEMORY_MMAP     &&
 	    req->memory != V4L2_MEMORY_USERPTR  &&
 	    req->memory != V4L2_MEMORY_OVERLAY) {
@@ -471,6 +466,12 @@ int videobuf_reqbufs(struct videobuf_queue *q,
 		goto done;
 	}
 
+	if (req->count == 0) {
+		dprintk(1, "reqbufs: count invalid (%d)\n", req->count);
+		retval = __videobuf_free(q);
+		goto done;
+	}
+
 	count = req->count;
 	if (count > VIDEO_MAX_FRAME)
 		count = VIDEO_MAX_FRAME;
-- 
2.1.0

