Return-path: <mchehab@gaivota>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:3739 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab1ACSbc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jan 2011 13:31:32 -0500
Received: from localhost.localdomain (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr18.xs4all.nl (8.13.8/8.13.8) with ESMTP id p03IVMuZ006180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 3 Jan 2011 19:31:31 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv2 PATCH 08/10] radio-cadet: use v4l2_fh helper functions
Date: Mon,  3 Jan 2011 19:31:13 +0100
Message-Id: <362367dfefbbed04a99e28acedf68b8c28f820a6.1294078230.git.hverkuil@xs4all.nl>
In-Reply-To: <1294079475-13259-1-git-send-email-hverkuil@xs4all.nl>
References: <1294079475-13259-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <6515cfbdde63364fd12bca1219870f38ff371145.1294078230.git.hverkuil@xs4all.nl>
References: <6515cfbdde63364fd12bca1219870f38ff371145.1294078230.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This will introduce priority handling for free.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/radio/radio-cadet.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/radio-cadet.c b/drivers/media/radio/radio-cadet.c
index bc9ad08..9dbbb41 100644
--- a/drivers/media/radio/radio-cadet.c
+++ b/drivers/media/radio/radio-cadet.c
@@ -42,6 +42,7 @@
 #include <linux/io.h>		/* outb, outb_p			*/
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-fh.h>
 
 MODULE_AUTHOR("Fred Gleason, Russell Kroll, Quay Lu, Donald Song, Jason Lewis, Scott McGrath, William McGrath");
 MODULE_DESCRIPTION("A driver for the ADS Cadet AM/FM/RDS radio card.");
@@ -526,7 +527,10 @@ static int vidioc_s_audio(struct file *file, void *priv,
 static int cadet_open(struct file *file)
 {
 	struct cadet *dev = video_drvdata(file);
+	int ret = v4l2_fh_open(file);
 
+	if (ret)
+		return ret;
 	mutex_lock(&dev->lock);
 	dev->users++;
 	if (1 == dev->users)
@@ -546,7 +550,7 @@ static int cadet_release(struct file *file)
 		dev->rdsstat = 0;
 	}
 	mutex_unlock(&dev->lock);
-	return 0;
+	return v4l2_fh_release(file);
 }
 
 static unsigned int cadet_poll(struct file *file, struct poll_table_struct *wait)
-- 
1.7.0.4

