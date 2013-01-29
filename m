Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:48295 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab3A2Glf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 01:41:35 -0500
Received: by mail-pa0-f52.google.com with SMTP id kp6so200051pab.11
        for <linux-media@vger.kernel.org>; Mon, 28 Jan 2013 22:41:34 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: sachin.kamat@linaro.org, a.hajda@samsung.com,
	s.nawrocki@samsung.com
Subject: [PATCH 1/1] [media] s5c73m3: Staticize some symbols
Date: Tue, 29 Jan 2013 12:02:30 +0530
Message-Id: <1359441150-25872-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following sparse warnings:
drivers/media/i2c/s5c73m3/s5c73m3-core.c:42:5: warning:
symbol 'boot_from_rom' was not declared. Should it be static?
drivers/media/i2c/s5c73m3/s5c73m3-core.c:45:5: warning:
symbol 'update_fw' was not declared. Should it be static?
drivers/media/i2c/s5c73m3/s5c73m3-core.c:298:5: warning:
symbol 's5c73m3_isp_comm_result' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/i2c/s5c73m3/s5c73m3-core.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index 600909d..b063b4d 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -39,10 +39,10 @@
 int s5c73m3_dbg;
 module_param_named(debug, s5c73m3_dbg, int, 0644);
 
-int boot_from_rom = 1;
+static int boot_from_rom = 1;
 module_param(boot_from_rom, int, 0644);
 
-int update_fw;
+static int update_fw;
 module_param(update_fw, int, 0644);
 
 #define S5C73M3_EMBEDDED_DATA_MAXLEN	SZ_4K
@@ -295,7 +295,8 @@ int s5c73m3_isp_command(struct s5c73m3 *state, u16 command, u16 data)
 	return s5c73m3_write(state, REG_STATUS, 0x0001);
 }
 
-int s5c73m3_isp_comm_result(struct s5c73m3 *state, u16 command, u16 *data)
+static int s5c73m3_isp_comm_result(struct s5c73m3 *state, u16 command,
+				   u16 *data)
 {
 	return s5c73m3_read(state, COMM_RESULT_OFFSET + command, data);
 }
-- 
1.7.4.1

