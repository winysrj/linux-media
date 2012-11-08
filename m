Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:33191 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab2KHTMO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 14:12:14 -0500
Received: by mail-ea0-f174.google.com with SMTP id c13so1190326eaa.19
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2012 11:12:14 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 02/21] em28xx: clarify meaning of field 'progressive' in struct em28xx
Date: Thu,  8 Nov 2012 20:11:34 +0200
Message-Id: <1352398313-3698-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx.h |    2 +-
 1 Datei geändert, 1 Zeile hinzugefügt(+), 1 Zeile entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 86e90d8..ad9eec0 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -497,7 +497,7 @@ struct em28xx {
 	int sensor_xres, sensor_yres;
 	int sensor_xtal;
 
-	/* Allows progressive (e. g. non-interlaced) mode */
+	/* Progressive (non-interlaced) mode */
 	int progressive;
 
 	/* Vinmode/Vinctl used at the driver */
-- 
1.7.10.4

