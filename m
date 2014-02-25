Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3540 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbaBYMxX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 07:53:23 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 13/15] vb2: replace BUG by WARN_ON
Date: Tue, 25 Feb 2014 13:52:53 +0100
Message-Id: <1393332775-44067-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393332775-44067-1-git-send-email-hverkuil@xs4all.nl>
References: <1393332775-44067-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

No need to oops for this, WARN_ON is good enough.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 3815f9c..68f3def 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2536,9 +2536,9 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
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
1.9.0

