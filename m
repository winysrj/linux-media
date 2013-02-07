Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:61092 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030198Ab3BGRjx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 12:39:53 -0500
Received: by mail-ea0-f182.google.com with SMTP id a12so1268344eaa.27
        for <linux-media@vger.kernel.org>; Thu, 07 Feb 2013 09:39:52 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 13/13] em28xx: do not claim VBI support if the device is a camera
Date: Thu,  7 Feb 2013 18:39:21 +0100
Message-Id: <1360258761-2959-14-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1360258761-2959-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1360258761-2959-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Avoids registering a VBI device and streaming in VBI-mode if the device is a
camera.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/em28xx/em28xx-core.c |    5 +++++
 1 Datei geändert, 5 Zeilen hinzugefügt(+)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 3905570..a6e88db 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -681,6 +681,11 @@ int em28xx_vbi_supported(struct em28xx *dev)
 	if (disable_vbi == 1)
 		return 0;
 
+	if (dev->board.is_webcam)
+		return 0;
+
+	/* FIXME: check subdevices for VBI support */
+
 	if (dev->chip_id == CHIP_ID_EM2860 ||
 	    dev->chip_id == CHIP_ID_EM2883)
 		return 1;
-- 
1.7.10.4

