Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33114 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754369AbcLSRBw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Dec 2016 12:01:52 -0500
From: Santosh Kumar Singh <kumar.san1093@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Santosh Kumar Singh <kumar.san1093@gmail.com>
Subject: [PATCH] tm6000: Clean up file handle in open() error path.
Date: Mon, 19 Dec 2016 22:27:11 +0530
Message-Id: <1482166631-4025-1-git-send-email-kumar.san1093@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix to avoid possible memory leak and exit file handle
in error paths.

Signed-off-by: Santosh Kumar Singh <kumar.san1093@gmail.com>
---
 drivers/media/usb/tm6000/tm6000-video.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index dee7e7d..b39247a 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -1377,8 +1377,11 @@ static int __tm6000_open(struct file *file)
 
 	/* initialize hardware on analog mode */
 	rc = tm6000_init_analog_mode(dev);
-	if (rc < 0)
+	if (rc < 0) {
+		v4l2_fh_exit(&fh->fh);
+		kfree(fh);
 		return rc;
+	}
 
 	dev->mode = TM6000_MODE_ANALOG;
 
-- 
1.9.1

