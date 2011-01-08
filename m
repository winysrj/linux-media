Return-path: <mchehab@pedra>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3050 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab1AHNhG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 08:37:06 -0500
Received: from localhost.localdomain (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id p08DalkA015112
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 8 Jan 2011 14:37:05 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv3 PATCH 13/16] radio-cadet: use v4l2_fh helper functions
Date: Sat,  8 Jan 2011 14:36:38 +0100
Message-Id: <08691f479316008d298aa0628ecef8958abf734a.1294493428.git.hverkuil@xs4all.nl>
In-Reply-To: <1294493801-17406-1-git-send-email-hverkuil@xs4all.nl>
References: <1294493801-17406-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1d57787db3bd1a76d292bd80d91ba9e10c07af68.1294493427.git.hverkuil@xs4all.nl>
References: <1d57787db3bd1a76d292bd80d91ba9e10c07af68.1294493427.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This will introduce priority handling.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/radio/radio-cadet.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/media/radio/radio-cadet.c b/drivers/media/radio/radio-cadet.c
index 4a37b69..b511854 100644
--- a/drivers/media/radio/radio-cadet.c
+++ b/drivers/media/radio/radio-cadet.c
@@ -42,6 +42,7 @@
 #include <linux/io.h>		/* outb, outb_p			*/
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-fh.h>
 
 MODULE_AUTHOR("Fred Gleason, Russell Kroll, Quay Lu, Donald Song, Jason Lewis, Scott McGrath, William McGrath");
 MODULE_DESCRIPTION("A driver for the ADS Cadet AM/FM/RDS radio card.");
@@ -64,7 +65,6 @@ struct cadet {
 	struct v4l2_device v4l2_dev;
 	struct video_device vdev;
 	int io;
-	int users;
 	int curtuner;
 	int tunestat;
 	int sigstrength;
@@ -500,23 +500,22 @@ static int vidioc_s_audio(struct file *file, void *priv,
 static int cadet_open(struct file *file)
 {
 	struct cadet *dev = video_drvdata(file);
+	int ret = v4l2_fh_open(file);
 
-	dev->users++;
-	if (1 == dev->users)
+	if (v4l2_fh_is_singular_file(file))
 		init_waitqueue_head(&dev->read_queue);
-	return 0;
+	return ret;
 }
 
 static int cadet_release(struct file *file)
 {
 	struct cadet *dev = video_drvdata(file);
 
-	dev->users--;
-	if (0 == dev->users) {
+	if (v4l2_fh_is_singular_file(file)) {
 		del_timer_sync(&dev->readtimer);
 		dev->rdsstat = 0;
 	}
-	return 0;
+	return v4l2_fh_release(file);
 }
 
 static unsigned int cadet_poll(struct file *file, struct poll_table_struct *wait)
-- 
1.7.0.4

