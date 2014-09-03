Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44320 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036AbaICUd3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:29 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	davinci-linux-open-source@linux.davincidsp.com
Subject: [PATCH 39/46] [media] davinci: just return 0 instead of using a var
Date: Wed,  3 Sep 2014 17:33:11 -0300
Message-Id: <7784c0dade5a08d844babfe22eeb614b3327ae1b.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of allocating a var to store 0 and just return it,
change the code to return 0 directly.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index ed9dd27e3c63..c557eb5ebf6b 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -943,12 +943,11 @@ static int vpfe_g_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *fmt)
 {
 	struct vpfe_device *vpfe_dev = video_drvdata(file);
-	int ret = 0;
 
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_g_fmt_vid_cap\n");
 	/* Fill in the information about format */
 	*fmt = vpfe_dev->fmt;
-	return ret;
+	return 0;
 }
 
 static int vpfe_enum_fmt_vid_cap(struct file *file, void  *priv,
-- 
1.9.3

