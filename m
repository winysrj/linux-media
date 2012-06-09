Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61710 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab2FIN4J (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jun 2012 09:56:09 -0400
Received: by yhmm54 with SMTP id m54so1838146yhm.19
        for <linux-media@vger.kernel.org>; Sat, 09 Jun 2012 06:56:09 -0700 (PDT)
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mike Isely <isely@pobox.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 2/4] pvrusb2: Variable set but not used
Date: Sat,  9 Jun 2012 10:53:57 -0300
Message-Id: <1339250039-30000-2-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1339250039-30000-1-git-send-email-peter.senna@gmail.com>
References: <1339250039-30000-1-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In function pvr2_queryctrl variable ret was set but not used. Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
index f1e0421..aa0cf25 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
@@ -554,9 +554,7 @@ static int pvr2_queryctrl(struct file *file, void *priv,
 	struct pvr2_hdw *hdw = fh->channel.mc_head->hdw;
 	struct pvr2_ctrl *cptr;
 	int val;
-	int ret;
 
-	ret = 0;
 	if (vc->id & V4L2_CTRL_FLAG_NEXT_CTRL) {
 		cptr = pvr2_hdw_get_ctrl_nextv4l(
 				hdw, (vc->id & ~V4L2_CTRL_FLAG_NEXT_CTRL));
-- 
1.7.10.2

