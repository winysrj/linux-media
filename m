Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay01.digicable.hu ([92.249.128.189]:56377 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab0CAHKz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Mar 2010 02:10:55 -0500
Message-ID: <4B8B687C.4090306@freemail.hu>
Date: Mon, 01 Mar 2010 08:10:52 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Adams Xu <Adams.xu@azwave.com.cn>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] az6027: remove redundant condition check
References: <201002281949.o1SJnGO7064642@smtp-vbr12.xs4all.nl> <4B8B6853.3050801@freemail.hu>
In-Reply-To: <4B8B6853.3050801@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

The condition (msg[i].addr == 0xd0) is checked twice the second one
is not necessary.

This will remove the following compiler warning:
   az6027.c: In function 'az6027_i2c_xfer':
   az6027.c:942: warning: 'index' may be used uninitialized in this function
   az6027.c:943: warning: 'value' may be used uninitialized in this function
   az6027.c:944: warning: 'length' may be used uninitialized in this function
   az6027.c:945: warning: 'req' may be used uninitialized in this function

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 37581bb7e6f1 linux/drivers/media/dvb/dvb-usb/az6027.c
--- a/linux/drivers/media/dvb/dvb-usb/az6027.c	Wed Feb 24 22:48:50 2010 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/az6027.c	Mon Mar 01 08:09:35 2010 +0100
@@ -976,17 +976,14 @@
 				i++;
 			} else {

-				if (msg[i].addr == 0xd0) {
-					/* demod 16bit addr */
-					req = 0xBD;
-					index = (((msg[i].buf[0] << 8) & 0xff00) | (msg[i].buf[1] & 0x00ff));
-					value = msg[i].addr + (2 << 8);
-					length = msg[i].len - 2;
-					len = msg[i].len - 2;
-					for (j = 0; j < len; j++)
-						data[j] = msg[i].buf[j + 2];
-
-				}
+				/* demod 16bit addr */
+				req = 0xBD;
+				index = (((msg[i].buf[0] << 8) & 0xff00) | (msg[i].buf[1] & 0x00ff));
+				value = msg[i].addr + (2 << 8);
+				length = msg[i].len - 2;
+				len = msg[i].len - 2;
+				for (j = 0; j < len; j++)
+					data[j] = msg[i].buf[j + 2];
 				az6027_usb_out_op(d, req, value, index, data, length);
 			}
 		}

