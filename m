Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f53.google.com ([209.85.212.53]:54974 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab3ADU74 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 15:59:56 -0500
Received: by mail-vb0-f53.google.com with SMTP id b23so17012594vbz.12
        for <linux-media@vger.kernel.org>; Fri, 04 Jan 2013 12:59:55 -0800 (PST)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 03/15] em28xx: fix VIDIOC_DBG_G_CHIP_IDENT compliance errors.
Date: Fri,  4 Jan 2013 15:59:33 -0500
Message-Id: <1357333186-8466-4-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
References: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index f025440..b71df42 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1403,6 +1403,14 @@ static int vidioc_g_chip_ident(struct file *file, void *priv,
 
 	chip->ident = V4L2_IDENT_NONE;
 	chip->revision = 0;
+	if (chip->match.type == V4L2_CHIP_MATCH_HOST) {
+		if (v4l2_chip_match_host(&chip->match))
+			chip->ident = V4L2_IDENT_NONE;
+		return 0;
+	}
+	if (chip->match.type != V4L2_CHIP_MATCH_I2C_DRIVER &&
+	    chip->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
+		return -EINVAL;
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, core, g_chip_ident, chip);
 
-- 
1.7.9.5

