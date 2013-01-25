Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:58567 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757658Ab3AYR1J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 12:27:09 -0500
Received: by mail-ea0-f170.google.com with SMTP id a11so261354eaa.1
        for <linux-media@vger.kernel.org>; Fri, 25 Jan 2013 09:27:07 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [REVIEW PATCH 11/12] em28xx: make ioctl VIDIOC_DBG_G_CHIP_IDENT available for radio devices
Date: Fri, 25 Jan 2013 18:27:01 +0100
Message-Id: <1359134822-4585-12-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1359134822-4585-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1359134822-4585-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |    1 +
 1 Datei geändert, 1 Zeile hinzugefügt(+)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index dd05cfb..e97b095 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1695,6 +1695,7 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register    = vidioc_g_register,
 	.vidioc_s_register    = vidioc_s_register,
+	.vidioc_g_chip_ident  = vidioc_g_chip_ident,
 #endif
 };
 
-- 
1.7.10.4

