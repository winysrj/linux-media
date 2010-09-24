Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:60405 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310Ab0IXOOk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Sep 2010 10:14:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Jean Delvare <khali@linux-fr.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pete Eberlein <pete@sensoray.com>,
	Mike Isely <isely@pobox.com>,
	Eduardo Valentin <eduardo.valentin@nokia.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Vaibhav Hiremath <hvaibhav@ti.com>,
	Muralidharan Karicheri <mkaricheri@gmail.com>
Subject: [PATCH 06/16] zoran: Don't use module names to load I2C modules
Date: Fri, 24 Sep 2010 16:14:04 +0200
Message-Id: <1285337654-5044-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

With the v4l2_i2c_new_subdev* functions now supporting loading modules
based on modaliases, replace the hardcoded module name passed to those
functions by NULL.

All corresponding I2C modules have been checked, and all of them include
a module aliases table with names corresponding to what the zoran driver
uses.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/zoran/zoran.h      |    2 --
 drivers/media/video/zoran/zoran_card.c |   23 +++--------------------
 2 files changed, 3 insertions(+), 22 deletions(-)

diff --git a/drivers/media/video/zoran/zoran.h b/drivers/media/video/zoran/zoran.h
index 307e847..37fe161 100644
--- a/drivers/media/video/zoran/zoran.h
+++ b/drivers/media/video/zoran/zoran.h
@@ -341,10 +341,8 @@ struct card_info {
 	enum card_type type;
 	char name[32];
 	const char *i2c_decoder;	/* i2c decoder device */
-	const char *mod_decoder;	/* i2c decoder module */
 	const unsigned short *addrs_decoder;
 	const char *i2c_encoder;	/* i2c encoder device */
-	const char *mod_encoder;	/* i2c encoder module */
 	const unsigned short *addrs_encoder;
 	u16 video_vfe, video_codec;			/* videocodec types */
 	u16 audio_chip;					/* audio type */
diff --git a/drivers/media/video/zoran/zoran_card.c b/drivers/media/video/zoran/zoran_card.c
index bfcd3ae..0aac376 100644
--- a/drivers/media/video/zoran/zoran_card.c
+++ b/drivers/media/video/zoran/zoran_card.c
@@ -379,7 +379,6 @@ static struct card_info zoran_cards[NUM_CARDS] __devinitdata = {
 		.type = DC10_old,
 		.name = "DC10(old)",
 		.i2c_decoder = "vpx3220a",
-		.mod_decoder = "vpx3220",
 		.addrs_decoder = vpx3220_addrs,
 		.video_codec = CODEC_TYPE_ZR36050,
 		.video_vfe = CODEC_TYPE_ZR36016,
@@ -409,10 +408,8 @@ static struct card_info zoran_cards[NUM_CARDS] __devinitdata = {
 		.type = DC10_new,
 		.name = "DC10(new)",
 		.i2c_decoder = "saa7110",
-		.mod_decoder = "saa7110",
 		.addrs_decoder = saa7110_addrs,
 		.i2c_encoder = "adv7175",
-		.mod_encoder = "adv7175",
 		.addrs_encoder = adv717x_addrs,
 		.video_codec = CODEC_TYPE_ZR36060,
 
@@ -440,10 +437,8 @@ static struct card_info zoran_cards[NUM_CARDS] __devinitdata = {
 		.type = DC10plus,
 		.name = "DC10plus",
 		.i2c_decoder = "saa7110",
-		.mod_decoder = "saa7110",
 		.addrs_decoder = saa7110_addrs,
 		.i2c_encoder = "adv7175",
-		.mod_encoder = "adv7175",
 		.addrs_encoder = adv717x_addrs,
 		.video_codec = CODEC_TYPE_ZR36060,
 
@@ -472,10 +467,8 @@ static struct card_info zoran_cards[NUM_CARDS] __devinitdata = {
 		.type = DC30,
 		.name = "DC30",
 		.i2c_decoder = "vpx3220a",
-		.mod_decoder = "vpx3220",
 		.addrs_decoder = vpx3220_addrs,
 		.i2c_encoder = "adv7175",
-		.mod_encoder = "adv7175",
 		.addrs_encoder = adv717x_addrs,
 		.video_codec = CODEC_TYPE_ZR36050,
 		.video_vfe = CODEC_TYPE_ZR36016,
@@ -505,10 +498,8 @@ static struct card_info zoran_cards[NUM_CARDS] __devinitdata = {
 		.type = DC30plus,
 		.name = "DC30plus",
 		.i2c_decoder = "vpx3220a",
-		.mod_decoder = "vpx3220",
 		.addrs_decoder = vpx3220_addrs,
 		.i2c_encoder = "adv7175",
-		.mod_encoder = "adv7175",
 		.addrs_encoder = adv717x_addrs,
 		.video_codec = CODEC_TYPE_ZR36050,
 		.video_vfe = CODEC_TYPE_ZR36016,
@@ -538,10 +529,8 @@ static struct card_info zoran_cards[NUM_CARDS] __devinitdata = {
 		.type = LML33,
 		.name = "LML33",
 		.i2c_decoder = "bt819a",
-		.mod_decoder = "bt819",
 		.addrs_decoder = bt819_addrs,
 		.i2c_encoder = "bt856",
-		.mod_encoder = "bt856",
 		.addrs_encoder = bt856_addrs,
 		.video_codec = CODEC_TYPE_ZR36060,
 
@@ -569,10 +558,8 @@ static struct card_info zoran_cards[NUM_CARDS] __devinitdata = {
 		.type = LML33R10,
 		.name = "LML33R10",
 		.i2c_decoder = "saa7114",
-		.mod_decoder = "saa7115",
 		.addrs_decoder = saa7114_addrs,
 		.i2c_encoder = "adv7170",
-		.mod_encoder = "adv7170",
 		.addrs_encoder = adv717x_addrs,
 		.video_codec = CODEC_TYPE_ZR36060,
 
@@ -600,10 +587,8 @@ static struct card_info zoran_cards[NUM_CARDS] __devinitdata = {
 		.type = BUZ,
 		.name = "Buz",
 		.i2c_decoder = "saa7111",
-		.mod_decoder = "saa7115",
 		.addrs_decoder = saa7111_addrs,
 		.i2c_encoder = "saa7185",
-		.mod_encoder = "saa7185",
 		.addrs_encoder = saa7185_addrs,
 		.video_codec = CODEC_TYPE_ZR36060,
 
@@ -633,10 +618,8 @@ static struct card_info zoran_cards[NUM_CARDS] __devinitdata = {
 		/* AverMedia chose not to brand the 6-Eyes. Thus it
 		   can't be autodetected, and requires card=x. */
 		.i2c_decoder = "ks0127",
-		.mod_decoder = "ks0127",
 		.addrs_decoder = ks0127_addrs,
 		.i2c_encoder = "bt866",
-		.mod_encoder = "bt866",
 		.addrs_encoder = bt866_addrs,
 		.video_codec = CODEC_TYPE_ZR36060,
 
@@ -1359,13 +1342,13 @@ static int __devinit zoran_probe(struct pci_dev *pdev,
 	}
 
 	zr->decoder = v4l2_i2c_new_subdev(&zr->v4l2_dev,
-		&zr->i2c_adapter, zr->card.mod_decoder, zr->card.i2c_decoder,
+		&zr->i2c_adapter, NULL, zr->card.i2c_decoder,
 		0, zr->card.addrs_decoder);
 
-	if (zr->card.mod_encoder)
+	if (zr->card.i2c_encoder)
 		zr->encoder = v4l2_i2c_new_subdev(&zr->v4l2_dev,
 			&zr->i2c_adapter,
-			zr->card.mod_encoder, zr->card.i2c_encoder,
+			NULL, zr->card.i2c_encoder,
 			0, zr->card.addrs_encoder);
 
 	dprintk(2,
-- 
1.7.2.2

