Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:59893 "HELO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754067AbZLMUGS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Dec 2009 15:06:18 -0500
Message-ID: <4B254932.7080808@freemail.hu>
Date: Sun, 13 Dec 2009 21:06:10 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: srinivasa.deevi@conexant.com,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] cx231xx: use NULL when pointer is needed
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

The gpio field in the cx231xx_board.input structure is a pointer. Eliminate the
following sparse warnings (see "make C=1"):
 * cx231xx-cards.c:72:13: warning: Using plain integer as NULL pointer
 * cx231xx-cards.c:77:13: warning: Using plain integer as NULL pointer
 * cx231xx-cards.c:84:13: warning: Using plain integer as NULL pointer
 * cx231xx-cards.c:111:13: warning: Using plain integer as NULL pointer
 * cx231xx-cards.c:116:13: warning: Using plain integer as NULL pointer
 * cx231xx-cards.c:123:13: warning: Using plain integer as NULL pointer
 * cx231xx-cards.c:151:13: warning: Using plain integer as NULL pointer
 * cx231xx-cards.c:156:13: warning: Using plain integer as NULL pointer
 * cx231xx-cards.c:163:13: warning: Using plain integer as NULL pointer

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r e2f13778b5dc linux/drivers/media/video/cx231xx/cx231xx-cards.c
--- a/linux/drivers/media/video/cx231xx/cx231xx-cards.c	Sat Dec 12 17:25:43 2009 +0100
+++ b/linux/drivers/media/video/cx231xx/cx231xx-cards.c	Sun Dec 13 18:33:37 2009 +0100
@@ -69,19 +69,19 @@
 				.type = CX231XX_VMUX_TELEVISION,
 				.vmux = CX231XX_VIN_3_1,
 				.amux = CX231XX_AMUX_VIDEO,
-				.gpio = 0,
+				.gpio = NULL,
 			}, {
 				.type = CX231XX_VMUX_COMPOSITE1,
 				.vmux = CX231XX_VIN_2_1,
 				.amux = CX231XX_AMUX_LINE_IN,
-				.gpio = 0,
+				.gpio = NULL,
 			}, {
 				.type = CX231XX_VMUX_SVIDEO,
 				.vmux = CX231XX_VIN_1_1 |
 					(CX231XX_VIN_1_2 << 8) |
 					CX25840_SVIDEO_ON,
 				.amux = CX231XX_AMUX_LINE_IN,
-				.gpio = 0,
+				.gpio = NULL,
 			}
 		},
 	},
@@ -108,19 +108,19 @@
 				.type = CX231XX_VMUX_TELEVISION,
 				.vmux = CX231XX_VIN_3_1,
 				.amux = CX231XX_AMUX_VIDEO,
-				.gpio = 0,
+				.gpio = NULL,
 			}, {
 				.type = CX231XX_VMUX_COMPOSITE1,
 				.vmux = CX231XX_VIN_2_1,
 				.amux = CX231XX_AMUX_LINE_IN,
-				.gpio = 0,
+				.gpio = NULL,
 			}, {
 				.type = CX231XX_VMUX_SVIDEO,
 				.vmux = CX231XX_VIN_1_1 |
 					(CX231XX_VIN_1_2 << 8) |
 					CX25840_SVIDEO_ON,
 				.amux = CX231XX_AMUX_LINE_IN,
-				.gpio = 0,
+				.gpio = NULL,
 			}
 		},
 	},
@@ -148,19 +148,19 @@
 				.type = CX231XX_VMUX_TELEVISION,
 				.vmux = CX231XX_VIN_3_1,
 				.amux = CX231XX_AMUX_VIDEO,
-				.gpio = 0,
+				.gpio = NULL,
 			}, {
 				.type = CX231XX_VMUX_COMPOSITE1,
 				.vmux = CX231XX_VIN_2_1,
 				.amux = CX231XX_AMUX_LINE_IN,
-				.gpio = 0,
+				.gpio = NULL,
 			}, {
 				.type = CX231XX_VMUX_SVIDEO,
 				.vmux = CX231XX_VIN_1_1 |
 					(CX231XX_VIN_1_2 << 8) |
 					CX25840_SVIDEO_ON,
 				.amux = CX231XX_AMUX_LINE_IN,
-				.gpio = 0,
+				.gpio = NULL,
 			}
 		},
 	},
