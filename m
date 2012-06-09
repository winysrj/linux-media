Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54407 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab2FIOOk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jun 2012 10:14:40 -0400
Received: by yenm10 with SMTP id m10so1830431yen.19
        for <linux-media@vger.kernel.org>; Sat, 09 Jun 2012 07:14:39 -0700 (PDT)
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Michael Hunold <michael@mihu.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH] saa7146: Variable set but not used
Date: Sat,  9 Jun 2012 11:13:58 -0300
Message-Id: <1339251238-4388-1-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In function fops_open variable type was set but not used. Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/media/common/saa7146_fops.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/media/common/saa7146_fops.c b/drivers/media/common/saa7146_fops.c
index 7d42c11..0cdbd74 100644
--- a/drivers/media/common/saa7146_fops.c
+++ b/drivers/media/common/saa7146_fops.c
@@ -198,7 +198,6 @@ static int fops_open(struct file *file)
 	struct saa7146_dev *dev = video_drvdata(file);
 	struct saa7146_fh *fh = NULL;
 	int result = 0;
-	enum v4l2_buf_type type;
 
 	DEB_EE("file:%p, dev:%s\n", file, video_device_node_name(vdev));
 
@@ -207,10 +206,6 @@ static int fops_open(struct file *file)
 
 	DEB_D("using: %p\n", dev);
 
-	type = vdev->vfl_type == VFL_TYPE_GRABBER
-	     ? V4L2_BUF_TYPE_VIDEO_CAPTURE
-	     : V4L2_BUF_TYPE_VBI_CAPTURE;
-
 	/* check if an extension is registered */
 	if( NULL == dev->ext ) {
 		DEB_S("no extension registered for this device\n");
-- 
1.7.10.2

