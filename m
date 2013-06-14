Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:59909 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab3FNTJQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jun 2013 15:09:16 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH v11 02/21] soc-camera: add host clock callbacks to start and stop the master clock
Date: Fri, 14 Jun 2013 21:08:12 +0200
Message-Id: <1371236911-15131-3-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1371236911-15131-1-git-send-email-g.liakhovetski@gmx.de>
References: <1371236911-15131-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently soc-camera uses a single camera host callback to activate the
interface master clock and to configure the interface for a specific
client. However, during probing we might not have the information about
a client, we just need to activate the clock. Add new camera host driver
callbacks to only start and stop the clock without and client-specific
configuration.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/soc_camera.c |   19 +++++++++++++++++--
 include/media/soc_camera.h                     |    2 ++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 832f059..df90565 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -513,10 +513,23 @@ static int soc_camera_add_device(struct soc_camera_device *icd)
 	if (ici->icd)
 		return -EBUSY;
 
+	if (ici->ops->clock_start) {
+		ret = ici->ops->clock_start(ici);
+		if (ret < 0)
+			return ret;
+	}
+
 	ret = ici->ops->add(icd);
-	if (!ret)
-		ici->icd = icd;
+	if (ret < 0)
+		goto eadd;
+
+	ici->icd = icd;
 
+	return 0;
+
+eadd:
+	if (ici->ops->clock_stop)
+		ici->ops->clock_stop(ici);
 	return ret;
 }
 
@@ -528,6 +541,8 @@ static void soc_camera_remove_device(struct soc_camera_device *icd)
 		return;
 
 	ici->ops->remove(icd);
+	if (ici->ops->clock_stop)
+		ici->ops->clock_stop(ici);
 	ici->icd = NULL;
 }
 
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 5a46ce2..64415ee 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -74,6 +74,8 @@ struct soc_camera_host_ops {
 	struct module *owner;
 	int (*add)(struct soc_camera_device *);
 	void (*remove)(struct soc_camera_device *);
+	int (*clock_start)(struct soc_camera_host *);
+	void (*clock_stop)(struct soc_camera_host *);
 	/*
 	 * .get_formats() is called for each client device format, but
 	 * .put_formats() is only called once. Further, if any of the calls to
-- 
1.7.2.5

