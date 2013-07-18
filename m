Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([94.23.35.102]:56951 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758179Ab3GRNBZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jul 2013 09:01:25 -0400
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: <linux-media@vger.kernel.org>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
	Sergey 'Jin' Bostandzhyan <jin@mediatomb.cc>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] media: stk1160: Ignore unchanged standard set
Date: Thu, 18 Jul 2013 10:01:23 -0300
Message-Id: <1374152483-3106-1-git-send-email-ezequiel.garcia@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This commit adds an early check to vidioc_s_std() to detect if the
new and current standards are equal, and exit with success in that
case.

This is needed to prevent userspace applications that might attempt
to re-set the same standard from failing if that's done when streaming
has started.

Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
---
Cc: Sergey 'Jin' Bostandzhyan <jin@mediatomb.cc>
Cc: Hans Verkuil <hans.verkuil@cisco.com>

 drivers/media/usb/stk1160/stk1160-v4l.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index ee46d82..c45c988 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -379,6 +379,9 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
 	struct stk1160 *dev = video_drvdata(file);
 	struct vb2_queue *q = &dev->vb_vidq;
 
+	if (dev->norm == norm)
+		return 0;
+
 	if (vb2_is_busy(q))
 		return -EBUSY;
 
-- 
1.8.1.5

