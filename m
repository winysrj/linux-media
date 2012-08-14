Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:26639 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab2HNG7P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 02:59:15 -0400
Date: Tue, 14 Aug 2012 09:58:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tomasz =?utf-8?Q?Mo=C5=84?= <desowin@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] mem2mem_testdev: unlock and return error code
 properly
Message-ID: <20120814065856.GC4791@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We recently added locking to this function, but there was an error path
which accidentally returned holding a lock.  Also we returned zero on
failure on some paths instead of the error code.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Applies to linux-next.

diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/video/mem2mem_testdev.c
index 0aa8c47..0b496f3 100644
--- a/drivers/media/video/mem2mem_testdev.c
+++ b/drivers/media/video/mem2mem_testdev.c
@@ -911,10 +911,9 @@ static int m2mtest_open(struct file *file)
 	v4l2_ctrl_new_custom(hdl, &m2mtest_ctrl_trans_time_msec, NULL);
 	v4l2_ctrl_new_custom(hdl, &m2mtest_ctrl_trans_num_bufs, NULL);
 	if (hdl->error) {
-		int err = hdl->error;
-
+		rc = hdl->error;
 		v4l2_ctrl_handler_free(hdl);
-		return err;
+		goto open_unlock;
 	}
 	ctx->fh.ctrl_handler = hdl;
 	v4l2_ctrl_handler_setup(hdl);
@@ -946,7 +945,7 @@ static int m2mtest_open(struct file *file)
 
 open_unlock:
 	mutex_unlock(&dev->dev_mutex);
-	return 0;
+	return rc;
 }
 
 static int m2mtest_release(struct file *file)
