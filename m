Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35260 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932441AbcELMPI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2016 08:15:08 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, hverkuil@xs4all.nl, david@unsolicited.net,
	linux-kernel@vger.kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v2 1/2] vb2: core: Skip planes array verification if pb is NULL
Date: Thu, 12 May 2016 15:14:51 +0300
Message-Id: <1463055292-25053-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1463055292-25053-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1463055292-25053-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

An earlier patch fixing an input validation issue introduced another
issue: vb2_core_dqbuf() is called with pb argument value NULL in some
cases, causing a NULL pointer dereference. Fix this by skipping the
verification as there's nothing to verify.

Signed-off-by: David R <david@unsolicited.net>

Use if () instead of ? :; it's nicer that way. Improve the comment in the
code as well.

Fixes: e7e0c3e26587 ("[media] videobuf2-core: Check user space planes array in dqbuf")

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: stable@vger.kernel.org # for v4.4 and later
---
 drivers/media/v4l2-core/videobuf2-core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 9fbcb67..633fc1a 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1648,7 +1648,7 @@ static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_buffer **vb,
 			     void *pb, int nonblocking)
 {
 	unsigned long flags;
-	int ret;
+	int ret = 0;
 
 	/*
 	 * Wait for at least one buffer to become available on the done_list.
@@ -1664,10 +1664,12 @@ static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_buffer **vb,
 	spin_lock_irqsave(&q->done_lock, flags);
 	*vb = list_first_entry(&q->done_list, struct vb2_buffer, done_entry);
 	/*
-	 * Only remove the buffer from done_list if v4l2_buffer can handle all
-	 * the planes.
+	 * Only remove the buffer from done_list if all planes can be
+	 * handled. Some cases such as V4L2 file I/O and DVB have pb
+	 * == NULL; skip the check then as there's nothing to verify.
 	 */
-	ret = call_bufop(q, verify_planes_array, *vb, pb);
+	if (pb)
+		ret = call_bufop(q, verify_planes_array, *vb, pb);
 	if (!ret)
 		list_del(&(*vb)->done_entry);
 	spin_unlock_irqrestore(&q->done_lock, flags);
-- 
2.1.4

