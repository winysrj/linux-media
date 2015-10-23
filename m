Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35613 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbbJWGgS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2015 02:36:18 -0400
From: Nilesh Kokane <nilesh.kokane05@gmail.com>
To: mchehab@osg.samsung.com
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	suneel.raikar@gmail.com, Nilesh Kokane <Nilesh.Kokane05@gmail.com>
Subject: [PATCH] Staging: media: lirc Braces not needed for single statement
Date: Fri, 23 Oct 2015 12:06:01 +0530
Message-Id: <1445582161-6840-1-git-send-email-Nilesh.Kokane05@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed the braces issue for single statement.

Signed-off-by: Nilesh Kokane <Nilesh.Kokane05@gmail.com>
---
 drivers/staging/media/lirc/lirc_imon.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
index 62ec9f7..a6cae49 100644
--- a/drivers/staging/media/lirc/lirc_imon.c
+++ b/drivers/staging/media/lirc/lirc_imon.c
@@ -785,13 +785,11 @@ static int imon_probe(struct usb_interface *interface,
 	}
 
 	driver = kzalloc(sizeof(struct lirc_driver), GFP_KERNEL);
-	if (!driver) {
+	if (!driver)
 		goto free_context;
-	}
 	rbuf = kmalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
-	if (!rbuf) {
+	if (!rbuf)
 		goto free_driver;
-	}
 	if (lirc_buffer_init(rbuf, BUF_CHUNK_SIZE, BUF_SIZE)) {
 		dev_err(dev, "%s: lirc_buffer_init failed\n", __func__);
 		goto free_rbuf;
-- 
1.9.1

