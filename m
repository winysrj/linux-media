Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:33029 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbbDCM6i (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2015 08:58:38 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-pm@vger.kernel.org
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/7] [media] media-devnode: Implement dev_pm_ops.prepare callback
Date: Fri,  3 Apr 2015 14:57:55 +0200
Message-Id: <1428065887-16017-7-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1428065887-16017-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1428065887-16017-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Have it return 1 so that media device nodes that are runtime-suspended
won't be suspended when the system goes to a sleep state. This can make
resume times considerably shorter because these devices don't need to be
resumed when the system is awaken.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/media/media-devnode.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index ebf9626..2c36d0a 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -76,8 +76,18 @@ static void media_devnode_release(struct device *cd)
 		mdev->release(mdev);
 }
 
+static int media_bus_prepare(struct device *dev)
+{
+	return 1;
+}
+
+static const struct dev_pm_ops media_bus_pm_ops = {
+	.prepare = media_bus_prepare,
+};
+
 static struct bus_type media_bus_type = {
 	.name = MEDIA_NAME,
+	.pm = &media_bus_pm_ops,
 };
 
 static ssize_t media_read(struct file *filp, char __user *buf,
-- 
2.3.4

