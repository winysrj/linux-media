Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:34964 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbZGWSOe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jul 2009 14:14:34 -0400
Received: by ewy26 with SMTP id 26so1207013ewy.37
        for <linux-media@vger.kernel.org>; Thu, 23 Jul 2009 11:14:33 -0700 (PDT)
Message-ID: <4A68A919.8070404@gmail.com>
Date: Thu, 23 Jul 2009 20:16:57 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: mchehab@infradead.org, uris@siano-ms.com,
	linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Siano: Read buffer overflow
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With mode DEVICE_MODE_RAW_TUNER a read occurs past the end of smscore_fw_lkup[].
Subsequently an attempt is made to load the firmware from the resulting
filename.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
This can be reached only when coredev->device_flags contains SMS_DEVICE_FAMILY2,
codedev->modes_supported does not include the DEVICE_MODE_RAW_TUNER bit flag,
and the initial attempt to load firmware. Can this happen in practice on the
hardware in question?

diff --git a/drivers/media/dvb/siano/smscoreapi.c b/drivers/media/dvb/siano/smscoreapi.c
index a246903..bd9ab9d 100644
--- a/drivers/media/dvb/siano/smscoreapi.c
+++ b/drivers/media/dvb/siano/smscoreapi.c
@@ -816,7 +816,7 @@ int smscore_set_device_mode(struct smscore_device_t *coredev, int mode)
 
 	sms_debug("set device mode to %d", mode);
 	if (coredev->device_flags & SMS_DEVICE_FAMILY2) {
-		if (mode < DEVICE_MODE_DVBT || mode > DEVICE_MODE_RAW_TUNER) {
+		if (mode < DEVICE_MODE_DVBT || mode >= DEVICE_MODE_RAW_TUNER) {
 			sms_err("invalid mode specified %d", mode);
 			return -EINVAL;
 		}
