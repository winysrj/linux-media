Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f50.google.com ([209.85.210.50]:58986 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab3CBMAi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2013 07:00:38 -0500
Received: by mail-da0-f50.google.com with SMTP id h15so1781719dan.23
        for <linux-media@vger.kernel.org>; Sat, 02 Mar 2013 04:00:38 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, sachin.kamat@linaro.org, patches@linaro.org,
	s.nawrocki@samsung.com
Subject: [PATCH 1/3] [media] s5p-mfc: Staticize some symbols in s5p_mfc_cmd_v5.c
Date: Sat,  2 Mar 2013 17:20:12 +0530
Message-Id: <1362225014-31760-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These symbols are used only in this file and can be made static.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c
index 13877808..ad4f1df 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c
@@ -16,7 +16,7 @@
 #include "s5p_mfc_debug.h"
 
 /* This function is used to send a command to the MFC */
-int s5p_mfc_cmd_host2risc_v5(struct s5p_mfc_dev *dev, int cmd,
+static int s5p_mfc_cmd_host2risc_v5(struct s5p_mfc_dev *dev, int cmd,
 				struct s5p_mfc_cmd_args *args)
 {
 	int cur_cmd;
@@ -41,7 +41,7 @@ int s5p_mfc_cmd_host2risc_v5(struct s5p_mfc_dev *dev, int cmd,
 }
 
 /* Initialize the MFC */
-int s5p_mfc_sys_init_cmd_v5(struct s5p_mfc_dev *dev)
+static int s5p_mfc_sys_init_cmd_v5(struct s5p_mfc_dev *dev)
 {
 	struct s5p_mfc_cmd_args h2r_args;
 
@@ -52,7 +52,7 @@ int s5p_mfc_sys_init_cmd_v5(struct s5p_mfc_dev *dev)
 }
 
 /* Suspend the MFC hardware */
-int s5p_mfc_sleep_cmd_v5(struct s5p_mfc_dev *dev)
+static int s5p_mfc_sleep_cmd_v5(struct s5p_mfc_dev *dev)
 {
 	struct s5p_mfc_cmd_args h2r_args;
 
@@ -61,7 +61,7 @@ int s5p_mfc_sleep_cmd_v5(struct s5p_mfc_dev *dev)
 }
 
 /* Wake up the MFC hardware */
-int s5p_mfc_wakeup_cmd_v5(struct s5p_mfc_dev *dev)
+static int s5p_mfc_wakeup_cmd_v5(struct s5p_mfc_dev *dev)
 {
 	struct s5p_mfc_cmd_args h2r_args;
 
@@ -71,7 +71,7 @@ int s5p_mfc_wakeup_cmd_v5(struct s5p_mfc_dev *dev)
 }
 
 
-int s5p_mfc_open_inst_cmd_v5(struct s5p_mfc_ctx *ctx)
+static int s5p_mfc_open_inst_cmd_v5(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	struct s5p_mfc_cmd_args h2r_args;
@@ -124,7 +124,7 @@ int s5p_mfc_open_inst_cmd_v5(struct s5p_mfc_ctx *ctx)
 	return ret;
 }
 
-int s5p_mfc_close_inst_cmd_v5(struct s5p_mfc_ctx *ctx)
+static int s5p_mfc_close_inst_cmd_v5(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	struct s5p_mfc_cmd_args h2r_args;
-- 
1.7.4.1

