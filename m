Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:45337 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757679Ab3AYR1L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 12:27:11 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so312592eei.7
        for <linux-media@vger.kernel.org>; Fri, 25 Jan 2013 09:27:10 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [REVIEW PATCH 12/12] em28xx: do not claim VBI support if the device is a camera
Date: Fri, 25 Jan 2013 18:27:02 +0100
Message-Id: <1359134822-4585-13-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1359134822-4585-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1359134822-4585-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Avoids registering a VBI device and streaming in VBI-mode if the device is a
camera.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-core.c |    5 +++++
 1 Datei geändert, 5 Zeilen hinzugefügt(+)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index f516a63..f743e09 100644
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

