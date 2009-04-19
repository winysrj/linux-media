Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:39198 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580AbZDSUVI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Apr 2009 16:21:08 -0400
Received: by fxm2 with SMTP id 2so1655284fxm.37
        for <linux-media@vger.kernel.org>; Sun, 19 Apr 2009 13:21:06 -0700 (PDT)
Subject: [patch review] av7110_hw: fix compile warning
From: Alexey Klimov <klimov.linux@gmail.com>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Mon, 20 Apr 2009 00:21:03 +0400
Message-Id: <1240172463.12537.7.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

One more warning fix.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>
--
diff -r cda79523a93c linux/drivers/media/dvb/ttpci/av7110_hw.c
--- a/linux/drivers/media/dvb/ttpci/av7110_hw.c	Thu Apr 16 18:30:38 2009 +0200
+++ b/linux/drivers/media/dvb/ttpci/av7110_hw.c	Mon Apr 20 00:17:51 2009 +0400
@@ -1089,7 +1089,7 @@
 		else {
 			int i, len = dc->x0-dc->color+1;
 			u8 __user *colors = (u8 __user *)dc->data;
-			u8 r, g, b, blend;
+			u8 r, g = 0, b = 0, blend = 0;
 			ret = 0;
 			for (i = 0; i<len; i++) {
 				if (get_user(r, colors + i * 4) ||



-- 
Best regards, Klimov Alexey

