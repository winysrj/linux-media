Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:35717 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbbHEHB7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Aug 2015 03:01:59 -0400
Received: by oihn130 with SMTP id n130so17908849oih.2
        for <linux-media@vger.kernel.org>; Wed, 05 Aug 2015 00:01:58 -0700 (PDT)
From: Pradheep Shrinivasan <pradheep.sh@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	Pradheep Shrinivasan <pradheep.sh@gmail.com>
Subject: [PATCH 1/2] staging: media: lirc Remove the extra braces in if
Date: Wed,  5 Aug 2015 02:01:51 -0500
Message-Id: <1438758112-12501-1-git-send-email-pradheep.sh@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patche removes the extra braces found in
drivers/staging/media/lirc/lirc_imon.c to fix the warning thrown by
checkpatch.pl

Signed-off-by: Pradheep Shrinivasan <pradheep.sh@gmail.com>
---
 drivers/staging/media/lirc/lirc_imon.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
index 62ec9f7..05d47dc 100644
--- a/drivers/staging/media/lirc/lirc_imon.c
+++ b/drivers/staging/media/lirc/lirc_imon.c
@@ -785,13 +785,13 @@ static int imon_probe(struct usb_interface *interface,
 	}
 
 	driver = kzalloc(sizeof(struct lirc_driver), GFP_KERNEL);
-	if (!driver) {
+	if (!driver)
 		goto free_context;
-	}
+
 	rbuf = kmalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
-	if (!rbuf) {
+	if (!rbuf)
 		goto free_driver;
-	}
+
 	if (lirc_buffer_init(rbuf, BUF_CHUNK_SIZE, BUF_SIZE)) {
 		dev_err(dev, "%s: lirc_buffer_init failed\n", __func__);
 		goto free_rbuf;
-- 
1.9.1

