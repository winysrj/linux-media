Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:53156 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932510AbdHVOVW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 10:21:22 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] em28xx: calculate left volume level correctly
Date: Tue, 22 Aug 2017 15:21:20 +0100
Message-Id: <20170822142120.14348-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The calculation of the left volume looks suspect, the value of
0x1f - ((val << 8) & 0x1f) is always 0x1f. The debug prior to the
assignemnt of value[1] prints the left volume setting using the
calculation 0x1f - (val >> 8) & 0x1f which looks correct to me.
Fix the left volume by using the correct expression as used in
the debug.

Detected by CoverityScan, CID#146140 ("Wrong operator used")

Fixes: 850d24a5a861 ("[media] em28xx-alsa: add mixer support for AC97 volume controls")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 261620a57420..4628d73f46f2 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -564,7 +564,7 @@ static int em28xx_vol_get(struct snd_kcontrol *kcontrol,
 		val, (int)kcontrol->private_value);
 
 	value->value.integer.value[0] = 0x1f - (val & 0x1f);
-	value->value.integer.value[1] = 0x1f - ((val << 8) & 0x1f);
+	value->value.integer.value[1] = 0x1f - ((val >> 8) & 0x1f);
 
 	return 0;
 }
-- 
2.14.1
