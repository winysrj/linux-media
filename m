Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:43190 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752364AbdLAMbm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Dec 2017 07:31:42 -0500
Received: by mail-pg0-f66.google.com with SMTP id b18so4426997pgv.10
        for <linux-media@vger.kernel.org>; Fri, 01 Dec 2017 04:31:41 -0800 (PST)
From: Jaedon Shin <jaedon.shin@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        linux-media@vger.kernel.org, Jaedon Shin <jaedon.shin@gmail.com>
Subject: [PATCH 1/3] media: dvb_frontend: Add unlocked_ioctl in dvb_frontend.c
Date: Fri,  1 Dec 2017 21:31:28 +0900
Message-Id: <20171201123130.23128-2-jaedon.shin@gmail.com>
In-Reply-To: <20171201123130.23128-1-jaedon.shin@gmail.com>
References: <20171201123130.23128-1-jaedon.shin@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds unlocked ioctl function directly in dvb_frontend.c instead of using
dvb_generic_ioctl().

Signed-off-by: Jaedon Shin <jaedon.shin@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 3ad83359098b..6d8f4dd39c0c 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1920,7 +1920,8 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 	return r;
 }
 
-static int dvb_frontend_ioctl(struct file *file, unsigned int cmd, void *parg)
+static int dvb_frontend_do_ioctl(struct file *file, unsigned int cmd,
+				 void *parg)
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_frontend *fe = dvbdev->priv;
@@ -1963,6 +1964,17 @@ static int dvb_frontend_ioctl(struct file *file, unsigned int cmd, void *parg)
 	return err;
 }
 
+static long dvb_frontend_ioctl(struct file *file, unsigned int cmd,
+			       unsigned long arg)
+{
+	struct dvb_device *dvbdev = file->private_data;
+
+	if (!dvbdev)
+		return -ENODEV;
+
+	return dvb_usercopy(file, cmd, arg, dvb_frontend_do_ioctl);
+}
+
 static int dtv_set_frontend(struct dvb_frontend *fe)
 {
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
@@ -2644,7 +2656,7 @@ static int dvb_frontend_release(struct inode *inode, struct file *file)
 
 static const struct file_operations dvb_frontend_fops = {
 	.owner		= THIS_MODULE,
-	.unlocked_ioctl	= dvb_generic_ioctl,
+	.unlocked_ioctl	= dvb_frontend_ioctl,
 	.poll		= dvb_frontend_poll,
 	.open		= dvb_frontend_open,
 	.release	= dvb_frontend_release,
@@ -2712,7 +2724,6 @@ int dvb_register_frontend(struct dvb_adapter* dvb,
 #if defined(CONFIG_MEDIA_CONTROLLER_DVB)
 		.name = fe->ops.info.name,
 #endif
-		.kernel_ioctl = dvb_frontend_ioctl
 	};
 
 	dev_dbg(dvb->device, "%s:\n", __func__);
-- 
2.15.0
