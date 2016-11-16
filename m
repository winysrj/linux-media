Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57066 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934094AbcKPJFY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 04:05:24 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Inki Dae <inki.dae@samsung.com>
Subject: [PATCH 2/9] s5p-mfc: Use printk_ratelimited for reporting ioctl errors
Date: Wed, 16 Nov 2016 10:04:51 +0100
Message-id: <1479287098-30493-3-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1479287098-30493-1-git-send-email-m.szyprowski@samsung.com>
References: <1479287098-30493-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20161116090518eucas1p17c506d8c8282f852cb3f4f10c5f82fa0@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some applications doesn't check error codes from QBUF/DQBUF ioctls, so
don't spam kernel log with errors if they fall into endless loop
trying to queue next buffer after a failure.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_debug.h | 6 ++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c   | 2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c   | 2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_debug.h b/drivers/media/platform/s5p-mfc/s5p_mfc_debug.h
index 5936923c631c..1936a5b868f5 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_debug.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_debug.h
@@ -39,6 +39,12 @@
 		       __func__, __LINE__, ##args);	\
 	} while (0)
 
+#define mfc_err_limited(fmt, args...)			\
+	do {						\
+		printk_ratelimited(KERN_ERR "%s:%d: " fmt,	\
+		       __func__, __LINE__, ##args);	\
+	} while (0)
+
 #define mfc_info(fmt, args...)				\
 	do {						\
 		printk(KERN_INFO "%s:%d: " fmt,		\
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 52081ddc9bf2..47aceacee169 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -642,7 +642,7 @@ static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 	int ret;
 
 	if (ctx->state == MFCINST_ERROR) {
-		mfc_err("Call on DQBUF after unrecoverable error\n");
+		mfc_err_limited("Call on DQBUF after unrecoverable error\n");
 		return -EIO;
 	}
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index fcc2e054c61f..e39d9e06e299 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1268,7 +1268,7 @@ static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 	int ret;
 
 	if (ctx->state == MFCINST_ERROR) {
-		mfc_err("Call on DQBUF after unrecoverable error\n");
+		mfc_err_limited("Call on DQBUF after unrecoverable error\n");
 		return -EIO;
 	}
 	if (buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-- 
1.9.1

