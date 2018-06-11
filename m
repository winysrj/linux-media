Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35814 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754105AbeFKHpu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Jun 2018 03:45:50 -0400
From: Zhouyang Jia <jiazhouyang09@gmail.com>
Cc: Zhouyang Jia <jiazhouyang09@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Brian Warner <brian.warner@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: cx88: add error handling for snd_ctl_add
Date: Mon, 11 Jun 2018 15:41:58 +0800
Message-Id: <1528702920-33410-1-git-send-email-jiazhouyang09@gmail.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When snd_ctl_add fails, the lack of error-handling code may
cause unexpected results.

This patch adds error-handling code after calling snd_ctl_add.

Signed-off-by: Zhouyang Jia <jiazhouyang09@gmail.com>
---
 drivers/media/pci/cx88/cx88-alsa.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-alsa.c b/drivers/media/pci/cx88/cx88-alsa.c
index 8a28fda..d366793 100644
--- a/drivers/media/pci/cx88/cx88-alsa.c
+++ b/drivers/media/pci/cx88/cx88-alsa.c
@@ -962,8 +962,11 @@ static int cx88_audio_initdev(struct pci_dev *pci,
 		goto error;
 
 	/* If there's a wm8775 then add a Line-In ALC switch */
-	if (core->sd_wm8775)
-		snd_ctl_add(card, snd_ctl_new1(&snd_cx88_alc_switch, chip));
+	if (core->sd_wm8775) {
+		err = snd_ctl_add(card, snd_ctl_new1(&snd_cx88_alc_switch, chip));
+		if (err < 0)
+			goto error;
+	}
 
 	strcpy(card->driver, "CX88x");
 	sprintf(card->shortname, "Conexant CX%x", pci->device);
-- 
2.7.4
