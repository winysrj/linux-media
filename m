Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:63748 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601Ab3H3L3A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 07:29:00 -0400
Received: by mail-pa0-f49.google.com with SMTP id ld10so2203003pab.36
        for <linux-media@vger.kernel.org>; Fri, 30 Aug 2013 04:28:59 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com, sachin.kamat@linaro.org,
	patches@linaro.org, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 1/1] [media] v4l2-ctrls: Remove duplicate const
Date: Fri, 30 Aug 2013 16:41:22 +0530
Message-Id: <1377861082-17312-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function returns a pointer to a const array. Duplicate use of const
led to the following warning.
drivers/media/v4l2-core/v4l2-ctrls.c:574:32: warning: duplicate const

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c |    6 +++---
 include/media/v4l2-common.h          |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index c6dc1fd..653d48d 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -565,13 +565,13 @@ EXPORT_SYMBOL(v4l2_ctrl_get_menu);
  * Returns NULL or an s64 type array containing the menu for given
  * control ID. The total number of the menu items is returned in @len.
  */
-const s64 const *v4l2_ctrl_get_int_menu(u32 id, u32 *len)
+const s64 *v4l2_ctrl_get_int_menu(u32 id, u32 *len)
 {
-	static const s64 const qmenu_int_vpx_num_partitions[] = {
+	static const s64 qmenu_int_vpx_num_partitions[] = {
 		1, 2, 4, 8,
 	};
 
-	static const s64 const qmenu_int_vpx_num_ref_frames[] = {
+	static const s64 qmenu_int_vpx_num_ref_frames[] = {
 		1, 2, 3,
 	};
 
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 16550c4..b87692c 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -86,7 +86,7 @@ int v4l2_ctrl_check(struct v4l2_ext_control *ctrl, struct v4l2_queryctrl *qctrl,
 		const char * const *menu_items);
 const char *v4l2_ctrl_get_name(u32 id);
 const char * const *v4l2_ctrl_get_menu(u32 id);
-const s64 const *v4l2_ctrl_get_int_menu(u32 id, u32 *len);
+const s64 *v4l2_ctrl_get_int_menu(u32 id, u32 *len);
 int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 min, s32 max, s32 step, s32 def);
 int v4l2_ctrl_query_menu(struct v4l2_querymenu *qmenu,
 		struct v4l2_queryctrl *qctrl, const char * const *menu_items);
-- 
1.7.9.5

