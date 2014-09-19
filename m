Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41183 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723AbaISQC1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Sep 2014 12:02:27 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/2] em28xx: fix VBI handling logic
Date: Fri, 19 Sep 2014 13:02:12 -0300
Message-Id: <8444ab3f16a454ab8d2eaefb8990193313c2ac33.1411142521.git.mchehab@osg.samsung.com>
In-Reply-To: <c3e1b2c823189385494c01a7c776700f0e8d5913.1411142521.git.mchehab@osg.samsung.com>
References: <c3e1b2c823189385494c01a7c776700f0e8d5913.1411142521.git.mchehab@osg.samsung.com>
In-Reply-To: <c3e1b2c823189385494c01a7c776700f0e8d5913.1411142521.git.mchehab@osg.samsung.com>
References: <c3e1b2c823189385494c01a7c776700f0e8d5913.1411142521.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When both VBI and video are streaming, and video stream is stopped,
a subsequent trial to restart it will fail, because S_FMT will
return -EBUSY.

That prevents applications like zvbi to work properly.

Please notice that, while this fix it fully for zvbi, the
best is to get rid of streaming_users and res_get logic as a hole.

However, this single-line patch is better to be merged at -stable.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 08569cbccd95..d75e7f82dfb9 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1351,7 +1351,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	struct em28xx *dev = video_drvdata(file);
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 
-	if (v4l2->streaming_users > 0)
+	if (vb2_is_busy(&v4l2->vb_vidq))
 		return -EBUSY;
 
 	vidioc_try_fmt_vid_cap(file, priv, f);
-- 
1.9.3

