Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:38851 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030198Ab3BGRju (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 12:39:50 -0500
Received: by mail-ee0-f54.google.com with SMTP id c41so1626794eek.13
        for <linux-media@vger.kernel.org>; Thu, 07 Feb 2013 09:39:48 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 12/13] em28xx: make ioctl VIDIOC_DBG_G_CHIP_IDENT available for radio devices
Date: Thu,  7 Feb 2013 18:39:20 +0100
Message-Id: <1360258761-2959-13-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1360258761-2959-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1360258761-2959-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |    1 +
 1 Datei geändert, 1 Zeile hinzugefügt(+)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 2020faa..5e360e0 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1691,6 +1691,7 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_s_frequency   = vidioc_s_frequency,
 	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
+	.vidioc_g_chip_ident  = vidioc_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register    = vidioc_g_register,
 	.vidioc_s_register    = vidioc_s_register,
-- 
1.7.10.4

