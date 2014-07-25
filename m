Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:62828 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935088AbaGYRsL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 13:48:11 -0400
Received: by mail-we0-f182.google.com with SMTP id k48so4673828wev.27
        for <linux-media@vger.kernel.org>; Fri, 25 Jul 2014 10:48:09 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 3/4] em28xx-v4l: simplify em28xx_v4l2_open() by using v4l2_fh_open()
Date: Fri, 25 Jul 2014 19:48:57 +0200
Message-Id: <1406310538-5001-4-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1406310538-5001-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1406310538-5001-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of calling

...
struct v4l2_fh *fh = kzalloc(sizeof(*fh), GFP_KERNEL);
filp->private_data = fh;
v4l2_fh_init(fh, vdev);
v4l2_fh_add(fh);
...

simply use function v4l2_fh_open() which does all of these calls for us.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 4eb4a6a..3a7ec3b 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1868,7 +1868,7 @@ static int em28xx_v4l2_open(struct file *filp)
 	struct em28xx *dev = video_drvdata(filp);
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 	enum v4l2_buf_type fh_type = 0;
-	struct v4l2_fh *fh;
+	int ret;
 
 	switch (vdev->vfl_type) {
 	case VFL_TYPE_GRABBER:
@@ -1889,14 +1889,14 @@ static int em28xx_v4l2_open(struct file *filp)
 
 	if (mutex_lock_interruptible(&dev->lock))
 		return -ERESTARTSYS;
-	fh = kzalloc(sizeof(struct v4l2_fh), GFP_KERNEL);
-	if (!fh) {
-		em28xx_errdev("em28xx-video.c: Out of memory?!\n");
+
+	ret = v4l2_fh_open(filp);
+	if (ret) {
+		em28xx_errdev("%s: v4l2_fh_open() returned error %d\n",
+			      __func__, ret);
 		mutex_unlock(&dev->lock);
-		return -ENOMEM;
+		return ret;
 	}
-	v4l2_fh_init(fh, vdev);
-	filp->private_data = fh;
 
 	if (v4l2->users == 0) {
 		em28xx_set_mode(dev, EM28XX_ANALOG_MODE);
@@ -1921,7 +1921,6 @@ static int em28xx_v4l2_open(struct file *filp)
 	v4l2->users++;
 
 	mutex_unlock(&dev->lock);
-	v4l2_fh_add(fh);
 
 	return 0;
 }
-- 
1.8.4.5

