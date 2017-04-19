Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:33894 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937980AbdDSXOV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 19:14:21 -0400
Received: by mail-qt0-f180.google.com with SMTP id c45so32510518qtb.1
        for <linux-media@vger.kernel.org>; Wed, 19 Apr 2017 16:14:21 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 01/12] au8522: don't attempt to configure unsupported VBI slicer
Date: Wed, 19 Apr 2017 19:13:44 -0400
Message-Id: <1492643635-30823-2-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1492643635-30823-1-git-send-email-dheitmueller@kernellabs.com>
References: <1492643635-30823-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since we don't suppoort sliced VBI with the au0828/au8522, there is
no need to configure the au8522 VBI slicer, which because of the
coefficients requires a large amount of i2c traffic.

Remove the relevant code.  Note that this has no effect on raw VBI
support, which is currently the only supported way to access VBI on
this device.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/dvb-frontends/au8522_decoder.c | 38 ----------------------------
 1 file changed, 38 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index a2e7713..12a5c2c 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -179,42 +179,6 @@ static inline struct au8522_state *to_state(struct v4l2_subdev *sd)
 	return container_of(sd, struct au8522_state, sd);
 }
 
-static void setup_vbi(struct au8522_state *state, int aud_input)
-{
-	int i;
-
-	/* These are set to zero regardless of what mode we're in */
-	au8522_writereg(state, AU8522_TVDEC_VBI_CTRL_H_REG017H, 0x00);
-	au8522_writereg(state, AU8522_TVDEC_VBI_CTRL_L_REG018H, 0x00);
-	au8522_writereg(state, AU8522_TVDEC_VBI_USER_TOTAL_BITS_REG019H, 0x00);
-	au8522_writereg(state, AU8522_TVDEC_VBI_USER_TUNIT_H_REG01AH, 0x00);
-	au8522_writereg(state, AU8522_TVDEC_VBI_USER_TUNIT_L_REG01BH, 0x00);
-	au8522_writereg(state, AU8522_TVDEC_VBI_USER_THRESH1_REG01CH, 0x00);
-	au8522_writereg(state, AU8522_TVDEC_VBI_USER_FRAME_PAT2_REG01EH, 0x00);
-	au8522_writereg(state, AU8522_TVDEC_VBI_USER_FRAME_PAT1_REG01FH, 0x00);
-	au8522_writereg(state, AU8522_TVDEC_VBI_USER_FRAME_PAT0_REG020H, 0x00);
-	au8522_writereg(state, AU8522_TVDEC_VBI_USER_FRAME_MASK2_REG021H,
-			0x00);
-	au8522_writereg(state, AU8522_TVDEC_VBI_USER_FRAME_MASK1_REG022H,
-			0x00);
-	au8522_writereg(state, AU8522_TVDEC_VBI_USER_FRAME_MASK0_REG023H,
-			0x00);
-
-	/* Setup the VBI registers */
-	for (i = 0x30; i < 0x60; i++)
-		au8522_writereg(state, i, 0x40);
-
-	/* For some reason, every register is 0x40 except register 0x44
-	   (confirmed via the HVR-950q USB capture) */
-	au8522_writereg(state, 0x44, 0x60);
-
-	/* Enable VBI (we always do this regardless of whether the user is
-	   viewing closed caption info) */
-	au8522_writereg(state, AU8522_TVDEC_VBI_CTRL_H_REG017H,
-			AU8522_TVDEC_VBI_CTRL_H_REG017H_CCON);
-
-}
-
 static void setup_decoder_defaults(struct au8522_state *state, bool is_svideo)
 {
 	int i;
@@ -317,8 +281,6 @@ static void setup_decoder_defaults(struct au8522_state *state, bool is_svideo)
 			AU8522_TOREGAAGC_REG0E5H_CVBS);
 	au8522_writereg(state, AU8522_REG016H, AU8522_REG016H_CVBS);
 
-	setup_vbi(state, 0);
-
 	if (is_svideo) {
 		/* Despite what the table says, for the HVR-950q we still need
 		   to be in CVBS mode for the S-Video input (reason unknown). */
-- 
1.9.1
