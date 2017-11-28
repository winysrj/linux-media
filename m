Return-path: <linux-media-owner@vger.kernel.org>
Received: from wp215.webpack.hosteurope.de ([80.237.132.222]:54416 "EHLO
        wp215.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751976AbdK1Rrs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Nov 2017 12:47:48 -0500
Subject: [PATCH Resend] staging: media: lirc: style fix - replace hard-coded
 function names
From: Martin Homuth <martin@martinhomuth.de>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
References: <8bfec3aa-8f12-365c-9cf2-10d97f54adec@martinhomuth.de>
Message-ID: <671e53b1-5cfd-ee34-1680-e7c5f1722137@martinhomuth.de>
Date: Tue, 28 Nov 2017 18:47:08 +0100
MIME-Version: 1.0
In-Reply-To: <8bfec3aa-8f12-365c-9cf2-10d97f54adec@martinhomuth.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes the remaining coding style warnings in the lirc module.
Instead of hard coding the function name the __func__ variable
should be used.

It fixes the following checkpatch.pl warning:

WARNING: Prefer using '"%s...", __func__' to using 'read', this
function's name, in a string

Signed-off-by: Martin Homuth <martin@martinhomuth.de>
---
 drivers/staging/media/lirc/lirc_zilog.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_zilog.c
b/drivers/staging/media/lirc/lirc_zilog.c
index 6bd0717bf76e..be68ee652071 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -888,9 +888,9 @@ static ssize_t read(struct file *filep, char __user
*outbuf, size_t n,
 	unsigned int m;
 	DECLARE_WAITQUEUE(wait, current);

-	dev_dbg(ir->dev, "read called\n");
+	dev_dbg(ir->dev, "%s called\n", __func__);
 	if (n % rbuf->chunk_size) {
-		dev_dbg(ir->dev, "read result = -EINVAL\n");
+		dev_dbg(ir->dev, "%s result = -EINVAL\n", __func__);
 		return -EINVAL;
 	}

@@ -949,7 +949,7 @@ static ssize_t read(struct file *filep, char __user
*outbuf, size_t n,
 				retries++;
 			}
 			if (retries >= 5) {
-				dev_err(ir->dev, "Buffer read failed!\n");
+				dev_err(ir->dev, "%s failed!\n", __func__);
 				ret = -EIO;
 			}
 		}
@@ -959,7 +959,7 @@ static ssize_t read(struct file *filep, char __user
*outbuf, size_t n,
 	put_ir_rx(rx, false);
 	set_current_state(TASK_RUNNING);

-	dev_dbg(ir->dev, "read result = %d (%s)\n", ret,
+	dev_dbg(ir->dev, "%s result = %d (%s)\n", __func__, ret,
 		ret ? "Error" : "OK");

 	return ret ? ret : written;
-- 
2.13.6
