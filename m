Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f194.google.com ([209.85.210.194]:32933 "EHLO
        mail-wj0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752053AbcL2Lpm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Dec 2016 06:45:42 -0500
From: Augusto Mecking Caringi <augustocaringi@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Augusto Mecking Caringi <augustocaringi@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] smiapp: Fix build warnings when !CONFIG_PM_SLEEP
Date: Thu, 29 Dec 2016 11:45:07 +0000
Message-Id: <1483011924-10787-1-git-send-email-augustocaringi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the following build warnings when CONFIG_PM is set but
CONFIG_PM_SLEEP is not:

drivers/media/i2c/smiapp/smiapp-core.c:2746:12: warning:
‘smiapp_suspend’ defined but not used [-Wunused-function]
static int smiapp_suspend(struct device *dev)
            ^
drivers/media/i2c/smiapp/smiapp-core.c:2771:12: warning: ‘smiapp_resume’
defined but not used [-Wunused-function]
static int smiapp_resume(struct device *dev)
            ^

Signed-off-by: Augusto Mecking Caringi <augustocaringi@gmail.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 59872b3..a08465e 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2741,7 +2741,7 @@ static const struct v4l2_subdev_internal_ops smiapp_internal_ops = {
  * I2C Driver
  */
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 
 static int smiapp_suspend(struct device *dev)
 {
-- 
2.7.4

