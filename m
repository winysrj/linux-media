Return-path: <mchehab@pedra>
Received: from gateway05.websitewelcome.com ([67.18.144.2]:50500 "HELO
	gateway05.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755967Ab0IWRuX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Sep 2010 13:50:23 -0400
Received: from [66.15.212.169] (port=14207 helo=[10.140.5.17])
	by gator886.hostgator.com with esmtpsa (SSLv3:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <pete@sensoray.com>)
	id 1OyppX-0000yH-T1
	for linux-media@vger.kernel.org; Thu, 23 Sep 2010 12:43:36 -0500
Subject: [PATCH] go7007: MJPEG buffer overflow
From: Pete Eberlein <pete@sensoray.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Sep 2010 10:43:41 -0700
Message-ID: <1285263821.2456.36.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The go7007 driver has a potential buffer overflow and pointer corruption
bug which causes a crash while capturing MJPEG. The motion detection
(MODET) active_map array can be overflowed by JPEG frame data that
emulates a MODET start code. The active_map overflow overwrites the
active_buf pointer, causing a crash.

The JPEG data that emulated MODET start code was being removed from the
output, resulting in garbled JPEG frames. Therefore ignore MODET start
codes when MODET is not enabled. 

Priority: normal

Signed-off-by: Pete Eberlein <pete@sensoray.com>

diff --git a/drivers/staging/go7007/go7007-driver.c b/drivers/staging/go7007/go7007-driver.c
index 372a7c6..34d21e2 100644
--- a/drivers/staging/go7007/go7007-driver.c
+++ b/drivers/staging/go7007/go7007-driver.c
@@ -393,7 +393,8 @@ static void write_bitmap_word(struct go7007 *go)
 	for (i = 0; i < 16; ++i) {
 		y = (((go->parse_length - 1) << 3) + i) / (go->width >> 4);
 		x = (((go->parse_length - 1) << 3) + i) % (go->width >> 4);
-		go->active_map[stride * y + (x >> 3)] |=
+		if (stride * y + (x >> 3) < sizeof(go->active_map))
+			go->active_map[stride * y + (x >> 3)] |=
 					(go->modet_word & 1) << (x & 0x7);
 		go->modet_word >>= 1;
 	}
@@ -485,6 +486,15 @@ void go7007_parse_video_stream(struct go7007 *go, u8 *buf, int length)
 			}
 			break;
 		case STATE_00_00_01:
+			if (buf[i] == 0xF8 && go->modet_enable == 0) {
+				/* MODET start code, but MODET not enabled */
+				store_byte(go->active_buf, 0x00);
+				store_byte(go->active_buf, 0x00);
+				store_byte(go->active_buf, 0x01);
+				store_byte(go->active_buf, 0xF8);
+				go->state = STATE_DATA;
+				break;
+			}
 			/* If this is the start of a new MPEG frame,
 			 * get a new buffer */
 			if ((go->format == GO7007_FORMAT_MPEG1 ||


