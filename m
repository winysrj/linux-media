Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:62656 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab2FKTRo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jun 2012 15:17:44 -0400
Received: by ghrr11 with SMTP id r11so2810023ghr.19
        for <linux-media@vger.kernel.org>; Mon, 11 Jun 2012 12:17:44 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>,
	Gianluca Gennari <gennarone@gmail.com>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 1/3] em28xx: Fix wrong AC97 mic register usage
Date: Mon, 11 Jun 2012 16:17:22 -0300
Message-Id: <1339442244-11546-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/em28xx/em28xx-audio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-audio.c b/drivers/media/video/em28xx/em28xx-audio.c
index d7e2a3d..e2a7a00 100644
--- a/drivers/media/video/em28xx/em28xx-audio.c
+++ b/drivers/media/video/em28xx/em28xx-audio.c
@@ -682,7 +682,7 @@ static int em28xx_audio_init(struct em28xx *dev)
 		em28xx_cvol_new(card, dev, "Video", AC97_VIDEO_VOL);
 		em28xx_cvol_new(card, dev, "Line In", AC97_LINEIN_VOL);
 		em28xx_cvol_new(card, dev, "Phone", AC97_PHONE_VOL);
-		em28xx_cvol_new(card, dev, "Microphone", AC97_PHONE_VOL);
+		em28xx_cvol_new(card, dev, "Microphone", AC97_MIC_VOL);
 		em28xx_cvol_new(card, dev, "CD", AC97_CD_VOL);
 		em28xx_cvol_new(card, dev, "AUX", AC97_AUX_VOL);
 		em28xx_cvol_new(card, dev, "PCM", AC97_PCM_OUT_VOL);
-- 
1.7.4.4

