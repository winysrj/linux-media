Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:37149 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab3CURuf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 13:50:35 -0400
Received: by mail-ea0-f178.google.com with SMTP id g14so1037750eak.37
        for <linux-media@vger.kernel.org>; Thu, 21 Mar 2013 10:50:34 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 1/8] bttv: audio_mux(): use a local variable "gpio_mute" instead of modifying the function parameter "mute"
Date: Thu, 21 Mar 2013 18:51:13 +0100
Message-Id: <1363888280-28724-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1363888280-28724-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1363888280-28724-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Function audio_mux() actually deals with two types of mute: gpio mute and
subdevice muting.
This patch claryfies the meaning of these values, but mainly prepares the code for
the next patch.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c |    8 ++++----
 1 Datei geändert, 4 Zeilen hinzugefügt(+), 4 Zeilen entfernt(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 8610b6a..a584d82 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -992,7 +992,7 @@ static char *audio_modes[] = {
 static int
 audio_mux(struct bttv *btv, int input, int mute)
 {
-	int gpio_val, signal;
+	int gpio_val, signal, mute_gpio;
 	struct v4l2_ctrl *ctrl;
 
 	gpio_inout(bttv_tvcards[btv->c.type].gpiomask,
@@ -1003,10 +1003,10 @@ audio_mux(struct bttv *btv, int input, int mute)
 	btv->audio = input;
 
 	/* automute */
-	mute = mute || (btv->opt_automute && (!signal || !btv->users)
+	mute_gpio = mute || (btv->opt_automute && (!signal || !btv->users)
 				&& !btv->has_radio_tuner);
 
-	if (mute)
+	if (mute_gpio)
 		gpio_val = bttv_tvcards[btv->c.type].gpiomute;
 	else
 		gpio_val = bttv_tvcards[btv->c.type].gpiomux[input];
@@ -1022,7 +1022,7 @@ audio_mux(struct bttv *btv, int input, int mute)
 	}
 
 	if (bttv_gpio)
-		bttv_gpio_tracking(btv, audio_modes[mute ? 4 : input]);
+		bttv_gpio_tracking(btv, audio_modes[mute_gpio ? 4 : input]);
 	if (in_interrupt())
 		return 0;
 
-- 
1.7.10.4

