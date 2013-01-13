Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:42744 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab3AMMyE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jan 2013 07:54:04 -0500
Received: by mail-ee0-f47.google.com with SMTP id e52so1527048eek.34
        for <linux-media@vger.kernel.org>; Sun, 13 Jan 2013 04:54:03 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, hans.verkuil@cisco.com,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] em28xx: return -ENOTTY for VBI-format ioctls if the device doesn't support VBI
Date: Sun, 13 Jan 2013 13:54:25 +0100
Message-Id: <1358081665-6049-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |    6 ++++++
 1 Datei geändert, 6 Zeilen hinzugefügt(+)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 4a7f73c..c43e4c5 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1507,6 +1507,9 @@ static int vidioc_g_fmt_vbi_cap(struct file *file, void *priv,
 	struct em28xx_fh      *fh  = priv;
 	struct em28xx         *dev = fh->dev;
 
+	if (!em28xx_vbi_supported(dev))
+		return -ENOTTY;
+
 	format->fmt.vbi.samples_per_line = dev->vbi_width;
 	format->fmt.vbi.sample_format = V4L2_PIX_FMT_GREY;
 	format->fmt.vbi.offset = 0;
@@ -1536,6 +1539,9 @@ static int vidioc_s_fmt_vbi_cap(struct file *file, void *priv,
 	struct em28xx_fh      *fh  = priv;
 	struct em28xx         *dev = fh->dev;
 
+	if (!em28xx_vbi_supported(dev))
+		return -ENOTTY;
+
 	format->fmt.vbi.samples_per_line = dev->vbi_width;
 	format->fmt.vbi.sample_format = V4L2_PIX_FMT_GREY;
 	format->fmt.vbi.offset = 0;
-- 
1.7.10.4

