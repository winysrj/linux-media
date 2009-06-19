Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:52941 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbZFSLVJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 07:21:09 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andreas Oberritter <obi@linuxtv.org>,
	Steven Toth <stoth@linuxtv.org>
Subject: [PATCH] Use kzalloc for frontend states to have struct dvb_frontend properly initialized
Date: Fri, 19 Jun 2009 13:21:05 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_hS3OKaDP8THYBq/"
Message-Id: <200906191321.05477.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_hS3OKaDP8THYBq/
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi list!

This patch changes most frontend drivers to allocate their state structure via 
kzalloc and not kmalloc. This is done to properly initialize the 
embedded "struct dvb_frontend frontend" field, that they all have.

The visible effect of this struct being uninitalized is, that the member "id" 
that is used to set the name of kernel thread is totally random.

Some board drivers (for example cx88-dvb) set this "id" via 
videobuf_dvb_alloc_frontend but most do not.

So I at least get random id values for saa7134, flexcop and ttpci based cards. 
It looks like this in dmesg:
DVB: registering adapter 1 frontend -10551321 (ST STV0299 DVB-S)

The related kernel thread then also gets a strange name 
like "kdvb-ad-1-fe--1".

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>

Regards
Matthias

--Boundary-00=_hS3OKaDP8THYBq/
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="dvb-zero-frontend.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dvb-zero-frontend.diff"

Index: v4l-dvb/linux/drivers/media/dvb/frontends/mt312.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/mt312.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/mt312.c
@@ -782,7 +782,7 @@ struct dvb_frontend *mt312_attach(const 
 	struct mt312_state *state = NULL;
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct mt312_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct mt312_state), GFP_KERNEL);
 	if (state == NULL)
 		goto error;
 
Index: v4l-dvb/linux/drivers/media/dvb/frontends/ves1x93.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/ves1x93.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/ves1x93.c
@@ -456,7 +456,7 @@ struct dvb_frontend* ves1x93_attach(cons
 	u8 identity;
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct ves1x93_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct ves1x93_state), GFP_KERNEL);
 	if (state == NULL) goto error;
 
 	/* setup the state */
Index: v4l-dvb/linux/drivers/media/dvb/frontends/at76c651.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/at76c651.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/at76c651.c
@@ -369,7 +369,7 @@ struct dvb_frontend* at76c651_attach(con
 	struct at76c651_state* state = NULL;
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct at76c651_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct at76c651_state), GFP_KERNEL);
 	if (state == NULL) goto error;
 
 	/* setup the state */
Index: v4l-dvb/linux/drivers/media/dvb/frontends/cx22700.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/cx22700.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/cx22700.c
@@ -380,7 +380,7 @@ struct dvb_frontend* cx22700_attach(cons
 	struct cx22700_state* state = NULL;
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct cx22700_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct cx22700_state), GFP_KERNEL);
 	if (state == NULL) goto error;
 
 	/* setup the state */
Index: v4l-dvb/linux/drivers/media/dvb/frontends/cx22702.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/cx22702.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/cx22702.c
@@ -580,7 +580,7 @@ struct dvb_frontend *cx22702_attach(cons
 	struct cx22702_state *state = NULL;
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct cx22702_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct cx22702_state), GFP_KERNEL);
 	if (state == NULL)
 		goto error;
 
Index: v4l-dvb/linux/drivers/media/dvb/frontends/cx24110.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/cx24110.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/cx24110.c
@@ -598,7 +598,7 @@ struct dvb_frontend* cx24110_attach(cons
 	int ret;
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct cx24110_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct cx24110_state), GFP_KERNEL);
 	if (state == NULL) goto error;
 
 	/* setup the state */
Index: v4l-dvb/linux/drivers/media/dvb/frontends/dvb_dummy_fe.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/dvb_dummy_fe.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/dvb_dummy_fe.c
@@ -117,7 +117,7 @@ struct dvb_frontend* dvb_dummy_fe_ofdm_a
 	struct dvb_dummy_fe_state* state = NULL;
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct dvb_dummy_fe_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct dvb_dummy_fe_state), GFP_KERNEL);
 	if (state == NULL) goto error;
 
 	/* create dvb_frontend */
@@ -137,7 +137,7 @@ struct dvb_frontend *dvb_dummy_fe_qpsk_a
 	struct dvb_dummy_fe_state* state = NULL;
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct dvb_dummy_fe_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct dvb_dummy_fe_state), GFP_KERNEL);
 	if (state == NULL) goto error;
 
 	/* create dvb_frontend */
@@ -157,7 +157,7 @@ struct dvb_frontend *dvb_dummy_fe_qam_at
 	struct dvb_dummy_fe_state* state = NULL;
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct dvb_dummy_fe_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct dvb_dummy_fe_state), GFP_KERNEL);
 	if (state == NULL) goto error;
 
 	/* create dvb_frontend */
Index: v4l-dvb/linux/drivers/media/dvb/frontends/l64781.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/l64781.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/l64781.c
@@ -501,7 +501,7 @@ struct dvb_frontend* l64781_attach(const
 			   { .addr = config->demod_address, .flags = I2C_M_RD, .buf = b1, .len = 1 } };
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct l64781_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct l64781_state), GFP_KERNEL);
 	if (state == NULL) goto error;
 
 	/* setup the state */
Index: v4l-dvb/linux/drivers/media/dvb/frontends/lgs8gl5.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/lgs8gl5.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/lgs8gl5.c
@@ -411,7 +411,7 @@ lgs8gl5_attach(const struct lgs8gl5_conf
 	dprintk("%s\n", __func__);
 
 	/* Allocate memory for the internal state */
-	state = kmalloc(sizeof(struct lgs8gl5_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct lgs8gl5_state), GFP_KERNEL);
 	if (state == NULL)
 		goto error;
 
Index: v4l-dvb/linux/drivers/media/dvb/frontends/nxt6000.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/nxt6000.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/nxt6000.c
@@ -545,7 +545,7 @@ struct dvb_frontend* nxt6000_attach(cons
 	struct nxt6000_state* state = NULL;
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct nxt6000_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct nxt6000_state), GFP_KERNEL);
 	if (state == NULL) goto error;
 
 	/* setup the state */
Index: v4l-dvb/linux/drivers/media/dvb/frontends/or51132.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/or51132.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/or51132.c
@@ -562,7 +562,7 @@ struct dvb_frontend* or51132_attach(cons
 	struct or51132_state* state = NULL;
 
 	/* Allocate memory for the internal state */
-	state = kmalloc(sizeof(struct or51132_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct or51132_state), GFP_KERNEL);
 	if (state == NULL)
 		return NULL;
 
Index: v4l-dvb/linux/drivers/media/dvb/frontends/or51211.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/or51211.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/or51211.c
@@ -527,7 +527,7 @@ struct dvb_frontend* or51211_attach(cons
 	struct or51211_state* state = NULL;
 
 	/* Allocate memory for the internal state */
-	state = kmalloc(sizeof(struct or51211_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct or51211_state), GFP_KERNEL);
 	if (state == NULL)
 		return NULL;
 
Index: v4l-dvb/linux/drivers/media/dvb/frontends/s5h1409.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/s5h1409.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/s5h1409.c
@@ -796,7 +796,7 @@ struct dvb_frontend *s5h1409_attach(cons
 	u16 reg;
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct s5h1409_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct s5h1409_state), GFP_KERNEL);
 	if (state == NULL)
 		goto error;
 
Index: v4l-dvb/linux/drivers/media/dvb/frontends/s5h1411.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/s5h1411.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/s5h1411.c
@@ -844,7 +844,7 @@ struct dvb_frontend *s5h1411_attach(cons
 	u16 reg;
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct s5h1411_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct s5h1411_state), GFP_KERNEL);
 	if (state == NULL)
 		goto error;
 
Index: v4l-dvb/linux/drivers/media/dvb/frontends/si21xx.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/si21xx.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/si21xx.c
@@ -1003,7 +1003,7 @@ struct dvb_frontend *si21xx_attach(const
 	dprintk("%s\n", __func__);
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct si21xx_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct si21xx_state), GFP_KERNEL);
 	if (state == NULL)
 		goto error;
 
Index: v4l-dvb/linux/drivers/media/dvb/frontends/sp8870.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/sp8870.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/sp8870.c
@@ -557,7 +557,7 @@ struct dvb_frontend* sp8870_attach(const
 	struct sp8870_state* state = NULL;
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct sp8870_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct sp8870_state), GFP_KERNEL);
 	if (state == NULL) goto error;
 
 	/* setup the state */
Index: v4l-dvb/linux/drivers/media/dvb/frontends/sp887x.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/sp887x.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/sp887x.c
@@ -557,7 +557,7 @@ struct dvb_frontend* sp887x_attach(const
 	struct sp887x_state* state = NULL;
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct sp887x_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct sp887x_state), GFP_KERNEL);
 	if (state == NULL) goto error;
 
 	/* setup the state */
Index: v4l-dvb/linux/drivers/media/dvb/frontends/stv0288.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/stv0288.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/stv0288.c
@@ -570,7 +570,7 @@ struct dvb_frontend *stv0288_attach(cons
 	int id;
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct stv0288_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct stv0288_state), GFP_KERNEL);
 	if (state == NULL)
 		goto error;
 
Index: v4l-dvb/linux/drivers/media/dvb/frontends/stv0297.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/stv0297.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/stv0297.c
@@ -663,7 +663,7 @@ struct dvb_frontend *stv0297_attach(cons
 	struct stv0297_state *state = NULL;
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct stv0297_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct stv0297_state), GFP_KERNEL);
 	if (state == NULL)
 		goto error;
 
Index: v4l-dvb/linux/drivers/media/dvb/frontends/stv0299.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/stv0299.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/stv0299.c
@@ -667,7 +667,7 @@ struct dvb_frontend* stv0299_attach(cons
 	int id;
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct stv0299_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct stv0299_state), GFP_KERNEL);
 	if (state == NULL) goto error;
 
 	/* setup the state */
Index: v4l-dvb/linux/drivers/media/dvb/frontends/tda10021.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/tda10021.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/tda10021.c
@@ -413,7 +413,7 @@ struct dvb_frontend* tda10021_attach(con
 	u8 id;
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct tda10021_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct tda10021_state), GFP_KERNEL);
 	if (state == NULL) goto error;
 
 	/* setup the state */
Index: v4l-dvb/linux/drivers/media/dvb/frontends/tda10048.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/tda10048.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/tda10048.c
@@ -1099,7 +1099,7 @@ struct dvb_frontend *tda10048_attach(con
 	dprintk(1, "%s()\n", __func__);
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct tda10048_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct tda10048_state), GFP_KERNEL);
 	if (state == NULL)
 		goto error;
 
Index: v4l-dvb/linux/drivers/media/dvb/frontends/tda1004x.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/tda1004x.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/tda1004x.c
@@ -1269,7 +1269,7 @@ struct dvb_frontend* tda10045_attach(con
 	int id;
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct tda1004x_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct tda1004x_state), GFP_KERNEL);
 	if (!state) {
 		printk(KERN_ERR "Can't alocate memory for tda10045 state\n");
 		return NULL;
@@ -1339,7 +1339,7 @@ struct dvb_frontend* tda10046_attach(con
 	int id;
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct tda1004x_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct tda1004x_state), GFP_KERNEL);
 	if (!state) {
 		printk(KERN_ERR "Can't alocate memory for tda10046 state\n");
 		return NULL;
Index: v4l-dvb/linux/drivers/media/dvb/frontends/tda10086.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/tda10086.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/tda10086.c
@@ -746,7 +746,7 @@ struct dvb_frontend* tda10086_attach(con
 	dprintk ("%s\n", __func__);
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct tda10086_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct tda10086_state), GFP_KERNEL);
 	if (!state)
 		return NULL;
 
Index: v4l-dvb/linux/drivers/media/dvb/frontends/tda8083.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/tda8083.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/tda8083.c
@@ -417,7 +417,7 @@ struct dvb_frontend* tda8083_attach(cons
 	struct tda8083_state* state = NULL;
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct tda8083_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct tda8083_state), GFP_KERNEL);
 	if (state == NULL) goto error;
 
 	/* setup the state */
Index: v4l-dvb/linux/drivers/media/dvb/frontends/tda80xx.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/tda80xx.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/tda80xx.c
@@ -646,7 +646,7 @@ struct dvb_frontend* tda80xx_attach(cons
 	int ret;
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct tda80xx_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct tda80xx_state), GFP_KERNEL);
 	if (state == NULL) goto error;
 
 	/* setup the state */
Index: v4l-dvb/linux/drivers/media/dvb/frontends/ves1820.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/ves1820.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/ves1820.c
@@ -374,7 +374,7 @@ struct dvb_frontend* ves1820_attach(cons
 	struct ves1820_state* state = NULL;
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct ves1820_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct ves1820_state), GFP_KERNEL);
 	if (state == NULL)
 		goto error;
 

--Boundary-00=_hS3OKaDP8THYBq/--
