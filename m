Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60720 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab3KBQdj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Nov 2013 12:33:39 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCHv2 29/29] lirc_zilog: Don't use dynamic static allocation
Date: Sat,  2 Nov 2013 11:31:37 -0200
Message-Id: <1383399097-11615-30-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dynamic static allocation is evil, as Kernel stack is too low, and
ompilation complains about it on some archs:

	drivers/staging/media/lirc/lirc_zilog.c:967:1: warning: 'read' uses dynamic stack allocation [enabled by default]

Instead, let's enforce a limit for the buffer to be 80. That should
be more than enough.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/staging/media/lirc/lirc_zilog.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index 11d5338b4f2f..9bcd52a962d4 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -941,7 +941,14 @@ static ssize_t read(struct file *filep, char *outbuf, size_t n, loff_t *ppos)
 			schedule();
 			set_current_state(TASK_INTERRUPTIBLE);
 		} else {
-			unsigned char buf[rbuf->chunk_size];
+			unsigned char buf[80];
+
+			if (rbuf->chunk_size > sizeof(buf)) {
+				zilog_error("chunk_size is too big (%d)!\n",
+					    rbuf->chunk_size);
+				ret = -EIO;
+				break;
+			}
 			m = lirc_buffer_read(rbuf, buf);
 			if (m == rbuf->chunk_size) {
 				ret = copy_to_user((void *)outbuf+written, buf,
-- 
1.8.3.1

