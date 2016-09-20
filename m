Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:40590 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751539AbcITGv5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Sep 2016 02:51:57 -0400
From: Shailendra Verma <shailendra.v@samsung.com>
To: Jarod Wilson <jarod@wilsonet.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Shailendra Verma <shailendra.v@samsung.com>,
        Ravikant Sharma <ravikant.s2@samsung.com>
Cc: linux-kernel@vger.kernel.org, vidushi.koul@samsung.com
Subject: Staging: Media: Lirc - Fix possible ERR_PTR() dereferencing.
Date: Tue, 20 Sep 2016 12:21:21 +0530
Message-id: <1474354281-18962-1-git-send-email-shailendra.v@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is of course wrong to call kfree() if memdup_user() fails,
no memory was allocated and the error in the error-valued pointer
should be returned.

Reviewed-by: Ravikant Sharma <ravikant.s2@samsung.com>
Signed-off-by: Shailendra Verma <shailendra.v@samsung.com>
---
 drivers/staging/media/lirc/lirc_imon.c  | 7 ++-----
 drivers/staging/media/lirc/lirc_sasem.c | 7 ++-----
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
index 534b810..c21591b 100644
--- a/drivers/staging/media/lirc/lirc_imon.c
+++ b/drivers/staging/media/lirc/lirc_imon.c
@@ -409,11 +409,8 @@ static ssize_t vfd_write(struct file *file, const char __user *buf,
 	}
 
 	data_buf = memdup_user(buf, n_bytes);
-	if (IS_ERR(data_buf)) {
-		retval = PTR_ERR(data_buf);
-		data_buf = NULL;
-		goto exit;
-	}
+	if (IS_ERR(data_buf))
+		return PTR_ERR(data_buf);
 
 	memcpy(context->tx.data_buf, data_buf, n_bytes);
 
diff --git a/drivers/staging/media/lirc/lirc_sasem.c b/drivers/staging/media/lirc/lirc_sasem.c
index f2dca69..ba1ee86 100644
--- a/drivers/staging/media/lirc/lirc_sasem.c
+++ b/drivers/staging/media/lirc/lirc_sasem.c
@@ -387,11 +387,8 @@ static ssize_t vfd_write(struct file *file, const char __user *buf,
 	}
 
 	data_buf = memdup_user(buf, n_bytes);
-	if (IS_ERR(data_buf)) {
-		retval = PTR_ERR(data_buf);
-		data_buf = NULL;
-		goto exit;
-	}
+	if (IS_ERR(data_buf))
+		return PTR_ERR(data_buf);
 
 	memcpy(context->tx.data_buf, data_buf, n_bytes);
 
-- 
1.9.1

