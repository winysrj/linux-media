Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:44684 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759565AbZEBUwx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 May 2009 16:52:53 -0400
Received: by ewy24 with SMTP id 24so3004844ewy.37
        for <linux-media@vger.kernel.org>; Sat, 02 May 2009 13:52:52 -0700 (PDT)
Message-ID: <49FCB2A4.2000609@gmail.com>
Date: Sat, 02 May 2009 22:52:52 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: hverkuil@xs4all.nl
CC: linux-media@vger.kernel.org, mjpeg-users@lists.sourceforge.net,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] zoran: Fix &&/|| typo
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix &&/|| typo

diff --git a/drivers/media/video/zoran/zoran_card.c b/drivers/media/video/zoran/zoran_card.c
index ea6c577..ea9de8b 100644
--- a/drivers/media/video/zoran/zoran_card.c
+++ b/drivers/media/video/zoran/zoran_card.c
@@ -1022,7 +1022,7 @@ zr36057_init (struct zoran *zr)
 	zr->vbuf_bytesperline = 0;
 
 	/* Avoid nonsense settings from user for default input/norm */
-	if (default_norm < 0 && default_norm > 2)
+	if (default_norm < 0 || default_norm > 2)
 		default_norm = 0;
 	if (default_norm == 0) {
 		zr->norm = V4L2_STD_PAL;
