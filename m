Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:49584 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbZLKVdf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2009 16:33:35 -0500
Message-ID: <4B22BAB0.5070604@freemail.hu>
Date: Fri, 11 Dec 2009 22:33:36 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] gspca m5602: eliminate sparse warnings
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Eliminate the following sparse warnings (see "make C=1"):
 * v4l/m5602_s5k4aa.c:530:23: warning: dubious: x | !y
 * v4l/m5602_s5k4aa.c:575:23: warning: dubious: x | !y

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
../../m5602_s5k4aa_dubious.patch
diff -r f5662ce08663 linux/drivers/media/video/gspca/m5602/m5602_s5k4aa.c
--- a/linux/drivers/media/video/gspca/m5602/m5602_s5k4aa.c	Fri Dec 11 09:53:41 2009 +0100
+++ b/linux/drivers/media/video/gspca/m5602/m5602_s5k4aa.c	Fri Dec 11 22:25:50 2009 +0100
@@ -527,7 +527,7 @@
 	err = m5602_read_sensor(sd, S5K4AA_ROWSTART_LO, &data, 1);
 	if (err < 0)
 		return err;
-	data = (data & 0xfe) | !val;
+	data = (data & 0xfe) | (val ? 0 : 1);
 	err = m5602_write_sensor(sd, S5K4AA_ROWSTART_LO, &data, 1);
 	return err;
 }
@@ -572,7 +572,7 @@
 	err = m5602_read_sensor(sd, S5K4AA_COLSTART_LO, &data, 1);
 	if (err < 0)
 		return err;
-	data = (data & 0xfe) | !val;
+	data = (data & 0xfe) | (val ? 0 : 1);
 	err = m5602_write_sensor(sd, S5K4AA_COLSTART_LO, &data, 1);
 	return err;
 }
