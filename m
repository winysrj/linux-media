Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53133 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbbFIMbY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2015 08:31:24 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] dvb: convert demod frequency ranges to Hz
Date: Tue,  9 Jun 2015 09:31:17 -0300
Message-Id: <1433853077-29083-1-git-send-email-mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, all demods are either Satellite or Cable/Terrestrial.

On Satellite, the frequency ranges are specified in kHz, while
on Cable/Terrestrial, they're in Hz.

There's a new set of demods arriving in the market that can handle
both Satellite and Cable/Terrestrial.

As the demod entry would be the same, the best is to always use
Hz as the frequency range on the internal descriptors, letting
the DVB core to convert to kHz when needed.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.c      | 27 +++++++++++++++++++++++++++
 drivers/media/dvb-frontends/cx24110.c      |  8 ++++----
 drivers/media/dvb-frontends/cx24116.c      |  8 ++++----
 drivers/media/dvb-frontends/cx24117.c      |  8 ++++----
 drivers/media/dvb-frontends/cx24120.c      |  8 ++++----
 drivers/media/dvb-frontends/cx24123.c      |  8 ++++----
 drivers/media/dvb-frontends/ds3000.c       |  8 ++++----
 drivers/media/dvb-frontends/dvb_dummy_fe.c |  8 ++++----
 drivers/media/dvb-frontends/m88ds3103.c    |  6 +++---
 drivers/media/dvb-frontends/m88rs2000.c    |  8 ++++----
 drivers/media/dvb-frontends/mb86a16.c      |  6 +++---
 drivers/media/dvb-frontends/mt312.c        |  6 +++---
 drivers/media/dvb-frontends/s5h1420.c      |  8 ++++----
 drivers/media/dvb-frontends/si21xx.c       |  6 +++---
 drivers/media/dvb-frontends/stb0899_drv.c  |  4 ++--
 drivers/media/dvb-frontends/stv0288.c      |  6 +++---
 drivers/media/dvb-frontends/stv0299.c      |  8 ++++----
 drivers/media/dvb-frontends/stv0900_core.c |  6 +++---
 drivers/media/dvb-frontends/stv090x.c      |  4 ++--
 drivers/media/dvb-frontends/tc90522.c      |  4 ++--
 drivers/media/dvb-frontends/tda10071.c     |  6 +++---
 drivers/media/dvb-frontends/tda10086.c     |  6 +++---
 drivers/media/dvb-frontends/tda8083.c      |  6 +++---
 drivers/media/dvb-frontends/ves1x93.c      |  8 ++++----
 24 files changed, 104 insertions(+), 77 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index c2050742d22d..058628145169 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -974,6 +974,8 @@ static int dvb_frontend_start(struct dvb_frontend *fe)
 static void dvb_frontend_get_frequency_limits(struct dvb_frontend *fe,
 					u32 *freq_min, u32 *freq_max)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+
 	*freq_min = max(fe->ops.info.frequency_min, fe->ops.tuner_ops.info.frequency_min);
 
 	if (fe->ops.info.frequency_max == 0)
@@ -986,6 +988,19 @@ static void dvb_frontend_get_frequency_limits(struct dvb_frontend *fe,
 	if (*freq_min == 0 || *freq_max == 0)
 		dev_warn(fe->dvb->device, "DVB: adapter %i frontend %u frequency limits undefined - fix the driver\n",
 				fe->dvb->num, fe->id);
+
+	switch (c->delivery_system) {
+	case SYS_DVBS:
+	case SYS_DVBS2:
+	case SYS_TURBO:
+	case SYS_DSS:
+	case SYS_ISDBS:
+		/* Userspace API expects ranges in kHz */
+		*freq_min /= 1000;
+		*freq_max /= 1000;
+	default:
+		break;
+	}
 }
 
 static int dvb_frontend_check_parameters(struct dvb_frontend *fe)
@@ -2299,6 +2314,18 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 
 		memcpy(info, &fe->ops.info, sizeof(struct dvb_frontend_info));
 		dvb_frontend_get_frequency_limits(fe, &info->frequency_min, &info->frequency_max);
+		switch (c->delivery_system) {
+		case SYS_DVBS:
+		case SYS_DVBS2:
+		case SYS_TURBO:
+		case SYS_DSS:
+		case SYS_ISDBS:
+			/* Userspace API expects ranges in kHz */
+			info->frequency_stepsize /= 1000;
+			info->frequency_tolerance /= 1000;
+		default:
+			break;
+		}
 
 		/*
 		 * Associate the 4 delivery systems supported by DVBv3
diff --git a/drivers/media/dvb-frontends/cx24110.c b/drivers/media/dvb-frontends/cx24110.c
index 4edadb5a29de..2a5fc286db4b 100644
--- a/drivers/media/dvb-frontends/cx24110.c
+++ b/drivers/media/dvb-frontends/cx24110.c
@@ -624,10 +624,10 @@ static struct dvb_frontend_ops cx24110_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name = "Conexant CX24110 DVB-S",
-		.frequency_min = 950000,
-		.frequency_max = 2150000,
-		.frequency_stepsize = 1011,  /* kHz for QPSK frontends */
-		.frequency_tolerance = 29500,
+		.frequency_min = 950000000, /* Hz */
+		.frequency_max = 2150000000U, /* Hz */
+		.frequency_stepsize = 1011000,  /* Hz */
+		.frequency_tolerance = 29500000, /* Hz */
 		.symbol_rate_min = 1000000,
 		.symbol_rate_max = 45000000,
 		.caps = FE_CAN_INVERSION_AUTO |
diff --git a/drivers/media/dvb-frontends/cx24116.c b/drivers/media/dvb-frontends/cx24116.c
index 9378364e7365..2d9df776c97a 100644
--- a/drivers/media/dvb-frontends/cx24116.c
+++ b/drivers/media/dvb-frontends/cx24116.c
@@ -1469,10 +1469,10 @@ static struct dvb_frontend_ops cx24116_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2 },
 	.info = {
 		.name = "Conexant CX24116/CX24118",
-		.frequency_min = 950000,
-		.frequency_max = 2150000,
-		.frequency_stepsize = 1011, /* kHz for QPSK frontends */
-		.frequency_tolerance = 5000,
+		.frequency_min = 950000000, /* Hz */
+		.frequency_max = 2150000000U, /* Hz */
+		.frequency_stepsize = 1011000, /* Hz */
+		.frequency_tolerance = 5000000, /* Hz */
 		.symbol_rate_min = 1000000,
 		.symbol_rate_max = 45000000,
 		.caps = FE_CAN_INVERSION_AUTO |
diff --git a/drivers/media/dvb-frontends/cx24117.c b/drivers/media/dvb-frontends/cx24117.c
index be41297535a2..5ad648e57cf4 100644
--- a/drivers/media/dvb-frontends/cx24117.c
+++ b/drivers/media/dvb-frontends/cx24117.c
@@ -1620,10 +1620,10 @@ static struct dvb_frontend_ops cx24117_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2 },
 	.info = {
 		.name = "Conexant CX24117/CX24132",
-		.frequency_min = 950000,
-		.frequency_max = 2150000,
-		.frequency_stepsize = 1011, /* kHz for QPSK frontends */
-		.frequency_tolerance = 5000,
+		.frequency_min = 950000000, /* Hz */
+		.frequency_max = 2150000000U, /* Hz */
+		.frequency_stepsize = 1011000, /* Hz */
+		.frequency_tolerance = 5000000, /* Hz */
 		.symbol_rate_min = 1000000,
 		.symbol_rate_max = 45000000,
 		.caps = FE_CAN_INVERSION_AUTO |
diff --git a/drivers/media/dvb-frontends/cx24120.c b/drivers/media/dvb-frontends/cx24120.c
index 3b0ef52bb834..284168a03771 100644
--- a/drivers/media/dvb-frontends/cx24120.c
+++ b/drivers/media/dvb-frontends/cx24120.c
@@ -1554,10 +1554,10 @@ static struct dvb_frontend_ops cx24120_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2 },
 	.info = {
 		.name = "Conexant CX24120/CX24118",
-		.frequency_min = 950000,
-		.frequency_max = 2150000,
-		.frequency_stepsize = 1011, /* kHz for QPSK frontends */
-		.frequency_tolerance = 5000,
+		.frequency_min = 950000000, /* Hz */
+		.frequency_max = 2150000000U, /* Hz */
+		.frequency_stepsize = 1011000, /* Hz */
+		.frequency_tolerance = 5000000, /* Hz */
 		.symbol_rate_min = 1000000,
 		.symbol_rate_max = 45000000,
 		.caps =	FE_CAN_INVERSION_AUTO |
diff --git a/drivers/media/dvb-frontends/cx24123.c b/drivers/media/dvb-frontends/cx24123.c
index b6c1b2094bc5..ccfc711902df 100644
--- a/drivers/media/dvb-frontends/cx24123.c
+++ b/drivers/media/dvb-frontends/cx24123.c
@@ -1115,10 +1115,10 @@ static struct dvb_frontend_ops cx24123_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name = "Conexant CX24123/CX24109",
-		.frequency_min = 950000,
-		.frequency_max = 2150000,
-		.frequency_stepsize = 1011, /* kHz for QPSK frontends */
-		.frequency_tolerance = 5000,
+		.frequency_min = 950000000, /* Hz */
+		.frequency_max = 2150000000U, /* Hz */
+		.frequency_stepsize = 1011000, /* Hz */
+		.frequency_tolerance = 5000000, /* Hz */
 		.symbol_rate_min = 1000000,
 		.symbol_rate_max = 45000000,
 		.caps = FE_CAN_INVERSION_AUTO |
diff --git a/drivers/media/dvb-frontends/ds3000.c b/drivers/media/dvb-frontends/ds3000.c
index 435c4dac9389..adc8f11c2b0e 100644
--- a/drivers/media/dvb-frontends/ds3000.c
+++ b/drivers/media/dvb-frontends/ds3000.c
@@ -1098,10 +1098,10 @@ static struct dvb_frontend_ops ds3000_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2 },
 	.info = {
 		.name = "Montage Technology DS3000",
-		.frequency_min = 950000,
-		.frequency_max = 2150000,
-		.frequency_stepsize = 1011, /* kHz for QPSK frontends */
-		.frequency_tolerance = 5000,
+		.frequency_min = 950000000, /* Hz */
+		.frequency_max = 2150000000U, /* Hz */
+		.frequency_stepsize = 1011000, /* Hz */
+		.frequency_tolerance = 5000000, /* Hz */
 		.symbol_rate_min = 1000000,
 		.symbol_rate_max = 45000000,
 		.caps = FE_CAN_INVERSION_AUTO |
diff --git a/drivers/media/dvb-frontends/dvb_dummy_fe.c b/drivers/media/dvb-frontends/dvb_dummy_fe.c
index 3aeb64576bee..ec66647ad21a 100644
--- a/drivers/media/dvb-frontends/dvb_dummy_fe.c
+++ b/drivers/media/dvb-frontends/dvb_dummy_fe.c
@@ -228,10 +228,10 @@ static struct dvb_frontend_ops dvb_dummy_fe_qpsk_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "Dummy DVB-S",
-		.frequency_min		= 950000,
-		.frequency_max		= 2150000,
-		.frequency_stepsize	= 250,           /* kHz for QPSK frontends */
-		.frequency_tolerance	= 29500,
+		.frequency_min		= 950000000, /* Hz */
+		.frequency_max		= 2150000000U, /* Hz */
+		.frequency_stepsize	= 250000, /* Hz */
+		.frequency_tolerance	= 29500000, /* Hz */
 		.symbol_rate_min	= 1000000,
 		.symbol_rate_max	= 45000000,
 		.caps = FE_CAN_INVERSION_AUTO |
diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index 88572666088f..7f4d7ab2cae3 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -1444,9 +1444,9 @@ static struct dvb_frontend_ops m88ds3103_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2 },
 	.info = {
 		.name = "Montage M88DS3103",
-		.frequency_min =  950000,
-		.frequency_max = 2150000,
-		.frequency_tolerance = 5000,
+		.frequency_min =  950000000, /* Hz */
+		.frequency_max = 2150000000U, /* Hz */
+		.frequency_tolerance = 5000000, /* Hz */
 		.symbol_rate_min =  1000000,
 		.symbol_rate_max = 45000000,
 		.caps = FE_CAN_INVERSION_AUTO |
diff --git a/drivers/media/dvb-frontends/m88rs2000.c b/drivers/media/dvb-frontends/m88rs2000.c
index 9cd1d8a1b895..bb9972baf84b 100644
--- a/drivers/media/dvb-frontends/m88rs2000.c
+++ b/drivers/media/dvb-frontends/m88rs2000.c
@@ -753,10 +753,10 @@ static struct dvb_frontend_ops m88rs2000_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "M88RS2000 DVB-S",
-		.frequency_min		= 950000,
-		.frequency_max		= 2150000,
-		.frequency_stepsize	= 1000,	 /* kHz for QPSK frontends */
-		.frequency_tolerance	= 5000,
+		.frequency_min		= 950000000, /* Hz */
+		.frequency_max		= 2150000000U, /* Hz */
+		.frequency_stepsize	= 1000000, /* Hz */
+		.frequency_tolerance	= 5000000, /* Hz */
 		.symbol_rate_min	= 1000000,
 		.symbol_rate_max	= 45000000,
 		.symbol_rate_tolerance	= 500,	/* ppm */
diff --git a/drivers/media/dvb-frontends/mb86a16.c b/drivers/media/dvb-frontends/mb86a16.c
index 0fe400b3e8be..9d5a1c71a8a9 100644
--- a/drivers/media/dvb-frontends/mb86a16.c
+++ b/drivers/media/dvb-frontends/mb86a16.c
@@ -1819,9 +1819,9 @@ static struct dvb_frontend_ops mb86a16_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "Fujitsu MB86A16 DVB-S",
-		.frequency_min		= 950000,
-		.frequency_max		= 2150000,
-		.frequency_stepsize	= 3000,
+		.frequency_min		= 950000000, /* Hz */
+		.frequency_max		= 2150000000U, /* Hz */
+		.frequency_stepsize	= 3000000, /* Hz */
 		.frequency_tolerance	= 0,
 		.symbol_rate_min	= 1000000,
 		.symbol_rate_max	= 45000000,
diff --git a/drivers/media/dvb-frontends/mt312.c b/drivers/media/dvb-frontends/mt312.c
index aa33ecff913d..e8568161cd7b 100644
--- a/drivers/media/dvb-frontends/mt312.c
+++ b/drivers/media/dvb-frontends/mt312.c
@@ -749,10 +749,10 @@ static struct dvb_frontend_ops mt312_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name = "Zarlink ???? DVB-S",
-		.frequency_min = 950000,
-		.frequency_max = 2150000,
+		.frequency_min = 950000000, /* Hz */
+		.frequency_max = 2150000000U, /* Hz */
 		/* FIXME: adjust freq to real used xtal */
-		.frequency_stepsize = (MT312_PLL_CLK / 1000) / 128,
+		.frequency_stepsize = MT312_PLL_CLK / 128, /* Hz */
 		.symbol_rate_min = MT312_SYS_CLK / 128, /* FIXME as above */
 		.symbol_rate_max = MT312_SYS_CLK / 2,
 		.caps =
diff --git a/drivers/media/dvb-frontends/s5h1420.c b/drivers/media/dvb-frontends/s5h1420.c
index d2e1a21ccb1c..21a68ba1087e 100644
--- a/drivers/media/dvb-frontends/s5h1420.c
+++ b/drivers/media/dvb-frontends/s5h1420.c
@@ -933,10 +933,10 @@ static struct dvb_frontend_ops s5h1420_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name     = "Samsung S5H1420/PnpNetwork PN1010 DVB-S",
-		.frequency_min    = 950000,
-		.frequency_max    = 2150000,
-		.frequency_stepsize = 125,     /* kHz for QPSK frontends */
-		.frequency_tolerance  = 29500,
+		.frequency_min    = 950000000, /* Hz */
+		.frequency_max    = 2150000000U, /* Hz */
+		.frequency_stepsize = 125000,  /* Hz */
+		.frequency_tolerance  = 29500000, /* Hz */
 		.symbol_rate_min  = 1000000,
 		.symbol_rate_max  = 45000000,
 		/*  .symbol_rate_tolerance  = ???,*/
diff --git a/drivers/media/dvb-frontends/si21xx.c b/drivers/media/dvb-frontends/si21xx.c
index 4ee88d36681e..146b493d7b3d 100644
--- a/drivers/media/dvb-frontends/si21xx.c
+++ b/drivers/media/dvb-frontends/si21xx.c
@@ -870,9 +870,9 @@ static struct dvb_frontend_ops si21xx_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "SL SI21XX DVB-S",
-		.frequency_min		= 950000,
-		.frequency_max		= 2150000,
-		.frequency_stepsize	= 125,	 /* kHz for QPSK frontends */
+		.frequency_min		= 950000000, /* Hz */
+		.frequency_max		= 2150000000U, /* Hz */
+		.frequency_stepsize	= 125000, /* Hz */
 		.frequency_tolerance	= 0,
 		.symbol_rate_min	= 1000000,
 		.symbol_rate_max	= 45000000,
diff --git a/drivers/media/dvb-frontends/stb0899_drv.c b/drivers/media/dvb-frontends/stb0899_drv.c
index 493f5ebb91d8..1296883ee72b 100644
--- a/drivers/media/dvb-frontends/stb0899_drv.c
+++ b/drivers/media/dvb-frontends/stb0899_drv.c
@@ -1588,8 +1588,8 @@ static struct dvb_frontend_ops stb0899_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2, SYS_DSS },
 	.info = {
 		.name 			= "STB0899 Multistandard",
-		.frequency_min		= 950000,
-		.frequency_max 		= 2150000,
+		.frequency_min		= 950000000, /* Hz */
+		.frequency_max 		= 2150000000U, /* Hz */
 		.frequency_stepsize	= 0,
 		.frequency_tolerance	= 0,
 		.symbol_rate_min 	=  5000000,
diff --git a/drivers/media/dvb-frontends/stv0288.c b/drivers/media/dvb-frontends/stv0288.c
index b54d55802e27..da1e0bf5f128 100644
--- a/drivers/media/dvb-frontends/stv0288.c
+++ b/drivers/media/dvb-frontends/stv0288.c
@@ -539,9 +539,9 @@ static struct dvb_frontend_ops stv0288_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "ST STV0288 DVB-S",
-		.frequency_min		= 950000,
-		.frequency_max		= 2150000,
-		.frequency_stepsize	= 1000,	 /* kHz for QPSK frontends */
+		.frequency_min		= 950000000, /* Hz */
+		.frequency_max		= 2150000000U, /* Hz */
+		.frequency_stepsize	= 1000000, /* Hz */
 		.frequency_tolerance	= 0,
 		.symbol_rate_min	= 1000000,
 		.symbol_rate_max	= 45000000,
diff --git a/drivers/media/dvb-frontends/stv0299.c b/drivers/media/dvb-frontends/stv0299.c
index 20bde6431e5d..c31feb8b8c8d 100644
--- a/drivers/media/dvb-frontends/stv0299.c
+++ b/drivers/media/dvb-frontends/stv0299.c
@@ -711,10 +711,10 @@ static struct dvb_frontend_ops stv0299_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "ST STV0299 DVB-S",
-		.frequency_min		= 950000,
-		.frequency_max		= 2150000,
-		.frequency_stepsize	= 125,	 /* kHz for QPSK frontends */
-		.frequency_tolerance	= 0,
+		.frequency_min		= 950000000, /* Hz */
+		.frequency_max		= 2150000000U, /* Hz */
+		.frequency_stepsize	= 125000, /* Hz */
+		.frequency_tolerance	= 0, /* Hz */
 		.symbol_rate_min	= 1000000,
 		.symbol_rate_max	= 45000000,
 		.symbol_rate_tolerance	= 500,	/* ppm */
diff --git a/drivers/media/dvb-frontends/stv0900_core.c b/drivers/media/dvb-frontends/stv0900_core.c
index fc47b70c07e4..6d09bd0c367c 100644
--- a/drivers/media/dvb-frontends/stv0900_core.c
+++ b/drivers/media/dvb-frontends/stv0900_core.c
@@ -1874,9 +1874,9 @@ static struct dvb_frontend_ops stv0900_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2, SYS_DSS },
 	.info = {
 		.name			= "STV0900 frontend",
-		.frequency_min		= 950000,
-		.frequency_max		= 2150000,
-		.frequency_stepsize	= 125,
+		.frequency_min		= 950000000, /* Hz */
+		.frequency_max		= 2150000000U, /* Hz */
+		.frequency_stepsize	= 125000, /* Hz */
 		.frequency_tolerance	= 0,
 		.symbol_rate_min	= 1000000,
 		.symbol_rate_max	= 45000000,
diff --git a/drivers/media/dvb-frontends/stv090x.c b/drivers/media/dvb-frontends/stv090x.c
index 34b303bdfcf0..3d8fa03117e8 100644
--- a/drivers/media/dvb-frontends/stv090x.c
+++ b/drivers/media/dvb-frontends/stv090x.c
@@ -4889,8 +4889,8 @@ static struct dvb_frontend_ops stv090x_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2, SYS_DSS },
 	.info = {
 		.name			= "STV090x Multistandard",
-		.frequency_min		= 950000,
-		.frequency_max 		= 2150000,
+		.frequency_min		= 950000000, /* Hz */
+		.frequency_max 		= 2150000000U, /* Hz */
 		.frequency_stepsize	= 0,
 		.frequency_tolerance	= 0,
 		.symbol_rate_min 	= 1000000,
diff --git a/drivers/media/dvb-frontends/tc90522.c b/drivers/media/dvb-frontends/tc90522.c
index 169c38f21acd..894c2a78b621 100644
--- a/drivers/media/dvb-frontends/tc90522.c
+++ b/drivers/media/dvb-frontends/tc90522.c
@@ -722,8 +722,8 @@ static const struct dvb_frontend_ops tc90522_ops_sat = {
 	.delsys = { SYS_ISDBS },
 	.info = {
 		.name = "Toshiba TC90522 ISDB-S module",
-		.frequency_min =  950000,
-		.frequency_max = 2150000,
+		.frequency_min =  950000000, /* Hz */
+		.frequency_max = 2150000000U, /* Hz */
 		.caps = FE_CAN_INVERSION_AUTO | FE_CAN_FEC_AUTO |
 			FE_CAN_QAM_AUTO | FE_CAN_TRANSMISSION_MODE_AUTO |
 			FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_HIERARCHY_AUTO,
diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index feed77e0cae4..051c2ff348b7 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -1269,9 +1269,9 @@ static struct dvb_frontend_ops tda10071_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2 },
 	.info = {
 		.name = "NXP TDA10071",
-		.frequency_min = 950000,
-		.frequency_max = 2150000,
-		.frequency_tolerance = 5000,
+		.frequency_min = 950000000, /* Hz */
+		.frequency_max = 2150000000U, /* Hz */
+		.frequency_tolerance = 5000000, /* Hz */
 		.symbol_rate_min = 1000000,
 		.symbol_rate_max = 45000000,
 		.caps = FE_CAN_INVERSION_AUTO |
diff --git a/drivers/media/dvb-frontends/tda10086.c b/drivers/media/dvb-frontends/tda10086.c
index 7ca450be5fe8..a83e666b4148 100644
--- a/drivers/media/dvb-frontends/tda10086.c
+++ b/drivers/media/dvb-frontends/tda10086.c
@@ -707,9 +707,9 @@ static struct dvb_frontend_ops tda10086_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name     = "Philips TDA10086 DVB-S",
-		.frequency_min    = 950000,
-		.frequency_max    = 2150000,
-		.frequency_stepsize = 125,     /* kHz for QPSK frontends */
+		.frequency_min    = 950000000, /* Hz */
+		.frequency_max    = 2150000000U, /* Hz */
+		.frequency_stepsize = 125000, /* Hz */
 		.symbol_rate_min  = 1000000,
 		.symbol_rate_max  = 45000000,
 		.caps = FE_CAN_INVERSION_AUTO |
diff --git a/drivers/media/dvb-frontends/tda8083.c b/drivers/media/dvb-frontends/tda8083.c
index 915c9cb33ef2..2f474b08ef2d 100644
--- a/drivers/media/dvb-frontends/tda8083.c
+++ b/drivers/media/dvb-frontends/tda8083.c
@@ -443,9 +443,9 @@ static struct dvb_frontend_ops tda8083_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "Philips TDA8083 DVB-S",
-		.frequency_min		= 920000,     /* TDA8060 */
-		.frequency_max		= 2200000,    /* TDA8060 */
-		.frequency_stepsize	= 125,   /* kHz for QPSK frontends */
+		.frequency_min		= 920000000, /* Hz */    /* TDA8060 */
+		.frequency_max		= 2200000000, /* Hz */   /* TDA8060 */
+		.frequency_stepsize	= 125000, /* Hz */
 	/*      .frequency_tolerance	= ???,*/
 		.symbol_rate_min	= 12000000,
 		.symbol_rate_max	= 30000000,
diff --git a/drivers/media/dvb-frontends/ves1x93.c b/drivers/media/dvb-frontends/ves1x93.c
index 3c23f715843d..39b93c1034e2 100644
--- a/drivers/media/dvb-frontends/ves1x93.c
+++ b/drivers/media/dvb-frontends/ves1x93.c
@@ -513,10 +513,10 @@ static struct dvb_frontend_ops ves1x93_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "VLSI VES1x93 DVB-S",
-		.frequency_min		= 950000,
-		.frequency_max		= 2150000,
-		.frequency_stepsize	= 125,		 /* kHz for QPSK frontends */
-		.frequency_tolerance	= 29500,
+		.frequency_min		= 950000000, /* Hz */
+		.frequency_max		= 2150000000U, /* Hz */
+		.frequency_stepsize	= 125000, /* Hz */
+		.frequency_tolerance	= 29500000, /* Hz */
 		.symbol_rate_min	= 1000000,
 		.symbol_rate_max	= 45000000,
 	/*	.symbol_rate_tolerance	=	???,*/
-- 
2.4.2

