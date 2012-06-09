Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34970 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab2FIN4H (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jun 2012 09:56:07 -0400
Received: by yenm10 with SMTP id m10so1824963yen.19
        for <linux-media@vger.kernel.org>; Sat, 09 Jun 2012 06:56:06 -0700 (PDT)
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mike Isely <isely@pobox.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 1/4] pvrusb2: Variable set but not used
Date: Sat,  9 Jun 2012 10:53:56 -0300
Message-Id: <1339250039-30000-1-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In function pvr2_enum_input variable ret was set but not used. Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
index 7bddfae..f1e0421 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
@@ -226,13 +226,11 @@ static int pvr2_enum_input(struct file *file, void *priv, struct v4l2_input *vi)
 	struct v4l2_input tmp;
 	unsigned int cnt;
 	int val;
-	int ret;
 
 	cptr = pvr2_hdw_get_ctrl_by_id(hdw, PVR2_CID_INPUT);
 
 	memset(&tmp, 0, sizeof(tmp));
 	tmp.index = vi->index;
-	ret = 0;
 	if (vi->index >= fh->input_cnt)
 		return -EINVAL;
 	val = fh->input_map[vi->index];
-- 
1.7.10.2

