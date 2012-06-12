Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:57726 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab2FLNyS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jun 2012 09:54:18 -0400
Received: by ghrr11 with SMTP id r11so3379897ghr.19
        for <linux-media@vger.kernel.org>; Tue, 12 Jun 2012 06:54:17 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: <linux-media@vger.kernel.org>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH] em28xx: Remove useless runtime->private_data usage
Date: Tue, 12 Jun 2012 10:53:42 -0300
Message-Id: <1339509222-2714-2-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1339509222-2714-1-git-send-email-elezegarcia@gmail.com>
References: <1339509222-2714-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/em28xx/em28xx-audio.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-audio.c b/drivers/media/video/em28xx/em28xx-audio.c
index d7e2a3d..2fcddae 100644
--- a/drivers/media/video/em28xx/em28xx-audio.c
+++ b/drivers/media/video/em28xx/em28xx-audio.c
@@ -305,7 +305,6 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
 
 	snd_pcm_hw_constraint_integer(runtime, SNDRV_PCM_HW_PARAM_PERIODS);
 	dev->adev.capture_pcm_substream = substream;
-	runtime->private_data = dev;
 
 	return 0;
 err:
-- 
1.7.3.4

