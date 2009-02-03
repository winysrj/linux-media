Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:44655 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbZBCBIt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2009 20:08:49 -0500
Received: by fg-out-1718.google.com with SMTP id 16so763430fgg.17
        for <linux-media@vger.kernel.org>; Mon, 02 Feb 2009 17:08:48 -0800 (PST)
Subject: [patch review 5/8] radio-mr800: fix amradio_set_freq
From: Alexey Klimov <klimov.linux@gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Tue, 03 Feb 2009 04:08:45 +0300
Message-Id: <1233623325.17456.261.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixing frequency adjustment to provide better diapason(band?) fit.
Also, add AMRADIO_SET_FREQ to the list of commands.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r d2d1176133ad linux/drivers/media/radio/radio-mr800.c
--- a/linux/drivers/media/radio/radio-mr800.c	Mon Feb 02 03:57:46 2009 +0300
+++ b/linux/drivers/media/radio/radio-mr800.c	Mon Feb 02 06:38:01 2009 +0300
@@ -92,6 +92,7 @@
  * Commands that device should understand
  * List isnt full and will be updated with implementation of new functions
  */
+#define AMRADIO_SET_FREQ	0xa4
 #define AMRADIO_SET_MUTE	0xab
 
 /* Comfortable defines for amradio_set_mute */
@@ -223,7 +224,7 @@
 {
 	int retval;
 	int size;
-	unsigned short freq_send = 0x13 + (freq >> 3) / 25;
+	unsigned short freq_send = 0x10 + (freq >> 3) / 25;
 
 	/* safety check */
 	if (radio->removed)
@@ -235,7 +236,7 @@
 	radio->buffer[1] = 0x55;
 	radio->buffer[2] = 0xaa;
 	radio->buffer[3] = 0x03;
-	radio->buffer[4] = 0xa4;
+	radio->buffer[4] = AMRADIO_SET_FREQ;
 	radio->buffer[5] = 0x00;
 	radio->buffer[6] = 0x00;
 	radio->buffer[7] = 0x08;


-- 
Best regards, Klimov Alexey

