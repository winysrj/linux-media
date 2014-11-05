Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:52748 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753457AbaKEISD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Nov 2014 03:18:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/8] stk1160: fix sparse warning
Date: Wed,  5 Nov 2014 09:17:49 +0100
Message-Id: <1415175472-24203-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1415175472-24203-1-git-send-email-hverkuil@xs4all.nl>
References: <1415175472-24203-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

stk1160-v4l.c:478:49: warning: incorrect type in argument 3 (different base types)

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/stk1160/stk1160-v4l.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index 2330543..a476291 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -475,7 +475,7 @@ static int vidioc_s_register(struct file *file, void *priv,
 	struct stk1160 *dev = video_drvdata(file);
 
 	/* Match host */
-	return stk1160_write_reg(dev, reg->reg, cpu_to_le16(reg->val));
+	return stk1160_write_reg(dev, reg->reg, reg->val);
 }
 #endif
 
-- 
2.1.1

