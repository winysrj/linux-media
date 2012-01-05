Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:36985 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab2AEGYM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 01:24:12 -0500
Date: Thu, 5 Jan 2012 09:24:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] saa7134: use correct array offset
Message-ID: <20120105062400.GB25744@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Smatch complains that i can be one passed the end of the array if we
don't hit the break statement.  We should be using the "audio" here like
we do in the other places.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Compile tested only.  Please review carefully.

diff --git a/drivers/media/video/saa7134/saa7134-tvaudio.c b/drivers/media/video/saa7134/saa7134-tvaudio.c
index ec1df6f..b7a99be 100644
--- a/drivers/media/video/saa7134/saa7134-tvaudio.c
+++ b/drivers/media/video/saa7134/saa7134-tvaudio.c
@@ -605,7 +605,7 @@ static int tvaudio_thread(void *data)
 			if (kthread_should_stop())
 				break;
 			if (UNSET == dev->thread.mode) {
-				rx = tvaudio_getstereo(dev,&tvaudio[i]);
+				rx = tvaudio_getstereo(dev, &tvaudio[audio]);
 				mode = saa7134_tvaudio_rx2mode(rx);
 			} else {
 				mode = dev->thread.mode;
