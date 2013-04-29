Return-path: <linux-media-owner@vger.kernel.org>
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:33084 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759049Ab3D2UiD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Apr 2013 16:38:03 -0400
From: =?UTF-8?q?Jon=20Arne=20J=C3=B8rgensen?= <jonarne@jonarne.no>
To: mchehab@redhat.com
Cc: ezequiel.garcia@free-electrons.com, linux-media@vger.kernel.org,
	jonjon.arnearne@gmail.com
Subject: [PATCH V2 3/3] saa7115: Add register setup and config for gm7113c
Date: Mon, 29 Apr 2013 22:41:09 +0200
Message-Id: <1367268069-11429-4-git-send-email-jonarne@jonarne.no>
In-Reply-To: <1367268069-11429-1-git-send-email-jonarne@jonarne.no>
References: <1367268069-11429-1-git-send-email-jonarne@jonarne.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Jon Arne Jørgensen <jonarne@jonarne.no>
---
 drivers/media/i2c/saa7115.c | 48 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 39 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index eb2c19d..77c13dc 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -126,6 +126,8 @@ static int saa711x_has_reg(const int id, const u8 reg)
 		return 0;
 
 	switch (id) {
+	case V4L2_IDENT_GM7113C:
+		return reg != 0x14 && (reg < 0x18 || reg > 0x1e) && reg < 0x20;
 	case V4L2_IDENT_SAA7113:
 		return reg != 0x14 && (reg < 0x18 || reg > 0x1e) && (reg < 0x20 || reg > 0x3f) &&
 		       reg != 0x5d && reg < 0x63;
@@ -447,6 +449,30 @@ static const unsigned char saa7115_cfg_50hz_video[] = {
 
 /* ============== SAA7715 VIDEO templates (end) =======  */
 
+/* ============== GM7113C VIDEO templates =============  */
+static const unsigned char gm7113c_cfg_60hz_video[] = {
+	R_08_SYNC_CNTL, 0x68,			/* 0xBO: auto detection, 0x68 = NTSC */
+	R_0E_CHROMA_CNTL_1, 0x07,		/* video autodetection is on */
+
+#if 0
+	R_5A_V_OFF_FOR_SLICER, 0x06,		/* standard 60hz value for ITU656 line counting */
+#endif
+	0x00, 0x00
+};
+
+static const unsigned char gm7113c_cfg_50hz_video[] = {
+	R_08_SYNC_CNTL, 0x28,			/* 0x28 = PAL */
+	R_0E_CHROMA_CNTL_1, 0x07,
+
+#if 0
+	R_5A_V_OFF_FOR_SLICER, 0x03,		/* standard 50hz value */
+#endif
+	0x00, 0x00
+};
+
+/* ============== GM7113C VIDEO templates (end) =======  */
+
+
 static const unsigned char saa7115_cfg_vbi_on[] = {
 	R_80_GLOBAL_CNTL_1, 0x00,			/* reset tasks */
 	R_88_POWER_SAVE_ADC_PORT_CNTL, 0xd0,		/* reset scaler */
@@ -927,11 +953,17 @@ static void saa711x_set_v4lstd(struct v4l2_subdev *sd, v4l2_std_id std)
 	// This works for NTSC-M, SECAM-L and the 50Hz PAL variants.
 	if (std & V4L2_STD_525_60) {
 		v4l2_dbg(1, debug, sd, "decoder set standard 60 Hz\n");
-		saa711x_writeregs(sd, saa7115_cfg_60hz_video);
+		if (state->ident == V4L2_IDENT_GM7113C)
+			saa711x_writeregs(sd, gm7113c_cfg_60hz_video);
+		else
+			saa711x_writeregs(sd, saa7115_cfg_60hz_video);
 		saa711x_set_size(sd, 720, 480);
 	} else {
 		v4l2_dbg(1, debug, sd, "decoder set standard 50 Hz\n");
-		saa711x_writeregs(sd, saa7115_cfg_50hz_video);
+		if (state->ident == V4L2_IDENT_GM7113C)
+			saa711x_writeregs(sd, gm7113c_cfg_50hz_video);
+		else
+			saa711x_writeregs(sd, saa7115_cfg_50hz_video);
 		saa711x_set_size(sd, 720, 576);
 	}
 
@@ -944,7 +976,8 @@ static void saa711x_set_v4lstd(struct v4l2_subdev *sd, v4l2_std_id std)
 	011 NTSC N (3.58MHz)            PAL M (3.58MHz)
 	100 reserved                    NTSC-Japan (3.58MHz)
 	*/
-	if (state->ident <= V4L2_IDENT_SAA7113) {
+	if (state->ident <= V4L2_IDENT_SAA7113 ||
+	    state->ident == V4L2_IDENT_GM7113C) {
 		u8 reg = saa711x_read(sd, R_0E_CHROMA_CNTL_1) & 0x8f;
 
 		if (std == V4L2_STD_PAL_M) {
@@ -1215,7 +1248,8 @@ static int saa711x_s_routing(struct v4l2_subdev *sd,
 		input, output);
 
 	/* saa7111/3 does not have these inputs */
-	if (state->ident <= V4L2_IDENT_SAA7113 &&
+	if ((state->ident <= V4L2_IDENT_SAA7113 ||
+	     state->ident == V4L2_IDENT_GM7113C) &&
 	    (input == SAA7115_COMPOSITE4 ||
 	     input == SAA7115_COMPOSITE5)) {
 		return -EINVAL;
@@ -1687,11 +1721,6 @@ static int saa711x_probe(struct i2c_client *client,
 	if (ident < 0)
 		return ident;
 
-	if (ident == V4L2_IDENT_GM7113C) {
-		v4l_warn(client, "%s not yet supported\n", name);
-		return -ENODEV;
-	}
-
 	strlcpy(client->name, name, sizeof(client->name));
 
 	state = kzalloc(sizeof(struct saa711x_state), GFP_KERNEL);
@@ -1742,6 +1771,7 @@ static int saa711x_probe(struct i2c_client *client,
 	case V4L2_IDENT_SAA7111A:
 		saa711x_writeregs(sd, saa7111_init);
 		break;
+	case V4L2_IDENT_GM7113C:
 	case V4L2_IDENT_SAA7113:
 		saa711x_writeregs(sd, saa7113_init);
 		break;
-- 
1.8.2.1

