Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3625 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab3FZGb2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jun 2013 02:31:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH] mem2mem_testdev: fix missing v4l2_dev assignment
Date: Wed, 26 Jun 2013 08:31:14 +0200
Cc: Fengguang Wu <fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201306260831.14370.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

This patch adds the missing v4l2_dev assignment as reported by Fengguang.

It also fixes a poorly formatted message:

m2m-testdev m2m-testdev.0: mem2mem-testdevDevice registered as /dev/video0

Is it OK if I take this through my tree? I have similar fix as well in another
driver.

Regards,

	Hans

diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
index 4cc7f65d..6a17676 100644
--- a/drivers/media/platform/mem2mem_testdev.c
+++ b/drivers/media/platform/mem2mem_testdev.c
@@ -1051,6 +1051,7 @@ static int m2mtest_probe(struct platform_device *pdev)
 
 	*vfd = m2mtest_videodev;
 	vfd->lock = &dev->dev_mutex;
+	vfd->v4l2_dev = &dev->v4l2_dev;
 
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
 	if (ret) {
@@ -1061,7 +1062,7 @@ static int m2mtest_probe(struct platform_device *pdev)
 	video_set_drvdata(vfd, dev);
 	snprintf(vfd->name, sizeof(vfd->name), "%s", m2mtest_videodev.name);
 	dev->vfd = vfd;
-	v4l2_info(&dev->v4l2_dev, MEM2MEM_TEST_MODULE_NAME
+	v4l2_info(&dev->v4l2_dev,
 			"Device registered as /dev/video%d\n", vfd->num);
 
 	setup_timer(&dev->timer, device_isr, (long)dev);
