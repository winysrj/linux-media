Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:45843 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab3CZFpx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 01:45:53 -0400
Received: by mail-bk0-f43.google.com with SMTP id jm19so3170866bkc.30
        for <linux-media@vger.kernel.org>; Mon, 25 Mar 2013 22:45:51 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 26 Mar 2013 13:45:51 +0800
Message-ID: <CAPgLHd99aV5rzjpOVUvWMK9PNJtxeqfmezv9XSzMU4rXVdg85g@mail.gmail.com>
Subject: [PATCH -next] [media] go7007: remove unused including <linux/version.h>
From: Wei Yongjun <weiyj.lk@gmail.com>
To: hans.verkuil@cisco.com, mchehab@redhat.com,
	gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove including <linux/version.h> that don't need it.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/media/go7007/go7007-v4l2.c | 1 -
 1 file changed, 1 deletion(-)

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


