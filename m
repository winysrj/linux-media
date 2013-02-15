Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:60830 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab3BOSh6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 13:37:58 -0500
Received: by mail-ea0-f172.google.com with SMTP id f13so1539855eaa.17
        for <linux-media@vger.kernel.org>; Fri, 15 Feb 2013 10:37:57 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 2/4] em28xx: remove unused ac97 v4l2_ctrl_handler
Date: Fri, 15 Feb 2013 19:38:30 +0100
Message-Id: <1360953512-4133-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1360953512-4133-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1360953512-4133-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/em28xx/em28xx.h |    2 --
 1 Datei geändert, 2 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 6a9e3e1..7dc27b5 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -491,8 +491,6 @@ struct em28xx {
 
 	struct v4l2_device v4l2_dev;
 	struct v4l2_ctrl_handler ctrl_handler;
-	/* provides ac97 mute and volume overrides */
-	struct v4l2_ctrl_handler ac97_ctrl_handler;
 	struct em28xx_board board;
 
 	/* Webcam specific fields */
-- 
1.7.10.4

