Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39661 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab1DCXjK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Apr 2011 19:39:10 -0400
Received: by mail-iw0-f174.google.com with SMTP id 34so5252053iwn.19
        for <linux-media@vger.kernel.org>; Sun, 03 Apr 2011 16:39:09 -0700 (PDT)
From: Pawel Osciak <pawel@osciak.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, Pawel Osciak <pawel@osciak.com>
Subject: [PATCH 3/3] [media] vb2: prevent drivers from requesting too many buffers/planes.
Date: Sun,  3 Apr 2011 16:38:57 -0700
Message-Id: <1301873937-14146-3-git-send-email-pawel@osciak.com>
In-Reply-To: <1301873937-14146-1-git-send-email-pawel@osciak.com>
References: <1301873937-14146-1-git-send-email-pawel@osciak.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add a sanity check to make sure drivers do not adjust the number of buffers
or planes above the supported limit on reqbufs.

Signed-off-by: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/videobuf2-core.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 6698c77..6e69584 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -529,6 +529,11 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 	if (ret)
 		return ret;
 
+	/*
+	 * Make sure driver did not request more buffers/planes than we can handle.
+	 */
+	BUG_ON (num_buffers > VIDEO_MAX_FRAME || num_planes > VIDEO_MAX_PLANES);
+
 	/* Finally, allocate buffers and video memory */
 	ret = __vb2_queue_alloc(q, req->memory, num_buffers, num_planes,
 				plane_sizes);
-- 
1.7.4.2

