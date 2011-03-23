Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:54797 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943Ab1CWJQ1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2011 05:16:27 -0400
Date: Wed, 23 Mar 2011 10:16:24 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Magnus Damm <damm@opensource.se>
Subject: [PATCH 1/3 v2] V4L: soc_camera_platform: add helper functions to
 manage device instances
Message-ID: <Pine.LNX.4.64.1103231011540.6836@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add helper inline functions to correctly manage dynamic allocation and
freeing of platform devices. This avoids the ugly code to nullify
device objects.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Acked-by: Magnus Damm <damm@opensource.se>
---

v2: fix the device link assignment order, reported by Magnus - thanks for 
testing!

Now, wondering, if we still can manage to get this into .39 together with 
the other 2 patches for the SH and ARM platforms from the series and via 
which tree...

 include/media/soc_camera_platform.h |   50 +++++++++++++++++++++++++++++++++++
 1 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/include/media/soc_camera_platform.h b/include/media/soc_camera_platform.h
index 0ecefe2..6d7a4fd 100644
--- a/include/media/soc_camera_platform.h
+++ b/include/media/soc_camera_platform.h
@@ -25,4 +25,54 @@ struct soc_camera_platform_info {
 	int (*set_capture)(struct soc_camera_platform_info *info, int enable);
 };
 
+static inline void soc_camera_platform_release(struct platform_device **pdev)
+{
+	*pdev = NULL;
+}
+
+static inline int soc_camera_platform_add(const struct soc_camera_link *icl,
+					  struct device *dev,
+					  struct platform_device **pdev,
+					  struct soc_camera_link *plink,
+					  void (*release)(struct device *dev),
+					  int id)
+{
+	struct soc_camera_platform_info *info = plink->priv;
+	int ret;
+
+	if (icl != plink)
+		return -ENODEV;
+
+	if (*pdev)
+		return -EBUSY;
+
+	*pdev = platform_device_alloc("soc_camera_platform", id);
+	if (!*pdev)
+		return -ENOMEM;
+
+	info->dev = dev;
+
+	(*pdev)->dev.platform_data = info;
+	(*pdev)->dev.release = release;
+
+	ret = platform_device_add(*pdev);
+	if (ret < 0) {
+		platform_device_put(*pdev);
+		*pdev = NULL;
+		info->dev = NULL;
+	}
+
+	return ret;
+}
+
+static inline void soc_camera_platform_del(const struct soc_camera_link *icl,
+					   struct platform_device *pdev,
+					   const struct soc_camera_link *plink)
+{
+	if (icl != plink || !pdev)
+		return;
+
+	platform_device_unregister(pdev);
+}
+
 #endif /* __SOC_CAMERA_H__ */
-- 
1.7.2.5

