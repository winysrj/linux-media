Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50488 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab3AEMul (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Jan 2013 07:50:41 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr12so8249821wgb.35
        for <linux-media@vger.kernel.org>; Sat, 05 Jan 2013 04:50:40 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: remy.blank@pobox.com, linux-media@vger.kernel.org,
	saschasommer@freenet.de,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
	stable@kernel.org
Subject: [PATCH] em28xx: fix audio input for TV mode of device Terratec Cinergy 250
Date: Sat,  5 Jan 2013 13:44:09 +0100
Message-Id: <1357389849-3149-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remy Blank reported that audio over USB can be made working for the television
input if .amux is changed from EM28XX_AMUX_LINE_IN to EM28XX_AMUX_VIDEO.
An examination of his devices shows, that it is indeed supplied with an EM202
AC97 audio IC. We also use this setting for the Cinergy 200.

Remy Blank also provided the original version of this patch (many thanks !).

Fixes bug 14126 (see bug report for further device details).

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Signed-off-by: Remy Blank <remy.blank@pobox.com>
Cc: stable@kernel.org
---
 drivers/media/usb/em28xx/em28xx-cards.c |    2 +-
 1 Datei geändert, 1 Zeile hinzugefügt(+), 1 Zeile entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 4d849bf..0a5aa62 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -493,7 +493,7 @@ struct em28xx_board em28xx_boards[] = {
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
 			.vmux     = SAA7115_COMPOSITE2,
-			.amux     = EM28XX_AMUX_LINE_IN,
+			.amux     = EM28XX_AMUX_VIDEO,
 		}, {
 			.type     = EM28XX_VMUX_COMPOSITE1,
 			.vmux     = SAA7115_COMPOSITE0,
-- 
1.7.10.4

