Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:34568 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbbLXULU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Dec 2015 15:11:20 -0500
Received: by mail-qg0-f47.google.com with SMTP id 6so24558033qgy.1
        for <linux-media@vger.kernel.org>; Thu, 24 Dec 2015 12:11:19 -0800 (PST)
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH] stk1160: Remove redundant vb2_buf payload set
Date: Thu, 24 Dec 2015 17:06:45 -0300
Message-Id: <1450987605-3864-1-git-send-email-ezequiel@vanguardiasur.com.ar>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Calling vb2_set_plane_payload is enough, there's no need to
set the planes[] bytesused field. Remove it.

Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
---
 drivers/media/usb/stk1160/stk1160-video.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/stk1160/stk1160-video.c b/drivers/media/usb/stk1160/stk1160-video.c
index 46191d5262eb..6ecb0b48423f 100644
--- a/drivers/media/usb/stk1160/stk1160-video.c
+++ b/drivers/media/usb/stk1160/stk1160-video.c
@@ -98,7 +98,6 @@ void stk1160_buffer_done(struct stk1160 *dev)
 
 	buf->vb.sequence = dev->sequence++;
 	buf->vb.field = V4L2_FIELD_INTERLACED;
-	buf->vb.vb2_buf.planes[0].bytesused = buf->bytesused;
 	buf->vb.vb2_buf.timestamp = ktime_get_ns();
 
 	vb2_set_plane_payload(&buf->vb.vb2_buf, 0, buf->bytesused);
-- 
2.6.4

