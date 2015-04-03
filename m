Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:37574 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbbDCM6h (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2015 08:58:37 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-pm@vger.kernel.org
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/7] [media] v4l2-core: Implement dev_pm_ops.prepare()
Date: Fri,  3 Apr 2015 14:57:54 +0200
Message-Id: <1428065887-16017-6-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1428065887-16017-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1428065887-16017-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Have it return 1 so that video devices that are runtime-suspended won't
be suspended when the system goes to a sleep state. This can make resume
times considerably shorter because these devices don't need to be
resumed when the system is awaken.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/media/v4l2-core/v4l2-dev.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index e2b8b3e..b74e3d3 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -219,9 +219,19 @@ static void v4l2_device_release(struct device *cd)
 		v4l2_device_put(v4l2_dev);
 }
 
+static int video_device_prepare(struct device *dev)
+{
+	return 1;
+}
+
+static const struct dev_pm_ops video_device_pm_ops = {
+	.prepare = video_device_prepare,
+};
+
 static struct class video_class = {
 	.name = VIDEO_NAME,
 	.dev_groups = video_device_groups,
+	.pm = &video_device_pm_ops,
 };
 
 struct video_device *video_devdata(struct file *file)
-- 
2.3.4

