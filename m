Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpbgbr2.qq.com ([54.207.22.56]:39332 "EHLO smtpbgbr2.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750797AbdE1SHR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 14:07:17 -0400
From: Chen Guanqiao <chen.chenchacha@foxmail.com>
To: mchehab@kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, alan@linux.intel.com,
        fengguang.wu@intel.com, linux-kernel@vger.kernel.org,
        Chen Guanqiao <chen.chenchacha@foxmail.com>
Subject: [PATCH] staging: atomisp: lm3554: fix sparse warnings(was not declared. Should it be static?)
Date: Mon, 29 May 2017 02:06:41 +0800
Message-Id: <20170528180641.9152-1-chen.chenchacha@foxmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix "symbol 'xxxxxxx' was not declared. Should it be static?" sparse warnings.

Signed-off-by: Chen Guanqiao <chen.chenchacha@foxmail.com>
---
 drivers/staging/media/atomisp/i2c/lm3554.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/lm3554.c b/drivers/staging/media/atomisp/i2c/lm3554.c
index dd9c9c3ffff7..2b170c07aaba 100644
--- a/drivers/staging/media/atomisp/i2c/lm3554.c
+++ b/drivers/staging/media/atomisp/i2c/lm3554.c
@@ -497,7 +497,7 @@ static const struct v4l2_ctrl_ops ctrl_ops = {
 	.g_volatile_ctrl = lm3554_g_volatile_ctrl
 };
 
-struct v4l2_ctrl_config lm3554_controls[] = {
+static const struct v4l2_ctrl_config lm3554_controls[] = {
 	{
 	 .ops = &ctrl_ops,
 	 .id = V4L2_CID_FLASH_TIMEOUT,
@@ -825,7 +825,7 @@ static int lm3554_gpio_uninit(struct i2c_client *client)
 	return 0;
 }
 
-void *lm3554_platform_data_func(struct i2c_client *client)
+static void *lm3554_platform_data_func(struct i2c_client *client)
 {
 	static struct lm3554_platform_data platform_data;
 
-- 
2.11.0
