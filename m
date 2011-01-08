Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37862 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab1AHVp4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 16:45:56 -0500
Received: by vws16 with SMTP id 16so7617153vws.19
        for <linux-media@vger.kernel.org>; Sat, 08 Jan 2011 13:45:55 -0800 (PST)
MIME-Version: 1.0
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Sat, 8 Jan 2011 22:45:35 +0100
Message-ID: <AANLkTimpR8cyfOb90AwfNp2nmqKUoYVyAeqmLKLyShwJ@mail.gmail.com>
Subject: [PATCH] adv7175: support s_power
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch adds s_power support to adv7175 driver. Power-down is done
by power-down all four DACs.

Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
---

diff --git a/drivers/media/video/adv7175.c b/drivers/media/video/adv7175.c
index f318b51..d2327db 100644
--- a/drivers/media/video/adv7175.c
+++ b/drivers/media/video/adv7175.c
@@ -303,11 +303,22 @@ static int adv7175_g_chip_ident(struct
v4l2_subdev *sd, struct v4l2_dbg_chip_ide
        return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_ADV7175, 0);
 }

+static int adv7175_s_power(struct v4l2_subdev *sd, int on)
+{
+       if (on)
+               adv7175_write(sd, 0x01, 0x00);
+       else
+               adv7175_write(sd, 0x01, 0x78);
+
+       return 0;
+}
+
 /* ----------------------------------------------------------------------- */

 static const struct v4l2_subdev_core_ops adv7175_core_ops = {
        .g_chip_ident = adv7175_g_chip_ident,
        .init = adv7175_init,
+       .s_power = adv7175_s_power,
 };
