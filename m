Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:44136 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751005AbaKWMkK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Nov 2014 07:40:10 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/3] v4l2-common: remove unused helper functions.
Date: Sun, 23 Nov 2014 13:39:53 +0100
Message-Id: <1416746395-48631-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1416746395-48631-1-git-send-email-hverkuil@xs4all.nl>
References: <1416746395-48631-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Several control helper functions are no longer needed since most drivers
are now converted to the control framework. So we can delete them.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-common.c | 95 -----------------------------------
 include/media/v4l2-common.h           | 10 ----
 2 files changed, 105 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index 2e9d81f..8493209 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -135,101 +135,6 @@ int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 _min, s32 _max, s32 _
 }
 EXPORT_SYMBOL(v4l2_ctrl_query_fill);
 
-/* Fill in a struct v4l2_querymenu based on the struct v4l2_queryctrl and
-   the menu. The qctrl pointer may be NULL, in which case it is ignored.
-   If menu_items is NULL, then the menu items are retrieved using
-   v4l2_ctrl_get_menu. */
-int v4l2_ctrl_query_menu(struct v4l2_querymenu *qmenu, struct v4l2_queryctrl *qctrl,
-	       const char * const *menu_items)
-{
-	int i;
-
-	qmenu->reserved = 0;
-	if (menu_items == NULL)
-		menu_items = v4l2_ctrl_get_menu(qmenu->id);
-	if (menu_items == NULL ||
-	    (qctrl && (qmenu->index < qctrl->minimum || qmenu->index > qctrl->maximum)))
-		return -EINVAL;
-	for (i = 0; i < qmenu->index && menu_items[i]; i++) ;
-	if (menu_items[i] == NULL || menu_items[i][0] == '\0')
-		return -EINVAL;
-	strlcpy(qmenu->name, menu_items[qmenu->index], sizeof(qmenu->name));
-	return 0;
-}
-EXPORT_SYMBOL(v4l2_ctrl_query_menu);
-
-/* Fill in a struct v4l2_querymenu based on the specified array of valid
-   menu items (terminated by V4L2_CTRL_MENU_IDS_END).
-   Use this if there are 'holes' in the list of valid menu items. */
-int v4l2_ctrl_query_menu_valid_items(struct v4l2_querymenu *qmenu, const u32 *ids)
-{
-	const char * const *menu_items = v4l2_ctrl_get_menu(qmenu->id);
-
-	qmenu->reserved = 0;
-	if (menu_items == NULL || ids == NULL)
-		return -EINVAL;
-	while (*ids != V4L2_CTRL_MENU_IDS_END) {
-		if (*ids++ == qmenu->index) {
-			strlcpy(qmenu->name, menu_items[qmenu->index],
-					sizeof(qmenu->name));
-			return 0;
-		}
-	}
-	return -EINVAL;
-}
-EXPORT_SYMBOL(v4l2_ctrl_query_menu_valid_items);
-
-/* ctrl_classes points to an array of u32 pointers, the last element is
-   a NULL pointer. Each u32 array is a 0-terminated array of control IDs.
-   Each array must be sorted low to high and belong to the same control
-   class. The array of u32 pointers must also be sorted, from low class IDs
-   to high class IDs.
-
-   This function returns the first ID that follows after the given ID.
-   When no more controls are available 0 is returned. */
-u32 v4l2_ctrl_next(const u32 * const * ctrl_classes, u32 id)
-{
-	u32 ctrl_class = V4L2_CTRL_ID2CLASS(id);
-	const u32 *pctrl;
-
-	if (ctrl_classes == NULL)
-		return 0;
-
-	/* if no query is desired, then check if the ID is part of ctrl_classes */
-	if ((id & V4L2_CTRL_FLAG_NEXT_CTRL) == 0) {
-		/* find class */
-		while (*ctrl_classes && V4L2_CTRL_ID2CLASS(**ctrl_classes) != ctrl_class)
-			ctrl_classes++;
-		if (*ctrl_classes == NULL)
-			return 0;
-		pctrl = *ctrl_classes;
-		/* find control ID */
-		while (*pctrl && *pctrl != id) pctrl++;
-		return *pctrl ? id : 0;
-	}
-	id &= V4L2_CTRL_ID_MASK;
-	id++;	/* select next control */
-	/* find first class that matches (or is greater than) the class of
-	   the ID */
-	while (*ctrl_classes && V4L2_CTRL_ID2CLASS(**ctrl_classes) < ctrl_class)
-		ctrl_classes++;
-	/* no more classes */
-	if (*ctrl_classes == NULL)
-		return 0;
-	pctrl = *ctrl_classes;
-	/* find first ctrl within the class that is >= ID */
-	while (*pctrl && *pctrl < id) pctrl++;
-	if (*pctrl)
-		return *pctrl;
-	/* we are at the end of the controls of the current class. */
-	/* continue with next class if available */
-	ctrl_classes++;
-	if (*ctrl_classes == NULL)
-		return 0;
-	return **ctrl_classes;
-}
-EXPORT_SYMBOL(v4l2_ctrl_next);
-
 /* I2C Helper functions */
 
 #if IS_ENABLED(CONFIG_I2C)
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 48f9748..6b4951d 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -88,16 +88,6 @@ const char *v4l2_ctrl_get_name(u32 id);
 const char * const *v4l2_ctrl_get_menu(u32 id);
 const s64 *v4l2_ctrl_get_int_menu(u32 id, u32 *len);
 int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 min, s32 max, s32 step, s32 def);
-int v4l2_ctrl_query_menu(struct v4l2_querymenu *qmenu,
-		struct v4l2_queryctrl *qctrl, const char * const *menu_items);
-#define V4L2_CTRL_MENU_IDS_END (0xffffffff)
-int v4l2_ctrl_query_menu_valid_items(struct v4l2_querymenu *qmenu, const u32 *ids);
-
-/* Note: ctrl_classes points to an array of u32 pointers. Each u32 array is a
-   0-terminated array of control IDs. Each array must be sorted low to high
-   and belong to the same control class. The array of u32 pointers must also
-   be sorted, from low class IDs to high class IDs. */
-u32 v4l2_ctrl_next(const u32 * const *ctrl_classes, u32 id);
 
 /* ------------------------------------------------------------------------- */
 
-- 
2.1.3

