Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:39132 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab3CYFdj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 01:33:39 -0400
Received: by mail-pa0-f51.google.com with SMTP id jh10so200039pab.24
        for <linux-media@vger.kernel.org>; Sun, 24 Mar 2013 22:33:39 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com, sachin.kamat@linaro.org
Subject: [PATCH 2/2] [media] go7007: Remove unneeded version.h header include
Date: Mon, 25 Mar 2013 10:52:19 +0530
Message-Id: <1364188939-10218-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1364188939-10218-1-git-send-email-sachin.kamat@linaro.org>
References: <1364188939-10218-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

version.h header inclusion is not necessary as detected by
versioncheck.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/staging/media/go7007/go7007-v4l2.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index 24ba50e..50eb69a 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -17,7 +17,6 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/version.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
-- 
1.7.4.1

