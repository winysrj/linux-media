Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:63578 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab3CYFdh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 01:33:37 -0400
Received: by mail-pa0-f54.google.com with SMTP id fa10so834980pad.13
        for <linux-media@vger.kernel.org>; Sun, 24 Mar 2013 22:33:36 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com, sachin.kamat@linaro.org
Subject: [PATCH 1/2] [media] tw9906: Remove unneeded version.h header include
Date: Mon, 25 Mar 2013 10:52:18 +0530
Message-Id: <1364188939-10218-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

version.h header inclusion is not necessary as detected by
versioncheck.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/i2c/tw9906.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/i2c/tw9906.c b/drivers/media/i2c/tw9906.c
index 2263a91..d94325b 100644
--- a/drivers/media/i2c/tw9906.c
+++ b/drivers/media/i2c/tw9906.c
@@ -17,7 +17,6 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/version.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <linux/ioctl.h>
-- 
1.7.4.1

