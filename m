Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:26664 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932235AbcIKPCY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Sep 2016 11:02:24 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 2/3] [media] tuners: constify dvb_tuner_ops structures
Date: Sun, 11 Sep 2016 16:44:13 +0200
Message-Id: <1473605054-9002-3-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1473605054-9002-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1473605054-9002-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These structures are only used to copy into other structures, so declare
them as const.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r disable optional_qualifier@
identifier i;
position p;
@@
static struct dvb_tuner_ops i@p = { ... };

@ok1@
identifier r.i;
expression e;
position p;
@@
e = i@p

@ok2@
identifier r.i;
expression e1, e2;
position p;
@@
memcpy(e1, &i@p, e2)

@bad@
position p != {r.p,ok1.p,ok2.p};
identifier r.i;
struct dvb_tuner_ops e;
@@
e@i@p

@depends on !bad disable optional_qualifier@
identifier r.i;
@@
static
+const
 struct dvb_tuner_ops i = { ... };
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/tuners/mt2063.c       |    2 +-
 drivers/media/tuners/mt20xx.c       |    4 ++--
 drivers/media/tuners/mxl5007t.c     |    2 +-
 drivers/media/tuners/tda827x.c      |    4 ++--
 drivers/media/tuners/tea5761.c      |    2 +-
 drivers/media/tuners/tea5767.c      |    2 +-
 drivers/media/tuners/tuner-simple.c |    2 +-
 7 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/tuners/tea5767.c b/drivers/media/tuners/tea5767.c
index 36e85d8..6d86aa6 100644
--- a/drivers/media/tuners/tea5767.c
+++ b/drivers/media/tuners/tea5767.c
@@ -423,7 +423,7 @@ static int tea5767_set_config (struct dvb_frontend *fe, void *priv_cfg)
 	return 0;
 }
 
-static struct dvb_tuner_ops tea5767_tuner_ops = {
+static const struct dvb_tuner_ops tea5767_tuner_ops = {
 	.info = {
 		.name           = "tea5767", // Philips TEA5767HN FM Radio
 	},
diff --git a/drivers/media/tuners/mxl5007t.c b/drivers/media/tuners/mxl5007t.c
index f4ae04c..42569c6 100644
--- a/drivers/media/tuners/mxl5007t.c
+++ b/drivers/media/tuners/mxl5007t.c
@@ -794,7 +794,7 @@ static int mxl5007t_release(struct dvb_frontend *fe)
 
 /* ------------------------------------------------------------------------- */
 
-static struct dvb_tuner_ops mxl5007t_tuner_ops = {
+static const struct dvb_tuner_ops mxl5007t_tuner_ops = {
 	.info = {
 		.name = "MaxLinear MxL5007T",
 	},
diff --git a/drivers/media/tuners/mt2063.c b/drivers/media/tuners/mt2063.c
index 7f0b9d5..dfec237 100644
--- a/drivers/media/tuners/mt2063.c
+++ b/drivers/media/tuners/mt2063.c
@@ -2201,7 +2201,7 @@ static int mt2063_get_bandwidth(struct dvb_frontend *fe, u32 *bw)
 	return 0;
 }
 
-static struct dvb_tuner_ops mt2063_ops = {
+static const struct dvb_tuner_ops mt2063_ops = {
 	.info = {
 		 .name = "MT2063 Silicon Tuner",
 		 .frequency_min = 45000000,
diff --git a/drivers/media/tuners/mt20xx.c b/drivers/media/tuners/mt20xx.c
index 9e03104..52da467 100644
--- a/drivers/media/tuners/mt20xx.c
+++ b/drivers/media/tuners/mt20xx.c
@@ -363,7 +363,7 @@ static int mt2032_set_params(struct dvb_frontend *fe,
 	return ret;
 }
 
-static struct dvb_tuner_ops mt2032_tuner_ops = {
+static const struct dvb_tuner_ops mt2032_tuner_ops = {
 	.set_analog_params = mt2032_set_params,
 	.release           = microtune_release,
 	.get_frequency     = microtune_get_frequency,
@@ -563,7 +563,7 @@ static int mt2050_set_params(struct dvb_frontend *fe,
 	return ret;
 }
 
-static struct dvb_tuner_ops mt2050_tuner_ops = {
+static const struct dvb_tuner_ops mt2050_tuner_ops = {
 	.set_analog_params = mt2050_set_params,
 	.release           = microtune_release,
 	.get_frequency     = microtune_get_frequency,
diff --git a/drivers/media/tuners/tda827x.c b/drivers/media/tuners/tda827x.c
index edcb4a7..5050ce9 100644
--- a/drivers/media/tuners/tda827x.c
+++ b/drivers/media/tuners/tda827x.c
@@ -818,7 +818,7 @@ static int tda827x_initial_sleep(struct dvb_frontend *fe)
 	return fe->ops.tuner_ops.sleep(fe);
 }
 
-static struct dvb_tuner_ops tda827xo_tuner_ops = {
+static const struct dvb_tuner_ops tda827xo_tuner_ops = {
 	.info = {
 		.name = "Philips TDA827X",
 		.frequency_min  =  55000000,
@@ -834,7 +834,7 @@ static struct dvb_tuner_ops tda827xo_tuner_ops = {
 	.get_bandwidth = tda827x_get_bandwidth,
 };
 
-static struct dvb_tuner_ops tda827xa_tuner_ops = {
+static const struct dvb_tuner_ops tda827xa_tuner_ops = {
 	.info = {
 		.name = "Philips TDA827XA",
 		.frequency_min  =  44000000,
diff --git a/drivers/media/tuners/tuner-simple.c b/drivers/media/tuners/tuner-simple.c
index 8e9ce14..9ba9582 100644
--- a/drivers/media/tuners/tuner-simple.c
+++ b/drivers/media/tuners/tuner-simple.c
@@ -1035,7 +1035,7 @@ static int simple_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
 	return 0;
 }
 
-static struct dvb_tuner_ops simple_tuner_ops = {
+static const struct dvb_tuner_ops simple_tuner_ops = {
 	.init              = simple_init,
 	.sleep             = simple_sleep,
 	.set_analog_params = simple_set_params,
diff --git a/drivers/media/tuners/tea5761.c b/drivers/media/tuners/tea5761.c
index bf78cb9..36b0b1e 100644
--- a/drivers/media/tuners/tea5761.c
+++ b/drivers/media/tuners/tea5761.c
@@ -301,7 +301,7 @@ static int tea5761_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
-static struct dvb_tuner_ops tea5761_tuner_ops = {
+static const struct dvb_tuner_ops tea5761_tuner_ops = {
 	.info = {
 		.name           = "tea5761", // Philips TEA5761HN FM Radio
 	},

