Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37214 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097AbbG1HzV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2015 03:55:21 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kamil Debski <kamil@wypas.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] v4l2: export videobuf2 trace points
Date: Tue, 28 Jul 2015 09:55:04 +0200
Message-Id: <1438070104-24084-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If videobuf2-core is built as a module, the vb2 trace points must be
exported from videodev.o to avoid errors when linking videobuf2-core.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 85de455..e8b78ae 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2784,3 +2784,8 @@ long video_ioctl2(struct file *file,
 	return video_usercopy(file, cmd, arg, __video_do_ioctl);
 }
 EXPORT_SYMBOL(video_ioctl2);
+
+EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_buf_done);
+EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_buf_queue);
+EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_dqbuf);
+EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_qbuf);
-- 
2.4.6

