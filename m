Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1252 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbaB1Rmw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Feb 2014 12:42:52 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv3 PATCH 13/17] vb2: replace BUG by WARN_ON
Date: Fri, 28 Feb 2014 18:42:11 +0100
Message-Id: <1393609335-12081-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393609335-12081-1-git-send-email-hverkuil@xs4all.nl>
References: <1393609335-12081-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

No need to oops for this, WARN_ON is good enough.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index d37a07f..ae7a7c1 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2535,9 +2535,9 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	/*
 	 * Sanity check
 	 */
-	if ((read && !(q->io_modes & VB2_READ)) ||
-	   (!read && !(q->io_modes & VB2_WRITE)))
-		BUG();
+	if (WARN_ON((read && !(q->io_modes & VB2_READ)) ||
+		    (!read && !(q->io_modes & VB2_WRITE))))
+		return -EINVAL;
 
 	/*
 	 * Check if device supports mapping buffers to kernel virtual space.
-- 
1.9.rc1

