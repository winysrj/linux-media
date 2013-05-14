Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:59188 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758212Ab3ENUzT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 May 2013 16:55:19 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/3] tea575x-tuner: move HW init to a separate function
Date: Tue, 14 May 2013 22:54:43 +0200
Message-Id: <1368564885-20940-2-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1368564885-20940-1-git-send-email-linux@rainbow-software.org>
References: <1368564885-20940-1-git-send-email-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move HW initialization to separate function to allow using the code without
the v4l parts. This is needed for use in the bttv driver.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 include/sound/tea575x-tuner.h   |    1 +
 sound/i2c/other/tea575x-tuner.c |   19 +++++++++++++------
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/sound/tea575x-tuner.h b/include/sound/tea575x-tuner.h
index 098c4de..2d4fa59 100644
--- a/include/sound/tea575x-tuner.h
+++ b/include/sound/tea575x-tuner.h
@@ -71,6 +71,7 @@ struct snd_tea575x {
 	int (*ext_init)(struct snd_tea575x *tea);
 };
 
+int snd_tea575x_hw_init(struct snd_tea575x *tea);
 int snd_tea575x_init(struct snd_tea575x *tea, struct module *owner);
 void snd_tea575x_exit(struct snd_tea575x *tea);
 void snd_tea575x_set_freq(struct snd_tea575x *tea);
diff --git a/sound/i2c/other/tea575x-tuner.c b/sound/i2c/other/tea575x-tuner.c
index 8a36a1d..46ec4dff 100644
--- a/sound/i2c/other/tea575x-tuner.c
+++ b/sound/i2c/other/tea575x-tuner.c
@@ -486,13 +486,9 @@ static const struct v4l2_ctrl_ops tea575x_ctrl_ops = {
 	.s_ctrl = tea575x_s_ctrl,
 };
 
-/*
- * initialize all the tea575x chips
- */
-int snd_tea575x_init(struct snd_tea575x *tea, struct module *owner)
-{
-	int retval;
 
+int snd_tea575x_hw_init(struct snd_tea575x *tea)
+{
 	tea->mute = true;
 
 	/* Not all devices can or know how to read the data back.
@@ -507,6 +503,17 @@ int snd_tea575x_init(struct snd_tea575x *tea, struct module *owner)
 	tea->freq = 90500 * 16;		/* 90.5Mhz default */
 	snd_tea575x_set_freq(tea);
 
+	return 0;
+}
+EXPORT_SYMBOL(snd_tea575x_hw_init);
+
+int snd_tea575x_init(struct snd_tea575x *tea, struct module *owner)
+{
+	int retval = snd_tea575x_hw_init(tea);
+
+	if (retval)
+		return retval;
+
 	tea->vd = tea575x_radio;
 	video_set_drvdata(&tea->vd, tea);
 	mutex_init(&tea->mutex);
-- 
Ondrej Zary

