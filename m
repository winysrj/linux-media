Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33674 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab2IYWK7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 18:10:59 -0400
Received: by yenm12 with SMTP id m12so2052323yen.19
        for <linux-media@vger.kernel.org>; Tue, 25 Sep 2012 15:10:58 -0700 (PDT)
From: Guilherme Herrmann Destefani <linuxtv@destefani.eng.br>
To: linux-media@vger.kernel.org
Cc: Guilherme Herrmann Destefani <linuxtv@destefani.eng.br>
Subject: [PATCH v2] bt8xx: Add video4linux control V4L2_CID_COLOR_KILLER.
Date: Tue, 25 Sep 2012 19:10:52 -0300
Message-Id: <1348611052-26644-1-git-send-email-linuxtv@destefani.eng.br>
In-Reply-To: <1347556331-7522-1-git-send-email-linuxtv@destefani.eng.br>
References: <1347556331-7522-1-git-send-email-linuxtv@destefani.eng.br>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added V4L2_CID_COLOR_KILLER control to the bt8xx driver.
The control V4L2_CID_PRIVATE_CHROMA_AGC was changed too because
with this change the bttv driver must touch two bits in the
SC Loop Control Registers, for controls V4L2_CID_COLOR_KILLER
and V4L2_CID_PRIVATE_CHROMA_AGC.

Signed-off-by: Guilherme Herrmann Destefani <linuxtv@destefani.eng.br>
---
Ola Mauro,

This is the same patch without the parameter, just the control.

Obrigado!

 drivers/media/video/bt8xx/bttv-driver.c | 30 ++++++++++++++++++++++++++----
 drivers/media/video/bt8xx/bttvp.h       |  1 +
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index e581b37..55a1742 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -674,6 +674,12 @@ static const struct v4l2_queryctrl bttv_ctls[] = {
 		.default_value = 32768,
 		.type          = V4L2_CTRL_TYPE_INTEGER,
 	},{
+		.id            = V4L2_CID_COLOR_KILLER,
+		.name          = "Color killer",
+		.minimum       = 0,
+		.maximum       = 1,
+		.type          = V4L2_CTRL_TYPE_BOOLEAN,
+	},{
 		.id            = V4L2_CID_HUE,
 		.name          = "Hue",
 		.minimum       = 0,
@@ -1475,6 +1481,9 @@ static int bttv_g_ctrl(struct file *file, void *priv,
 	case V4L2_CID_SATURATION:
 		c->value = btv->saturation;
 		break;
+	case V4L2_CID_COLOR_KILLER:
+		c->value = btv->opt_color_killer;
+		break;
 
 	case V4L2_CID_AUDIO_MUTE:
 	case V4L2_CID_AUDIO_VOLUME:
@@ -1527,7 +1536,6 @@ static int bttv_s_ctrl(struct file *file, void *f,
 					struct v4l2_control *c)
 {
 	int err;
-	int val;
 	struct bttv_fh *fh = f;
 	struct bttv *btv = fh->btv;
 
@@ -1548,6 +1556,16 @@ static int bttv_s_ctrl(struct file *file, void *f,
 	case V4L2_CID_SATURATION:
 		bt848_sat(btv, c->value);
 		break;
+	case V4L2_CID_COLOR_KILLER:
+		btv->opt_color_killer = c->value;
+		if (btv->opt_color_killer) {
+			btor(BT848_SCLOOP_CKILL, BT848_E_SCLOOP);
+			btor(BT848_SCLOOP_CKILL, BT848_O_SCLOOP);
+		} else {
+			btand(~BT848_SCLOOP_CKILL, BT848_E_SCLOOP);
+			btand(~BT848_SCLOOP_CKILL, BT848_O_SCLOOP);
+		}
+		break;
 	case V4L2_CID_AUDIO_MUTE:
 		audio_mute(btv, c->value);
 		/* fall through */
@@ -1565,9 +1583,13 @@ static int bttv_s_ctrl(struct file *file, void *f,
 
 	case V4L2_CID_PRIVATE_CHROMA_AGC:
 		btv->opt_chroma_agc = c->value;
-		val = btv->opt_chroma_agc ? BT848_SCLOOP_CAGC : 0;
-		btwrite(val, BT848_E_SCLOOP);
-		btwrite(val, BT848_O_SCLOOP);
+		if (btv->opt_chroma_agc) {
+			btor(BT848_SCLOOP_CAGC, BT848_E_SCLOOP);
+			btor(BT848_SCLOOP_CAGC, BT848_O_SCLOOP);
+		} else {
+			btand(~BT848_SCLOOP_CAGC, BT848_E_SCLOOP);
+			btand(~BT848_SCLOOP_CAGC, BT848_O_SCLOOP);
+		}
 		break;
 	case V4L2_CID_PRIVATE_COMBFILTER:
 		btv->opt_combfilter = c->value;
diff --git a/drivers/media/video/bt8xx/bttvp.h b/drivers/media/video/bt8xx/bttvp.h
index db943a8d..3979b7c 100644
--- a/drivers/media/video/bt8xx/bttvp.h
+++ b/drivers/media/video/bt8xx/bttvp.h
@@ -429,6 +429,7 @@ struct bttv {
 	int opt_lumafilter;
 	int opt_automute;
 	int opt_chroma_agc;
+	int opt_color_killer;
 	int opt_adc_crush;
 	int opt_vcr_hack;
 	int opt_whitecrush_upper;
-- 
1.7.11.4

