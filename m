Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:51808 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab0A2UHv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2010 15:07:51 -0500
Message-ID: <4B63400E.3000502@freemail.hu>
Date: Fri, 29 Jan 2010 21:07:42 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH gspca_jf tree] gspca zc3xx: signal when unknown packet received
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 95d3956ea3e5 linux/drivers/media/video/gspca/zc3xx.c
--- a/linux/drivers/media/video/gspca/zc3xx.c	Fri Jan 29 15:05:25 2010 +0100
+++ b/linux/drivers/media/video/gspca/zc3xx.c	Fri Jan 29 21:01:52 2010 +0100
@@ -7213,14 +7213,17 @@
 			u8 *data,		/* interrupt packet data */
 			int len)		/* interrput packet length */
 {
+	int ret = -EINVAL;
+
 	if (len == 8 && data[4] == 1) {
 		input_report_key(gspca_dev->input_dev, KEY_CAMERA, 1);
 		input_sync(gspca_dev->input_dev);
 		input_report_key(gspca_dev->input_dev, KEY_CAMERA, 0);
 		input_sync(gspca_dev->input_dev);
+		ret = 0;
 	}

-	return 0;
+	return ret;
 }
 #endif

