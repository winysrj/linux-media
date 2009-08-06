Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752717AbZHFXBY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Aug 2009 19:01:24 -0400
Message-Id: <200908062301.n76N1FIw029970@imap1.linux-foundation.org>
Subject: [patch 4/9] siano: read buffer overflow
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	roel.kluin@gmail.com
From: akpm@linux-foundation.org
Date: Thu, 06 Aug 2009 16:01:15 -0700
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Roel Kluin <roel.kluin@gmail.com>

With mode DEVICE_MODE_RAW_TUNER a read occurs past the end of smscore_fw_lkup[].
Subsequently an attempt is made to load the firmware from the resulting
filename.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/siano/smscoreapi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/dvb/siano/smscoreapi.c~siano-read-buffer-overflow drivers/media/dvb/siano/smscoreapi.c
--- a/drivers/media/dvb/siano/smscoreapi.c~siano-read-buffer-overflow
+++ a/drivers/media/dvb/siano/smscoreapi.c
@@ -816,7 +816,7 @@ int smscore_set_device_mode(struct smsco
 
 	sms_debug("set device mode to %d", mode);
 	if (coredev->device_flags & SMS_DEVICE_FAMILY2) {
-		if (mode < DEVICE_MODE_DVBT || mode > DEVICE_MODE_RAW_TUNER) {
+		if (mode < DEVICE_MODE_DVBT || mode >= DEVICE_MODE_RAW_TUNER) {
 			sms_err("invalid mode specified %d", mode);
 			return -EINVAL;
 		}
_
