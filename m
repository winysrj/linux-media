Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:36270 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425AbZBWP0p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 10:26:45 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] remove redundant memset after kzalloc
Date: Mon, 23 Feb 2009 16:26:38 +0100
Cc: Markus Rechberger <mrechberger@sundtek.de>,
	Patrick Boettcher <pb@linuxtv.org>,
	Steven Toth <stoth@hauppauge.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_uAsoJa7rXeeqpXY"
Message-Id: <200902231626.38940.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_uAsoJa7rXeeqpXY
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi there!

While having a look at the allocation of struct dvb_frontend in *_attach 
functions, I found some cases calling memset after kzalloc. This is 
redundant, and the attached patch removes these calls.
I also changed one case calling kmalloc and memset to kzalloc.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>

Regards
Matthias

--Boundary-00=_uAsoJa7rXeeqpXY
Content-Type: text/x-diff;
  charset="utf-8";
  name="kzalloc_no_memset.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kzalloc_no_memset.diff"

Index: v4l-dvb/linux/drivers/media/dvb/frontends/cx24113.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/cx24113.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/cx24113.c
@@ -559,7 +559,7 @@ struct dvb_frontend *cx24113_attach(stru
 		kzalloc(sizeof(struct cx24113_state), GFP_KERNEL);
 	int rc;
 	if (state == NULL) {
-		err("Unable to kmalloc\n");
+		err("Unable to kzalloc\n");
 		goto error;
 	}
 
Index: v4l-dvb/linux/drivers/media/dvb/frontends/cx24116.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/cx24116.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/cx24116.c
@@ -1112,13 +1112,10 @@ struct dvb_frontend *cx24116_attach(cons
 	dprintk("%s\n", __func__);
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct cx24116_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct cx24116_state), GFP_KERNEL);
 	if (state == NULL)
 		goto error1;
 
-	/* setup the state */
-	memset(state, 0, sizeof(struct cx24116_state));
-
 	state->config = config;
 	state->i2c = i2c;
 
Index: v4l-dvb/linux/drivers/media/dvb/frontends/cx24123.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/cx24123.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/cx24123.c
@@ -1084,13 +1084,13 @@ static struct dvb_frontend_ops cx24123_o
 struct dvb_frontend *cx24123_attach(const struct cx24123_config *config,
 				    struct i2c_adapter *i2c)
 {
+	/* allocate memory for the internal state */
 	struct cx24123_state *state =
 		kzalloc(sizeof(struct cx24123_state), GFP_KERNEL);
 
 	dprintk("\n");
-	/* allocate memory for the internal state */
 	if (state == NULL) {
-		err("Unable to kmalloc\n");
+		err("Unable to kzalloc\n");
 		goto error;
 	}
 
Index: v4l-dvb/linux/drivers/media/dvb/frontends/lgdt3304.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/lgdt3304.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/lgdt3304.c
@@ -383,7 +383,6 @@ struct dvb_frontend* lgdt3304_attach(con
 
 	struct lgdt3304_state *state;
 	state = kzalloc(sizeof(struct lgdt3304_state), GFP_KERNEL);
-	memset(state, 0x0, sizeof(struct lgdt3304_state));
 	state->addr = config->i2c_address;
 	state->i2c = i2c;
 
Index: v4l-dvb/linux/drivers/media/dvb/frontends/s921_module.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/s921_module.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/s921_module.c
@@ -233,7 +233,6 @@ struct dvb_frontend* s921_attach(const s
 
 	struct s921_state *state;
 	state = kzalloc(sizeof(struct s921_state), GFP_KERNEL);
-	memset(state, 0x0, sizeof(struct s921_state));
 
 	state->addr = config->i2c_address;
 	state->i2c = i2c;

--Boundary-00=_uAsoJa7rXeeqpXY--
