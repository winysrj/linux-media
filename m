Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:56762 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752528AbcKJKBG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Nov 2016 05:01:06 -0500
From: Shailendra Verma <shailendra.v@samsung.com>
To: Jarod Wilson <jarod@wilsonet.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Shailendra Verma <shailendra.v@samsung.com>,
        Shailendra Verma <shailendra.capricorn@gmail.com>
Cc: linux-kernel@vger.kernel.org, vidushi.koul@samsung.com
Subject: [PATCH] Staging: Media: Lirc - Improvement in code readability
Date: Thu, 10 Nov 2016 15:28:38 +0530
Message-id: <1478771918-1690-1-git-send-email-shailendra.v@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Shailendra Verma" <shailendra.v@samsung.com>

There is no need to call kfree() if memdup_user() fails, as no memory
was allocated and the error in the error-valued pointer should be returned.

Signed-off-by: Shailendra Verma <shailendra.v@samsung.com>
---
 drivers/staging/media/lirc/lirc_imon.c  |    5 ++---
 drivers/staging/media/lirc/lirc_sasem.c |    5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
index 198a805..610d38c 100644
--- a/drivers/staging/media/lirc/lirc_imon.c
+++ b/drivers/staging/media/lirc/lirc_imon.c
@@ -408,9 +408,8 @@ static ssize_t vfd_write(struct file *file, const char __user *buf,
 
 	data_buf = memdup_user(buf, n_bytes);
 	if (IS_ERR(data_buf)) {
-		retval = PTR_ERR(data_buf);
-		data_buf = NULL;
-		goto exit;
+		mutex_unlock(&context->ctx_lock);
+		return PTR_ERR(data_buf);
 	}
 
 	memcpy(context->tx.data_buf, data_buf, n_bytes);
diff --git a/drivers/staging/media/lirc/lirc_sasem.c b/drivers/staging/media/lirc/lirc_sasem.c
index 4678ae1..4fd810b 100644
--- a/drivers/staging/media/lirc/lirc_sasem.c
+++ b/drivers/staging/media/lirc/lirc_sasem.c
@@ -384,9 +384,8 @@ static ssize_t vfd_write(struct file *file, const char __user *buf,
 
 	data_buf = memdup_user(buf, n_bytes);
 	if (IS_ERR(data_buf)) {
-		retval = PTR_ERR(data_buf);
-		data_buf = NULL;
-		goto exit;
+		mutex_unlock(&context->ctx_lock);
+		return PTR_ERR(data_buf);
 	}
 
 	memcpy(context->tx.data_buf, data_buf, n_bytes);
-- 
1.7.9.5

