Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35415 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965046AbdEOTmy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 May 2017 15:42:54 -0400
Received: by mail-wm0-f68.google.com with SMTP id v4so31119085wmb.2
        for <linux-media@vger.kernel.org>; Mon, 15 May 2017 12:42:53 -0700 (PDT)
From: Ricardo Silva <rjpdasilva@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Ricardo Silva <rjpdasilva@gmail.com>
Subject: [PATCH 3/5] staging: media: lirc: Use __func__ for logging function name
Date: Mon, 15 May 2017 20:40:14 +0100
Message-Id: <20170515194016.10246-4-rjpdasilva@gmail.com>
In-Reply-To: <20170515194016.10246-1-rjpdasilva@gmail.com>
References: <20170515194016.10246-1-rjpdasilva@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix all checkpatch reported issues for "CHECK: Prefer using '"%s...",
__func__' to using '<func_name>', ..."

Use recommended style. Additionally, __func__ was already used in
similar cases throughout the code, so make it all consistent.

Signed-off-by: Ricardo Silva <rjpdasilva@gmail.com>
---
 drivers/staging/media/lirc/lirc_zilog.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index b33a2c820dc2..99b5858124e0 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -1212,7 +1212,7 @@ static unsigned int poll(struct file *filep, poll_table *wait)
 	struct lirc_buffer *rbuf = ir->l.rbuf;
 	unsigned int ret;
 
-	dev_dbg(ir->l.dev, "poll called\n");
+	dev_dbg(ir->l.dev, "%s called\n", __func__);
 
 	rx = get_ir_rx(ir);
 	if (!rx) {
@@ -1220,7 +1220,7 @@ static unsigned int poll(struct file *filep, poll_table *wait)
 		 * Revisit this, if our poll function ever reports writeable
 		 * status for Tx
 		 */
-		dev_dbg(ir->l.dev, "poll result = POLLERR\n");
+		dev_dbg(ir->l.dev, "%s result = POLLERR\n", __func__);
 		return POLLERR;
 	}
 
@@ -1233,7 +1233,7 @@ static unsigned int poll(struct file *filep, poll_table *wait)
 	/* Indicate what ops could happen immediately without blocking */
 	ret = lirc_buffer_empty(rbuf) ? 0 : (POLLIN | POLLRDNORM);
 
-	dev_dbg(ir->l.dev, "poll result = %s\n",
+	dev_dbg(ir->l.dev, "%s result = %s\n", __func__,
 		ret ? "POLLIN|POLLRDNORM" : "none");
 	return ret;
 }
@@ -1341,7 +1341,8 @@ static int close(struct inode *node, struct file *filep)
 	struct IR *ir = filep->private_data;
 
 	if (!ir) {
-		pr_err("ir: close: no private_data attached to the file!\n");
+		pr_err("ir: %s: no private_data attached to the file!\n",
+		       __func__);
 		return -ENODEV;
 	}
 
-- 
2.12.2
