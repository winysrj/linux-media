Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:36170 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbZHKMEo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2009 08:04:44 -0400
Message-ID: <4A8151A1.2020103@gmail.com>
Date: Tue, 11 Aug 2009 13:10:25 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Antoine Jacquet <royale@zerezo.com>, linux-usb@vger.kernel.org,
	linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] zr364: wrong indexes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The order of indexes is reversed

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Right?

diff --git a/drivers/media/video/zr364xx.c b/drivers/media/video/zr364xx.c
index fc976f4..2622a6e 100644
--- a/drivers/media/video/zr364xx.c
+++ b/drivers/media/video/zr364xx.c
@@ -695,7 +695,7 @@ static int zr364xx_release(struct file *file)
 	for (i = 0; i < 2; i++) {
 		err =
 		    send_control_msg(udev, 1, init[cam->method][i].value,
-				     0, init[i][cam->method].bytes,
+				     0, init[cam->method][i].bytes,
 				     init[cam->method][i].size);
 		if (err < 0) {
 			dev_err(&udev->dev, "error during release sequence\n");
