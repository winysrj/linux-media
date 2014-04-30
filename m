Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:45495 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759165AbaD3P6V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Apr 2014 11:58:21 -0400
Received: by mail-pd0-f177.google.com with SMTP id v10so1939888pde.36
        for <linux-media@vger.kernel.org>; Wed, 30 Apr 2014 08:58:20 -0700 (PDT)
From: Masanari Iida <standby24x7@gmail.com>
To: m.chehab@samsung.com, linux-media@vger.kernel.org,
	hverkuil@xs4all.nl
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] media: parport: Fix format string mismatch in bw-qcam.c
Date: Thu,  1 May 2014 00:57:50 +0900
Message-Id: <1398873470-3740-1-git-send-email-standby24x7@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix format string mismatch in bw-qcam.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/media/parport/bw-qcam.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/parport/bw-qcam.c b/drivers/media/parport/bw-qcam.c
index 8a0e84c..416507a 100644
--- a/drivers/media/parport/bw-qcam.c
+++ b/drivers/media/parport/bw-qcam.c
@@ -937,7 +937,7 @@ static struct qcam *qcam_init(struct parport *port)
 		return NULL;
 
 	v4l2_dev = &qcam->v4l2_dev;
-	snprintf(v4l2_dev->name, sizeof(v4l2_dev->name), "bw-qcam%d", num_cams);
+	snprintf(v4l2_dev->name, sizeof(v4l2_dev->name), "bw-qcam%u", num_cams);
 
 	if (v4l2_device_register(port->dev, v4l2_dev) < 0) {
 		v4l2_err(v4l2_dev, "Could not register v4l2_device\n");
-- 
2.0.0.rc1

