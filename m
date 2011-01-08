Return-path: <mchehab@pedra>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2067 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab1AHNhH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 08:37:07 -0500
Received: from localhost.localdomain (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id p08DalkC015112
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 8 Jan 2011 14:37:06 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv3 PATCH 15/16] radio-maxiradio: implement priority handling
Date: Sat,  8 Jan 2011 14:36:40 +0100
Message-Id: <c900f9a2c5052411200fdb9b31f262d54ceed5cc.1294493428.git.hverkuil@xs4all.nl>
In-Reply-To: <1294493801-17406-1-git-send-email-hverkuil@xs4all.nl>
References: <1294493801-17406-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1d57787db3bd1a76d292bd80d91ba9e10c07af68.1294493427.git.hverkuil@xs4all.nl>
References: <1d57787db3bd1a76d292bd80d91ba9e10c07af68.1294493427.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/radio/radio-maxiradio.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/media/radio/radio-maxiradio.c b/drivers/media/radio/radio-maxiradio.c
index 1323a56..d38c60f 100644
--- a/drivers/media/radio/radio-maxiradio.c
+++ b/drivers/media/radio/radio-maxiradio.c
@@ -45,6 +45,7 @@
 #include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-fh.h>
 
 MODULE_AUTHOR("Dimitromanolakis Apostolos, apdim@grecian.net");
 MODULE_DESCRIPTION("Radio driver for the Guillemot Maxi Radio FM2000 radio.");
@@ -337,6 +338,8 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 static const struct v4l2_file_operations maxiradio_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl = video_ioctl2,
+	.open		= v4l2_fh_open,
+	.release	= v4l2_fh_release,
 };
 
 static const struct v4l2_ioctl_ops maxiradio_ioctl_ops = {
-- 
1.7.0.4

