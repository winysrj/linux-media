Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36246 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbbFZJoZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2015 05:44:25 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <kamil@wypas.org>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 2/3] [media] v4l2-mem2mem: set the queue owner field just as vb2_ioctl_reqbufs does
Date: Fri, 26 Jun 2015 11:44:05 +0200
Message-Id: <1435311846-23417-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1435311846-23417-1-git-send-email-p.zabel@pengutronix.de>
References: <1435311846-23417-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The queue owner will be used by videobuf2 trace events to determine and
record the device minor number. It is set in v4l2_m2m_reqbufs instead of
v4l2_m2m_ioctl_reqbufs because several drivers implement their own
vidioc_reqbufs handlers that still call v4l2_m2m_reqbufs directly.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index dc853e5..af8d6b4 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -357,9 +357,16 @@ int v4l2_m2m_reqbufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		     struct v4l2_requestbuffers *reqbufs)
 {
 	struct vb2_queue *vq;
+	int ret;
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, reqbufs->type);
-	return vb2_reqbufs(vq, reqbufs);
+	ret = vb2_reqbufs(vq, reqbufs);
+	/* If count == 0, then the owner has released all buffers and he
+	   is no longer owner of the queue. Otherwise we have an owner. */
+	if (ret == 0)
+		vq->owner = reqbufs->count ? file->private_data : NULL;
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_reqbufs);
 
-- 
2.1.4

