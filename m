Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36787 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750703AbdI0Iij (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 04:38:39 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, hverkuil@xs4all.nl, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] [media] radio-si470x: make si470x_viddev_template const
Date: Wed, 27 Sep 2017 14:08:29 +0530
Message-Id: <1506501509-12369-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make this const as it is only used in a copy operation in the files
referencing it. Add const to declaration in the header too.

Structure found using Coccienlle and changes done by hand.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/radio/si470x/radio-si470x-common.c | 2 +-
 drivers/media/radio/si470x/radio-si470x.h        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
index cd76fac..c89a7d5 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -749,7 +749,7 @@ static int si470x_vidioc_enum_freq_bands(struct file *file, void *priv,
 /*
  * si470x_viddev_template - video device interface
  */
-struct video_device si470x_viddev_template = {
+const struct video_device si470x_viddev_template = {
 	.fops			= &si470x_fops,
 	.name			= DRIVER_NAME,
 	.release		= video_device_release_empty,
diff --git a/drivers/media/radio/si470x/radio-si470x.h b/drivers/media/radio/si470x/radio-si470x.h
index 7d2defd..eb7b834 100644
--- a/drivers/media/radio/si470x/radio-si470x.h
+++ b/drivers/media/radio/si470x/radio-si470x.h
@@ -209,7 +209,7 @@ struct si470x_device {
 /**************************************************************************
  * Common Functions
  **************************************************************************/
-extern struct video_device si470x_viddev_template;
+extern const struct video_device si470x_viddev_template;
 extern const struct v4l2_ctrl_ops si470x_ctrl_ops;
 int si470x_get_register(struct si470x_device *radio, int regnr);
 int si470x_set_register(struct si470x_device *radio, int regnr);
-- 
1.9.1
