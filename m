Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:40585 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082AbbCBPWi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2015 10:22:38 -0500
Received: by wesx3 with SMTP id x3so33990520wes.7
        for <linux-media@vger.kernel.org>; Mon, 02 Mar 2015 07:22:37 -0800 (PST)
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: linux-media@vger.kernel.org
Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] media: i2c: ths7303: drop module param debug
Date: Mon,  2 Mar 2015 15:22:19 +0000
Message-Id: <1425309739-29325-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch drops module param 'debug' as it was never used.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/i2c/ths7303.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/i2c/ths7303.c b/drivers/media/i2c/ths7303.c
index ed9ae88..9f7fdb6 100644
--- a/drivers/media/i2c/ths7303.c
+++ b/drivers/media/i2c/ths7303.c
@@ -52,10 +52,6 @@ MODULE_DESCRIPTION("TI THS7303 video amplifier driver");
 MODULE_AUTHOR("Chaithrika U S");
 MODULE_LICENSE("GPL");
 
-static int debug;
-module_param(debug, int, 0644);
-MODULE_PARM_DESC(debug, "Debug level 0-1");
-
 static inline struct ths7303_state *to_state(struct v4l2_subdev *sd)
 {
 	return container_of(sd, struct ths7303_state, sd);
-- 
1.9.1

