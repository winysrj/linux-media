Return-path: <linux-media-owner@vger.kernel.org>
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:37178 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751745Ab3EJHta (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 May 2013 03:49:30 -0400
From: =?UTF-8?q?Jon=20Arne=20J=C3=B8rgensen?= <jonarne@jonarne.no>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab@redhat.com,
	ezequiel.garcia@free-electrons.com, jonarne@jonarne.no
Subject: [PATCH V1 1/1] saa7115: Add register setup and config for gm7113c
Date: Fri, 10 May 2013 09:52:28 +0200
Message-Id: <1368172348-8459-2-git-send-email-jonarne@jonarne.no>
In-Reply-To: <1368172348-8459-1-git-send-email-jonarne@jonarne.no>
References: <1368172348-8459-1-git-send-email-jonarne@jonarne.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The gm7113c chip is similar to the original saa7113 chip, so I try to
re-use most of the saa7113 specific setup-/configuration registers.

According to the datasheet, the gm7113c chip has not implemented
any register-addresses after 0x1f, so I add a new entry to for the chip
to the saa711x_has_reg function.

The devices I've seen using this chip will fail to get stable video-sync
if these registers are not zeroed:
	R_14_ANAL_ADC_COMPAT_CNTL
	R_15_VGATE_START_FID_CHG
	R_16_VGATE_STOP
	R_17_MISC_VGATE_CONF_AND_MSB

The saa711x_set_v4lstd is updated to send a simpler configuration-table
to avoid setting these registers.

Signed-off-by: Jon Arne Jørgensen <jonarne@jonarne.no>
Tested-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
---
This must be applied on top of these patches:
https://patchwork.linuxtv.org/patch/18232/
https://patchwork.linuxtv.org/patch/18233/

 drivers/media/i2c/saa7115.c | 47 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index 19b7112..abe0ca8 100644
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
@@ -213,7 +215,10 @@ static const unsigned char saa7111_init[] = {
 	0x00, 0x00
 };
 
-/* SAA7113 init codes */
+/* SAA7113/GM7113C init codes
+ * It's important that R_14... R_17 == 0x00
+ * for the gm7113c chip to deliver stable video
+ */
 static const unsigned char saa7113_init[] = {
 	R_01_INC_DELAY, 0x08,
 	R_02_INPUT_CNTL_1, 0xc2,
@@ -447,6 +452,24 @@ static const unsigned char saa7115_cfg_50hz_video[] = {
 
 /* ============== SAA7715 VIDEO templates (end) =======  */
 
+/* ============== GM7113C VIDEO templates =============  */
+static const unsigned char gm7113c_cfg_60hz_video[] = {
+	R_08_SYNC_CNTL, 0x68,			/* 0xBO: auto detection, 0x68 = NTSC */
+	R_0E_CHROMA_CNTL_1, 0x07,		/* video autodetection is on */
+
+	0x00, 0x00
+};
+
+static const unsigned char gm7113c_cfg_50hz_video[] = {
+	R_08_SYNC_CNTL, 0x28,			/* 0x28 = PAL */
+	R_0E_CHROMA_CNTL_1, 0x07,
+
+	0x00, 0x00
+};
+
+/* ============== GM7113C VIDEO templates (end) =======  */
+
+
 static const unsigned char saa7115_cfg_vbi_on[] = {
 	R_80_GLOBAL_CNTL_1, 0x00,			/* reset tasks */
 	R_88_POWER_SAVE_ADC_PORT_CNTL, 0xd0,		/* reset scaler */
@@ -927,11 +950,17 @@ static void saa711x_set_v4lstd(struct v4l2_subdev *sd, v4l2_std_id std)
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
 
@@ -944,7 +973,8 @@ static void saa711x_set_v4lstd(struct v4l2_subdev *sd, v4l2_std_id std)
 	011 NTSC N (3.58MHz)            PAL M (3.58MHz)
 	100 reserved                    NTSC-Japan (3.58MHz)
 	*/
-	if (state->ident <= V4L2_IDENT_SAA7113) {
+	if (state->ident <= V4L2_IDENT_SAA7113 ||
+	    state->ident == V4L2_IDENT_GM7113C) {
 		u8 reg = saa711x_read(sd, R_0E_CHROMA_CNTL_1) & 0x8f;
 
 		if (std == V4L2_STD_PAL_M) {
@@ -1215,7 +1245,8 @@ static int saa711x_s_routing(struct v4l2_subdev *sd,
 		input, output);
 
 	/* saa7111/3 does not have these inputs */
-	if (state->ident <= V4L2_IDENT_SAA7113 &&
+	if ((state->ident <= V4L2_IDENT_SAA7113 ||
+	     state->ident == V4L2_IDENT_GM7113C) &&
 	    (input == SAA7115_COMPOSITE4 ||
 	     input == SAA7115_COMPOSITE5)) {
 		return -EINVAL;
@@ -1687,11 +1718,6 @@ static int saa711x_probe(struct i2c_client *client,
 	if (ident < 0)
 		return ident;
 
-	if (ident == V4L2_IDENT_GM7113C) {
-		v4l_warn(client, "%s not yet supported\n", name);
-		return -ENODEV;
-	}
-
 	strlcpy(client->name, name, sizeof(client->name));
 
 	state = kzalloc(sizeof(struct saa711x_state), GFP_KERNEL);
@@ -1742,6 +1768,7 @@ static int saa711x_probe(struct i2c_client *client,
 	case V4L2_IDENT_SAA7111A:
 		saa711x_writeregs(sd, saa7111_init);
 		break;
+	case V4L2_IDENT_GM7113C:
 	case V4L2_IDENT_SAA7113:
 		saa711x_writeregs(sd, saa7113_init);
 		break;
-- 
1.8.2.1

