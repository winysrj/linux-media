Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60115 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab3HWWMK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Aug 2013 18:12:10 -0400
Received: by mail-bk0-f46.google.com with SMTP id 6so428529bkj.19
        for <linux-media@vger.kernel.org>; Fri, 23 Aug 2013 15:12:09 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: hansverk@cisco.com, Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Arun Kumar <arun.kk@samsung.com>
Subject: [PATCH] v4l2-ctrls: Correct v4l2_ctrl_get_int_menu() function prototype
Date: Sat, 24 Aug 2013 00:11:58 +0200
Message-Id: <1377295918-14884-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This function is supposed to return constant pointer to a constant.
Also remove double const from the qmenu_int arrays' declarations.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Arun Kumar <arun.kk@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c |    6 +++---
 include/media/v4l2-common.h          |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index c6dc1fd..d081f35 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -565,13 +565,13 @@ EXPORT_SYMBOL(v4l2_ctrl_get_menu);
  * Returns NULL or an s64 type array containing the menu for given
  * control ID. The total number of the menu items is returned in @len.
  */
-const s64 const *v4l2_ctrl_get_int_menu(u32 id, u32 *len)
+const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len)
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
index 16550c4..e1c388c 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -86,7 +86,7 @@ int v4l2_ctrl_check(struct v4l2_ext_control *ctrl, struct v4l2_queryctrl *qctrl,
 		const char * const *menu_items);
 const char *v4l2_ctrl_get_name(u32 id);
 const char * const *v4l2_ctrl_get_menu(u32 id);
-const s64 const *v4l2_ctrl_get_int_menu(u32 id, u32 *len);
+const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
 int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 min, s32 max, s32 step, s32 def);
 int v4l2_ctrl_query_menu(struct v4l2_querymenu *qmenu,
 		struct v4l2_queryctrl *qctrl, const char * const *menu_items);
-- 
1.7.4.1

