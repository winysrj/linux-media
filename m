Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:34438 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757280Ab3CTTYH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 15:24:07 -0400
Received: by mail-ee0-f54.google.com with SMTP id c41so1313505eek.27
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2013 12:24:06 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [RFC PATCH 01/10] bttv: audio_mux(): use a local variable "gpio_mute" instead of modifying the function parameter "mute"
Date: Wed, 20 Mar 2013 20:24:41 +0100
Message-Id: <1363807490-3906-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1363807490-3906-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1363807490-3906-1-git-send-email-fschaefer.oss@googlemail.com>
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

