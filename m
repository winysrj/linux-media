Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:36649 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757881Ab3CTTYP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 15:24:15 -0400
Received: by mail-ee0-f44.google.com with SMTP id l10so1370683eei.31
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2013 12:24:14 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [RFC PATCH 05/10] bttv: separate GPIO part from function audio_mux()
Date: Wed, 20 Mar 2013 20:24:45 +0100
Message-Id: <1363807490-3906-6-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1363807490-3906-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1363807490-3906-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move the GPIO part of function audio_mux() to a separate function
audio_mux_gpio().
This prepares the code for the next patch which will separate mute and input
setting.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c |   18 ++++++++++++------
 1 Datei geändert, 12 Zeilen hinzugefügt(+), 6 Zeilen entfernt(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 81ee70d..f1cb0db 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -989,11 +989,10 @@ static char *audio_modes[] = {
 	"audio: intern", "audio: mute"
 };
 
-static int
-audio_mux(struct bttv *btv, int input, int mute)
+static void
+audio_mux_gpio(struct bttv *btv, int input, int mute)
 {
 	int gpio_val, signal, mute_gpio;
-	struct v4l2_ctrl *ctrl;
 
 	gpio_inout(bttv_tvcards[btv->c.type].gpiomask,
 		   bttv_tvcards[btv->c.type].gpiomask);
@@ -1020,8 +1019,14 @@ audio_mux(struct bttv *btv, int input, int mute)
 
 	if (bttv_gpio)
 		bttv_gpio_tracking(btv, audio_modes[mute_gpio ? 4 : input]);
-	if (in_interrupt())
-		return 0;
+}
+
+static int
+audio_mux(struct bttv *btv, int input, int mute)
+{
+	struct v4l2_ctrl *ctrl;
+
+	audio_mux_gpio(btv, input, mute);
 
 	if (btv->sd_msp34xx) {
 		u32 in;
@@ -3846,7 +3851,8 @@ static irqreturn_t bttv_irq(int irq, void *dev_id)
 			bttv_irq_switch_video(btv);
 
 		if ((astat & BT848_INT_HLOCK)  &&  btv->opt_automute)
-			audio_mute(btv, btv->mute);  /* trigger automute */
+			/* trigger automute */
+			audio_mux_gpio(btv, btv->audio_input, btv->mute);
 
 		if (astat & (BT848_INT_SCERR|BT848_INT_OCERR)) {
 			pr_info("%d: %s%s @ %08x,",
-- 
1.7.10.4

