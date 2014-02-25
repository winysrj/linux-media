Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1593 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbaBYKQR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 05:16:17 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 04/13] vivi: fix ENUM_FRAMEINTERVALS implementation
Date: Tue, 25 Feb 2014 11:15:54 +0100
Message-Id: <1393323363-30058-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393323363-30058-1-git-send-email-hverkuil@xs4all.nl>
References: <1393323363-30058-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This function never checked if width and height are correct. Add such
a check so the v4l2-compliance tool returns OK again for vivi.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
index f4ac1f9..0cc2a20 100644
--- a/drivers/media/platform/vivi.c
+++ b/drivers/media/platform/vivi.c
@@ -1120,7 +1120,11 @@ static int vidioc_enum_frameintervals(struct file *file, void *priv,
 	if (!fmt)
 		return -EINVAL;
 
-	/* regarding width & height - we support any */
+	/* check for valid width/height */
+	if (fival->width < 48 || fival->width > MAX_WIDTH || (fival->width & 3))
+		return -EINVAL;
+	if (fival->height < 32 || fival->height > MAX_HEIGHT)
+		return -EINVAL;
 
 	fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
 
-- 
1.9.0

