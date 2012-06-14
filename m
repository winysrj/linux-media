Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:47276 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423Ab2FNR7q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 13:59:46 -0400
Received: by mail-gg0-f174.google.com with SMTP id u4so1627280ggl.19
        for <linux-media@vger.kernel.org>; Thu, 14 Jun 2012 10:59:46 -0700 (PDT)
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Michael Hunold <michael@mihu.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 3/8] [RESEND] saa7146: Variable set but not used
Date: Thu, 14 Jun 2012 14:58:11 -0300
Message-Id: <1339696716-14373-3-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1339696716-14373-1-git-send-email-peter.senna@gmail.com>
References: <1339696716-14373-1-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In function fops_open variable type was set but not used.

Tested by compilation only.

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

