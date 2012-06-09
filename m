Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61710 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab2FIN4L (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jun 2012 09:56:11 -0400
Received: by mail-yw0-f46.google.com with SMTP id m54so1838146yhm.19
        for <linux-media@vger.kernel.org>; Sat, 09 Jun 2012 06:56:11 -0700 (PDT)
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mike Isely <isely@pobox.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 3/4] pvrusb2: Variable set but not used
Date: Sat,  9 Jun 2012 10:53:58 -0300
Message-Id: <1339250039-30000-3-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1339250039-30000-1-git-send-email-peter.senna@gmail.com>
References: <1339250039-30000-1-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In function pvr2_try_ext_ctrls variable ret was set but not used. Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
index aa0cf25..fc9c2ac 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
@@ -701,11 +701,9 @@ static int pvr2_try_ext_ctrls(struct file *file, void *priv,
 	struct v4l2_ext_control *ctrl;
 	struct pvr2_ctrl *pctl;
 	unsigned int idx;
-	int ret;
 
 	/* For the moment just validate that the requested control
 	   actually exists. */
-	ret = 0;
 	for (idx = 0; idx < ctls->count; idx++) {
 		ctrl = ctls->controls + idx;
 		pctl = pvr2_hdw_get_ctrl_v4l(hdw, ctrl->id);
-- 
1.7.10.2

