Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55254 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759142AbaKANjG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Nov 2014 09:39:06 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 5/7] [media] cx25840: convert max_buf_size var to lowercase
Date: Sat,  1 Nov 2014 11:38:57 -0200
Message-Id: <ed64250c23ea1c5249674c3ffb50b7d8b79b1561.1414849031.git.mchehab@osg.samsung.com>
In-Reply-To: <1414849139-29609-1-git-send-email-mchehab@osg.samsung.com>
References: <1414849139-29609-1-git-send-email-mchehab@osg.samsung.com>
In-Reply-To: <cover.1414849031.git.mchehab@osg.samsung.com>
References: <cover.1414849031.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CodingStyle fix: vars should be in lowercase.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/i2c/cx25840/cx25840-firmware.c b/drivers/media/i2c/cx25840/cx25840-firmware.c
index 6092bf71300f..9bbb31adc29d 100644
--- a/drivers/media/i2c/cx25840/cx25840-firmware.c
+++ b/drivers/media/i2c/cx25840/cx25840-firmware.c
@@ -113,7 +113,7 @@ int cx25840_loadfw(struct i2c_client *client)
 	const u8 *ptr;
 	const char *fwname = get_fw_name(client);
 	int size, retval;
-	int MAX_BUF_SIZE = FWSEND;
+	int max_buf_size = FWSEND;
 	u32 gpio_oe = 0, gpio_da = 0;
 
 	if (is_cx2388x(state)) {
@@ -123,8 +123,8 @@ int cx25840_loadfw(struct i2c_client *client)
 	}
 
 	/* cx231xx cannot accept more than 16 bytes at a time */
-	if (is_cx231xx(state) && MAX_BUF_SIZE > 16)
-		MAX_BUF_SIZE = 16;
+	if (is_cx231xx(state) && max_buf_size > 16)
+		max_buf_size = 16;
 
 	if (request_firmware(&fw, fwname, FWDEV(client)) != 0) {
 		v4l_err(client, "unable to open firmware %s\n", fwname);
@@ -139,7 +139,7 @@ int cx25840_loadfw(struct i2c_client *client)
 	size = fw->size;
 	ptr = fw->data;
 	while (size > 0) {
-		int len = min(MAX_BUF_SIZE - 2, size);
+		int len = min(max_buf_size - 2, size);
 
 		memcpy(buffer + 2, ptr, len);
 
-- 
1.9.3

