Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:53168 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933549AbaD3ODp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Apr 2014 10:03:45 -0400
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-kernel@vger.kernel.org (open list)
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Thierry Reding <thierry.reding@gmail.com>,
	David Airlie <airlied@linux.ie>,
	Inki Dae <inki.dae@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Figa <t.figa@samsung.com>,
	Tomasz Stansislawski <t.stanislaws@samsung.com>,
	linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
	linux-arm-kernel@lists.infradead.org (moderated list:ARM/S5P EXYNOS
	AR...), dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org
Subject: [RFC PATCH 2/4] drm/panel: add interface tracker support
Date: Wed, 30 Apr 2014 16:02:52 +0200
Message-id: <1398866574-27001-3-git-send-email-a.hajda@samsung.com>
In-reply-to: <1398866574-27001-1-git-send-email-a.hajda@samsung.com>
References: <1398866574-27001-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drm_panel framework allows only query for presence of given panel.
It also does not protect panel module from unloading and does not
provide solution for driver unbinding. interface_tracker
should solve both issues.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
---
 drivers/gpu/drm/drm_panel.c       | 5 +++++
 include/linux/interface_tracker.h | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel.c b/drivers/gpu/drm/drm_panel.c
index 2ef988e..72a3c5c 100644
--- a/drivers/gpu/drm/drm_panel.c
+++ b/drivers/gpu/drm/drm_panel.c
@@ -22,6 +22,7 @@
  */
 
 #include <linux/err.h>
+#include <linux/interface_tracker.h>
 #include <linux/module.h>
 
 #include <drm/drm_crtc.h>
@@ -41,6 +42,8 @@ int drm_panel_add(struct drm_panel *panel)
 	mutex_lock(&panel_lock);
 	list_add_tail(&panel->list, &panel_list);
 	mutex_unlock(&panel_lock);
+	interface_tracker_ifup(panel->dev->of_node,
+			       INTERFACE_TRACKER_TYPE_DRM_PANEL, panel);
 
 	return 0;
 }
@@ -48,6 +51,8 @@ EXPORT_SYMBOL(drm_panel_add);
 
 void drm_panel_remove(struct drm_panel *panel)
 {
+	interface_tracker_ifdown(panel->dev->of_node,
+				 INTERFACE_TRACKER_TYPE_DRM_PANEL, panel);
 	mutex_lock(&panel_lock);
 	list_del_init(&panel->list);
 	mutex_unlock(&panel_lock);
diff --git a/include/linux/interface_tracker.h b/include/linux/interface_tracker.h
index e1eff00..0a08cba 100644
--- a/include/linux/interface_tracker.h
+++ b/include/linux/interface_tracker.h
@@ -6,6 +6,8 @@
 struct list_head;
 struct interface_tracker_block;
 
+#define INTERFACE_TRACKER_TYPE_DRM_PANEL 1
+
 typedef void (*interface_tracker_fn_t)(struct interface_tracker_block *itb,
 				       const void *object, unsigned long type,
 				       bool on, void *data);
-- 
1.8.3.2

