Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:54997 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab3C0VGi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Mar 2013 17:06:38 -0400
Received: by mail-ea0-f179.google.com with SMTP id f15so3574969eak.24
        for <linux-media@vger.kernel.org>; Wed, 27 Mar 2013 14:06:37 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 8/9] em28xx: add comment about Samsung and Kodak sensor probing addresses
Date: Wed, 27 Mar 2013 22:06:35 +0100
Message-Id: <1364418396-8191-9-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1364418396-8191-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1364418396-8191-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Windows driver also probes at least two further i2c addresses (0x22 >> 1
and 0x66 >> 1). I've got some hints that they are very likely used by Samsung
and Kodak sensors, which are known to be used in Empia devices, too.
We havn't seen any devices using these sensors yet and don't know how to probe
them properly, so leave a comment.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-camera.c |    5 +++++
 1 Datei geändert, 5 Zeilen hinzugefügt(+)

diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index e8b3322..64b70d4 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -301,6 +301,11 @@ int em28xx_detect_sensor(struct em28xx *dev)
 	if (dev->em28xx_sensor == EM28XX_NOSENSOR && ret < 0)
 		ret = em28xx_probe_sensor_omnivision(dev);
 
+	/*
+	 * NOTE: the Windows driver also probes i2c addresses
+	 *       0x22 (Samsung ?) and 0x66 (Kodak ?)
+	 */
+
 	if (dev->em28xx_sensor == EM28XX_NOSENSOR && ret < 0) {
 		em28xx_info("No sensor detected\n");
 		return -ENODEV;
-- 
1.7.10.4

