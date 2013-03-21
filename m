Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:64024 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab3CURuh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 13:50:37 -0400
Received: by mail-ee0-f43.google.com with SMTP id c50so1924358eek.16
        for <linux-media@vger.kernel.org>; Thu, 21 Mar 2013 10:50:35 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 2/8] bttv: audio_mux(): do not change the value of the v4l2 mute control
Date: Thu, 21 Mar 2013 18:51:14 +0100
Message-Id: <1363888280-28724-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1363888280-28724-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1363888280-28724-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are cases where we want to call audio_mux() without changing the value of
the v4l2 mute control, for example
- mute mute on last close
- mute on device probing

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c |    8 ++++----
 1 Datei geändert, 4 Zeilen hinzugefügt(+), 4 Zeilen entfernt(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index a584d82..a082ab4 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -999,7 +999,6 @@ audio_mux(struct bttv *btv, int input, int mute)
 		   bttv_tvcards[btv->c.type].gpiomask);
 	signal = btread(BT848_DSTATUS) & BT848_DSTATUS_HLOC;
 
-	btv->mute = mute;
 	btv->audio = input;
 
 	/* automute */
@@ -1031,7 +1030,7 @@ audio_mux(struct bttv *btv, int input, int mute)
 
 		ctrl = v4l2_ctrl_find(btv->sd_msp34xx->ctrl_handler, V4L2_CID_AUDIO_MUTE);
 		if (ctrl)
-			v4l2_ctrl_s_ctrl(ctrl, btv->mute);
+			v4l2_ctrl_s_ctrl(ctrl, mute);
 
 		/* Note: the inputs tuner/radio/extern/intern are translated
 		   to msp routings. This assumes common behavior for all msp3400
@@ -1080,7 +1079,7 @@ audio_mux(struct bttv *btv, int input, int mute)
 		ctrl = v4l2_ctrl_find(btv->sd_tvaudio->ctrl_handler, V4L2_CID_AUDIO_MUTE);
 
 		if (ctrl)
-			v4l2_ctrl_s_ctrl(ctrl, btv->mute);
+			v4l2_ctrl_s_ctrl(ctrl, mute);
 		v4l2_subdev_call(btv->sd_tvaudio, audio, s_routing,
 				input, 0, 0);
 	}
@@ -1088,7 +1087,7 @@ audio_mux(struct bttv *btv, int input, int mute)
 		ctrl = v4l2_ctrl_find(btv->sd_tda7432->ctrl_handler, V4L2_CID_AUDIO_MUTE);
 
 		if (ctrl)
-			v4l2_ctrl_s_ctrl(ctrl, btv->mute);
+			v4l2_ctrl_s_ctrl(ctrl, mute);
 	}
 	return 0;
 }
@@ -1300,6 +1299,7 @@ static int bttv_s_ctrl(struct v4l2_ctrl *c)
 		break;
 	case V4L2_CID_AUDIO_MUTE:
 		audio_mute(btv, c->val);
+		btv->mute = c->val;
 		break;
 	case V4L2_CID_AUDIO_VOLUME:
 		btv->volume_gpio(btv, c->val);
-- 
1.7.10.4

