Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34334 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727523AbeHHRNB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2018 13:13:01 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 2/6] media: saa7164: fix return codes for the polling routine
Date: Wed,  8 Aug 2018 10:52:52 -0400
Message-Id: <899042a97eedf25c7d648d80f8b6d5dfbcb837e5.1533739965.git.mchehab+samsung@kernel.org>
In-Reply-To: <577a6299b1881c011bb82adb8a321ce72599a33c.1533739965.git.mchehab+samsung@kernel.org>
References: <577a6299b1881c011bb82adb8a321ce72599a33c.1533739965.git.mchehab+samsung@kernel.org>
In-Reply-To: <577a6299b1881c011bb82adb8a321ce72599a33c.1533739965.git.mchehab+samsung@kernel.org>
References: <577a6299b1881c011bb82adb8a321ce72599a33c.1533739965.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All poll handlers should return a poll flag, and not error codes. So,
instead of returning an error, do the right thing at saa7164,
e. g. to return EPOLERR on errors, just like the V4L2 VB2 code.

Solves the following sparse warnings:
    drivers/media/pci/saa7164/saa7164-vbi.c:632:24: warning: incorrect type in return expression (different base types)
    drivers/media/pci/saa7164/saa7164-vbi.c:632:24:    expected restricted __poll_t
    drivers/media/pci/saa7164/saa7164-vbi.c:632:24:    got int
    drivers/media/pci/saa7164/saa7164-vbi.c:637:40: warning: incorrect type in return expression (different base types)
    drivers/media/pci/saa7164/saa7164-vbi.c:637:40:    expected restricted __poll_t
    drivers/media/pci/saa7164/saa7164-vbi.c:637:40:    got int
    drivers/media/pci/saa7164/saa7164-vbi.c:647:40: warning: incorrect type in return expression (different base types)
    drivers/media/pci/saa7164/saa7164-vbi.c:647:40:    expected restricted __poll_t
    drivers/media/pci/saa7164/saa7164-vbi.c:647:40:    got int

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/pci/saa7164/saa7164-vbi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-vbi.c b/drivers/media/pci/saa7164/saa7164-vbi.c
index 64ab91c24c18..221de91a8bae 100644
--- a/drivers/media/pci/saa7164/saa7164-vbi.c
+++ b/drivers/media/pci/saa7164/saa7164-vbi.c
@@ -629,12 +629,12 @@ static __poll_t fops_poll(struct file *file, poll_table *wait)
 		port->last_poll_msecs_diff);
 
 	if (!video_is_registered(port->v4l_device))
-		return -EIO;
+		return EPOLLERR;
 
 	if (atomic_cmpxchg(&fh->v4l_reading, 0, 1) == 0) {
 		if (atomic_inc_return(&port->v4l_reader_count) == 1) {
 			if (saa7164_vbi_initialize(port) < 0)
-				return -EINVAL;
+				return EPOLLERR;
 			saa7164_vbi_start_streaming(port);
 			msleep(200);
 		}
@@ -644,7 +644,7 @@ static __poll_t fops_poll(struct file *file, poll_table *wait)
 	if ((file->f_flags & O_NONBLOCK) == 0) {
 		if (wait_event_interruptible(port->wait_read,
 			saa7164_vbi_next_buf(port))) {
-				return -ERESTARTSYS;
+				return EPOLLERR;
 		}
 	}
 
-- 
2.17.1
