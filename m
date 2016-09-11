Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:6431 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755982AbcIKPCX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Sep 2016 11:02:23 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: kernel-janitors@vger.kernel.org, Abylay Ospan <aospan@netup.ru>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergey Kozlov <serjk@netup.ru>
Subject: [PATCH 1/3] [media] dvb-frontends: constify dvb_tuner_ops structures
Date: Sun, 11 Sep 2016 16:44:12 +0200
Message-Id: <1473605054-9002-2-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/media/dvb-frontends/ascot2e.c      |    2 +-
 drivers/media/dvb-frontends/dvb-pll.c      |    2 +-
 drivers/media/dvb-frontends/helene.c       |    4 ++--
 drivers/media/dvb-frontends/horus3a.c      |    2 +-
 drivers/media/dvb-frontends/ix2505v.c      |    2 +-
 drivers/media/dvb-frontends/stb6000.c      |    2 +-
 drivers/media/dvb-frontends/stb6100.c      |    2 +-
 drivers/media/dvb-frontends/stv6110.c      |    2 +-
 drivers/media/dvb-frontends/stv6110x.c     |    2 +-
 drivers/media/dvb-frontends/tda18271c2dd.c |    2 +-
 drivers/media/dvb-frontends/tda665x.c      |    2 +-
 drivers/media/dvb-frontends/tda8261.c      |    2 +-
 drivers/media/dvb-frontends/tda826x.c      |    2 +-
 drivers/media/dvb-frontends/ts2020.c       |    2 +-
 drivers/media/dvb-frontends/tua6100.c      |    2 +-
 drivers/media/dvb-frontends/zl10036.c      |    2 +-
 drivers/media/dvb-frontends/zl10039.c      |    2 +-
 17 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/media/dvb-frontends/ix2505v.c b/drivers/media/dvb-frontends/ix2505v.c
index 0e3387e..2826bbb 100644
--- a/drivers/media/dvb-frontends/ix2505v.c
+++ b/drivers/media/dvb-frontends/ix2505v.c
@@ -258,7 +258,7 @@ static int ix2505v_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
-static struct dvb_tuner_ops ix2505v_tuner_ops = {
+static const struct dvb_tuner_ops ix2505v_tuner_ops = {
 	.info = {
 		.name = "Sharp IX2505V (B0017)",
 		.frequency_min = 950000,
diff --git a/drivers/media/dvb-frontends/helene.c b/drivers/media/dvb-frontends/helene.c
index 97a8982..4cb0505 100644
--- a/drivers/media/dvb-frontends/helene.c
+++ b/drivers/media/dvb-frontends/helene.c
@@ -842,7 +842,7 @@ static int helene_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
-static struct dvb_tuner_ops helene_tuner_ops = {
+static const struct dvb_tuner_ops helene_tuner_ops = {
 	.info = {
 		.name = "Sony HELENE Ter tuner",
 		.frequency_min = 1000000,
@@ -856,7 +856,7 @@ static struct dvb_tuner_ops helene_tuner_ops = {
 	.get_frequency = helene_get_frequency,
 };
 
-static struct dvb_tuner_ops helene_tuner_ops_s = {
+static const struct dvb_tuner_ops helene_tuner_ops_s = {
 	.info = {
 		.name = "Sony HELENE Sat tuner",
 		.frequency_min = 500000,
diff --git a/drivers/media/dvb-frontends/ascot2e.c b/drivers/media/dvb-frontends/ascot2e.c
index 8cc8c45..ad304ee 100644
--- a/drivers/media/dvb-frontends/ascot2e.c
+++ b/drivers/media/dvb-frontends/ascot2e.c
@@ -464,7 +464,7 @@ static int ascot2e_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
-static struct dvb_tuner_ops ascot2e_tuner_ops = {
+static const struct dvb_tuner_ops ascot2e_tuner_ops = {
 	.info = {
 		.name = "Sony ASCOT2E",
 		.frequency_min = 1000000,
diff --git a/drivers/media/dvb-frontends/horus3a.c b/drivers/media/dvb-frontends/horus3a.c
index a98bca5..0c089b5 100644
--- a/drivers/media/dvb-frontends/horus3a.c
+++ b/drivers/media/dvb-frontends/horus3a.c
@@ -326,7 +326,7 @@ static int horus3a_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
-static struct dvb_tuner_ops horus3a_tuner_ops = {
+static const struct dvb_tuner_ops horus3a_tuner_ops = {
 	.info = {
 		.name = "Sony Horus3a",
 		.frequency_min = 950000,
diff --git a/drivers/media/dvb-frontends/dvb-pll.c b/drivers/media/dvb-frontends/dvb-pll.c
index 53089e1..735a966 100644
--- a/drivers/media/dvb-frontends/dvb-pll.c
+++ b/drivers/media/dvb-frontends/dvb-pll.c
@@ -739,7 +739,7 @@ static int dvb_pll_init(struct dvb_frontend *fe)
 	return -EINVAL;
 }
 
-static struct dvb_tuner_ops dvb_pll_tuner_ops = {
+static const struct dvb_tuner_ops dvb_pll_tuner_ops = {
 	.release = dvb_pll_release,
 	.sleep = dvb_pll_sleep,
 	.init = dvb_pll_init,
diff --git a/drivers/media/dvb-frontends/stb6000.c b/drivers/media/dvb-frontends/stb6000.c
index a0c3c52..73347d5 100644
--- a/drivers/media/dvb-frontends/stb6000.c
+++ b/drivers/media/dvb-frontends/stb6000.c
@@ -186,7 +186,7 @@ static int stb6000_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
-static struct dvb_tuner_ops stb6000_tuner_ops = {
+static const struct dvb_tuner_ops stb6000_tuner_ops = {
 	.info = {
 		.name = "ST STB6000",
 		.frequency_min = 950000,
diff --git a/drivers/media/dvb-frontends/stb6100.c b/drivers/media/dvb-frontends/stb6100.c
index b9c2511..5add118 100644
--- a/drivers/media/dvb-frontends/stb6100.c
+++ b/drivers/media/dvb-frontends/stb6100.c
@@ -522,7 +522,7 @@ static int stb6100_set_params(struct dvb_frontend *fe)
 	return 0;
 }
 
-static struct dvb_tuner_ops stb6100_ops = {
+static const struct dvb_tuner_ops stb6100_ops = {
 	.info = {
 		.name			= "STB6100 Silicon Tuner",
 		.frequency_min		= 950000,
diff --git a/drivers/media/dvb-frontends/stv6110.c b/drivers/media/dvb-frontends/stv6110.c
index 91c6dcf..66a5a7f 100644
--- a/drivers/media/dvb-frontends/stv6110.c
+++ b/drivers/media/dvb-frontends/stv6110.c
@@ -382,7 +382,7 @@ static int stv6110_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
 	return 0;
 }
 
-static struct dvb_tuner_ops stv6110_tuner_ops = {
+static const struct dvb_tuner_ops stv6110_tuner_ops = {
 	.info = {
 		.name = "ST STV6110",
 		.frequency_min = 950000,
diff --git a/drivers/media/dvb-frontends/stv6110x.c b/drivers/media/dvb-frontends/stv6110x.c
index a62c01e..c611ad2 100644
--- a/drivers/media/dvb-frontends/stv6110x.c
+++ b/drivers/media/dvb-frontends/stv6110x.c
@@ -345,7 +345,7 @@ static int stv6110x_release(struct dvb_frontend *fe)
 	return 0;
 }
 
-static struct dvb_tuner_ops stv6110x_ops = {
+static const struct dvb_tuner_ops stv6110x_ops = {
 	.info = {
 		.name		= "STV6110(A) Silicon Tuner",
 		.frequency_min	=  950000,
diff --git a/drivers/media/dvb-frontends/tda18271c2dd.c b/drivers/media/dvb-frontends/tda18271c2dd.c
index de0a1c1..bc247f9 100644
--- a/drivers/media/dvb-frontends/tda18271c2dd.c
+++ b/drivers/media/dvb-frontends/tda18271c2dd.c
@@ -1217,7 +1217,7 @@ static int get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
 }
 
 
-static struct dvb_tuner_ops tuner_ops = {
+static const struct dvb_tuner_ops tuner_ops = {
 	.info = {
 		.name = "NXP TDA18271C2D",
 		.frequency_min  =  47125000,
diff --git a/drivers/media/dvb-frontends/tda665x.c b/drivers/media/dvb-frontends/tda665x.c
index 82f8cc5..7ca9659 100644
--- a/drivers/media/dvb-frontends/tda665x.c
+++ b/drivers/media/dvb-frontends/tda665x.c
@@ -206,7 +206,7 @@ static int tda665x_release(struct dvb_frontend *fe)
 	return 0;
 }
 
-static struct dvb_tuner_ops tda665x_ops = {
+static const struct dvb_tuner_ops tda665x_ops = {
 	.get_status	= tda665x_get_status,
 	.set_params	= tda665x_set_params,
 	.get_frequency	= tda665x_get_frequency,
diff --git a/drivers/media/dvb-frontends/tda8261.c b/drivers/media/dvb-frontends/tda8261.c
index 3285b1b..e0df931 100644
--- a/drivers/media/dvb-frontends/tda8261.c
+++ b/drivers/media/dvb-frontends/tda8261.c
@@ -161,7 +161,7 @@ static int tda8261_release(struct dvb_frontend *fe)
 	return 0;
 }
 
-static struct dvb_tuner_ops tda8261_ops = {
+static const struct dvb_tuner_ops tda8261_ops = {
 
 	.info = {
 		.name		= "TDA8261",
diff --git a/drivers/media/dvb-frontends/tda826x.c b/drivers/media/dvb-frontends/tda826x.c
index 04bbcc2..2ec671d 100644
--- a/drivers/media/dvb-frontends/tda826x.c
+++ b/drivers/media/dvb-frontends/tda826x.c
@@ -129,7 +129,7 @@ static int tda826x_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
-static struct dvb_tuner_ops tda826x_tuner_ops = {
+static const struct dvb_tuner_ops tda826x_tuner_ops = {
 	.info = {
 		.name = "Philips TDA826X",
 		.frequency_min = 950000,
diff --git a/drivers/media/dvb-frontends/ts2020.c b/drivers/media/dvb-frontends/ts2020.c
index 14b410f..a9f6bbe 100644
--- a/drivers/media/dvb-frontends/ts2020.c
+++ b/drivers/media/dvb-frontends/ts2020.c
@@ -496,7 +496,7 @@ static int ts2020_read_signal_strength(struct dvb_frontend *fe,
 	return 0;
 }
 
-static struct dvb_tuner_ops ts2020_tuner_ops = {
+static const struct dvb_tuner_ops ts2020_tuner_ops = {
 	.info = {
 		.name = "TS2020",
 		.frequency_min = 950000,
diff --git a/drivers/media/dvb-frontends/tua6100.c b/drivers/media/dvb-frontends/tua6100.c
index 029384d..6da12b9 100644
--- a/drivers/media/dvb-frontends/tua6100.c
+++ b/drivers/media/dvb-frontends/tua6100.c
@@ -157,7 +157,7 @@ static int tua6100_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
-static struct dvb_tuner_ops tua6100_tuner_ops = {
+static const struct dvb_tuner_ops tua6100_tuner_ops = {
 	.info = {
 		.name = "Infineon TUA6100",
 		.frequency_min = 950000,
diff --git a/drivers/media/dvb-frontends/zl10036.c b/drivers/media/dvb-frontends/zl10036.c
index 0903d46..7ed8131 100644
--- a/drivers/media/dvb-frontends/zl10036.c
+++ b/drivers/media/dvb-frontends/zl10036.c
@@ -446,7 +446,7 @@ static int zl10036_init(struct dvb_frontend *fe)
 	return ret;
 }
 
-static struct dvb_tuner_ops zl10036_tuner_ops = {
+static const struct dvb_tuner_ops zl10036_tuner_ops = {
 	.info = {
 		.name = "Zarlink ZL10036",
 		.frequency_min = 950000,
diff --git a/drivers/media/dvb-frontends/zl10039.c b/drivers/media/dvb-frontends/zl10039.c
index ee09ec2..f8c271b 100644
--- a/drivers/media/dvb-frontends/zl10039.c
+++ b/drivers/media/dvb-frontends/zl10039.c
@@ -255,7 +255,7 @@ static int zl10039_release(struct dvb_frontend *fe)
 	return 0;
 }
 
-static struct dvb_tuner_ops zl10039_ops = {
+static const struct dvb_tuner_ops zl10039_ops = {
 	.release = zl10039_release,
 	.init = zl10039_init,
 	.sleep = zl10039_sleep,

