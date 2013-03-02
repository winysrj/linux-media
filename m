Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59016 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab3CBKvZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2013 05:51:25 -0500
Received: by mail-pb0-f46.google.com with SMTP id uo15so2232561pbc.19
        for <linux-media@vger.kernel.org>; Sat, 02 Mar 2013 02:51:24 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] [media] s5p-mfc: Staticize some symbols in s5p_mfc_cmd_v6.c
Date: Sat,  2 Mar 2013 16:11:02 +0530
Message-Id: <1362220862-29079-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since these symbols are used only in this file, they can be made static.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
index 754bfbc..5708fc3 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
@@ -17,7 +17,7 @@
 #include "s5p_mfc_intr.h"
 #include "s5p_mfc_opr.h"
 
-int s5p_mfc_cmd_host2risc_v6(struct s5p_mfc_dev *dev, int cmd,
+static int s5p_mfc_cmd_host2risc_v6(struct s5p_mfc_dev *dev, int cmd,
 				struct s5p_mfc_cmd_args *args)
 {
 	mfc_debug(2, "Issue the command: %d\n", cmd);
@@ -32,7 +32,7 @@ int s5p_mfc_cmd_host2risc_v6(struct s5p_mfc_dev *dev, int cmd,
 	return 0;
 }
 
-int s5p_mfc_sys_init_cmd_v6(struct s5p_mfc_dev *dev)
+static int s5p_mfc_sys_init_cmd_v6(struct s5p_mfc_dev *dev)
 {
 	struct s5p_mfc_cmd_args h2r_args;
 	struct s5p_mfc_buf_size_v6 *buf_size = dev->variant->buf_size->priv;
@@ -44,7 +44,7 @@ int s5p_mfc_sys_init_cmd_v6(struct s5p_mfc_dev *dev)
 					&h2r_args);
 }
 
-int s5p_mfc_sleep_cmd_v6(struct s5p_mfc_dev *dev)
+static int s5p_mfc_sleep_cmd_v6(struct s5p_mfc_dev *dev)
 {
 	struct s5p_mfc_cmd_args h2r_args;
 
@@ -53,7 +53,7 @@ int s5p_mfc_sleep_cmd_v6(struct s5p_mfc_dev *dev)
 			&h2r_args);
 }
 
-int s5p_mfc_wakeup_cmd_v6(struct s5p_mfc_dev *dev)
+static int s5p_mfc_wakeup_cmd_v6(struct s5p_mfc_dev *dev)
 {
 	struct s5p_mfc_cmd_args h2r_args;
 
@@ -63,7 +63,7 @@ int s5p_mfc_wakeup_cmd_v6(struct s5p_mfc_dev *dev)
 }
 
 /* Open a new instance and get its number */
-int s5p_mfc_open_inst_cmd_v6(struct s5p_mfc_ctx *ctx)
+static int s5p_mfc_open_inst_cmd_v6(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	struct s5p_mfc_cmd_args h2r_args;
@@ -121,7 +121,7 @@ int s5p_mfc_open_inst_cmd_v6(struct s5p_mfc_ctx *ctx)
 }
 
 /* Close instance */
-int s5p_mfc_close_inst_cmd_v6(struct s5p_mfc_ctx *ctx)
+static int s5p_mfc_close_inst_cmd_v6(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	struct s5p_mfc_cmd_args h2r_args;
-- 
1.7.4.1

