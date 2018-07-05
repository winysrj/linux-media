Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50708 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753254AbeGEW7q (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 18:59:46 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Daniel Scheller <d.scheller.oss@gmail.com>,
        Antti Palosaari <crope@iki.fi>, Michael Buesch <m@bues.ch>,
        Olli Salonen <olli.salonen@iki.fi>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Shuah Khan <shuah@kernel.org>,
        Jaedon Shin <jaedon.shin@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Dan Gopstein <dgopstein@nyu.edu>,
        Akihiro Tsukada <tskd08@gmail.com>, Sean Young <sean@mess.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philippe Ombredanne <pombredanne@nexb.com>
Subject: [PATCH v2 1/3] media: dvb: convert tuner_info frequencies to Hz
Date: Thu,  5 Jul 2018 19:59:35 -0300
Message-Id: <52bc658c97a0779b46f5475a517df88a4e354d9b.1530830503.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1530830503.git.mchehab+samsung@kernel.org>
References: <cover.1530830503.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1530830503.git.mchehab+samsung@kernel.org>
References: <cover.1530830503.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now, satellite tuner drivers specify frequencies in kHz,
while terrestrial/cable ones specify in Hz. That's confusing
for developers.

However, the main problem is that universal tuners capable
of handling both satellite and non-satelite delivery systems
are appearing. We end by needing to hack the drivers in
order to support such hybrid tuners.

So, convert everything to specify tuner frequencies in Hz.

Plese notice that a similar patch is also needed for frontends.

Tested-by: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Acked-by: Michael Büsch <m@bues.ch>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/dvb-core/dvb_frontend.c         | 25 ++++++++++++++++---
 drivers/media/dvb-frontends/ascot2e.c         |  6 ++---
 drivers/media/dvb-frontends/cx24113.c         |  8 +++---
 drivers/media/dvb-frontends/dib0070.c         |  8 +++---
 drivers/media/dvb-frontends/dib0090.c         | 12 ++++-----
 drivers/media/dvb-frontends/dvb-pll.c         | 16 ++++++++++--
 drivers/media/dvb-frontends/helene.c          | 12 ++++-----
 drivers/media/dvb-frontends/horus3a.c         |  6 ++---
 drivers/media/dvb-frontends/itd1000.c         |  8 +++---
 drivers/media/dvb-frontends/ix2505v.c         |  4 +--
 drivers/media/dvb-frontends/stb6000.c         |  4 +--
 drivers/media/dvb-frontends/stb6100.c         |  5 ++--
 drivers/media/dvb-frontends/stv6110.c         |  6 ++---
 drivers/media/dvb-frontends/stv6110x.c        |  7 +++---
 drivers/media/dvb-frontends/stv6111.c         |  5 ++--
 drivers/media/dvb-frontends/tda18271c2dd.c    |  6 ++---
 drivers/media/dvb-frontends/tda665x.c         |  6 ++---
 drivers/media/dvb-frontends/tda8261.c         |  9 +++----
 drivers/media/dvb-frontends/tda826x.c         |  4 +--
 drivers/media/dvb-frontends/ts2020.c          |  4 +--
 drivers/media/dvb-frontends/tua6100.c         |  6 ++---
 drivers/media/dvb-frontends/zl10036.c         |  4 +--
 drivers/media/tuners/e4000.c                  |  6 ++---
 drivers/media/tuners/fc0011.c                 |  6 ++---
 drivers/media/tuners/fc0012.c                 |  7 +++---
 drivers/media/tuners/fc0013.c                 |  7 +++---
 drivers/media/tuners/fc2580.c                 |  6 ++---
 drivers/media/tuners/it913x.c                 |  6 ++---
 drivers/media/tuners/m88rs6000t.c             |  6 ++---
 drivers/media/tuners/max2165.c                |  8 +++---
 drivers/media/tuners/mc44s803.c               |  8 +++---
 drivers/media/tuners/mt2060.c                 |  8 +++---
 drivers/media/tuners/mt2063.c                 |  7 +++---
 drivers/media/tuners/mt2131.c                 |  8 +++---
 drivers/media/tuners/mt2266.c                 |  8 +++---
 drivers/media/tuners/mxl301rf.c               |  4 +--
 drivers/media/tuners/mxl5005s.c               |  8 +++---
 drivers/media/tuners/qm1d1b0004.c             |  4 +--
 drivers/media/tuners/qm1d1c0042.c             |  4 +--
 drivers/media/tuners/qt1010.c                 |  8 +++---
 drivers/media/tuners/qt1010_priv.h            | 14 ++++++-----
 drivers/media/tuners/r820t.c                  |  6 ++---
 drivers/media/tuners/si2157.c                 |  6 ++---
 drivers/media/tuners/tda18212.c               |  8 +++---
 drivers/media/tuners/tda18218.c               |  8 +++---
 drivers/media/tuners/tda18250.c               |  6 ++---
 drivers/media/tuners/tda18271-fe.c            |  6 ++---
 drivers/media/tuners/tda827x.c                | 12 ++++-----
 drivers/media/tuners/tua9001.c                |  6 ++---
 drivers/media/tuners/tuner-xc2028.c           |  6 ++---
 drivers/media/tuners/xc4000.c                 | 12 ++++-----
 drivers/media/tuners/xc5000.c                 | 12 ++++-----
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c |  6 ++---
 include/media/dvb_frontend.h                  | 19 +++++++-------
 54 files changed, 221 insertions(+), 196 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index ce25aef39008..75e95b56f8b3 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -896,14 +896,31 @@ static int dvb_frontend_start(struct dvb_frontend *fe)
 static void dvb_frontend_get_frequency_limits(struct dvb_frontend *fe,
 					      u32 *freq_min, u32 *freq_max)
 {
-	*freq_min = max(fe->ops.info.frequency_min, fe->ops.tuner_ops.info.frequency_min);
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	__u32 tuner_min = fe->ops.tuner_ops.info.frequency_min_hz;
+	__u32 tuner_max = fe->ops.tuner_ops.info.frequency_max_hz;
+
+	/* If the standard is for satellite, convert frequencies to kHz */
+	switch (c->delivery_system) {
+	case SYS_DVBS:
+	case SYS_DVBS2:
+	case SYS_TURBO:
+	case SYS_ISDBS:
+		tuner_max /= kHz;
+		tuner_min /= kHz;
+		break;
+	default:
+		break;
+	}
+
+	*freq_min = max(fe->ops.info.frequency_min, tuner_min);
 
 	if (fe->ops.info.frequency_max == 0)
-		*freq_max = fe->ops.tuner_ops.info.frequency_max;
-	else if (fe->ops.tuner_ops.info.frequency_max == 0)
+		*freq_max = tuner_max;
+	else if (tuner_max == 0)
 		*freq_max = fe->ops.info.frequency_max;
 	else
-		*freq_max = min(fe->ops.info.frequency_max, fe->ops.tuner_ops.info.frequency_max);
+		*freq_max = min(fe->ops.info.frequency_max, tuner_max);
 
 	if (*freq_min == 0 || *freq_max == 0)
 		dev_warn(fe->dvb->device,
diff --git a/drivers/media/dvb-frontends/ascot2e.c b/drivers/media/dvb-frontends/ascot2e.c
index 9746c6dd7fb8..52ce0e6e2a15 100644
--- a/drivers/media/dvb-frontends/ascot2e.c
+++ b/drivers/media/dvb-frontends/ascot2e.c
@@ -468,9 +468,9 @@ static int ascot2e_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 static const struct dvb_tuner_ops ascot2e_tuner_ops = {
 	.info = {
 		.name = "Sony ASCOT2E",
-		.frequency_min = 1000000,
-		.frequency_max = 1200000000,
-		.frequency_step = 25000,
+		.frequency_min_hz  =    1 * MHz,
+		.frequency_max_hz  = 1200 * MHz,
+		.frequency_step_hz =   25 * kHz,
 	},
 	.init = ascot2e_init,
 	.release = ascot2e_release,
diff --git a/drivers/media/dvb-frontends/cx24113.c b/drivers/media/dvb-frontends/cx24113.c
index 037db3e9d2dd..91a5033b6bd7 100644
--- a/drivers/media/dvb-frontends/cx24113.c
+++ b/drivers/media/dvb-frontends/cx24113.c
@@ -533,10 +533,10 @@ static void cx24113_release(struct dvb_frontend *fe)
 
 static const struct dvb_tuner_ops cx24113_tuner_ops = {
 	.info = {
-		.name           = "Conexant CX24113",
-		.frequency_min  = 950000,
-		.frequency_max  = 2150000,
-		.frequency_step = 125,
+		.name              = "Conexant CX24113",
+		.frequency_min_hz  =  950 * MHz,
+		.frequency_max_hz  = 2150 * MHz,
+		.frequency_step_hz =  125 * kHz,
 	},
 
 	.release       = cx24113_release,
diff --git a/drivers/media/dvb-frontends/dib0070.c b/drivers/media/dvb-frontends/dib0070.c
index 932d235118e2..37ebd5af8fd4 100644
--- a/drivers/media/dvb-frontends/dib0070.c
+++ b/drivers/media/dvb-frontends/dib0070.c
@@ -726,10 +726,10 @@ static void dib0070_release(struct dvb_frontend *fe)
 
 static const struct dvb_tuner_ops dib0070_ops = {
 	.info = {
-		.name           = "DiBcom DiB0070",
-		.frequency_min  =  45000000,
-		.frequency_max  = 860000000,
-		.frequency_step =      1000,
+		.name              = "DiBcom DiB0070",
+		.frequency_min_hz  =  45 * MHz,
+		.frequency_max_hz  = 860 * MHz,
+		.frequency_step_hz =   1 * kHz,
 	},
 	.release       = dib0070_release,
 
diff --git a/drivers/media/dvb-frontends/dib0090.c b/drivers/media/dvb-frontends/dib0090.c
index ee7af34979ed..44a074261e69 100644
--- a/drivers/media/dvb-frontends/dib0090.c
+++ b/drivers/media/dvb-frontends/dib0090.c
@@ -2578,9 +2578,9 @@ static int dib0090_set_params(struct dvb_frontend *fe)
 static const struct dvb_tuner_ops dib0090_ops = {
 	.info = {
 		 .name = "DiBcom DiB0090",
-		 .frequency_min = 45000000,
-		 .frequency_max = 860000000,
-		 .frequency_step = 1000,
+		 .frequency_min_hz  =  45 * MHz,
+		 .frequency_max_hz  = 860 * MHz,
+		 .frequency_step_hz =   1 * kHz,
 		 },
 	.release = dib0090_release,
 
@@ -2593,9 +2593,9 @@ static const struct dvb_tuner_ops dib0090_ops = {
 static const struct dvb_tuner_ops dib0090_fw_ops = {
 	.info = {
 		 .name = "DiBcom DiB0090",
-		 .frequency_min = 45000000,
-		 .frequency_max = 860000000,
-		 .frequency_step = 1000,
+		 .frequency_min_hz  =  45 * MHz,
+		 .frequency_max_hz  = 860 * MHz,
+		 .frequency_step_hz =   1 * kHz,
 		 },
 	.release = dib0090_release,
 
diff --git a/drivers/media/dvb-frontends/dvb-pll.c b/drivers/media/dvb-frontends/dvb-pll.c
index e3894ff403d7..fdbdfb2c74db 100644
--- a/drivers/media/dvb-frontends/dvb-pll.c
+++ b/drivers/media/dvb-frontends/dvb-pll.c
@@ -799,6 +799,7 @@ struct dvb_frontend *dvb_pll_attach(struct dvb_frontend *fe, int pll_addr,
 	struct dvb_pll_priv *priv = NULL;
 	int ret;
 	const struct dvb_pll_desc *desc;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
 	b1 = kmalloc(1, GFP_KERNEL);
 	if (!b1)
@@ -844,8 +845,19 @@ struct dvb_frontend *dvb_pll_attach(struct dvb_frontend *fe, int pll_addr,
 
 	strncpy(fe->ops.tuner_ops.info.name, desc->name,
 		sizeof(fe->ops.tuner_ops.info.name));
-	fe->ops.tuner_ops.info.frequency_min = desc->min;
-	fe->ops.tuner_ops.info.frequency_max = desc->max;
+	switch (c->delivery_system) {
+	case SYS_DVBS:
+	case SYS_DVBS2:
+	case SYS_TURBO:
+	case SYS_ISDBS:
+		fe->ops.tuner_ops.info.frequency_min_hz = desc->min * kHz;
+		fe->ops.tuner_ops.info.frequency_max_hz = desc->max * kHz;
+		break;
+	default:
+		fe->ops.tuner_ops.info.frequency_min_hz = desc->min;
+		fe->ops.tuner_ops.info.frequency_max_hz = desc->max;
+	}
+
 	if (!desc->initdata)
 		fe->ops.tuner_ops.init = NULL;
 	if (!desc->sleepdata)
diff --git a/drivers/media/dvb-frontends/helene.c b/drivers/media/dvb-frontends/helene.c
index a0d0b53c91d7..e9c44aba50c6 100644
--- a/drivers/media/dvb-frontends/helene.c
+++ b/drivers/media/dvb-frontends/helene.c
@@ -846,9 +846,9 @@ static int helene_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 static const struct dvb_tuner_ops helene_tuner_ops = {
 	.info = {
 		.name = "Sony HELENE Ter tuner",
-		.frequency_min = 1000000,
-		.frequency_max = 1200000000,
-		.frequency_step = 25000,
+		.frequency_min_hz  =    1 * MHz,
+		.frequency_max_hz  = 1200 * MHz,
+		.frequency_step_hz =   25 * kHz,
 	},
 	.init = helene_init,
 	.release = helene_release,
@@ -860,9 +860,9 @@ static const struct dvb_tuner_ops helene_tuner_ops = {
 static const struct dvb_tuner_ops helene_tuner_ops_s = {
 	.info = {
 		.name = "Sony HELENE Sat tuner",
-		.frequency_min = 500000,
-		.frequency_max = 2500000,
-		.frequency_step = 1000,
+		.frequency_min_hz  =  500 * MHz,
+		.frequency_max_hz  = 2500 * MHz,
+		.frequency_step_hz =    1 * MHz,
 	},
 	.init = helene_init,
 	.release = helene_release,
diff --git a/drivers/media/dvb-frontends/horus3a.c b/drivers/media/dvb-frontends/horus3a.c
index 5e7e265a52e6..02bc08081971 100644
--- a/drivers/media/dvb-frontends/horus3a.c
+++ b/drivers/media/dvb-frontends/horus3a.c
@@ -330,9 +330,9 @@ static int horus3a_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 static const struct dvb_tuner_ops horus3a_tuner_ops = {
 	.info = {
 		.name = "Sony Horus3a",
-		.frequency_min = 950000,
-		.frequency_max = 2150000,
-		.frequency_step = 1000,
+		.frequency_min_hz  =  950 * MHz,
+		.frequency_max_hz  = 2150 * MHz,
+		.frequency_step_hz =    1 * MHz,
 	},
 	.init = horus3a_init,
 	.release = horus3a_release,
diff --git a/drivers/media/dvb-frontends/itd1000.c b/drivers/media/dvb-frontends/itd1000.c
index 04f7f6854f73..c3a6e81ae87f 100644
--- a/drivers/media/dvb-frontends/itd1000.c
+++ b/drivers/media/dvb-frontends/itd1000.c
@@ -353,10 +353,10 @@ static void itd1000_release(struct dvb_frontend *fe)
 
 static const struct dvb_tuner_ops itd1000_tuner_ops = {
 	.info = {
-		.name           = "Integrant ITD1000",
-		.frequency_min  = 950000,
-		.frequency_max  = 2150000,
-		.frequency_step = 125,     /* kHz for QPSK frontends */
+		.name              = "Integrant ITD1000",
+		.frequency_min_hz  =  950 * MHz,
+		.frequency_max_hz  = 2150 * MHz,
+		.frequency_step_hz =  125 * kHz,
 	},
 
 	.release       = itd1000_release,
diff --git a/drivers/media/dvb-frontends/ix2505v.c b/drivers/media/dvb-frontends/ix2505v.c
index 965012ad5c59..9c055f72c416 100644
--- a/drivers/media/dvb-frontends/ix2505v.c
+++ b/drivers/media/dvb-frontends/ix2505v.c
@@ -256,8 +256,8 @@ static int ix2505v_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 static const struct dvb_tuner_ops ix2505v_tuner_ops = {
 	.info = {
 		.name = "Sharp IX2505V (B0017)",
-		.frequency_min = 950000,
-		.frequency_max = 2175000
+		.frequency_min_hz =  950 * MHz,
+		.frequency_max_hz = 2175 * MHz
 	},
 	.release = ix2505v_release,
 	.set_params = ix2505v_set_params,
diff --git a/drivers/media/dvb-frontends/stb6000.c b/drivers/media/dvb-frontends/stb6000.c
index 69c03892f2da..786b9eccde00 100644
--- a/drivers/media/dvb-frontends/stb6000.c
+++ b/drivers/media/dvb-frontends/stb6000.c
@@ -188,8 +188,8 @@ static int stb6000_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 static const struct dvb_tuner_ops stb6000_tuner_ops = {
 	.info = {
 		.name = "ST STB6000",
-		.frequency_min = 950000,
-		.frequency_max = 2150000
+		.frequency_min_hz =  950 * MHz,
+		.frequency_max_hz = 2150 * MHz
 	},
 	.release = stb6000_release,
 	.sleep = stb6000_sleep,
diff --git a/drivers/media/dvb-frontends/stb6100.c b/drivers/media/dvb-frontends/stb6100.c
index 3a851f524b16..30ac584dfab3 100644
--- a/drivers/media/dvb-frontends/stb6100.c
+++ b/drivers/media/dvb-frontends/stb6100.c
@@ -527,9 +527,8 @@ static int stb6100_set_params(struct dvb_frontend *fe)
 static const struct dvb_tuner_ops stb6100_ops = {
 	.info = {
 		.name			= "STB6100 Silicon Tuner",
-		.frequency_min		= 950000,
-		.frequency_max		= 2150000,
-		.frequency_step		= 0,
+		.frequency_min_hz	=  950 * MHz,
+		.frequency_max_hz	= 2150 * MHz,
 	},
 
 	.init		= stb6100_init,
diff --git a/drivers/media/dvb-frontends/stv6110.c b/drivers/media/dvb-frontends/stv6110.c
index 6aad0efa3174..7db9a5bceccc 100644
--- a/drivers/media/dvb-frontends/stv6110.c
+++ b/drivers/media/dvb-frontends/stv6110.c
@@ -371,9 +371,9 @@ static int stv6110_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
 static const struct dvb_tuner_ops stv6110_tuner_ops = {
 	.info = {
 		.name = "ST STV6110",
-		.frequency_min = 950000,
-		.frequency_max = 2150000,
-		.frequency_step = 1000,
+		.frequency_min_hz  =  950 * MHz,
+		.frequency_max_hz  = 2150 * MHz,
+		.frequency_step_hz =    1 * MHz,
 	},
 	.init = stv6110_init,
 	.release = stv6110_release,
diff --git a/drivers/media/dvb-frontends/stv6110x.c b/drivers/media/dvb-frontends/stv6110x.c
index d8950028d021..82c002d3833a 100644
--- a/drivers/media/dvb-frontends/stv6110x.c
+++ b/drivers/media/dvb-frontends/stv6110x.c
@@ -347,10 +347,9 @@ static void stv6110x_release(struct dvb_frontend *fe)
 
 static const struct dvb_tuner_ops stv6110x_ops = {
 	.info = {
-		.name		= "STV6110(A) Silicon Tuner",
-		.frequency_min	=  950000,
-		.frequency_max	= 2150000,
-		.frequency_step	= 0,
+		.name		  = "STV6110(A) Silicon Tuner",
+		.frequency_min_hz =  950 * MHz,
+		.frequency_max_hz = 2150 * MHz,
 	},
 	.release		= stv6110x_release
 };
diff --git a/drivers/media/dvb-frontends/stv6111.c b/drivers/media/dvb-frontends/stv6111.c
index 9b715b6fe152..0cf460111acb 100644
--- a/drivers/media/dvb-frontends/stv6111.c
+++ b/drivers/media/dvb-frontends/stv6111.c
@@ -646,9 +646,8 @@ static int get_rf_strength(struct dvb_frontend *fe, u16 *st)
 static const struct dvb_tuner_ops tuner_ops = {
 	.info = {
 		.name		= "ST STV6111",
-		.frequency_min	= 950000,
-		.frequency_max	= 2150000,
-		.frequency_step	= 0
+		.frequency_min_hz =  950 * MHz,
+		.frequency_max_hz = 2150 * MHz,
 	},
 	.set_params		= set_params,
 	.release		= release,
diff --git a/drivers/media/dvb-frontends/tda18271c2dd.c b/drivers/media/dvb-frontends/tda18271c2dd.c
index 2e1d36ae943b..972644732217 100644
--- a/drivers/media/dvb-frontends/tda18271c2dd.c
+++ b/drivers/media/dvb-frontends/tda18271c2dd.c
@@ -1214,9 +1214,9 @@ static int get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
 static const struct dvb_tuner_ops tuner_ops = {
 	.info = {
 		.name = "NXP TDA18271C2D",
-		.frequency_min  =  47125000,
-		.frequency_max  = 865000000,
-		.frequency_step =     62500
+		.frequency_min_hz  =  47125 * kHz,
+		.frequency_max_hz  =    865 * MHz,
+		.frequency_step_hz =  62500
 	},
 	.init              = init,
 	.sleep             = sleep,
diff --git a/drivers/media/dvb-frontends/tda665x.c b/drivers/media/dvb-frontends/tda665x.c
index 3ef7140ed7f3..8766c9ff6680 100644
--- a/drivers/media/dvb-frontends/tda665x.c
+++ b/drivers/media/dvb-frontends/tda665x.c
@@ -231,9 +231,9 @@ struct dvb_frontend *tda665x_attach(struct dvb_frontend *fe,
 	info			 = &fe->ops.tuner_ops.info;
 
 	memcpy(info->name, config->name, sizeof(config->name));
-	info->frequency_min	= config->frequency_min;
-	info->frequency_max	= config->frequency_max;
-	info->frequency_step	= config->frequency_offst;
+	info->frequency_min_hz	= config->frequency_min;
+	info->frequency_max_hz	= config->frequency_max;
+	info->frequency_step_hz	= config->frequency_offst;
 
 	printk(KERN_DEBUG "%s: Attaching TDA665x (%s) tuner\n", __func__, info->name);
 
diff --git a/drivers/media/dvb-frontends/tda8261.c b/drivers/media/dvb-frontends/tda8261.c
index f72a54e7eb23..500f50b81b66 100644
--- a/drivers/media/dvb-frontends/tda8261.c
+++ b/drivers/media/dvb-frontends/tda8261.c
@@ -163,10 +163,9 @@ static void tda8261_release(struct dvb_frontend *fe)
 static const struct dvb_tuner_ops tda8261_ops = {
 
 	.info = {
-		.name		= "TDA8261",
-		.frequency_min	=  950000,
-		.frequency_max	= 2150000,
-		.frequency_step = 0
+		.name		   = "TDA8261",
+		.frequency_min_hz  =  950 * MHz,
+		.frequency_max_hz  = 2150 * MHz,
 	},
 
 	.set_params	= tda8261_set_params,
@@ -190,7 +189,7 @@ struct dvb_frontend *tda8261_attach(struct dvb_frontend *fe,
 	fe->tuner_priv		= state;
 	fe->ops.tuner_ops	= tda8261_ops;
 
-	fe->ops.tuner_ops.info.frequency_step = div_tab[config->step_size];
+	fe->ops.tuner_ops.info.frequency_step_hz = div_tab[config->step_size] * kHz;
 
 	pr_info("%s: Attaching TDA8261 8PSK/QPSK tuner\n", __func__);
 
diff --git a/drivers/media/dvb-frontends/tda826x.c b/drivers/media/dvb-frontends/tda826x.c
index da427b4c2aaa..100da5d5fdc5 100644
--- a/drivers/media/dvb-frontends/tda826x.c
+++ b/drivers/media/dvb-frontends/tda826x.c
@@ -131,8 +131,8 @@ static int tda826x_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 static const struct dvb_tuner_ops tda826x_tuner_ops = {
 	.info = {
 		.name = "Philips TDA826X",
-		.frequency_min = 950000,
-		.frequency_max = 2175000
+		.frequency_min_hz =  950 * MHz,
+		.frequency_max_hz = 2175 * MHz
 	},
 	.release = tda826x_release,
 	.sleep = tda826x_sleep,
diff --git a/drivers/media/dvb-frontends/ts2020.c b/drivers/media/dvb-frontends/ts2020.c
index c55882a8da06..3e3e40878633 100644
--- a/drivers/media/dvb-frontends/ts2020.c
+++ b/drivers/media/dvb-frontends/ts2020.c
@@ -498,8 +498,8 @@ static int ts2020_read_signal_strength(struct dvb_frontend *fe,
 static const struct dvb_tuner_ops ts2020_tuner_ops = {
 	.info = {
 		.name = "TS2020",
-		.frequency_min = 950000,
-		.frequency_max = 2150000
+		.frequency_min_hz =  950 * MHz,
+		.frequency_max_hz = 2150 * MHz
 	},
 	.init = ts2020_init,
 	.release = ts2020_release,
diff --git a/drivers/media/dvb-frontends/tua6100.c b/drivers/media/dvb-frontends/tua6100.c
index 1d41abd47f04..b233b7be0b84 100644
--- a/drivers/media/dvb-frontends/tua6100.c
+++ b/drivers/media/dvb-frontends/tua6100.c
@@ -155,9 +155,9 @@ static int tua6100_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 static const struct dvb_tuner_ops tua6100_tuner_ops = {
 	.info = {
 		.name = "Infineon TUA6100",
-		.frequency_min = 950000,
-		.frequency_max = 2150000,
-		.frequency_step = 1000,
+		.frequency_min_hz  =  950 * MHz,
+		.frequency_max_hz  = 2150 * MHz,
+		.frequency_step_hz =    1 * MHz,
 	},
 	.release = tua6100_release,
 	.sleep = tua6100_sleep,
diff --git a/drivers/media/dvb-frontends/zl10036.c b/drivers/media/dvb-frontends/zl10036.c
index 89dd65ae88ad..e5a432fd84c3 100644
--- a/drivers/media/dvb-frontends/zl10036.c
+++ b/drivers/media/dvb-frontends/zl10036.c
@@ -443,8 +443,8 @@ static int zl10036_init(struct dvb_frontend *fe)
 static const struct dvb_tuner_ops zl10036_tuner_ops = {
 	.info = {
 		.name = "Zarlink ZL10036",
-		.frequency_min = 950000,
-		.frequency_max = 2175000
+		.frequency_min_hz =  950 * MHz,
+		.frequency_max_hz = 2175 * MHz
 	},
 	.init = zl10036_init,
 	.release = zl10036_release,
diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index b5b9d87ba75c..fbec1a13dc6a 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -610,9 +610,9 @@ static int e4000_dvb_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 
 static const struct dvb_tuner_ops e4000_dvb_tuner_ops = {
 	.info = {
-		.name           = "Elonics E4000",
-		.frequency_min  = 174000000,
-		.frequency_max  = 862000000,
+		.name              = "Elonics E4000",
+		.frequency_min_hz  = 174 * MHz,
+		.frequency_max_hz  = 862 * MHz,
 	},
 
 	.init = e4000_dvb_init,
diff --git a/drivers/media/tuners/fc0011.c b/drivers/media/tuners/fc0011.c
index 145407dee3db..a983899c6b0b 100644
--- a/drivers/media/tuners/fc0011.c
+++ b/drivers/media/tuners/fc0011.c
@@ -472,10 +472,10 @@ static int fc0011_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
 
 static const struct dvb_tuner_ops fc0011_tuner_ops = {
 	.info = {
-		.name		= "Fitipower FC0011",
+		.name		  = "Fitipower FC0011",
 
-		.frequency_min	= 45000000,
-		.frequency_max	= 1000000000,
+		.frequency_min_hz =   45 * MHz,
+		.frequency_max_hz = 1000 * MHz,
 	},
 
 	.release		= fc0011_release,
diff --git a/drivers/media/tuners/fc0012.c b/drivers/media/tuners/fc0012.c
index 625ac6f51c39..e992b98ae5bc 100644
--- a/drivers/media/tuners/fc0012.c
+++ b/drivers/media/tuners/fc0012.c
@@ -415,11 +415,10 @@ static int fc0012_get_rf_strength(struct dvb_frontend *fe, u16 *strength)
 
 static const struct dvb_tuner_ops fc0012_tuner_ops = {
 	.info = {
-		.name           = "Fitipower FC0012",
+		.name              = "Fitipower FC0012",
 
-		.frequency_min  = 37000000,	/* estimate */
-		.frequency_max  = 862000000,	/* estimate */
-		.frequency_step = 0,
+		.frequency_min_hz  =  37 * MHz,	/* estimate */
+		.frequency_max_hz  = 862 * MHz,	/* estimate */
 	},
 
 	.release	= fc0012_release,
diff --git a/drivers/media/tuners/fc0013.c b/drivers/media/tuners/fc0013.c
index e606118d1a9b..fc62afb1450d 100644
--- a/drivers/media/tuners/fc0013.c
+++ b/drivers/media/tuners/fc0013.c
@@ -574,11 +574,10 @@ static int fc0013_get_rf_strength(struct dvb_frontend *fe, u16 *strength)
 
 static const struct dvb_tuner_ops fc0013_tuner_ops = {
 	.info = {
-		.name		= "Fitipower FC0013",
+		.name		  = "Fitipower FC0013",
 
-		.frequency_min	= 37000000,	/* estimate */
-		.frequency_max	= 1680000000,	/* CHECK */
-		.frequency_step	= 0,
+		.frequency_min_hz =   37 * MHz,	/* estimate */
+		.frequency_max_hz = 1680 * MHz,	/* CHECK */
 	},
 
 	.release	= fc0013_release,
diff --git a/drivers/media/tuners/fc2580.c b/drivers/media/tuners/fc2580.c
index 743184ae0d26..db26892aac84 100644
--- a/drivers/media/tuners/fc2580.c
+++ b/drivers/media/tuners/fc2580.c
@@ -355,9 +355,9 @@ static int fc2580_dvb_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 
 static const struct dvb_tuner_ops fc2580_dvb_tuner_ops = {
 	.info = {
-		.name           = "FCI FC2580",
-		.frequency_min  = 174000000,
-		.frequency_max  = 862000000,
+		.name             = "FCI FC2580",
+		.frequency_min_hz = 174 * MHz,
+		.frequency_max_hz = 862 * MHz,
 	},
 
 	.init = fc2580_dvb_init,
diff --git a/drivers/media/tuners/it913x.c b/drivers/media/tuners/it913x.c
index 27e5bc1c3cb5..b5eb39921e95 100644
--- a/drivers/media/tuners/it913x.c
+++ b/drivers/media/tuners/it913x.c
@@ -375,9 +375,9 @@ static int it913x_set_params(struct dvb_frontend *fe)
 
 static const struct dvb_tuner_ops it913x_tuner_ops = {
 	.info = {
-		.name           = "ITE IT913X",
-		.frequency_min  = 174000000,
-		.frequency_max  = 862000000,
+		.name             = "ITE IT913X",
+		.frequency_min_hz = 174 * MHz,
+		.frequency_max_hz = 862 * MHz,
 	},
 
 	.init = it913x_init,
diff --git a/drivers/media/tuners/m88rs6000t.c b/drivers/media/tuners/m88rs6000t.c
index 9f3e0fd4cad9..3df2f23a40be 100644
--- a/drivers/media/tuners/m88rs6000t.c
+++ b/drivers/media/tuners/m88rs6000t.c
@@ -569,9 +569,9 @@ static int m88rs6000t_get_rf_strength(struct dvb_frontend *fe, u16 *strength)
 
 static const struct dvb_tuner_ops m88rs6000t_tuner_ops = {
 	.info = {
-		.name          = "Montage M88RS6000 Internal Tuner",
-		.frequency_min = 950000,
-		.frequency_max = 2150000,
+		.name             = "Montage M88RS6000 Internal Tuner",
+		.frequency_min_hz =  950 * MHz,
+		.frequency_max_hz = 2150 * MHz,
 	},
 
 	.init = m88rs6000t_init,
diff --git a/drivers/media/tuners/max2165.c b/drivers/media/tuners/max2165.c
index 20ceb72e530b..721d8f722efb 100644
--- a/drivers/media/tuners/max2165.c
+++ b/drivers/media/tuners/max2165.c
@@ -377,10 +377,10 @@ static void max2165_release(struct dvb_frontend *fe)
 
 static const struct dvb_tuner_ops max2165_tuner_ops = {
 	.info = {
-		.name           = "Maxim MAX2165",
-		.frequency_min  = 470000000,
-		.frequency_max  = 862000000,
-		.frequency_step =     50000,
+		.name              = "Maxim MAX2165",
+		.frequency_min_hz  = 470 * MHz,
+		.frequency_max_hz  = 862 * MHz,
+		.frequency_step_hz =  50 * kHz,
 	},
 
 	.release	   = max2165_release,
diff --git a/drivers/media/tuners/mc44s803.c b/drivers/media/tuners/mc44s803.c
index 403c6b2aa53b..2023e081d9ad 100644
--- a/drivers/media/tuners/mc44s803.c
+++ b/drivers/media/tuners/mc44s803.c
@@ -300,10 +300,10 @@ static int mc44s803_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 
 static const struct dvb_tuner_ops mc44s803_tuner_ops = {
 	.info = {
-		.name           = "Freescale MC44S803",
-		.frequency_min  =   48000000,
-		.frequency_max  = 1000000000,
-		.frequency_step =     100000,
+		.name              = "Freescale MC44S803",
+		.frequency_min_hz  =   48 * MHz,
+		.frequency_max_hz  = 1000 * MHz,
+		.frequency_step_hz =  100 * kHz,
 	},
 
 	.release       = mc44s803_release,
diff --git a/drivers/media/tuners/mt2060.c b/drivers/media/tuners/mt2060.c
index 3d3c6815b6a7..4ace77cfe285 100644
--- a/drivers/media/tuners/mt2060.c
+++ b/drivers/media/tuners/mt2060.c
@@ -395,10 +395,10 @@ static void mt2060_release(struct dvb_frontend *fe)
 
 static const struct dvb_tuner_ops mt2060_tuner_ops = {
 	.info = {
-		.name           = "Microtune MT2060",
-		.frequency_min  =  48000000,
-		.frequency_max  = 860000000,
-		.frequency_step =     50000,
+		.name              = "Microtune MT2060",
+		.frequency_min_hz  =  48 * MHz,
+		.frequency_max_hz  = 860 * MHz,
+		.frequency_step_hz =  50 * kHz,
 	},
 
 	.release       = mt2060_release,
diff --git a/drivers/media/tuners/mt2063.c b/drivers/media/tuners/mt2063.c
index 80dc3e241b4a..f4c8a7293ebb 100644
--- a/drivers/media/tuners/mt2063.c
+++ b/drivers/media/tuners/mt2063.c
@@ -2200,10 +2200,9 @@ static int mt2063_get_bandwidth(struct dvb_frontend *fe, u32 *bw)
 static const struct dvb_tuner_ops mt2063_ops = {
 	.info = {
 		 .name = "MT2063 Silicon Tuner",
-		 .frequency_min = 45000000,
-		 .frequency_max = 865000000,
-		 .frequency_step = 0,
-		 },
+		 .frequency_min_hz  =  45 * MHz,
+		 .frequency_max_hz  = 865 * MHz,
+	 },
 
 	.init = mt2063_init,
 	.sleep = MT2063_Sleep,
diff --git a/drivers/media/tuners/mt2131.c b/drivers/media/tuners/mt2131.c
index 659bf19dc434..086a7b7cf634 100644
--- a/drivers/media/tuners/mt2131.c
+++ b/drivers/media/tuners/mt2131.c
@@ -235,10 +235,10 @@ static void mt2131_release(struct dvb_frontend *fe)
 
 static const struct dvb_tuner_ops mt2131_tuner_ops = {
 	.info = {
-		.name           = "Microtune MT2131",
-		.frequency_min  =  48000000,
-		.frequency_max  = 860000000,
-		.frequency_step =     50000,
+		.name              = "Microtune MT2131",
+		.frequency_min_hz  =  48 * MHz,
+		.frequency_max_hz  = 860 * MHz,
+		.frequency_step_hz =  50 * kHz,
 	},
 
 	.release       = mt2131_release,
diff --git a/drivers/media/tuners/mt2266.c b/drivers/media/tuners/mt2266.c
index f4545b7f5da2..e6cc78720de4 100644
--- a/drivers/media/tuners/mt2266.c
+++ b/drivers/media/tuners/mt2266.c
@@ -304,10 +304,10 @@ static void mt2266_release(struct dvb_frontend *fe)
 
 static const struct dvb_tuner_ops mt2266_tuner_ops = {
 	.info = {
-		.name           = "Microtune MT2266",
-		.frequency_min  = 174000000,
-		.frequency_max  = 862000000,
-		.frequency_step =     50000,
+		.name              = "Microtune MT2266",
+		.frequency_min_hz  = 174 * MHz,
+		.frequency_max_hz  = 862 * MHz,
+		.frequency_step_hz =  50 * kHz,
 	},
 	.release       = mt2266_release,
 	.init          = mt2266_init,
diff --git a/drivers/media/tuners/mxl301rf.c b/drivers/media/tuners/mxl301rf.c
index 57b0e4862aaf..c628435a1b06 100644
--- a/drivers/media/tuners/mxl301rf.c
+++ b/drivers/media/tuners/mxl301rf.c
@@ -271,8 +271,8 @@ static const struct dvb_tuner_ops mxl301rf_ops = {
 	.info = {
 		.name = "MaxLinear MxL301RF",
 
-		.frequency_min =  93000000,
-		.frequency_max = 803142857,
+		.frequency_min_hz =  93 * MHz,
+		.frequency_max_hz = 803 * MHz + 142857,
 	},
 
 	.init = mxl301rf_init,
diff --git a/drivers/media/tuners/mxl5005s.c b/drivers/media/tuners/mxl5005s.c
index 355ef2959b7d..ec584316c812 100644
--- a/drivers/media/tuners/mxl5005s.c
+++ b/drivers/media/tuners/mxl5005s.c
@@ -4075,10 +4075,10 @@ static void mxl5005s_release(struct dvb_frontend *fe)
 
 static const struct dvb_tuner_ops mxl5005s_tuner_ops = {
 	.info = {
-		.name           = "MaxLinear MXL5005S",
-		.frequency_min  =  48000000,
-		.frequency_max  = 860000000,
-		.frequency_step =     50000,
+		.name              = "MaxLinear MXL5005S",
+		.frequency_min_hz  =  48 * MHz,
+		.frequency_max_hz  = 860 * MHz,
+		.frequency_step_hz =  50 * kHz,
 	},
 
 	.release       = mxl5005s_release,
diff --git a/drivers/media/tuners/qm1d1b0004.c b/drivers/media/tuners/qm1d1b0004.c
index b4495cc1626b..008ad870c00f 100644
--- a/drivers/media/tuners/qm1d1b0004.c
+++ b/drivers/media/tuners/qm1d1b0004.c
@@ -186,8 +186,8 @@ static const struct dvb_tuner_ops qm1d1b0004_ops = {
 	.info = {
 		.name = "Sharp qm1d1b0004",
 
-		.frequency_min =  950000,
-		.frequency_max = 2150000,
+		.frequency_min_hz =  950 * MHz,
+		.frequency_max_hz = 2150 * MHz,
 	},
 
 	.init = qm1d1b0004_init,
diff --git a/drivers/media/tuners/qm1d1c0042.c b/drivers/media/tuners/qm1d1c0042.c
index 642a065b9a07..83ca5dc047ea 100644
--- a/drivers/media/tuners/qm1d1c0042.c
+++ b/drivers/media/tuners/qm1d1c0042.c
@@ -388,8 +388,8 @@ static const struct dvb_tuner_ops qm1d1c0042_ops = {
 	.info = {
 		.name = "Sharp QM1D1C0042",
 
-		.frequency_min =  950000,
-		.frequency_max = 2150000,
+		.frequency_min_hz =  950 * MHz,
+		.frequency_max_hz = 2150 * MHz,
 	},
 
 	.init = qm1d1c0042_init,
diff --git a/drivers/media/tuners/qt1010.c b/drivers/media/tuners/qt1010.c
index b92be882ab3c..4565c06b1617 100644
--- a/drivers/media/tuners/qt1010.c
+++ b/drivers/media/tuners/qt1010.c
@@ -394,10 +394,10 @@ static int qt1010_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 
 static const struct dvb_tuner_ops qt1010_tuner_ops = {
 	.info = {
-		.name           = "Quantek QT1010",
-		.frequency_min  = QT1010_MIN_FREQ,
-		.frequency_max  = QT1010_MAX_FREQ,
-		.frequency_step = QT1010_STEP,
+		.name              = "Quantek QT1010",
+		.frequency_min_hz  = QT1010_MIN_FREQ,
+		.frequency_max_hz  = QT1010_MAX_FREQ,
+		.frequency_step_hz = QT1010_STEP,
 	},
 
 	.release       = qt1010_release,
diff --git a/drivers/media/tuners/qt1010_priv.h b/drivers/media/tuners/qt1010_priv.h
index 4cb78ecc8985..f25324c63067 100644
--- a/drivers/media/tuners/qt1010_priv.h
+++ b/drivers/media/tuners/qt1010_priv.h
@@ -71,12 +71,14 @@ reg def meaning
 2f  00  ? not used?
 */
 
-#define QT1010_STEP         125000 /*  125 kHz used by Windows drivers,
-				      hw could be more precise but we don't
-				      know how to use */
-#define QT1010_MIN_FREQ   48000000 /*   48 MHz */
-#define QT1010_MAX_FREQ  860000000 /*  860 MHz */
-#define QT1010_OFFSET   1246000000 /* 1246 MHz */
+#define QT1010_STEP         (125 * kHz) /*
+					 * used by Windows drivers,
+				         * hw could be more precise but we don't
+				         * know how to use
+					 */
+#define QT1010_MIN_FREQ   (48 * MHz)
+#define QT1010_MAX_FREQ  (860 * MHz)
+#define QT1010_OFFSET   (1246 * MHz)
 
 #define QT1010_WR 0
 #define QT1010_RD 1
diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 3e14b9e2e763..ba4be08a8551 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -2297,9 +2297,9 @@ static void r820t_release(struct dvb_frontend *fe)
 
 static const struct dvb_tuner_ops r820t_tuner_ops = {
 	.info = {
-		.name           = "Rafael Micro R820T",
-		.frequency_min  =   42000000,
-		.frequency_max  = 1002000000,
+		.name             = "Rafael Micro R820T",
+		.frequency_min_hz =   42 * MHz,
+		.frequency_max_hz = 1002 * MHz,
 	},
 	.init = r820t_init,
 	.release = r820t_release,
diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 9e34d31d724d..a08d8fe2bb1b 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -387,9 +387,9 @@ static int si2157_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 
 static const struct dvb_tuner_ops si2157_ops = {
 	.info = {
-		.name           = "Silicon Labs Si2141/Si2146/2147/2148/2157/2158",
-		.frequency_min  = 42000000,
-		.frequency_max  = 870000000,
+		.name             = "Silicon Labs Si2141/Si2146/2147/2148/2157/2158",
+		.frequency_min_hz =  42 * MHz,
+		.frequency_max_hz = 870 * MHz,
 	},
 
 	.init = si2157_init,
diff --git a/drivers/media/tuners/tda18212.c b/drivers/media/tuners/tda18212.c
index 7b8068354fea..8326106ec2e3 100644
--- a/drivers/media/tuners/tda18212.c
+++ b/drivers/media/tuners/tda18212.c
@@ -175,11 +175,11 @@ static int tda18212_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 
 static const struct dvb_tuner_ops tda18212_tuner_ops = {
 	.info = {
-		.name           = "NXP TDA18212",
+		.name              = "NXP TDA18212",
 
-		.frequency_min  =  48000000,
-		.frequency_max  = 864000000,
-		.frequency_step =      1000,
+		.frequency_min_hz  =  48 * MHz,
+		.frequency_max_hz  = 864 * MHz,
+		.frequency_step_hz =   1 * kHz,
 	},
 
 	.set_params    = tda18212_set_params,
diff --git a/drivers/media/tuners/tda18218.c b/drivers/media/tuners/tda18218.c
index c56fcf5d48e3..cbbd4d5e15da 100644
--- a/drivers/media/tuners/tda18218.c
+++ b/drivers/media/tuners/tda18218.c
@@ -269,11 +269,11 @@ static void tda18218_release(struct dvb_frontend *fe)
 
 static const struct dvb_tuner_ops tda18218_tuner_ops = {
 	.info = {
-		.name           = "NXP TDA18218",
+		.name              = "NXP TDA18218",
 
-		.frequency_min  = 174000000,
-		.frequency_max  = 864000000,
-		.frequency_step =      1000,
+		.frequency_min_hz  = 174 * MHz,
+		.frequency_max_hz  = 864 * MHz,
+		.frequency_step_hz =   1 * kHz,
 	},
 
 	.release       = tda18218_release,
diff --git a/drivers/media/tuners/tda18250.c b/drivers/media/tuners/tda18250.c
index 20d12b063380..20d10ef45ab6 100644
--- a/drivers/media/tuners/tda18250.c
+++ b/drivers/media/tuners/tda18250.c
@@ -740,9 +740,9 @@ static int tda18250_sleep(struct dvb_frontend *fe)
 
 static const struct dvb_tuner_ops tda18250_ops = {
 	.info = {
-		.name           = "NXP TDA18250",
-		.frequency_min  = 42000000,
-		.frequency_max  = 870000000,
+		.name              = "NXP TDA18250",
+		.frequency_min_hz  =  42 * MHz,
+		.frequency_max_hz  = 870 * MHz,
 	},
 
 	.init = tda18250_init,
diff --git a/drivers/media/tuners/tda18271-fe.c b/drivers/media/tuners/tda18271-fe.c
index 147155553648..4d69029229e4 100644
--- a/drivers/media/tuners/tda18271-fe.c
+++ b/drivers/media/tuners/tda18271-fe.c
@@ -1240,9 +1240,9 @@ static int tda18271_set_config(struct dvb_frontend *fe, void *priv_cfg)
 static const struct dvb_tuner_ops tda18271_tuner_ops = {
 	.info = {
 		.name = "NXP TDA18271HD",
-		.frequency_min  =  45000000,
-		.frequency_max  = 864000000,
-		.frequency_step =     62500
+		.frequency_min_hz  =  45 * MHz,
+		.frequency_max_hz  = 864 * MHz,
+		.frequency_step_hz = 62500
 	},
 	.init              = tda18271_init,
 	.sleep             = tda18271_sleep,
diff --git a/drivers/media/tuners/tda827x.c b/drivers/media/tuners/tda827x.c
index 8400808f8f7f..4391dabba510 100644
--- a/drivers/media/tuners/tda827x.c
+++ b/drivers/media/tuners/tda827x.c
@@ -816,9 +816,9 @@ static int tda827x_initial_sleep(struct dvb_frontend *fe)
 static const struct dvb_tuner_ops tda827xo_tuner_ops = {
 	.info = {
 		.name = "Philips TDA827X",
-		.frequency_min  =  55000000,
-		.frequency_max  = 860000000,
-		.frequency_step =    250000
+		.frequency_min_hz  =  55 * MHz,
+		.frequency_max_hz  = 860 * MHz,
+		.frequency_step_hz = 250 * kHz
 	},
 	.release = tda827x_release,
 	.init = tda827x_initial_init,
@@ -832,9 +832,9 @@ static const struct dvb_tuner_ops tda827xo_tuner_ops = {
 static const struct dvb_tuner_ops tda827xa_tuner_ops = {
 	.info = {
 		.name = "Philips TDA827XA",
-		.frequency_min  =  44000000,
-		.frequency_max  = 906000000,
-		.frequency_step =     62500
+		.frequency_min_hz  =  44 * MHz,
+		.frequency_max_hz  = 906 * MHz,
+		.frequency_step_hz = 62500
 	},
 	.release = tda827x_release,
 	.init = tda827x_init,
diff --git a/drivers/media/tuners/tua9001.c b/drivers/media/tuners/tua9001.c
index 9d70378fe2d3..5c89a130b47d 100644
--- a/drivers/media/tuners/tua9001.c
+++ b/drivers/media/tuners/tua9001.c
@@ -164,9 +164,9 @@ static int tua9001_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 
 static const struct dvb_tuner_ops tua9001_tuner_ops = {
 	.info = {
-		.name           = "Infineon TUA9001",
-		.frequency_min  = 170000000,
-		.frequency_max  = 862000000,
+		.name             = "Infineon TUA9001",
+		.frequency_min_hz = 170 * MHz,
+		.frequency_max_hz = 862 * MHz,
 	},
 
 	.init = tua9001_init,
diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
index 84744e138982..222b93ef31c0 100644
--- a/drivers/media/tuners/tuner-xc2028.c
+++ b/drivers/media/tuners/tuner-xc2028.c
@@ -1440,9 +1440,9 @@ static int xc2028_set_config(struct dvb_frontend *fe, void *priv_cfg)
 static const struct dvb_tuner_ops xc2028_dvb_tuner_ops = {
 	.info = {
 		 .name = "Xceive XC3028",
-		 .frequency_min = 42000000,
-		 .frequency_max = 864000000,
-		 .frequency_step = 50000,
+		 .frequency_min_hz  =  42 * MHz,
+		 .frequency_max_hz  = 864 * MHz,
+		 .frequency_step_hz =  50 * kHz,
 		 },
 
 	.set_config	   = xc2028_set_config,
diff --git a/drivers/media/tuners/xc4000.c b/drivers/media/tuners/xc4000.c
index f0fa8da08afa..76b3f37f24a8 100644
--- a/drivers/media/tuners/xc4000.c
+++ b/drivers/media/tuners/xc4000.c
@@ -398,8 +398,8 @@ static int xc_set_rf_frequency(struct xc4000_priv *priv, u32 freq_hz)
 
 	dprintk(1, "%s(%u)\n", __func__, freq_hz);
 
-	if ((freq_hz > xc4000_tuner_ops.info.frequency_max) ||
-	    (freq_hz < xc4000_tuner_ops.info.frequency_min))
+	if ((freq_hz > xc4000_tuner_ops.info.frequency_max_hz) ||
+	    (freq_hz < xc4000_tuner_ops.info.frequency_min_hz))
 		return -EINVAL;
 
 	freq_code = (u16)(freq_hz / 15625);
@@ -1635,10 +1635,10 @@ static void xc4000_release(struct dvb_frontend *fe)
 
 static const struct dvb_tuner_ops xc4000_tuner_ops = {
 	.info = {
-		.name           = "Xceive XC4000",
-		.frequency_min  =    1000000,
-		.frequency_max  = 1023000000,
-		.frequency_step =      50000,
+		.name              = "Xceive XC4000",
+		.frequency_min_hz  =    1 * MHz,
+		.frequency_max_hz  = 1023 * MHz,
+		.frequency_step_hz =   50 * kHz,
 	},
 
 	.release	   = xc4000_release,
diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index f7a8d05d1758..f6b65278e502 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -460,8 +460,8 @@ static int xc_set_rf_frequency(struct xc5000_priv *priv, u32 freq_hz)
 
 	dprintk(1, "%s(%u)\n", __func__, freq_hz);
 
-	if ((freq_hz > xc5000_tuner_ops.info.frequency_max) ||
-		(freq_hz < xc5000_tuner_ops.info.frequency_min))
+	if ((freq_hz > xc5000_tuner_ops.info.frequency_max_hz) ||
+		(freq_hz < xc5000_tuner_ops.info.frequency_min_hz))
 		return -EINVAL;
 
 	freq_code = (u16)(freq_hz / 15625);
@@ -1350,10 +1350,10 @@ static int xc5000_set_config(struct dvb_frontend *fe, void *priv_cfg)
 
 static const struct dvb_tuner_ops xc5000_tuner_ops = {
 	.info = {
-		.name           = "Xceive XC5000",
-		.frequency_min  =    1000000,
-		.frequency_max  = 1023000000,
-		.frequency_step =      50000,
+		.name              = "Xceive XC5000",
+		.frequency_min_hz  =    1 * MHz,
+		.frequency_max_hz  = 1023 * MHz,
+		.frequency_step_hz =   50 * kHz,
 	},
 
 	.release	   = xc5000_release,
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c b/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c
index 240d736bf1bb..92b3b9221a21 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c
@@ -465,9 +465,9 @@ static const struct dvb_tuner_ops mxl111sf_tuner_tuner_ops = {
 	.info = {
 		.name = "MaxLinear MxL111SF",
 #if 0
-		.frequency_min  = ,
-		.frequency_max  = ,
-		.frequency_step = ,
+		.frequency_min_hz  = ,
+		.frequency_max_hz  = ,
+		.frequency_step_hz = ,
 #endif
 	},
 #if 0
diff --git a/include/media/dvb_frontend.h b/include/media/dvb_frontend.h
index 331c8269c00e..aebaec2dc725 100644
--- a/include/media/dvb_frontend.h
+++ b/include/media/dvb_frontend.h
@@ -52,6 +52,10 @@
  */
 #define MAX_DELSYS	8
 
+/* Helper definitions to be used at frontend drivers */
+#define kHz 1000UL
+#define MHz 1000000UL
+
 /**
  * struct dvb_frontend_tune_settings - parameters to adjust frontend tuning
  *
@@ -73,22 +77,19 @@ struct dvb_frontend;
  * struct dvb_tuner_info - Frontend name and min/max ranges/bandwidths
  *
  * @name:		name of the Frontend
- * @frequency_min:	minimal frequency supported
- * @frequency_max:	maximum frequency supported
- * @frequency_step:	frequency step
+ * @frequency_min_hz:	minimal frequency supported in Hz
+ * @frequency_max_hz:	maximum frequency supported in Hz
+ * @frequency_step_hz:	frequency step in Hz
  * @bandwidth_min:	minimal frontend bandwidth supported
  * @bandwidth_max:	maximum frontend bandwidth supported
  * @bandwidth_step:	frontend bandwidth step
- *
- * NOTE: frequency parameters are in Hz, for terrestrial/cable or kHz for
- * satellite.
  */
 struct dvb_tuner_info {
 	char name[128];
 
-	u32 frequency_min;
-	u32 frequency_max;
-	u32 frequency_step;
+	u32 frequency_min_hz;
+	u32 frequency_max_hz;
+	u32 frequency_step_hz;
 
 	u32 bandwidth_min;
 	u32 bandwidth_max;
-- 
2.17.1
