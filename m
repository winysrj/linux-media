Return-path: <mchehab@gaivota>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:44024 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754477Ab1EITyR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2011 15:54:17 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 16/16] tm6000: remove tm6010 sif audio start and stop
Date: Mon,  9 May 2011 21:54:04 +0200
Message-Id: <1304970844-20955-16-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1304970844-20955-1-git-send-email-stefan.ringel@arcor.de>
References: <1304970844-20955-1-git-send-email-stefan.ringel@arcor.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Stefan Ringel <stefan.ringel@arcor.de>

remove tm6010 sif audio start and stop


Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-alsa.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
index acb0317..2b96047 100644
--- a/drivers/staging/tm6000/tm6000-alsa.c
+++ b/drivers/staging/tm6000/tm6000-alsa.c
@@ -84,7 +84,6 @@ static int _tm6000_start_audio_dma(struct snd_tm6000_card *chip)
 
 	tm6000_set_audio_bitrate(core, 48000);
 
-	tm6000_set_reg(core, TM6010_REQ08_R01_A_INIT, 0x80);
 
 	return 0;
 }
@@ -101,8 +100,6 @@ static int _tm6000_stop_audio_dma(struct snd_tm6000_card *chip)
 	/* Disables audio */
 	tm6000_set_reg_mask(core, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, 0x00, 0x40);
 
-	tm6000_set_reg(core, TM6010_REQ08_R01_A_INIT, 0);
-
 	return 0;
 }
 
-- 
1.7.4.2

