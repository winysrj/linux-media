Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4503 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbaBYJss (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 04:48:48 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv1 PATCH 01/14] vb2: Check if there are buffers before streamon
Date: Tue, 25 Feb 2014 10:48:14 +0100
Message-Id: <1393321707-9749-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393321707-9749-1-git-send-email-hverkuil@xs4all.nl>
References: <1393321707-9749-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

This patch adds a test preventing streamon() if there is no buffer
ready.

Without this patch, a user could call streamon() before
preparing any buffer. This leads to a situation where if he calls
close() before calling streamoff() the device is kept streaming.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 5a5fb7f..a127925 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1776,6 +1776,11 @@ static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 		return 0;
 	}
 
+	if (!q->num_buffers) {
+		dprintk(1, "streamon: no buffers have been allocated\n");
+		return -EINVAL;
+	}
+
 	/*
 	 * If any buffers were queued before streamon,
 	 * we can now pass them to driver for processing.
-- 
1.9.0

