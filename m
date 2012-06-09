Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:62500 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab2FIN4O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jun 2012 09:56:14 -0400
Received: by ghrr11 with SMTP id r11so1811765ghr.19
        for <linux-media@vger.kernel.org>; Sat, 09 Jun 2012 06:56:13 -0700 (PDT)
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mike Isely <isely@pobox.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 4/4] pvrusb2: Variable set but not used
Date: Sat,  9 Jun 2012 10:53:59 -0300
Message-Id: <1339250039-30000-4-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1339250039-30000-1-git-send-email-peter.senna@gmail.com>
References: <1339250039-30000-1-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In function pvr2_s_crop variable cap was set but not used. Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
index fc9c2ac..cbe4080 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
@@ -764,12 +764,10 @@ static int pvr2_s_crop(struct file *file, void *priv, struct v4l2_crop *crop)
 {
 	struct pvr2_v4l2_fh *fh = file->private_data;
 	struct pvr2_hdw *hdw = fh->channel.mc_head->hdw;
-	struct v4l2_cropcap cap;
 	int ret;
 
 	if (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
-	cap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	ret = pvr2_ctrl_set_value(
 			pvr2_hdw_get_ctrl_by_id(hdw, PVR2_CID_CROPL),
 			crop->c.left);
-- 
1.7.10.2

