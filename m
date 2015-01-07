Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:55960 "EHLO
	gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108AbbAGCAD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Jan 2015 21:00:03 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH] lirc_dev: avoid potential null-dereference
Date: Wed,  7 Jan 2015 03:53:37 +0200
Message-Id: <1420595617-31802-1-git-send-email-andy.shevchenko@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We have to check pointer for NULL and then dereference it.

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/media/rc/lirc_dev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 1e0545a..4de0e85 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -553,14 +553,14 @@ unsigned int lirc_dev_fop_poll(struct file *file, poll_table *wait)
 	if (!ir->attached)
 		return POLLERR;
 
-	poll_wait(file, &ir->buf->wait_poll, wait);
+	if (ir->buf) {
+		poll_wait(file, &ir->buf->wait_poll, wait);
 
-	if (ir->buf)
 		if (lirc_buffer_empty(ir->buf))
 			ret = 0;
 		else
 			ret = POLLIN | POLLRDNORM;
-	else
+	} else
 		ret = POLLERR;
 
 	dev_dbg(ir->d.dev, LOGHEAD "poll result = %d\n",
-- 
1.8.3.101.g727a46b

