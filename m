Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43833 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab0KQFMt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 00:12:49 -0500
Date: Wed, 17 Nov 2010 08:12:23 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jarod Wilson <jarod@redhat.com>,
	Zimny Lech <napohybelskurwysynom2010@gmail.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 1/3] [media] lirc_dev: stray unlock in lirc_dev_fop_poll()
Message-ID: <20101117051223.GD31724@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

We shouldn't unlock here.  I think this was a cut and paste error.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/IR/lirc_dev.c b/drivers/media/IR/lirc_dev.c
index 8418b14..8ab9d87 100644
--- a/drivers/media/IR/lirc_dev.c
+++ b/drivers/media/IR/lirc_dev.c
@@ -522,10 +522,8 @@ unsigned int lirc_dev_fop_poll(struct file *file, poll_table *wait)
 
 	dev_dbg(ir->d.dev, LOGHEAD "poll called\n", ir->d.name, ir->d.minor);
 
-	if (!ir->attached) {
-		mutex_unlock(&ir->irctl_lock);
+	if (!ir->attached)
 		return POLLERR;
-	}
 
 	poll_wait(file, &ir->buf->wait_poll, wait);
 
