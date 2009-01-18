Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f12.google.com ([209.85.219.12]:41209 "EHLO
	mail-ew0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761674AbZAROzS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jan 2009 09:55:18 -0500
Received: by ewy5 with SMTP id 5so562270ewy.13
        for <linux-media@vger.kernel.org>; Sun, 18 Jan 2009 06:55:15 -0800 (PST)
Message-ID: <497342D3.7050903@gmail.com>
Date: Sun, 18 Jan 2009 15:55:15 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: mchehab@redhat.com
CC: linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: [PATCH] V4L/DVB: make card signed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Is this correct?
--------------->8----------8<----------------
make card signed

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index ef9bf00..7c7a96c 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -47,7 +47,7 @@ static unsigned int disable_ir;
 module_param(disable_ir, int, 0444);
 MODULE_PARM_DESC(disable_ir, "disable infrared remote support");
 
-static unsigned int card[]     = {[0 ... (EM28XX_MAXBOARDS - 1)] = UNSET };
+static int card[]     = {[0 ... (EM28XX_MAXBOARDS - 1)] = UNSET };
 module_param_array(card,  int, NULL, 0444);
 MODULE_PARM_DESC(card,     "card type");
 
