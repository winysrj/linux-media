Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:35216 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab3JPTlf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Oct 2013 15:41:35 -0400
Received: by mail-ee0-f54.google.com with SMTP id e53so601552eek.41
        for <linux-media@vger.kernel.org>; Wed, 16 Oct 2013 12:41:34 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] em28xx: make sure that all subdevices are powered on when needed
Date: Wed, 16 Oct 2013 21:41:46 +0200
Message-Id: <1381952506-2405-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 622b828ab7 ("v4l2_subdev: rename tuner s_standby operation to
core s_power") replaced the tuner s_standby call in the em28xx driver with
a (s_power, 0) call which suspends all subdevices.
But it neglected to add corresponding (s_power, 1) calls to make sure that
the subdevices are powered on again when needed.

This patch fixes this issue by adding a (s_power, 1) call to
function em28xx_wake_i2c().

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-core.c |    1 +
 1 Datei geändert, 1 Zeile hinzugefügt(+)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index fc157af..8896789 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -1243,6 +1243,7 @@ EXPORT_SYMBOL_GPL(em28xx_init_usb_xfer);
  */
 void em28xx_wake_i2c(struct em28xx *dev)
 {
+	v4l2_device_call_all(&dev->v4l2_dev, 0, core,  s_power, 1);
 	v4l2_device_call_all(&dev->v4l2_dev, 0, core,  reset, 0);
 	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,
 			INPUT(dev->ctl_input)->vmux, 0, 0);
-- 
1.7.10.4

