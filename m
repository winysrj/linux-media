Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0156.hostedemail.com ([216.40.44.156]:42169 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751712AbdFITJL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Jun 2017 15:09:11 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: [PATCH] [media] tuner-core: Remove unused #define PREFIX
Date: Fri,  9 Jun 2017 12:09:08 -0700
Message-Id: <5d4be46cffe2f223b24b6b1c4b84cf3297433151.1497035313.git.joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 680d87c0a9e3 ("[media] tuner-core: use pr_foo, instead of
internal printk macros") removed the use of PREFIX, remove the #define

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/v4l2-core/tuner-core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index e48b7c032c95..8db45dfc271b 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -43,8 +43,6 @@
 
 #define UNSET (-1U)
 
-#define PREFIX (t->i2c->dev.driver->name)
-
 /*
  * Driver modprobe parameters
  */
-- 
2.10.0.rc2.1.g053435c
