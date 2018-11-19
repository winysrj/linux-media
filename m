Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:38992 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729669AbeKTB5m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Nov 2018 20:57:42 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Ezequiel Garcia <ezequiel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] videobuf2-v4l2: drop WARN_ON in vb2_warn_zero_bytesused()
Message-ID: <b3fae3d4-2370-d99a-b997-d6ae13cebe85@xs4all.nl>
Date: Mon, 19 Nov 2018 16:33:44 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Userspace shouldn't set bytesused to 0 for output buffers.
vb2_warn_zero_bytesused() warns about this (only once!), but it also
calls WARN_ON(1), which is confusing since it is not immediately clear
that it warns about a 0 value for bytesused.

Just drop the WARN_ON as it serves no purpose.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index a17033ab2c22..713326ef4e72 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -158,7 +158,6 @@ static void vb2_warn_zero_bytesused(struct vb2_buffer *vb)
 		return;

 	check_once = true;
-	WARN_ON(1);

 	pr_warn("use of bytesused == 0 is deprecated and will be removed in the future,\n");
 	if (vb->vb2_queue->allow_zero_bytesused)
