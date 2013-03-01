Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:34311 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab3CAXLz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2013 18:11:55 -0500
Received: by mail-ee0-f51.google.com with SMTP id d17so2699646eek.24
        for <linux-media@vger.kernel.org>; Fri, 01 Mar 2013 15:11:54 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 11/11] em28xx: enable tveeprom for device Hauppauge HVR-930C
Date: Sat,  2 Mar 2013 00:12:15 +0100
Message-Id: <1362179535-18929-12-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1362179535-18929-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1362179535-18929-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |    1 +
 1 Datei geändert, 1 Zeile hinzugefügt(+)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 2e3d3ad..5a5b637 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2741,6 +2741,7 @@ static void em28xx_card_setup(struct em28xx *dev)
 	case EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900_R2:
 	case EM2883_BOARD_HAUPPAUGE_WINTV_HVR_850:
 	case EM2883_BOARD_HAUPPAUGE_WINTV_HVR_950:
+	case EM2884_BOARD_HAUPPAUGE_WINTV_HVR_930C:
 	{
 		struct tveeprom tv;
 
-- 
1.7.10.4

