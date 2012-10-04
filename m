Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:33859 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab2JDHZA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 03:25:00 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBC00CTLXVK9PN0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 16:24:45 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBC006I9XWMLU10@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 16:24:44 +0900 (KST)
From: Rahul Sharma <rahul.sharma@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, inki.dae@samsung.com,
	kyungmin.park@samsung.com, joshi@samsung.com
Subject: [PATCH v1 06/14] drm: exynos: remove drm hdmi platform data struct
Date: Thu, 04 Oct 2012 21:12:44 +0530
Message-id: <1349365372-21417-7-git-send-email-rahul.sharma@samsung.com>
In-reply-to: <1349365372-21417-1-git-send-email-rahul.sharma@samsung.com>
References: <1349365372-21417-1-git-send-email-rahul.sharma@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch removes the drm hdmi platform data structure which is no
longer in use by drm hdmi driver after this patch set get merged. s5p
hdmi platform data structure is used instead.

Signed-off-by: Rahul Sharma <rahul.sharma@samsung.com>
---
 include/drm/exynos_drm.h |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/include/drm/exynos_drm.h b/include/drm/exynos_drm.h
index 0d1c503..8bdd49a 100644
--- a/include/drm/exynos_drm.h
+++ b/include/drm/exynos_drm.h
@@ -254,18 +254,5 @@ struct exynos_drm_common_hdmi_pd {
 	struct device *mixer_dev;
 };
 
-/**
- * Platform Specific Structure for DRM based HDMI core.
- *
- * @is_v13: set if hdmi version 13 is.
- * @cfg_hpd: function pointer to configure hdmi hotplug detection pin
- * @get_hpd: function pointer to get value of hdmi hotplug detection pin
- */
-struct exynos_drm_hdmi_pdata {
-	bool is_v13;
-	void (*cfg_hpd)(bool external);
-	int (*get_hpd)(void);
-};
-
 #endif	/* __KERNEL__ */
 #endif	/* _EXYNOS_DRM_H_ */
-- 
1.7.0.4

