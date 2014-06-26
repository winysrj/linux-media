Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.222.116]:41018 "EHLO
	kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbaFZOYD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jun 2014 10:24:03 -0400
Message-ID: <53AC2ACA.7080106@soulik.info>
Date: Thu, 26 Jun 2014 22:14:34 +0800
From: ayaka <ayaka@soulik.info>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: kyungmin.park@samsung.com, jtp.park@samsung.com,
	m.chehab@samsung.com
Subject: [PATCH] s5p-mfc: encoder could free buffers
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[PATCH] s5p-mfc: encoder could free buffers

The patch is necessary or the buffers could be freeed but
it would break the state of encoder in s5p-mfc. It is also need
by some application which would detect the buffer allocation
way, like gstreamer.
---
drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 8 ++++++++
1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index d26b248..1a7518f 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1166,6 +1166,10 @@ static int vidioc_reqbufs(struct file *file, void
*priv,
mfc_err("error in vb2_reqbufs() for E(D)\n");
return ret;
}
+ if (reqbufs->count == 0) {
+ mfc_debug(2, "Freeing buffers\n");
+ return ret;
+ }
ctx->capture_state = QUEUE_BUFS_REQUESTED;

ret = s5p_mfc_hw_call(ctx->dev->mfc_ops,
@@ -1200,6 +1204,10 @@ static int vidioc_reqbufs(struct file *file, void
*priv,
mfc_err("error in vb2_reqbufs() for E(S)\n");
return ret;
}
+ if (reqbufs->count == 0) {
+ mfc_debug(2, "Freeing buffers\n");
+ return ret;
+ }
ctx->output_state = QUEUE_BUFS_REQUESTED;
} else {
mfc_err("invalid buf type\n");
-- 
1.9.1

