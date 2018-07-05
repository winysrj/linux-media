Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50774 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753254AbeGEW7t (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 18:59:49 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Antti Palosaari <crope@iki.fi>,
        Jemma Denson <jdenson@gmail.com>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>,
        Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Daniel Scheller <d.scheller.oss@gmail.com>,
        Matthias Schwarzott <zzam@gentoo.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Shuah Khan <shuah@kernel.org>,
        Jaedon Shin <jaedon.shin@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, Sean Young <sean@mess.org>,
        Kees Cook <keescook@chromium.org>,
        Dan Gopstein <dgopstein@nyu.edu>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Brad Love <brad@nextdimension.cc>,
        Thomas Meyer <thomas@m3y3r.de>, Arnd Bergmann <arnd@arndb.de>,
        Ralph Metzler <rjkm@metzlerbros.de>,
        Athanasios Oikonomou <athoik@gmail.com>,
        Akihiro Tsukada <tskd08@gmail.com>, Michael Buesch <m@bues.ch>,
        =?UTF-8?q?J=C3=A9r=C3=A9my=20Lefaure?=
        <jeremy.lefaure@lse.epita.fr>,
        linux1394-devel@lists.sourceforge.net
Subject: [PATCH v2 2/3] media: dvb: represent min/max/step/tolerance freqs in Hz
Date: Thu,  5 Jul 2018 19:59:36 -0300
Message-Id: <0ea966e5313043b1b9e6d658ad356841fb961e84.1530830503.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1530830503.git.mchehab+samsung@kernel.org>
References: <cover.1530830503.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1530830503.git.mchehab+samsung@kernel.org>
References: <cover.1530830503.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now, satellite frontend drivers specify frequencies in kHz,
while terrestrial/cable ones specify in Hz. That's confusing
for developers.

However, the main problem is that universal frontends capable
of handling both satellite and non-satelite delivery systems
are appearing. We end by needing to hack the drivers in
order to support such hybrid frontends.

So, convert everything to specify frontend frequencies in Hz.

Tested-by: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/common/siano/smsdvb-main.c      |  6 +-
 drivers/media/dvb-core/dvb_frontend.c         | 90 +++++++++++++------
 drivers/media/dvb-frontends/af9013.c          |  7 +-
 drivers/media/dvb-frontends/af9033.c          |  7 +-
 drivers/media/dvb-frontends/as102_fe.c        |  6 +-
 drivers/media/dvb-frontends/atbm8830.c        |  6 +-
 drivers/media/dvb-frontends/au8522_dig.c      |  6 +-
 drivers/media/dvb-frontends/bcm3510.c         |  6 +-
 drivers/media/dvb-frontends/cx22700.c         |  6 +-
 drivers/media/dvb-frontends/cx22702.c         |  6 +-
 drivers/media/dvb-frontends/cx24110.c         |  8 +-
 drivers/media/dvb-frontends/cx24116.c         |  8 +-
 drivers/media/dvb-frontends/cx24117.c         |  8 +-
 drivers/media/dvb-frontends/cx24120.c         |  8 +-
 drivers/media/dvb-frontends/cx24123.c         |  8 +-
 drivers/media/dvb-frontends/cxd2820r_t.c      |  4 +-
 drivers/media/dvb-frontends/cxd2820r_t2.c     |  4 +-
 drivers/media/dvb-frontends/cxd2841er.c       |  9 +-
 .../media/dvb-frontends/cxd2880/cxd2880_top.c |  6 +-
 drivers/media/dvb-frontends/dib3000mb.c       |  6 +-
 drivers/media/dvb-frontends/dib3000mc.c       |  6 +-
 drivers/media/dvb-frontends/dib7000m.c        |  6 +-
 drivers/media/dvb-frontends/dib7000p.c        |  6 +-
 drivers/media/dvb-frontends/dib8000.c         |  6 +-
 drivers/media/dvb-frontends/dib9000.c         |  6 +-
 drivers/media/dvb-frontends/drx39xyj/drxj.c   |  6 +-
 drivers/media/dvb-frontends/drxd_hard.c       |  7 +-
 drivers/media/dvb-frontends/drxk_hard.c       |  8 +-
 drivers/media/dvb-frontends/ds3000.c          |  8 +-
 drivers/media/dvb-frontends/dvb_dummy_fe.c    | 24 ++---
 drivers/media/dvb-frontends/gp8psk-fe.c       |  6 +-
 drivers/media/dvb-frontends/ix2505v.c         |  4 +-
 drivers/media/dvb-frontends/l64781.c          |  7 +-
 drivers/media/dvb-frontends/lg2160.c          | 12 +--
 drivers/media/dvb-frontends/lgdt3305.c        | 12 +--
 drivers/media/dvb-frontends/lgdt3306a.c       |  6 +-
 drivers/media/dvb-frontends/lgdt330x.c        | 12 +--
 drivers/media/dvb-frontends/lgs8gl5.c         |  7 +-
 drivers/media/dvb-frontends/lgs8gxx.c         |  6 +-
 drivers/media/dvb-frontends/m88ds3103.c       |  6 +-
 drivers/media/dvb-frontends/m88rs2000.c       |  8 +-
 drivers/media/dvb-frontends/mb86a16.c         |  7 +-
 drivers/media/dvb-frontends/mb86a20s.c        |  6 +-
 drivers/media/dvb-frontends/mt312.c           | 10 +--
 drivers/media/dvb-frontends/mt352.c           |  7 +-
 drivers/media/dvb-frontends/mxl5xx.c          |  6 +-
 drivers/media/dvb-frontends/nxt200x.c         |  6 +-
 drivers/media/dvb-frontends/nxt6000.c         |  6 +-
 drivers/media/dvb-frontends/or51132.c         |  6 +-
 drivers/media/dvb-frontends/or51211.c         |  8 +-
 drivers/media/dvb-frontends/rtl2830.c         |  4 +-
 drivers/media/dvb-frontends/rtl2832.c         | 10 +--
 drivers/media/dvb-frontends/s5h1409.c         |  6 +-
 drivers/media/dvb-frontends/s5h1411.c         |  6 +-
 drivers/media/dvb-frontends/s5h1420.c         |  8 +-
 drivers/media/dvb-frontends/s5h1432.c         |  6 +-
 drivers/media/dvb-frontends/s921.c            |  7 +-
 drivers/media/dvb-frontends/si2165.c          |  2 +-
 drivers/media/dvb-frontends/si21xx.c          |  7 +-
 drivers/media/dvb-frontends/sp8870.c          |  6 +-
 drivers/media/dvb-frontends/sp887x.c          |  6 +-
 drivers/media/dvb-frontends/stb0899_drv.c     |  6 +-
 drivers/media/dvb-frontends/stv0288.c         |  7 +-
 drivers/media/dvb-frontends/stv0297.c         |  6 +-
 drivers/media/dvb-frontends/stv0299.c         |  7 +-
 drivers/media/dvb-frontends/stv0367.c         | 20 ++---
 drivers/media/dvb-frontends/stv0900_core.c    |  7 +-
 drivers/media/dvb-frontends/stv090x.c         |  6 +-
 drivers/media/dvb-frontends/stv0910.c         |  6 +-
 drivers/media/dvb-frontends/tc90522.c         | 10 +--
 drivers/media/dvb-frontends/tda10021.c        | 10 +--
 drivers/media/dvb-frontends/tda10023.c        |  6 +-
 drivers/media/dvb-frontends/tda10048.c        |  6 +-
 drivers/media/dvb-frontends/tda1004x.c        | 12 +--
 drivers/media/dvb-frontends/tda10071.c        | 10 +--
 drivers/media/dvb-frontends/tda10086.c        |  6 +-
 drivers/media/dvb-frontends/tda8083.c         |  7 +-
 drivers/media/dvb-frontends/ves1820.c         |  6 +-
 drivers/media/dvb-frontends/ves1x93.c         |  8 +-
 drivers/media/dvb-frontends/zl10036.c         |  4 +-
 drivers/media/dvb-frontends/zl10353.c         |  7 +-
 drivers/media/firewire/firedtv-fe.c           | 26 +++---
 drivers/media/pci/bt8xx/dst.c                 | 26 +++---
 drivers/media/pci/bt8xx/dvb-bt8xx.c           |  8 +-
 drivers/media/pci/ddbridge/ddbridge-mci.c     |  6 +-
 drivers/media/pci/mantis/mantis_vp3030.c      |  4 +-
 drivers/media/tuners/mxl5007t.c               |  2 -
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c |  6 +-
 drivers/media/usb/dvb-usb/af9005-fe.c         |  6 +-
 drivers/media/usb/dvb-usb/cinergyT2-fe.c      |  6 +-
 drivers/media/usb/dvb-usb/dtt200u-fe.c        |  6 +-
 drivers/media/usb/dvb-usb/friio-fe.c          | 11 ++-
 drivers/media/usb/dvb-usb/vp702x-fe.c         |  7 +-
 drivers/media/usb/dvb-usb/vp7045-fe.c         |  6 +-
 drivers/media/usb/ttusb-dec/ttusbdecfe.c      | 12 +--
 include/media/dvb_frontend.h                  | 30 ++++++-
 96 files changed, 432 insertions(+), 401 deletions(-)

diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index c0faad1ba428..43cfd1dbda01 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -1047,9 +1047,9 @@ static void smsdvb_release(struct dvb_frontend *fe)
 static const struct dvb_frontend_ops smsdvb_fe_ops = {
 	.info = {
 		.name			= "Siano Mobile Digital MDTV Receiver",
-		.frequency_min		= 44250000,
-		.frequency_max		= 867250000,
-		.frequency_stepsize	= 250000,
+		.frequency_min_hz	=  44250 * kHz,
+		.frequency_max_hz	= 867250 * kHz,
+		.frequency_stepsize_hz	=    250 * kHz,
 		.caps = FE_CAN_INVERSION_AUTO |
 			FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 			FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 75e95b56f8b3..3b9dca7d7d02 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -894,38 +894,64 @@ static int dvb_frontend_start(struct dvb_frontend *fe)
 }
 
 static void dvb_frontend_get_frequency_limits(struct dvb_frontend *fe,
-					      u32 *freq_min, u32 *freq_max)
+					      u32 *freq_min, u32 *freq_max,
+					      u32 *tolerance)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	__u32 tuner_min = fe->ops.tuner_ops.info.frequency_min_hz;
-	__u32 tuner_max = fe->ops.tuner_ops.info.frequency_max_hz;
+	u32 tuner_min = fe->ops.tuner_ops.info.frequency_min_hz;
+	u32 tuner_max = fe->ops.tuner_ops.info.frequency_max_hz;
+	u32 frontend_min = fe->ops.info.frequency_min_hz;
+	u32 frontend_max = fe->ops.info.frequency_max_hz;
 
-	/* If the standard is for satellite, convert frequencies to kHz */
-	switch (c->delivery_system) {
-	case SYS_DVBS:
-	case SYS_DVBS2:
-	case SYS_TURBO:
-	case SYS_ISDBS:
-		tuner_max /= kHz;
-		tuner_min /= kHz;
-		break;
-	default:
-		break;
-	}
+	*freq_min = max(frontend_min, tuner_min);
 
-	*freq_min = max(fe->ops.info.frequency_min, tuner_min);
-
-	if (fe->ops.info.frequency_max == 0)
+	if (frontend_max == 0)
 		*freq_max = tuner_max;
 	else if (tuner_max == 0)
-		*freq_max = fe->ops.info.frequency_max;
+		*freq_max = frontend_max;
 	else
-		*freq_max = min(fe->ops.info.frequency_max, tuner_max);
+		*freq_max = min(frontend_max, tuner_max);
 
 	if (*freq_min == 0 || *freq_max == 0)
 		dev_warn(fe->dvb->device,
 			 "DVB: adapter %i frontend %u frequency limits undefined - fix the driver\n",
 			 fe->dvb->num, fe->id);
+
+	/* If the standard is for satellite, convert frequencies to kHz */
+	switch (c->delivery_system) {
+	case SYS_DVBS:
+	case SYS_DVBS2:
+	case SYS_TURBO:
+	case SYS_ISDBS:
+		*freq_min /= kHz;
+		*freq_max /= kHz;
+		if (tolerance)
+			*tolerance = fe->ops.info.frequency_tolerance_hz / kHz;
+
+		break;
+	default:
+		if (tolerance)
+			*tolerance = fe->ops.info.frequency_tolerance_hz;
+		break;
+	}
+}
+
+static u32 dvb_frontend_get_stepsize(struct dvb_frontend *fe)
+{
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	u32 step = fe->ops.info.frequency_stepsize_hz;
+	switch (c->delivery_system) {
+	case SYS_DVBS:
+	case SYS_DVBS2:
+	case SYS_TURBO:
+	case SYS_ISDBS:
+		step /= kHz;
+		break;
+	default:
+		break;
+	}
+
+	return step;
 }
 
 static int dvb_frontend_check_parameters(struct dvb_frontend *fe)
@@ -935,7 +961,7 @@ static int dvb_frontend_check_parameters(struct dvb_frontend *fe)
 	u32 freq_max;
 
 	/* range check: frequency */
-	dvb_frontend_get_frequency_limits(fe, &freq_min, &freq_max);
+	dvb_frontend_get_frequency_limits(fe, &freq_min, &freq_max, NULL);
 	if ((freq_min && c->frequency < freq_min) ||
 	    (freq_max && c->frequency > freq_max)) {
 		dev_warn(fe->dvb->device, "DVB: adapter %i frontend %i frequency %u out of range (%u..%u)\n",
@@ -2261,8 +2287,8 @@ static int dtv_set_frontend(struct dvb_frontend *fe)
 		case SYS_ISDBT:
 		case SYS_DTMB:
 			fepriv->min_delay = HZ / 20;
-			fepriv->step_size = fe->ops.info.frequency_stepsize * 2;
-			fepriv->max_drift = (fe->ops.info.frequency_stepsize * 2) + 1;
+			fepriv->step_size = dvb_frontend_get_stepsize(fe) * 2;
+			fepriv->max_drift = (dvb_frontend_get_stepsize(fe) * 2) + 1;
 			break;
 		default:
 			/*
@@ -2391,9 +2417,19 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 
 	case FE_GET_INFO: {
 		struct dvb_frontend_info *info = parg;
+		memset(info, 0, sizeof(*info));
 
-		memcpy(info, &fe->ops.info, sizeof(struct dvb_frontend_info));
-		dvb_frontend_get_frequency_limits(fe, &info->frequency_min, &info->frequency_max);
+		strcpy(info->name, fe->ops.info.name);
+		info->frequency_stepsize = fe->ops.info.frequency_stepsize_hz;
+		info->frequency_tolerance = fe->ops.info.frequency_tolerance_hz;
+		info->symbol_rate_min = fe->ops.info.symbol_rate_min;
+		info->symbol_rate_max = fe->ops.info.symbol_rate_max;
+		info->symbol_rate_tolerance = fe->ops.info.symbol_rate_tolerance;
+		info->caps = fe->ops.info.caps;
+		info->frequency_stepsize = dvb_frontend_get_stepsize(fe);
+		dvb_frontend_get_frequency_limits(fe, &info->frequency_min,
+						  &info->frequency_max,
+						  &info->frequency_tolerance);
 
 		/*
 		 * Associate the 4 delivery systems supported by DVBv3
@@ -2423,10 +2459,10 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 			dev_err(fe->dvb->device,
 				"%s: doesn't know how to handle a DVBv3 call to delivery system %i\n",
 				__func__, c->delivery_system);
-			fe->ops.info.type = FE_OFDM;
+			info->type = FE_OFDM;
 		}
 		dev_dbg(fe->dvb->device, "%s: current delivery system on cache: %d, V3 type: %d\n",
-			__func__, c->delivery_system, fe->ops.info.type);
+			__func__, c->delivery_system, info->type);
 
 		/* Set CAN_INVERSION_AUTO bit on in other than oneshot mode */
 		if (!(fepriv->tune_mode_flags & FE_TUNE_MODE_ONESHOT))
diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index 482bce49819a..f3acbb57d48c 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -1136,10 +1136,9 @@ static const struct dvb_frontend_ops af9013_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "Afatech AF9013",
-		.frequency_min = 174000000,
-		.frequency_max = 862000000,
-		.frequency_stepsize = 250000,
-		.frequency_tolerance = 0,
+		.frequency_min_hz = 174 * MHz,
+		.frequency_max_hz = 862 * MHz,
+		.frequency_stepsize_hz = 250 * kHz,
 		.caps =	FE_CAN_FEC_1_2 |
 			FE_CAN_FEC_2_3 |
 			FE_CAN_FEC_3_4 |
diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index aaed7cfe5f66..0cd57013ea25 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -1020,10 +1020,9 @@ static const struct dvb_frontend_ops af9033_ops = {
 	.delsys = {SYS_DVBT},
 	.info = {
 		.name = "Afatech AF9033 (DVB-T)",
-		.frequency_min = 174000000,
-		.frequency_max = 862000000,
-		.frequency_stepsize = 250000,
-		.frequency_tolerance = 0,
+		.frequency_min_hz = 174 * MHz,
+		.frequency_max_hz = 862 * MHz,
+		.frequency_stepsize_hz = 250 * kHz,
 		.caps =	FE_CAN_FEC_1_2 |
 			FE_CAN_FEC_2_3 |
 			FE_CAN_FEC_3_4 |
diff --git a/drivers/media/dvb-frontends/as102_fe.c b/drivers/media/dvb-frontends/as102_fe.c
index 9b2f2da1d989..f59a102b0a64 100644
--- a/drivers/media/dvb-frontends/as102_fe.c
+++ b/drivers/media/dvb-frontends/as102_fe.c
@@ -419,9 +419,9 @@ static const struct dvb_frontend_ops as102_fe_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Abilis AS102 DVB-T",
-		.frequency_min		= 174000000,
-		.frequency_max		= 862000000,
-		.frequency_stepsize	= 166667,
+		.frequency_min_hz	= 174 * MHz,
+		.frequency_max_hz	= 862 * MHz,
+		.frequency_stepsize_hz	= 166667,
 		.caps = FE_CAN_INVERSION_AUTO
 			| FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4
 			| FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO
diff --git a/drivers/media/dvb-frontends/atbm8830.c b/drivers/media/dvb-frontends/atbm8830.c
index 7b0f3239dbba..cbcc65dc9d54 100644
--- a/drivers/media/dvb-frontends/atbm8830.c
+++ b/drivers/media/dvb-frontends/atbm8830.c
@@ -428,9 +428,9 @@ static const struct dvb_frontend_ops atbm8830_ops = {
 	.delsys = { SYS_DTMB },
 	.info = {
 		.name = "AltoBeam ATBM8830/8831 DMB-TH",
-		.frequency_min = 474000000,
-		.frequency_max = 858000000,
-		.frequency_stepsize = 10000,
+		.frequency_min_hz = 474 * MHz,
+		.frequency_max_hz = 858 * MHz,
+		.frequency_stepsize_hz = 10 * kHz,
 		.caps =
 			FE_CAN_FEC_AUTO |
 			FE_CAN_QAM_AUTO |
diff --git a/drivers/media/dvb-frontends/au8522_dig.c b/drivers/media/dvb-frontends/au8522_dig.c
index 8f659bd1c79e..076f737aa8c0 100644
--- a/drivers/media/dvb-frontends/au8522_dig.c
+++ b/drivers/media/dvb-frontends/au8522_dig.c
@@ -897,9 +897,9 @@ static const struct dvb_frontend_ops au8522_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name			= "Auvitek AU8522 QAM/8VSB Frontend",
-		.frequency_min		= 54000000,
-		.frequency_max		= 858000000,
-		.frequency_stepsize	= 62500,
+		.frequency_min_hz	=  54 * MHz,
+		.frequency_max_hz	= 858 * MHz,
+		.frequency_stepsize_hz	= 62500,
 		.caps = FE_CAN_QAM_64 | FE_CAN_QAM_256 | FE_CAN_8VSB
 	},
 
diff --git a/drivers/media/dvb-frontends/bcm3510.c b/drivers/media/dvb-frontends/bcm3510.c
index 05df133dc5be..e92542b92d34 100644
--- a/drivers/media/dvb-frontends/bcm3510.c
+++ b/drivers/media/dvb-frontends/bcm3510.c
@@ -840,10 +840,8 @@ static const struct dvb_frontend_ops bcm3510_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name = "Broadcom BCM3510 VSB/QAM frontend",
-		.frequency_min =  54000000,
-		.frequency_max = 803000000,
-		/* stepsize is just a guess */
-		.frequency_stepsize = 0,
+		.frequency_min_hz =  54 * MHz,
+		.frequency_max_hz = 803 * MHz,
 		.caps =
 			FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 			FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
diff --git a/drivers/media/dvb-frontends/cx22700.c b/drivers/media/dvb-frontends/cx22700.c
index 9ffd2c7ac74a..961380162cdd 100644
--- a/drivers/media/dvb-frontends/cx22700.c
+++ b/drivers/media/dvb-frontends/cx22700.c
@@ -412,9 +412,9 @@ static const struct dvb_frontend_ops cx22700_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Conexant CX22700 DVB-T",
-		.frequency_min		= 470000000,
-		.frequency_max		= 860000000,
-		.frequency_stepsize	= 166667,
+		.frequency_min_hz	= 470 * MHz,
+		.frequency_max_hz	= 860 * MHz,
+		.frequency_stepsize_hz	= 166667,
 		.caps = FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 		      FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
 		      FE_CAN_QPSK | FE_CAN_QAM_16 | FE_CAN_QAM_64 |
diff --git a/drivers/media/dvb-frontends/cx22702.c b/drivers/media/dvb-frontends/cx22702.c
index e8b1e6b7e7e5..ab9b2924bcca 100644
--- a/drivers/media/dvb-frontends/cx22702.c
+++ b/drivers/media/dvb-frontends/cx22702.c
@@ -622,9 +622,9 @@ static const struct dvb_frontend_ops cx22702_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Conexant CX22702 DVB-T",
-		.frequency_min		= 177000000,
-		.frequency_max		= 858000000,
-		.frequency_stepsize	= 166666,
+		.frequency_min_hz	= 177 * MHz,
+		.frequency_max_hz	= 858 * MHz,
+		.frequency_stepsize_hz	= 166666,
 		.caps = FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 		FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
 		FE_CAN_QPSK | FE_CAN_QAM_16 | FE_CAN_QAM_64 | FE_CAN_QAM_AUTO |
diff --git a/drivers/media/dvb-frontends/cx24110.c b/drivers/media/dvb-frontends/cx24110.c
index 2f3a1c237489..9441bdc73097 100644
--- a/drivers/media/dvb-frontends/cx24110.c
+++ b/drivers/media/dvb-frontends/cx24110.c
@@ -629,10 +629,10 @@ static const struct dvb_frontend_ops cx24110_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name = "Conexant CX24110 DVB-S",
-		.frequency_min = 950000,
-		.frequency_max = 2150000,
-		.frequency_stepsize = 1011,  /* kHz for QPSK frontends */
-		.frequency_tolerance = 29500,
+		.frequency_min_hz =  950 * MHz,
+		.frequency_max_hz = 2150 * MHz,
+		.frequency_stepsize_hz = 1011 * kHz,
+		.frequency_tolerance_hz = 29500 * kHz,
 		.symbol_rate_min = 1000000,
 		.symbol_rate_max = 45000000,
 		.caps = FE_CAN_INVERSION_AUTO |
diff --git a/drivers/media/dvb-frontends/cx24116.c b/drivers/media/dvb-frontends/cx24116.c
index 2dbc7349d870..220f26663647 100644
--- a/drivers/media/dvb-frontends/cx24116.c
+++ b/drivers/media/dvb-frontends/cx24116.c
@@ -1465,10 +1465,10 @@ static const struct dvb_frontend_ops cx24116_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2 },
 	.info = {
 		.name = "Conexant CX24116/CX24118",
-		.frequency_min = 950000,
-		.frequency_max = 2150000,
-		.frequency_stepsize = 1011, /* kHz for QPSK frontends */
-		.frequency_tolerance = 5000,
+		.frequency_min_hz = 950 * MHz,
+		.frequency_max_hz = 2150 * MHz,
+		.frequency_stepsize_hz = 1011 * kHz,
+		.frequency_tolerance_hz = 5 * MHz,
 		.symbol_rate_min = 1000000,
 		.symbol_rate_max = 45000000,
 		.caps = FE_CAN_INVERSION_AUTO |
diff --git a/drivers/media/dvb-frontends/cx24117.c b/drivers/media/dvb-frontends/cx24117.c
index ba55d75d916c..667bc8be848d 100644
--- a/drivers/media/dvb-frontends/cx24117.c
+++ b/drivers/media/dvb-frontends/cx24117.c
@@ -1622,10 +1622,10 @@ static const struct dvb_frontend_ops cx24117_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2 },
 	.info = {
 		.name = "Conexant CX24117/CX24132",
-		.frequency_min = 950000,
-		.frequency_max = 2150000,
-		.frequency_stepsize = 1011, /* kHz for QPSK frontends */
-		.frequency_tolerance = 5000,
+		.frequency_min_hz =  950 * MHz,
+		.frequency_max_hz = 2150 * MHz,
+		.frequency_stepsize_hz = 1011 * kHz,
+		.frequency_tolerance_hz = 5 * MHz,
 		.symbol_rate_min = 1000000,
 		.symbol_rate_max = 45000000,
 		.caps = FE_CAN_INVERSION_AUTO |
diff --git a/drivers/media/dvb-frontends/cx24120.c b/drivers/media/dvb-frontends/cx24120.c
index ccbabdae6a69..dd3ec316e7c2 100644
--- a/drivers/media/dvb-frontends/cx24120.c
+++ b/drivers/media/dvb-frontends/cx24120.c
@@ -1555,10 +1555,10 @@ static const struct dvb_frontend_ops cx24120_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2 },
 	.info = {
 		.name = "Conexant CX24120/CX24118",
-		.frequency_min = 950000,
-		.frequency_max = 2150000,
-		.frequency_stepsize = 1011, /* kHz for QPSK frontends */
-		.frequency_tolerance = 5000,
+		.frequency_min_hz =  950 * MHz,
+		.frequency_max_hz = 2150 * MHz,
+		.frequency_stepsize_hz = 1011 * kHz,
+		.frequency_tolerance_hz = 5 * MHz,
 		.symbol_rate_min = 1000000,
 		.symbol_rate_max = 45000000,
 		.caps =	FE_CAN_INVERSION_AUTO |
diff --git a/drivers/media/dvb-frontends/cx24123.c b/drivers/media/dvb-frontends/cx24123.c
index bf33e7390aaf..e49215020a93 100644
--- a/drivers/media/dvb-frontends/cx24123.c
+++ b/drivers/media/dvb-frontends/cx24123.c
@@ -1111,10 +1111,10 @@ static const struct dvb_frontend_ops cx24123_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name = "Conexant CX24123/CX24109",
-		.frequency_min = 950000,
-		.frequency_max = 2150000,
-		.frequency_stepsize = 1011, /* kHz for QPSK frontends */
-		.frequency_tolerance = 5000,
+		.frequency_min_hz =  950 * MHz,
+		.frequency_max_hz = 2150 * MHz,
+		.frequency_stepsize_hz = 1011 * kHz,
+		.frequency_tolerance_hz = 5 * MHz,
 		.symbol_rate_min = 1000000,
 		.symbol_rate_max = 45000000,
 		.caps = FE_CAN_INVERSION_AUTO |
diff --git a/drivers/media/dvb-frontends/cxd2820r_t.c b/drivers/media/dvb-frontends/cxd2820r_t.c
index c2e7caf9b010..eb1d7478fa8d 100644
--- a/drivers/media/dvb-frontends/cxd2820r_t.c
+++ b/drivers/media/dvb-frontends/cxd2820r_t.c
@@ -431,8 +431,8 @@ int cxd2820r_get_tune_settings_t(struct dvb_frontend *fe,
 	struct dvb_frontend_tune_settings *s)
 {
 	s->min_delay_ms = 500;
-	s->step_size = fe->ops.info.frequency_stepsize * 2;
-	s->max_drift = (fe->ops.info.frequency_stepsize * 2) + 1;
+	s->step_size = fe->ops.info.frequency_stepsize_hz * 2;
+	s->max_drift = (fe->ops.info.frequency_stepsize_hz * 2) + 1;
 
 	return 0;
 }
diff --git a/drivers/media/dvb-frontends/cxd2820r_t2.c b/drivers/media/dvb-frontends/cxd2820r_t2.c
index e641fde75379..f330ec1710b4 100644
--- a/drivers/media/dvb-frontends/cxd2820r_t2.c
+++ b/drivers/media/dvb-frontends/cxd2820r_t2.c
@@ -426,8 +426,8 @@ int cxd2820r_get_tune_settings_t2(struct dvb_frontend *fe,
 	struct dvb_frontend_tune_settings *s)
 {
 	s->min_delay_ms = 1500;
-	s->step_size = fe->ops.info.frequency_stepsize * 2;
-	s->max_drift = (fe->ops.info.frequency_stepsize * 2) + 1;
+	s->step_size = fe->ops.info.frequency_stepsize_hz * 2;
+	s->max_drift = (fe->ops.info.frequency_stepsize_hz * 2) + 1;
 
 	return 0;
 }
diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index 85905d3503ff..c98093ed3dd7 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -3942,9 +3942,8 @@ static const struct dvb_frontend_ops cxd2841er_dvbs_s2_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2 },
 	.info = {
 		.name		= "Sony CXD2841ER DVB-S/S2 demodulator",
-		.frequency_min	= 500000,
-		.frequency_max	= 2500000,
-		.frequency_stepsize	= 0,
+		.frequency_min_hz	=  500 * MHz,
+		.frequency_max_hz	= 2500 * MHz,
 		.symbol_rate_min = 1000000,
 		.symbol_rate_max = 45000000,
 		.symbol_rate_tolerance = 500,
@@ -3988,8 +3987,8 @@ static struct dvb_frontend_ops cxd2841er_t_c_ops = {
 			FE_CAN_HIERARCHY_AUTO |
 			FE_CAN_MUTE_TS |
 			FE_CAN_2G_MODULATION,
-		.frequency_min = 42000000,
-		.frequency_max = 1002000000,
+		.frequency_min_hz =   42 * MHz,
+		.frequency_max_hz = 1002 * MHz,
 		.symbol_rate_min = 870000,
 		.symbol_rate_max = 11700000
 	},
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_top.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_top.c
index bd9101e246d5..f87e27481ea7 100644
--- a/drivers/media/dvb-frontends/cxd2880/cxd2880_top.c
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_top.c
@@ -1833,9 +1833,9 @@ static enum dvbfe_algo cxd2880_get_frontend_algo(struct dvb_frontend *fe)
 static struct dvb_frontend_ops cxd2880_dvbt_t2_ops = {
 	.info = {
 		.name = "Sony CXD2880",
-		.frequency_min =  174000000,
-		.frequency_max = 862000000,
-		.frequency_stepsize = 1000,
+		.frequency_min_hz = 174 * MHz,
+		.frequency_max_hz = 862 * MHz,
+		.frequency_stepsize_hz = 1 * kHz,
 		.caps = FE_CAN_INVERSION_AUTO |
 				FE_CAN_FEC_1_2 |
 				FE_CAN_FEC_2_3 |
diff --git a/drivers/media/dvb-frontends/dib3000mb.c b/drivers/media/dvb-frontends/dib3000mb.c
index 5861f346db49..bbbd53280477 100644
--- a/drivers/media/dvb-frontends/dib3000mb.c
+++ b/drivers/media/dvb-frontends/dib3000mb.c
@@ -786,9 +786,9 @@ static const struct dvb_frontend_ops dib3000mb_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "DiBcom 3000M-B DVB-T",
-		.frequency_min		= 44250000,
-		.frequency_max		= 867250000,
-		.frequency_stepsize	= 62500,
+		.frequency_min_hz	=  44250 * kHz,
+		.frequency_max_hz	= 867250 * kHz,
+		.frequency_stepsize_hz	= 62500,
 		.caps = FE_CAN_INVERSION_AUTO |
 				FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 				FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
diff --git a/drivers/media/dvb-frontends/dib3000mc.c b/drivers/media/dvb-frontends/dib3000mc.c
index 7e5d474806a5..c9e1db251723 100644
--- a/drivers/media/dvb-frontends/dib3000mc.c
+++ b/drivers/media/dvb-frontends/dib3000mc.c
@@ -944,9 +944,9 @@ static const struct dvb_frontend_ops dib3000mc_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "DiBcom 3000MC/P",
-		.frequency_min      = 44250000,
-		.frequency_max      = 867250000,
-		.frequency_stepsize = 62500,
+		.frequency_min_hz      =  44250 * kHz,
+		.frequency_max_hz      = 867250 * kHz,
+		.frequency_stepsize_hz = 62500,
 		.caps = FE_CAN_INVERSION_AUTO |
 			FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 			FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
diff --git a/drivers/media/dvb-frontends/dib7000m.c b/drivers/media/dvb-frontends/dib7000m.c
index 6a1d357d0c7c..b79358d09de6 100644
--- a/drivers/media/dvb-frontends/dib7000m.c
+++ b/drivers/media/dvb-frontends/dib7000m.c
@@ -1443,9 +1443,9 @@ static const struct dvb_frontend_ops dib7000m_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "DiBcom 7000MA/MB/PA/PB/MC",
-		.frequency_min      = 44250000,
-		.frequency_max      = 867250000,
-		.frequency_stepsize = 62500,
+		.frequency_min_hz      =  44250 * kHz,
+		.frequency_max_hz      = 867250 * kHz,
+		.frequency_stepsize_hz = 62500,
 		.caps = FE_CAN_INVERSION_AUTO |
 			FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 			FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
index 5a8dbc0b25fb..58387860b62d 100644
--- a/drivers/media/dvb-frontends/dib7000p.c
+++ b/drivers/media/dvb-frontends/dib7000p.c
@@ -2824,9 +2824,9 @@ static const struct dvb_frontend_ops dib7000p_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		 .name = "DiBcom 7000PC",
-		 .frequency_min = 44250000,
-		 .frequency_max = 867250000,
-		 .frequency_stepsize = 62500,
+		 .frequency_min_hz =  44250 * kHz,
+		 .frequency_max_hz = 867250 * kHz,
+		 .frequency_stepsize_hz = 62500,
 		 .caps = FE_CAN_INVERSION_AUTO |
 		 FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 		 FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 22eec8f65485..3c3f8cb14845 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -4390,9 +4390,9 @@ static const struct dvb_frontend_ops dib8000_ops = {
 	.delsys = { SYS_ISDBT },
 	.info = {
 		 .name = "DiBcom 8000 ISDB-T",
-		 .frequency_min = 44250000,
-		 .frequency_max = 867250000,
-		 .frequency_stepsize = 62500,
+		 .frequency_min_hz =  44250 * kHz,
+		 .frequency_max_hz = 867250 * kHz,
+		 .frequency_stepsize_hz = 62500,
 		 .caps = FE_CAN_INVERSION_AUTO |
 		 FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 		 FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
diff --git a/drivers/media/dvb-frontends/dib9000.c b/drivers/media/dvb-frontends/dib9000.c
index b8edb55696bb..0183fb1346ef 100644
--- a/drivers/media/dvb-frontends/dib9000.c
+++ b/drivers/media/dvb-frontends/dib9000.c
@@ -2553,9 +2553,9 @@ static const struct dvb_frontend_ops dib9000_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		 .name = "DiBcom 9000",
-		 .frequency_min = 44250000,
-		 .frequency_max = 867250000,
-		 .frequency_stepsize = 62500,
+		 .frequency_min_hz =  44250 * kHz,
+		 .frequency_max_hz = 867250 * kHz,
+		 .frequency_stepsize_hz = 62500,
 		 .caps = FE_CAN_INVERSION_AUTO |
 		 FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 		 FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 5706898e84cc..2ddb7d218ace 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -12374,9 +12374,9 @@ static const struct dvb_frontend_ops drx39xxj_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		 .name = "Micronas DRX39xxj family Frontend",
-		 .frequency_stepsize = 62500,
-		 .frequency_min = 51000000,
-		 .frequency_max = 858000000,
+		 .frequency_min_hz =  51 * MHz,
+		 .frequency_max_hz = 858 * MHz,
+		 .frequency_stepsize_hz = 62500,
 		 .caps = FE_CAN_QAM_64 | FE_CAN_QAM_256 | FE_CAN_8VSB
 	},
 
diff --git a/drivers/media/dvb-frontends/drxd_hard.c b/drivers/media/dvb-frontends/drxd_hard.c
index 3b7d31a22d82..11fc259e4383 100644
--- a/drivers/media/dvb-frontends/drxd_hard.c
+++ b/drivers/media/dvb-frontends/drxd_hard.c
@@ -2912,10 +2912,9 @@ static const struct dvb_frontend_ops drxd_ops = {
 	.delsys = { SYS_DVBT},
 	.info = {
 		 .name = "Micronas DRXD DVB-T",
-		 .frequency_min = 47125000,
-		 .frequency_max = 855250000,
-		 .frequency_stepsize = 166667,
-		 .frequency_tolerance = 0,
+		 .frequency_min_hz =  47125 * kHz,
+		 .frequency_max_hz = 855250 * kHz,
+		 .frequency_stepsize_hz = 166667,
 		 .caps = FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 |
 		 FE_CAN_FEC_3_4 | FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 |
 		 FE_CAN_FEC_AUTO |
diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index 5a26ad93be10..ac10781d3550 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -6744,13 +6744,13 @@ static const struct dvb_frontend_ops drxk_ops = {
 	/* .delsys will be filled dynamically */
 	.info = {
 		.name = "DRXK",
-		.frequency_min = 47000000,
-		.frequency_max = 865000000,
+		.frequency_min_hz =  47 * MHz,
+		.frequency_max_hz = 865 * MHz,
 		 /* For DVB-C */
-		.symbol_rate_min = 870000,
+		.symbol_rate_min =   870000,
 		.symbol_rate_max = 11700000,
 		/* For DVB-T */
-		.frequency_stepsize = 166667,
+		.frequency_stepsize_hz = 166667,
 
 		.caps = FE_CAN_QAM_16 | FE_CAN_QAM_32 | FE_CAN_QAM_64 |
 			FE_CAN_QAM_128 | FE_CAN_QAM_256 | FE_CAN_FEC_AUTO |
diff --git a/drivers/media/dvb-frontends/ds3000.c b/drivers/media/dvb-frontends/ds3000.c
index 2ff90e5eabce..46a55146cb07 100644
--- a/drivers/media/dvb-frontends/ds3000.c
+++ b/drivers/media/dvb-frontends/ds3000.c
@@ -1100,10 +1100,10 @@ static const struct dvb_frontend_ops ds3000_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2 },
 	.info = {
 		.name = "Montage Technology DS3000",
-		.frequency_min = 950000,
-		.frequency_max = 2150000,
-		.frequency_stepsize = 1011, /* kHz for QPSK frontends */
-		.frequency_tolerance = 5000,
+		.frequency_min_hz =  950 * MHz,
+		.frequency_max_hz = 2150 * MHz,
+		.frequency_stepsize_hz = 1011 * kHz,
+		.frequency_tolerance_hz = 5 * MHz,
 		.symbol_rate_min = 1000000,
 		.symbol_rate_max = 45000000,
 		.caps = FE_CAN_INVERSION_AUTO |
diff --git a/drivers/media/dvb-frontends/dvb_dummy_fe.c b/drivers/media/dvb-frontends/dvb_dummy_fe.c
index 6650d4f61ef2..a4cbcae7967d 100644
--- a/drivers/media/dvb-frontends/dvb_dummy_fe.c
+++ b/drivers/media/dvb-frontends/dvb_dummy_fe.c
@@ -170,9 +170,9 @@ static const struct dvb_frontend_ops dvb_dummy_fe_ofdm_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Dummy DVB-T",
-		.frequency_min		= 0,
-		.frequency_max		= 863250000,
-		.frequency_stepsize	= 62500,
+		.frequency_min_hz	= 0,
+		.frequency_max_hz	= 863250 * kHz,
+		.frequency_stepsize_hz	= 62500,
 		.caps = FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 				FE_CAN_FEC_4_5 | FE_CAN_FEC_5_6 | FE_CAN_FEC_6_7 |
 				FE_CAN_FEC_7_8 | FE_CAN_FEC_8_9 | FE_CAN_FEC_AUTO |
@@ -201,11 +201,11 @@ static const struct dvb_frontend_ops dvb_dummy_fe_qam_ops = {
 	.delsys = { SYS_DVBC_ANNEX_A },
 	.info = {
 		.name			= "Dummy DVB-C",
-		.frequency_stepsize	= 62500,
-		.frequency_min		= 51000000,
-		.frequency_max		= 858000000,
-		.symbol_rate_min	= (57840000/2)/64,     /* SACLK/64 == (XIN/2)/64 */
-		.symbol_rate_max	= (57840000/2)/4,      /* SACLK/4 */
+		.frequency_min_hz	=  51 * MHz,
+		.frequency_max_hz	= 858 * MHz,
+		.frequency_stepsize_hz	= 62500,
+		.symbol_rate_min	= (57840000 / 2) / 64,  /* SACLK/64 == (XIN/2)/64 */
+		.symbol_rate_max	= (57840000 / 2) / 4,   /* SACLK/4 */
 		.caps = FE_CAN_QAM_16 | FE_CAN_QAM_32 | FE_CAN_QAM_64 |
 			FE_CAN_QAM_128 | FE_CAN_QAM_256 |
 			FE_CAN_FEC_AUTO | FE_CAN_INVERSION_AUTO
@@ -230,10 +230,10 @@ static const struct dvb_frontend_ops dvb_dummy_fe_qpsk_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "Dummy DVB-S",
-		.frequency_min		= 950000,
-		.frequency_max		= 2150000,
-		.frequency_stepsize	= 250,           /* kHz for QPSK frontends */
-		.frequency_tolerance	= 29500,
+		.frequency_min_hz	=  950 * MHz,
+		.frequency_max_hz	= 2150 * MHz,
+		.frequency_stepsize_hz	= 250 * kHz,
+		.frequency_tolerance_hz	= 29500 * kHz,
 		.symbol_rate_min	= 1000000,
 		.symbol_rate_max	= 45000000,
 		.caps = FE_CAN_INVERSION_AUTO |
diff --git a/drivers/media/dvb-frontends/gp8psk-fe.c b/drivers/media/dvb-frontends/gp8psk-fe.c
index a772ef8bfe1c..238f09aa72f2 100644
--- a/drivers/media/dvb-frontends/gp8psk-fe.c
+++ b/drivers/media/dvb-frontends/gp8psk-fe.c
@@ -355,9 +355,9 @@ static const struct dvb_frontend_ops gp8psk_fe_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "Genpix DVB-S",
-		.frequency_min		= 800000,
-		.frequency_max		= 2250000,
-		.frequency_stepsize	= 100,
+		.frequency_min_hz	=  800 * MHz,
+		.frequency_max_hz	= 2250 * MHz,
+		.frequency_stepsize_hz	=  100 * kHz,
 		.symbol_rate_min        = 1000000,
 		.symbol_rate_max        = 45000000,
 		.symbol_rate_tolerance  = 500,  /* ppm */
diff --git a/drivers/media/dvb-frontends/ix2505v.c b/drivers/media/dvb-frontends/ix2505v.c
index 9c055f72c416..a30707b61b1f 100644
--- a/drivers/media/dvb-frontends/ix2505v.c
+++ b/drivers/media/dvb-frontends/ix2505v.c
@@ -135,8 +135,8 @@ static int ix2505v_set_params(struct dvb_frontend *fe)
 	u8 gain, cc, ref, psc, local_osc, lpf;
 	u8 data[4] = {0};
 
-	if ((frequency < fe->ops.info.frequency_min)
-	||  (frequency > fe->ops.info.frequency_max))
+	if ((frequency < fe->ops.info.frequency_min_hz / kHz)
+	||  (frequency > fe->ops.info.frequency_max_hz / kHz))
 		return -EINVAL;
 
 	if (state->config->tuner_gain)
diff --git a/drivers/media/dvb-frontends/l64781.c b/drivers/media/dvb-frontends/l64781.c
index 249c18761e6e..9afb5bf6424b 100644
--- a/drivers/media/dvb-frontends/l64781.c
+++ b/drivers/media/dvb-frontends/l64781.c
@@ -575,10 +575,9 @@ static const struct dvb_frontend_ops l64781_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "LSI L64781 DVB-T",
-	/*	.frequency_min = ???,*/
-	/*	.frequency_max = ???,*/
-		.frequency_stepsize = 166666,
-	/*      .frequency_tolerance = ???,*/
+	/*	.frequency_min_hz = ???,*/
+	/*	.frequency_max_hz = ???,*/
+		.frequency_stepsize_hz = 166666,
 	/*      .symbol_rate_tolerance = ???,*/
 		.caps = FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 		      FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 |
diff --git a/drivers/media/dvb-frontends/lg2160.c b/drivers/media/dvb-frontends/lg2160.c
index 9854096839ae..408151e33fa7 100644
--- a/drivers/media/dvb-frontends/lg2160.c
+++ b/drivers/media/dvb-frontends/lg2160.c
@@ -1349,9 +1349,9 @@ static const struct dvb_frontend_ops lg2160_ops = {
 	.delsys = { SYS_ATSCMH },
 	.info = {
 		.name = "LG Electronics LG2160 ATSC/MH Frontend",
-		.frequency_min      = 54000000,
-		.frequency_max      = 858000000,
-		.frequency_stepsize = 62500,
+		.frequency_min_hz      =  54 * MHz,
+		.frequency_max_hz      = 858 * MHz,
+		.frequency_stepsize_hz = 62500,
 	},
 	.i2c_gate_ctrl        = lg216x_i2c_gate_ctrl,
 #if 0
@@ -1375,9 +1375,9 @@ static const struct dvb_frontend_ops lg2161_ops = {
 	.delsys = { SYS_ATSCMH },
 	.info = {
 		.name = "LG Electronics LG2161 ATSC/MH Frontend",
-		.frequency_min      = 54000000,
-		.frequency_max      = 858000000,
-		.frequency_stepsize = 62500,
+		.frequency_min_hz      =  54 * MHz,
+		.frequency_max_hz      = 858 * MHz,
+		.frequency_stepsize_hz = 62500,
 	},
 	.i2c_gate_ctrl        = lg216x_i2c_gate_ctrl,
 #if 0
diff --git a/drivers/media/dvb-frontends/lgdt3305.c b/drivers/media/dvb-frontends/lgdt3305.c
index 735d73060265..857e9b4d69b4 100644
--- a/drivers/media/dvb-frontends/lgdt3305.c
+++ b/drivers/media/dvb-frontends/lgdt3305.c
@@ -1164,9 +1164,9 @@ static const struct dvb_frontend_ops lgdt3304_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name = "LG Electronics LGDT3304 VSB/QAM Frontend",
-		.frequency_min      = 54000000,
-		.frequency_max      = 858000000,
-		.frequency_stepsize = 62500,
+		.frequency_min_hz      =  54 * MHz,
+		.frequency_max_hz      = 858 * MHz,
+		.frequency_stepsize_hz = 62500,
 		.caps = FE_CAN_QAM_64 | FE_CAN_QAM_256 | FE_CAN_8VSB
 	},
 	.i2c_gate_ctrl        = lgdt3305_i2c_gate_ctrl,
@@ -1187,9 +1187,9 @@ static const struct dvb_frontend_ops lgdt3305_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name = "LG Electronics LGDT3305 VSB/QAM Frontend",
-		.frequency_min      = 54000000,
-		.frequency_max      = 858000000,
-		.frequency_stepsize = 62500,
+		.frequency_min_hz      =  54 * MHz,
+		.frequency_max_hz      = 858 * MHz,
+		.frequency_stepsize_hz = 62500,
 		.caps = FE_CAN_QAM_64 | FE_CAN_QAM_256 | FE_CAN_8VSB
 	},
 	.i2c_gate_ctrl        = lgdt3305_i2c_gate_ctrl,
diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index 32de824476db..0e1f5daaf20c 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -2157,9 +2157,9 @@ static const struct dvb_frontend_ops lgdt3306a_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name = "LG Electronics LGDT3306A VSB/QAM Frontend",
-		.frequency_min      = 54000000,
-		.frequency_max      = 858000000,
-		.frequency_stepsize = 62500,
+		.frequency_min_hz      =  54 * MHz,
+		.frequency_max_hz      = 858 * MHz,
+		.frequency_stepsize_hz = 62500,
 		.caps = FE_CAN_QAM_AUTO | FE_CAN_QAM_64 | FE_CAN_QAM_256 | FE_CAN_8VSB
 	},
 	.i2c_gate_ctrl        = lgdt3306a_i2c_gate_ctrl,
diff --git a/drivers/media/dvb-frontends/lgdt330x.c b/drivers/media/dvb-frontends/lgdt330x.c
index f6731738b073..10d584ce538d 100644
--- a/drivers/media/dvb-frontends/lgdt330x.c
+++ b/drivers/media/dvb-frontends/lgdt330x.c
@@ -944,9 +944,9 @@ static const struct dvb_frontend_ops lgdt3302_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name = "LG Electronics LGDT3302 VSB/QAM Frontend",
-		.frequency_min = 54000000,
-		.frequency_max = 858000000,
-		.frequency_stepsize = 62500,
+		.frequency_min_hz =  54 * MHz,
+		.frequency_max_hz = 858 * MHz,
+		.frequency_stepsize_hz = 62500,
 		.symbol_rate_min    = 5056941,	/* QAM 64 */
 		.symbol_rate_max    = 10762000,	/* VSB 8  */
 		.caps = FE_CAN_QAM_64 | FE_CAN_QAM_256 | FE_CAN_8VSB
@@ -966,9 +966,9 @@ static const struct dvb_frontend_ops lgdt3303_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name = "LG Electronics LGDT3303 VSB/QAM Frontend",
-		.frequency_min = 54000000,
-		.frequency_max = 858000000,
-		.frequency_stepsize = 62500,
+		.frequency_min_hz =  54 * MHz,
+		.frequency_max_hz = 858 * MHz,
+		.frequency_stepsize_hz = 62500,
 		.symbol_rate_min    = 5056941,	/* QAM 64 */
 		.symbol_rate_max    = 10762000,	/* VSB 8  */
 		.caps = FE_CAN_QAM_64 | FE_CAN_QAM_256 | FE_CAN_8VSB
diff --git a/drivers/media/dvb-frontends/lgs8gl5.c b/drivers/media/dvb-frontends/lgs8gl5.c
index f47e5a1af16d..07e5bcee9c1e 100644
--- a/drivers/media/dvb-frontends/lgs8gl5.c
+++ b/drivers/media/dvb-frontends/lgs8gl5.c
@@ -416,10 +416,9 @@ static const struct dvb_frontend_ops lgs8gl5_ops = {
 	.delsys = { SYS_DTMB },
 	.info = {
 		.name			= "Legend Silicon LGS-8GL5 DMB-TH",
-		.frequency_min		= 474000000,
-		.frequency_max		= 858000000,
-		.frequency_stepsize	= 10000,
-		.frequency_tolerance	= 0,
+		.frequency_min_hz	= 474 * MHz,
+		.frequency_max_hz	= 858 * MHz,
+		.frequency_stepsize_hz	=  10 * kHz,
 		.caps = FE_CAN_FEC_AUTO |
 			FE_CAN_QPSK | FE_CAN_QAM_16 | FE_CAN_QAM_32 |
 			FE_CAN_QAM_64 | FE_CAN_QAM_AUTO |
diff --git a/drivers/media/dvb-frontends/lgs8gxx.c b/drivers/media/dvb-frontends/lgs8gxx.c
index 84af8a12f26a..a6bcf1571d10 100644
--- a/drivers/media/dvb-frontends/lgs8gxx.c
+++ b/drivers/media/dvb-frontends/lgs8gxx.c
@@ -985,9 +985,9 @@ static const struct dvb_frontend_ops lgs8gxx_ops = {
 	.delsys = { SYS_DTMB },
 	.info = {
 		.name = "Legend Silicon LGS8913/LGS8GXX DMB-TH",
-		.frequency_min = 474000000,
-		.frequency_max = 858000000,
-		.frequency_stepsize = 10000,
+		.frequency_min_hz = 474 * MHz,
+		.frequency_max_hz = 858 * MHz,
+		.frequency_stepsize_hz = 10 * kHz,
 		.caps =
 			FE_CAN_FEC_AUTO |
 			FE_CAN_QAM_AUTO |
diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index 65d157fe76d1..dffd2d4bf1c8 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -1300,9 +1300,9 @@ static const struct dvb_frontend_ops m88ds3103_ops = {
 	.delsys = {SYS_DVBS, SYS_DVBS2},
 	.info = {
 		.name = "Montage Technology M88DS3103",
-		.frequency_min =  950000,
-		.frequency_max = 2150000,
-		.frequency_tolerance = 5000,
+		.frequency_min_hz =  950 * MHz,
+		.frequency_max_hz = 2150 * MHz,
+		.frequency_tolerance_hz = 5 * MHz,
 		.symbol_rate_min =  1000000,
 		.symbol_rate_max = 45000000,
 		.caps = FE_CAN_INVERSION_AUTO |
diff --git a/drivers/media/dvb-frontends/m88rs2000.c b/drivers/media/dvb-frontends/m88rs2000.c
index 496ce27fa63a..d5bc85501f9e 100644
--- a/drivers/media/dvb-frontends/m88rs2000.c
+++ b/drivers/media/dvb-frontends/m88rs2000.c
@@ -759,10 +759,10 @@ static const struct dvb_frontend_ops m88rs2000_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "M88RS2000 DVB-S",
-		.frequency_min		= 950000,
-		.frequency_max		= 2150000,
-		.frequency_stepsize	= 1000,	 /* kHz for QPSK frontends */
-		.frequency_tolerance	= 5000,
+		.frequency_min_hz	=  950 * MHz,
+		.frequency_max_hz	= 2150 * MHz,
+		.frequency_stepsize_hz	= 1 * MHz,
+		.frequency_tolerance_hz	= 5 * MHz,
 		.symbol_rate_min	= 1000000,
 		.symbol_rate_max	= 45000000,
 		.symbol_rate_tolerance	= 500,	/* ppm */
diff --git a/drivers/media/dvb-frontends/mb86a16.c b/drivers/media/dvb-frontends/mb86a16.c
index 377cd984b069..da505a5d035f 100644
--- a/drivers/media/dvb-frontends/mb86a16.c
+++ b/drivers/media/dvb-frontends/mb86a16.c
@@ -1808,10 +1808,9 @@ static const struct dvb_frontend_ops mb86a16_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "Fujitsu MB86A16 DVB-S",
-		.frequency_min		= 950000,
-		.frequency_max		= 2150000,
-		.frequency_stepsize	= 3000,
-		.frequency_tolerance	= 0,
+		.frequency_min_hz	=  950 * MHz,
+		.frequency_max_hz	= 2150 * MHz,
+		.frequency_stepsize_hz	=    3 * MHz,
 		.symbol_rate_min	= 1000000,
 		.symbol_rate_max	= 45000000,
 		.symbol_rate_tolerance	= 500,
diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index c3b1b88e2e7a..66fc77db0e75 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -2111,9 +2111,9 @@ static const struct dvb_frontend_ops mb86a20s_ops = {
 			FE_CAN_TRANSMISSION_MODE_AUTO | FE_CAN_QAM_AUTO |
 			FE_CAN_GUARD_INTERVAL_AUTO    | FE_CAN_HIERARCHY_AUTO,
 		/* Actually, those values depend on the used tuner */
-		.frequency_min = 45000000,
-		.frequency_max = 864000000,
-		.frequency_stepsize = 62500,
+		.frequency_min_hz =  45 * MHz,
+		.frequency_max_hz = 864 * MHz,
+		.frequency_stepsize_hz = 62500,
 	},
 
 	.release = mb86a20s_release,
diff --git a/drivers/media/dvb-frontends/mt312.c b/drivers/media/dvb-frontends/mt312.c
index e2a3fc521620..aad07adda37d 100644
--- a/drivers/media/dvb-frontends/mt312.c
+++ b/drivers/media/dvb-frontends/mt312.c
@@ -559,8 +559,8 @@ static int mt312_set_frontend(struct dvb_frontend *fe)
 
 	dprintk("%s: Freq %d\n", __func__, p->frequency);
 
-	if ((p->frequency < fe->ops.info.frequency_min)
-	    || (p->frequency > fe->ops.info.frequency_max))
+	if ((p->frequency < fe->ops.info.frequency_min_hz / kHz)
+	    || (p->frequency > fe->ops.info.frequency_max_hz / kHz))
 		return -EINVAL;
 
 	if (((int)p->inversion < INVERSION_OFF)
@@ -755,10 +755,10 @@ static const struct dvb_frontend_ops mt312_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name = "Zarlink ???? DVB-S",
-		.frequency_min = 950000,
-		.frequency_max = 2150000,
+		.frequency_min_hz =  950 * MHz,
+		.frequency_max_hz = 2150 * MHz,
 		/* FIXME: adjust freq to real used xtal */
-		.frequency_stepsize = (MT312_PLL_CLK / 1000) / 128,
+		.frequency_stepsize_hz = MT312_PLL_CLK / 128,
 		.symbol_rate_min = MT312_SYS_CLK / 128, /* FIXME as above */
 		.symbol_rate_max = MT312_SYS_CLK / 2,
 		.caps =
diff --git a/drivers/media/dvb-frontends/mt352.c b/drivers/media/dvb-frontends/mt352.c
index a440b76444d3..da3e466d50e2 100644
--- a/drivers/media/dvb-frontends/mt352.c
+++ b/drivers/media/dvb-frontends/mt352.c
@@ -567,10 +567,9 @@ static const struct dvb_frontend_ops mt352_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Zarlink MT352 DVB-T",
-		.frequency_min		= 174000000,
-		.frequency_max		= 862000000,
-		.frequency_stepsize	= 166667,
-		.frequency_tolerance	= 0,
+		.frequency_min_hz	= 174 * MHz,
+		.frequency_max_hz	= 862 * MHz,
+		.frequency_stepsize_hz	= 166667,
 		.caps = FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 |
 			FE_CAN_FEC_3_4 | FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 |
 			FE_CAN_FEC_AUTO |
diff --git a/drivers/media/dvb-frontends/mxl5xx.c b/drivers/media/dvb-frontends/mxl5xx.c
index 274d8fca0763..295f37d5f10e 100644
--- a/drivers/media/dvb-frontends/mxl5xx.c
+++ b/drivers/media/dvb-frontends/mxl5xx.c
@@ -784,10 +784,8 @@ static struct dvb_frontend_ops mxl_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2, SYS_DSS },
 	.info = {
 		.name			= "MaxLinear MxL5xx DVB-S/S2 tuner-demodulator",
-		.frequency_min		= 300000,
-		.frequency_max		= 2350000,
-		.frequency_stepsize	= 0,
-		.frequency_tolerance	= 0,
+		.frequency_min_hz	=  300 * MHz,
+		.frequency_max_hz	= 2350 * MHz,
 		.symbol_rate_min	= 1000000,
 		.symbol_rate_max	= 45000000,
 		.caps			= FE_CAN_INVERSION_AUTO |
diff --git a/drivers/media/dvb-frontends/nxt200x.c b/drivers/media/dvb-frontends/nxt200x.c
index a6cc4952eb74..0961e686ff68 100644
--- a/drivers/media/dvb-frontends/nxt200x.c
+++ b/drivers/media/dvb-frontends/nxt200x.c
@@ -1212,9 +1212,9 @@ static const struct dvb_frontend_ops nxt200x_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name = "Nextwave NXT200X VSB/QAM frontend",
-		.frequency_min =  54000000,
-		.frequency_max = 860000000,
-		.frequency_stepsize = 166666,	/* stepsize is just a guess */
+		.frequency_min_hz =  54 * MHz,
+		.frequency_max_hz = 860 * MHz,
+		.frequency_stepsize_hz = 166666,	/* stepsize is just a guess */
 		.caps = FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 			FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
 			FE_CAN_8VSB | FE_CAN_QAM_64 | FE_CAN_QAM_256
diff --git a/drivers/media/dvb-frontends/nxt6000.c b/drivers/media/dvb-frontends/nxt6000.c
index 109a635d166a..72e447e8ba64 100644
--- a/drivers/media/dvb-frontends/nxt6000.c
+++ b/drivers/media/dvb-frontends/nxt6000.c
@@ -596,9 +596,9 @@ static const struct dvb_frontend_ops nxt6000_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "NxtWave NXT6000 DVB-T",
-		.frequency_min = 0,
-		.frequency_max = 863250000,
-		.frequency_stepsize = 62500,
+		.frequency_min_hz = 0,
+		.frequency_max_hz = 863250 * kHz,
+		.frequency_stepsize_hz = 62500,
 		/*.frequency_tolerance = *//* FIXME: 12% of SR */
 		.symbol_rate_min = 0,	/* FIXME */
 		.symbol_rate_max = 9360000,	/* FIXME */
diff --git a/drivers/media/dvb-frontends/or51132.c b/drivers/media/dvb-frontends/or51132.c
index b4c9aadcb552..fc35f37eb3c0 100644
--- a/drivers/media/dvb-frontends/or51132.c
+++ b/drivers/media/dvb-frontends/or51132.c
@@ -583,9 +583,9 @@ static const struct dvb_frontend_ops or51132_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name			= "Oren OR51132 VSB/QAM Frontend",
-		.frequency_min		= 44000000,
-		.frequency_max		= 958000000,
-		.frequency_stepsize	= 166666,
+		.frequency_min_hz	=  44 * MHz,
+		.frequency_max_hz	= 958 * MHz,
+		.frequency_stepsize_hz	= 166666,
 		.caps = FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 			FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
 			FE_CAN_QAM_64 | FE_CAN_QAM_256 | FE_CAN_QAM_AUTO |
diff --git a/drivers/media/dvb-frontends/or51211.c b/drivers/media/dvb-frontends/or51211.c
index b65ba34fd00a..a39bbd8ff1f0 100644
--- a/drivers/media/dvb-frontends/or51211.c
+++ b/drivers/media/dvb-frontends/or51211.c
@@ -530,10 +530,10 @@ struct dvb_frontend* or51211_attach(const struct or51211_config* config,
 static const struct dvb_frontend_ops or51211_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
-		.name               = "Oren OR51211 VSB Frontend",
-		.frequency_min      = 44000000,
-		.frequency_max      = 958000000,
-		.frequency_stepsize = 166666,
+		.name                  = "Oren OR51211 VSB Frontend",
+		.frequency_min_hz      =  44 * MHz,
+		.frequency_max_hz      = 958 * MHz,
+		.frequency_stepsize_hz = 166666,
 		.caps = FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 			FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
 			FE_CAN_8VSB
diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index 7bbfe11d11ed..adc9046d5a90 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -159,8 +159,8 @@ static int rtl2830_get_tune_settings(struct dvb_frontend *fe,
 				     struct dvb_frontend_tune_settings *s)
 {
 	s->min_delay_ms = 500;
-	s->step_size = fe->ops.info.frequency_stepsize * 2;
-	s->max_drift = (fe->ops.info.frequency_stepsize * 2) + 1;
+	s->step_size = fe->ops.info.frequency_stepsize_hz * 2;
+	s->max_drift = (fe->ops.info.frequency_stepsize_hz * 2) + 1;
 
 	return 0;
 }
diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index fa3b8169c1a5..2f1f5cbaf03c 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -408,8 +408,8 @@ static int rtl2832_get_tune_settings(struct dvb_frontend *fe,
 
 	dev_dbg(&client->dev, "\n");
 	s->min_delay_ms = 1000;
-	s->step_size = fe->ops.info.frequency_stepsize * 2;
-	s->max_drift = (fe->ops.info.frequency_stepsize * 2) + 1;
+	s->step_size = fe->ops.info.frequency_stepsize_hz * 2;
+	s->max_drift = (fe->ops.info.frequency_stepsize_hz * 2) + 1;
 	return 0;
 }
 
@@ -841,9 +841,9 @@ static const struct dvb_frontend_ops rtl2832_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "Realtek RTL2832 (DVB-T)",
-		.frequency_min	  = 174000000,
-		.frequency_max	  = 862000000,
-		.frequency_stepsize = 166667,
+		.frequency_min_hz	= 174 * MHz,
+		.frequency_max_hz	= 862 * MHz,
+		.frequency_stepsize_hz	= 166667,
 		.caps = FE_CAN_FEC_1_2 |
 			FE_CAN_FEC_2_3 |
 			FE_CAN_FEC_3_4 |
diff --git a/drivers/media/dvb-frontends/s5h1409.c b/drivers/media/dvb-frontends/s5h1409.c
index a23ba8727218..ceeb0c3551ce 100644
--- a/drivers/media/dvb-frontends/s5h1409.c
+++ b/drivers/media/dvb-frontends/s5h1409.c
@@ -999,9 +999,9 @@ static const struct dvb_frontend_ops s5h1409_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name			= "Samsung S5H1409 QAM/8VSB Frontend",
-		.frequency_min		= 54000000,
-		.frequency_max		= 858000000,
-		.frequency_stepsize	= 62500,
+		.frequency_min_hz	=  54 * MHz,
+		.frequency_max_hz	= 858 * MHz,
+		.frequency_stepsize_hz	= 62500,
 		.caps = FE_CAN_QAM_64 | FE_CAN_QAM_256 | FE_CAN_8VSB
 	},
 
diff --git a/drivers/media/dvb-frontends/s5h1411.c b/drivers/media/dvb-frontends/s5h1411.c
index af5962807f2c..98aeed1d2284 100644
--- a/drivers/media/dvb-frontends/s5h1411.c
+++ b/drivers/media/dvb-frontends/s5h1411.c
@@ -918,9 +918,9 @@ static const struct dvb_frontend_ops s5h1411_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name			= "Samsung S5H1411 QAM/8VSB Frontend",
-		.frequency_min		= 54000000,
-		.frequency_max		= 858000000,
-		.frequency_stepsize	= 62500,
+		.frequency_min_hz	=  54 * MHz,
+		.frequency_max_hz	= 858 * MHz,
+		.frequency_stepsize_hz	= 62500,
 		.caps = FE_CAN_QAM_64 | FE_CAN_QAM_256 | FE_CAN_8VSB
 	},
 
diff --git a/drivers/media/dvb-frontends/s5h1420.c b/drivers/media/dvb-frontends/s5h1420.c
index 8b2222530227..a65cdf8e8cd9 100644
--- a/drivers/media/dvb-frontends/s5h1420.c
+++ b/drivers/media/dvb-frontends/s5h1420.c
@@ -934,10 +934,10 @@ static const struct dvb_frontend_ops s5h1420_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name     = "Samsung S5H1420/PnpNetwork PN1010 DVB-S",
-		.frequency_min    = 950000,
-		.frequency_max    = 2150000,
-		.frequency_stepsize = 125,     /* kHz for QPSK frontends */
-		.frequency_tolerance  = 29500,
+		.frequency_min_hz    =  950 * MHz,
+		.frequency_max_hz    = 2150 * MHz,
+		.frequency_stepsize_hz = 125 * kHz,
+		.frequency_tolerance_hz  = 29500 * kHz,
 		.symbol_rate_min  = 1000000,
 		.symbol_rate_max  = 45000000,
 		/*  .symbol_rate_tolerance  = ???,*/
diff --git a/drivers/media/dvb-frontends/s5h1432.c b/drivers/media/dvb-frontends/s5h1432.c
index 740a60df0455..4dc3febc0e12 100644
--- a/drivers/media/dvb-frontends/s5h1432.c
+++ b/drivers/media/dvb-frontends/s5h1432.c
@@ -370,9 +370,9 @@ static const struct dvb_frontend_ops s5h1432_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		 .name = "Samsung s5h1432 DVB-T Frontend",
-		 .frequency_min = 177000000,
-		 .frequency_max = 858000000,
-		 .frequency_stepsize = 166666,
+		 .frequency_min_hz = 177 * MHz,
+		 .frequency_max_hz = 858 * MHz,
+		 .frequency_stepsize_hz = 166666,
 		 .caps = FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 		 FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
 		 FE_CAN_QPSK | FE_CAN_QAM_16 | FE_CAN_QAM_64 | FE_CAN_QAM_AUTO |
diff --git a/drivers/media/dvb-frontends/s921.c b/drivers/media/dvb-frontends/s921.c
index 6c9015236655..79276871112a 100644
--- a/drivers/media/dvb-frontends/s921.c
+++ b/drivers/media/dvb-frontends/s921.c
@@ -510,15 +510,14 @@ static const struct dvb_frontend_ops s921_ops = {
 	/* Use dib8000 values per default */
 	.info = {
 		.name = "Sharp S921",
-		.frequency_min = 470000000,
+		.frequency_min_hz = 470 * MHz,
 		/*
 		 * Max should be 770MHz instead, according with Sharp docs,
 		 * but Leadership doc says it works up to 806 MHz. This is
 		 * required to get channel 69, used in Brazil
 		 */
-		.frequency_max = 806000000,
-		.frequency_tolerance = 0,
-		 .caps = FE_CAN_INVERSION_AUTO |
+		.frequency_max_hz = 806 * MHz,
+		.caps =  FE_CAN_INVERSION_AUTO |
 			 FE_CAN_FEC_1_2  | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 			 FE_CAN_FEC_5_6  | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
 			 FE_CAN_QPSK     | FE_CAN_QAM_16 | FE_CAN_QAM_64 |
diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index 2dd336f95cbf..feacd8da421d 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -1120,7 +1120,7 @@ static const struct dvb_frontend_ops si2165_ops = {
 		.symbol_rate_min = 1000000,
 		.symbol_rate_max = 7200000,
 		/* For DVB-T */
-		.frequency_stepsize = 166667,
+		.frequency_stepsize_hz = 166667,
 		.caps = FE_CAN_FEC_1_2 |
 			FE_CAN_FEC_2_3 |
 			FE_CAN_FEC_3_4 |
diff --git a/drivers/media/dvb-frontends/si21xx.c b/drivers/media/dvb-frontends/si21xx.c
index 9b32a1b3205e..8546a236d452 100644
--- a/drivers/media/dvb-frontends/si21xx.c
+++ b/drivers/media/dvb-frontends/si21xx.c
@@ -870,10 +870,9 @@ static const struct dvb_frontend_ops si21xx_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "SL SI21XX DVB-S",
-		.frequency_min		= 950000,
-		.frequency_max		= 2150000,
-		.frequency_stepsize	= 125,	 /* kHz for QPSK frontends */
-		.frequency_tolerance	= 0,
+		.frequency_min_hz	=  950 * MHz,
+		.frequency_max_hz	= 2150 * MHz,
+		.frequency_stepsize_hz	=  125 * kHz,
 		.symbol_rate_min	= 1000000,
 		.symbol_rate_max	= 45000000,
 		.symbol_rate_tolerance	= 500,	/* ppm */
diff --git a/drivers/media/dvb-frontends/sp8870.c b/drivers/media/dvb-frontends/sp8870.c
index 1d57a20093fc..8d31cf3f4f07 100644
--- a/drivers/media/dvb-frontends/sp8870.c
+++ b/drivers/media/dvb-frontends/sp8870.c
@@ -584,9 +584,9 @@ static const struct dvb_frontend_ops sp8870_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Spase SP8870 DVB-T",
-		.frequency_min		= 470000000,
-		.frequency_max		= 860000000,
-		.frequency_stepsize	= 166666,
+		.frequency_min_hz	= 470 * MHz,
+		.frequency_max_hz	= 860 * MHz,
+		.frequency_stepsize_hz	= 166666,
 		.caps			= FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 |
 					  FE_CAN_FEC_3_4 | FE_CAN_FEC_5_6 |
 					  FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
diff --git a/drivers/media/dvb-frontends/sp887x.c b/drivers/media/dvb-frontends/sp887x.c
index 57a0d0ae2b48..c02f50995df4 100644
--- a/drivers/media/dvb-frontends/sp887x.c
+++ b/drivers/media/dvb-frontends/sp887x.c
@@ -594,9 +594,9 @@ static const struct dvb_frontend_ops sp887x_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "Spase SP887x DVB-T",
-		.frequency_min =  50500000,
-		.frequency_max = 858000000,
-		.frequency_stepsize = 166666,
+		.frequency_min_hz =  50500 * kHz,
+		.frequency_max_hz = 858000 * kHz,
+		.frequency_stepsize_hz = 166666,
 		.caps = FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 			FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
 			FE_CAN_QPSK | FE_CAN_QAM_16 | FE_CAN_QAM_64 |
diff --git a/drivers/media/dvb-frontends/stb0899_drv.c b/drivers/media/dvb-frontends/stb0899_drv.c
index 3c654ae16e78..874e9c9125d6 100644
--- a/drivers/media/dvb-frontends/stb0899_drv.c
+++ b/drivers/media/dvb-frontends/stb0899_drv.c
@@ -1584,10 +1584,8 @@ static const struct dvb_frontend_ops stb0899_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2, SYS_DSS },
 	.info = {
 		.name			= "STB0899 Multistandard",
-		.frequency_min		= 950000,
-		.frequency_max		= 2150000,
-		.frequency_stepsize	= 0,
-		.frequency_tolerance	= 0,
+		.frequency_min_hz	=  950 * MHz,
+		.frequency_max_hz	= 2150 * MHz,
 		.symbol_rate_min	=  5000000,
 		.symbol_rate_max	= 45000000,
 
diff --git a/drivers/media/dvb-frontends/stv0288.c b/drivers/media/dvb-frontends/stv0288.c
index f947ed947aae..c9a9fa4e2c1b 100644
--- a/drivers/media/dvb-frontends/stv0288.c
+++ b/drivers/media/dvb-frontends/stv0288.c
@@ -533,10 +533,9 @@ static const struct dvb_frontend_ops stv0288_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "ST STV0288 DVB-S",
-		.frequency_min		= 950000,
-		.frequency_max		= 2150000,
-		.frequency_stepsize	= 1000,	 /* kHz for QPSK frontends */
-		.frequency_tolerance	= 0,
+		.frequency_min_hz	=  950 * MHz,
+		.frequency_max_hz	= 2150 * MHz,
+		.frequency_stepsize_hz	=    1 * MHz,
 		.symbol_rate_min	= 1000000,
 		.symbol_rate_max	= 45000000,
 		.symbol_rate_tolerance	= 500,	/* ppm */
diff --git a/drivers/media/dvb-frontends/stv0297.c b/drivers/media/dvb-frontends/stv0297.c
index b823c04e24d3..9a9915f71483 100644
--- a/drivers/media/dvb-frontends/stv0297.c
+++ b/drivers/media/dvb-frontends/stv0297.c
@@ -694,9 +694,9 @@ static const struct dvb_frontend_ops stv0297_ops = {
 	.delsys = { SYS_DVBC_ANNEX_A },
 	.info = {
 		 .name = "ST STV0297 DVB-C",
-		 .frequency_min = 47000000,
-		 .frequency_max = 862000000,
-		 .frequency_stepsize = 62500,
+		 .frequency_min_hz = 470 * MHz,
+		 .frequency_max_hz = 862 * MHz,
+		 .frequency_stepsize_hz = 62500,
 		 .symbol_rate_min = 870000,
 		 .symbol_rate_max = 11700000,
 		 .caps = FE_CAN_QAM_16 | FE_CAN_QAM_32 | FE_CAN_QAM_64 |
diff --git a/drivers/media/dvb-frontends/stv0299.c b/drivers/media/dvb-frontends/stv0299.c
index 633b90e6fe86..4f466394a16c 100644
--- a/drivers/media/dvb-frontends/stv0299.c
+++ b/drivers/media/dvb-frontends/stv0299.c
@@ -717,10 +717,9 @@ static const struct dvb_frontend_ops stv0299_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "ST STV0299 DVB-S",
-		.frequency_min		= 950000,
-		.frequency_max		= 2150000,
-		.frequency_stepsize	= 125,	 /* kHz for QPSK frontends */
-		.frequency_tolerance	= 0,
+		.frequency_min_hz	=  950 * MHz,
+		.frequency_max_hz	= 2150 * MHz,
+		.frequency_stepsize_hz	=  125 * kHz,
 		.symbol_rate_min	= 1000000,
 		.symbol_rate_max	= 45000000,
 		.symbol_rate_tolerance	= 500,	/* ppm */
diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index 5435c908e298..5b91e740e135 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -1693,10 +1693,9 @@ static const struct dvb_frontend_ops stv0367ter_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "ST STV0367 DVB-T",
-		.frequency_min		= 47000000,
-		.frequency_max		= 862000000,
-		.frequency_stepsize	= 15625,
-		.frequency_tolerance	= 0,
+		.frequency_min_hz	=  47 * MHz,
+		.frequency_max_hz	= 862 * MHz,
+		.frequency_stepsize_hz	= 15625,
 		.caps = FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 |
 			FE_CAN_FEC_3_4 | FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 |
 			FE_CAN_FEC_AUTO |
@@ -2867,9 +2866,9 @@ static const struct dvb_frontend_ops stv0367cab_ops = {
 	.delsys = { SYS_DVBC_ANNEX_A },
 	.info = {
 		.name = "ST STV0367 DVB-C",
-		.frequency_min = 47000000,
-		.frequency_max = 862000000,
-		.frequency_stepsize = 62500,
+		.frequency_min_hz =  47 * MHz,
+		.frequency_max_hz = 862 * MHz,
+		.frequency_stepsize_hz = 62500,
 		.symbol_rate_min = 870000,
 		.symbol_rate_max = 11700000,
 		.caps = 0x400 |/* FE_CAN_QAM_4 */
@@ -3273,10 +3272,9 @@ static const struct dvb_frontend_ops stv0367ddb_ops = {
 	.delsys = { SYS_DVBC_ANNEX_A, SYS_DVBT },
 	.info = {
 		.name			= "ST STV0367 DDB DVB-C/T",
-		.frequency_min		= 47000000,
-		.frequency_max		= 865000000,
-		.frequency_stepsize	= 166667,
-		.frequency_tolerance	= 0,
+		.frequency_min_hz	=  47 * MHz,
+		.frequency_max_hz	= 865 * MHz,
+		.frequency_stepsize_hz	= 166667,
 		.symbol_rate_min	= 870000,
 		.symbol_rate_max	= 11700000,
 		.caps = /* DVB-C */
diff --git a/drivers/media/dvb-frontends/stv0900_core.c b/drivers/media/dvb-frontends/stv0900_core.c
index 72f17b97ca04..254618a06140 100644
--- a/drivers/media/dvb-frontends/stv0900_core.c
+++ b/drivers/media/dvb-frontends/stv0900_core.c
@@ -1875,10 +1875,9 @@ static const struct dvb_frontend_ops stv0900_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2, SYS_DSS },
 	.info = {
 		.name			= "STV0900 frontend",
-		.frequency_min		= 950000,
-		.frequency_max		= 2150000,
-		.frequency_stepsize	= 125,
-		.frequency_tolerance	= 0,
+		.frequency_min_hz	=  950 * MHz,
+		.frequency_max_hz	= 2150 * MHz,
+		.frequency_stepsize_hz	=  125 * kHz,
 		.symbol_rate_min	= 1000000,
 		.symbol_rate_max	= 45000000,
 		.symbol_rate_tolerance	= 500,
diff --git a/drivers/media/dvb-frontends/stv090x.c b/drivers/media/dvb-frontends/stv090x.c
index 9133f65d4623..a0622bb71803 100644
--- a/drivers/media/dvb-frontends/stv090x.c
+++ b/drivers/media/dvb-frontends/stv090x.c
@@ -4905,10 +4905,8 @@ static const struct dvb_frontend_ops stv090x_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2, SYS_DSS },
 	.info = {
 		.name			= "STV090x Multistandard",
-		.frequency_min		= 950000,
-		.frequency_max		= 2150000,
-		.frequency_stepsize	= 0,
-		.frequency_tolerance	= 0,
+		.frequency_min_hz	=  950 * MHz,
+		.frequency_max_hz	= 2150 * MHz,
 		.symbol_rate_min	= 1000000,
 		.symbol_rate_max	= 45000000,
 		.caps			= FE_CAN_INVERSION_AUTO |
diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index 41444fa1c0bb..eca9dc1fca1a 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -1724,10 +1724,8 @@ static const struct dvb_frontend_ops stv0910_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2, SYS_DSS },
 	.info = {
 		.name			= "ST STV0910",
-		.frequency_min		= 950000,
-		.frequency_max		= 2150000,
-		.frequency_stepsize	= 0,
-		.frequency_tolerance	= 0,
+		.frequency_min_hz	=  950 * MHz,
+		.frequency_max_hz	= 2150 * MHz,
 		.symbol_rate_min	= 100000,
 		.symbol_rate_max	= 70000000,
 		.caps			= FE_CAN_INVERSION_AUTO |
diff --git a/drivers/media/dvb-frontends/tc90522.c b/drivers/media/dvb-frontends/tc90522.c
index 7abf6b0916ed..2ad81a438d6a 100644
--- a/drivers/media/dvb-frontends/tc90522.c
+++ b/drivers/media/dvb-frontends/tc90522.c
@@ -714,8 +714,8 @@ static const struct dvb_frontend_ops tc90522_ops_sat = {
 	.delsys = { SYS_ISDBS },
 	.info = {
 		.name = "Toshiba TC90522 ISDB-S module",
-		.frequency_min =  950000,
-		.frequency_max = 2150000,
+		.frequency_min_hz =  950 * MHz,
+		.frequency_max_hz = 2150 * MHz,
 		.caps = FE_CAN_INVERSION_AUTO | FE_CAN_FEC_AUTO |
 			FE_CAN_QAM_AUTO | FE_CAN_TRANSMISSION_MODE_AUTO |
 			FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_HIERARCHY_AUTO,
@@ -734,9 +734,9 @@ static const struct dvb_frontend_ops tc90522_ops_ter = {
 	.delsys = { SYS_ISDBT },
 	.info = {
 		.name = "Toshiba TC90522 ISDB-T module",
-		.frequency_min = 470000000,
-		.frequency_max = 770000000,
-		.frequency_stepsize = 142857,
+		.frequency_min_hz = 470 * MHz,
+		.frequency_max_hz = 770 * MHz,
+		.frequency_stepsize_hz = 142857,
 		.caps = FE_CAN_INVERSION_AUTO |
 			FE_CAN_FEC_1_2  | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 			FE_CAN_FEC_5_6  | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
diff --git a/drivers/media/dvb-frontends/tda10021.c b/drivers/media/dvb-frontends/tda10021.c
index 4f588ebde39d..5cd885d4ea04 100644
--- a/drivers/media/dvb-frontends/tda10021.c
+++ b/drivers/media/dvb-frontends/tda10021.c
@@ -487,11 +487,11 @@ static const struct dvb_frontend_ops tda10021_ops = {
 	.delsys = { SYS_DVBC_ANNEX_A, SYS_DVBC_ANNEX_C },
 	.info = {
 		.name = "Philips TDA10021 DVB-C",
-		.frequency_stepsize = 62500,
-		.frequency_min = 47000000,
-		.frequency_max = 862000000,
-		.symbol_rate_min = (XIN/2)/64,     /* SACLK/64 == (XIN/2)/64 */
-		.symbol_rate_max = (XIN/2)/4,      /* SACLK/4 */
+		.frequency_min_hz =  47 * MHz,
+		.frequency_max_hz = 862 * MHz,
+		.frequency_stepsize_hz = 62500,
+		.symbol_rate_min = (XIN / 2) / 64,     /* SACLK/64 == (XIN/2)/64 */
+		.symbol_rate_max = (XIN / 2) / 4,      /* SACLK/4 */
 	#if 0
 		.frequency_tolerance = ???,
 		.symbol_rate_tolerance = ???,  /* ppm */  /* == 8% (spec p. 5) */
diff --git a/drivers/media/dvb-frontends/tda10023.c b/drivers/media/dvb-frontends/tda10023.c
index 6c84916234e3..0a9a54563ebe 100644
--- a/drivers/media/dvb-frontends/tda10023.c
+++ b/drivers/media/dvb-frontends/tda10023.c
@@ -575,9 +575,9 @@ static const struct dvb_frontend_ops tda10023_ops = {
 	.delsys = { SYS_DVBC_ANNEX_A, SYS_DVBC_ANNEX_C },
 	.info = {
 		.name = "Philips TDA10023 DVB-C",
-		.frequency_stepsize = 62500,
-		.frequency_min =  47000000,
-		.frequency_max = 862000000,
+		.frequency_min_hz =  47 * MHz,
+		.frequency_max_hz = 862 * MHz,
+		.frequency_stepsize_hz = 62500,
 		.symbol_rate_min = 0,  /* set in tda10023_attach */
 		.symbol_rate_max = 0,  /* set in tda10023_attach */
 		.caps = 0x400 | //FE_CAN_QAM_4
diff --git a/drivers/media/dvb-frontends/tda10048.c b/drivers/media/dvb-frontends/tda10048.c
index de82a2558e15..c01d60a88af2 100644
--- a/drivers/media/dvb-frontends/tda10048.c
+++ b/drivers/media/dvb-frontends/tda10048.c
@@ -1156,9 +1156,9 @@ static const struct dvb_frontend_ops tda10048_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "NXP TDA10048HN DVB-T",
-		.frequency_min		= 177000000,
-		.frequency_max		= 858000000,
-		.frequency_stepsize	= 166666,
+		.frequency_min_hz	= 177 * MHz,
+		.frequency_max_hz	= 858 * MHz,
+		.frequency_stepsize_hz	= 166666,
 		.caps = FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 		FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
 		FE_CAN_QPSK | FE_CAN_QAM_16 | FE_CAN_QAM_64 | FE_CAN_QAM_AUTO |
diff --git a/drivers/media/dvb-frontends/tda1004x.c b/drivers/media/dvb-frontends/tda1004x.c
index 7dcfb4a4b2d0..d402e4b722ca 100644
--- a/drivers/media/dvb-frontends/tda1004x.c
+++ b/drivers/media/dvb-frontends/tda1004x.c
@@ -1249,9 +1249,9 @@ static const struct dvb_frontend_ops tda10045_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "Philips TDA10045H DVB-T",
-		.frequency_min = 51000000,
-		.frequency_max = 858000000,
-		.frequency_stepsize = 166667,
+		.frequency_min_hz =  51 * MHz,
+		.frequency_max_hz = 858 * MHz,
+		.frequency_stepsize_hz = 166667,
 		.caps =
 		    FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 		    FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
@@ -1319,9 +1319,9 @@ static const struct dvb_frontend_ops tda10046_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "Philips TDA10046H DVB-T",
-		.frequency_min = 51000000,
-		.frequency_max = 858000000,
-		.frequency_stepsize = 166667,
+		.frequency_min_hz =  51 * MHz,
+		.frequency_max_hz = 858 * MHz,
+		.frequency_stepsize_hz = 166667,
 		.caps =
 		    FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 		    FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index 1ed67c08e699..097c42d3f8c2 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -681,8 +681,8 @@ static int tda10071_set_frontend(struct dvb_frontend *fe)
 	cmd.args[5] = (c->frequency >>  0) & 0xff;
 	cmd.args[6] = ((c->symbol_rate / 1000) >> 8) & 0xff;
 	cmd.args[7] = ((c->symbol_rate / 1000) >> 0) & 0xff;
-	cmd.args[8] = (tda10071_ops.info.frequency_tolerance >> 8) & 0xff;
-	cmd.args[9] = (tda10071_ops.info.frequency_tolerance >> 0) & 0xff;
+	cmd.args[8] = ((tda10071_ops.info.frequency_tolerance_hz / 1000) >> 8) & 0xff;
+	cmd.args[9] = ((tda10071_ops.info.frequency_tolerance_hz / 1000) >> 0) & 0xff;
 	cmd.args[10] = rolloff;
 	cmd.args[11] = inversion;
 	cmd.args[12] = pilot;
@@ -1106,9 +1106,9 @@ static const struct dvb_frontend_ops tda10071_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2 },
 	.info = {
 		.name = "NXP TDA10071",
-		.frequency_min = 950000,
-		.frequency_max = 2150000,
-		.frequency_tolerance = 5000,
+		.frequency_min_hz    =  950 * MHz,
+		.frequency_max_hz    = 2150 * MHz,
+		.frequency_tolerance_hz = 5 * MHz,
 		.symbol_rate_min = 1000000,
 		.symbol_rate_max = 45000000,
 		.caps = FE_CAN_INVERSION_AUTO |
diff --git a/drivers/media/dvb-frontends/tda10086.c b/drivers/media/dvb-frontends/tda10086.c
index 1a95c521e97f..8323e4e53d66 100644
--- a/drivers/media/dvb-frontends/tda10086.c
+++ b/drivers/media/dvb-frontends/tda10086.c
@@ -710,9 +710,9 @@ static const struct dvb_frontend_ops tda10086_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name     = "Philips TDA10086 DVB-S",
-		.frequency_min    = 950000,
-		.frequency_max    = 2150000,
-		.frequency_stepsize = 125,     /* kHz for QPSK frontends */
+		.frequency_min_hz      =  950 * MHz,
+		.frequency_max_hz      = 2150 * MHz,
+		.frequency_stepsize_hz =  125 * kHz,
 		.symbol_rate_min  = 1000000,
 		.symbol_rate_max  = 45000000,
 		.caps = FE_CAN_INVERSION_AUTO |
diff --git a/drivers/media/dvb-frontends/tda8083.c b/drivers/media/dvb-frontends/tda8083.c
index 29b4f64c030c..53b26060db7e 100644
--- a/drivers/media/dvb-frontends/tda8083.c
+++ b/drivers/media/dvb-frontends/tda8083.c
@@ -453,10 +453,9 @@ static const struct dvb_frontend_ops tda8083_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "Philips TDA8083 DVB-S",
-		.frequency_min		= 920000,     /* TDA8060 */
-		.frequency_max		= 2200000,    /* TDA8060 */
-		.frequency_stepsize	= 125,   /* kHz for QPSK frontends */
-	/*      .frequency_tolerance	= ???,*/
+		.frequency_min_hz	=  920 * MHz,     /* TDA8060 */
+		.frequency_max_hz	= 2200 * MHz,    /* TDA8060 */
+		.frequency_stepsize_hz	=  125 * kHz,
 		.symbol_rate_min	= 12000000,
 		.symbol_rate_max	= 30000000,
 	/*      .symbol_rate_tolerance	= ???,*/
diff --git a/drivers/media/dvb-frontends/ves1820.c b/drivers/media/dvb-frontends/ves1820.c
index 17600989f121..eb1249d81310 100644
--- a/drivers/media/dvb-frontends/ves1820.c
+++ b/drivers/media/dvb-frontends/ves1820.c
@@ -412,9 +412,9 @@ static const struct dvb_frontend_ops ves1820_ops = {
 	.delsys = { SYS_DVBC_ANNEX_A },
 	.info = {
 		.name = "VLSI VES1820 DVB-C",
-		.frequency_stepsize = 62500,
-		.frequency_min = 47000000,
-		.frequency_max = 862000000,
+		.frequency_min_hz =  47 * MHz,
+		.frequency_max_hz = 862 * MHz,
+		.frequency_stepsize_hz = 62500,
 		.caps = FE_CAN_QAM_16 |
 			FE_CAN_QAM_32 |
 			FE_CAN_QAM_64 |
diff --git a/drivers/media/dvb-frontends/ves1x93.c b/drivers/media/dvb-frontends/ves1x93.c
index 0c7b3286b04d..ddc5bfd84cd5 100644
--- a/drivers/media/dvb-frontends/ves1x93.c
+++ b/drivers/media/dvb-frontends/ves1x93.c
@@ -516,10 +516,10 @@ static const struct dvb_frontend_ops ves1x93_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "VLSI VES1x93 DVB-S",
-		.frequency_min		= 950000,
-		.frequency_max		= 2150000,
-		.frequency_stepsize	= 125,		 /* kHz for QPSK frontends */
-		.frequency_tolerance	= 29500,
+		.frequency_min_hz	=   950 * MHz,
+		.frequency_max_hz	=  2150 * MHz,
+		.frequency_stepsize_hz	=   125 * kHz,
+		.frequency_tolerance_hz	= 29500 * kHz,
 		.symbol_rate_min	= 1000000,
 		.symbol_rate_max	= 45000000,
 	/*	.symbol_rate_tolerance	=	???,*/
diff --git a/drivers/media/dvb-frontends/zl10036.c b/drivers/media/dvb-frontends/zl10036.c
index e5a432fd84c3..f1c92338015d 100644
--- a/drivers/media/dvb-frontends/zl10036.c
+++ b/drivers/media/dvb-frontends/zl10036.c
@@ -311,8 +311,8 @@ static int zl10036_set_params(struct dvb_frontend *fe)
 
 	/* ensure correct values
 	 * maybe redundant as core already checks this */
-	if ((frequency < fe->ops.info.frequency_min)
-	||  (frequency > fe->ops.info.frequency_max))
+	if ((frequency < fe->ops.info.frequency_min_hz / kHz)
+	||  (frequency > fe->ops.info.frequency_max_hz / kHz))
 		return -EINVAL;
 
 	/*
diff --git a/drivers/media/dvb-frontends/zl10353.c b/drivers/media/dvb-frontends/zl10353.c
index c9901f45deb7..42e63a3fa121 100644
--- a/drivers/media/dvb-frontends/zl10353.c
+++ b/drivers/media/dvb-frontends/zl10353.c
@@ -635,10 +635,9 @@ static const struct dvb_frontend_ops zl10353_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Zarlink ZL10353 DVB-T",
-		.frequency_min		= 174000000,
-		.frequency_max		= 862000000,
-		.frequency_stepsize	= 166667,
-		.frequency_tolerance	= 0,
+		.frequency_min_hz	= 174 * MHz,
+		.frequency_max_hz	= 862 * MHz,
+		.frequency_stepsize_hz	= 166667,
 		.caps = FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 |
 			FE_CAN_FEC_3_4 | FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 |
 			FE_CAN_FEC_AUTO |
diff --git a/drivers/media/firewire/firedtv-fe.c b/drivers/media/firewire/firedtv-fe.c
index a2ef4ede8ebe..69087ae6c1d0 100644
--- a/drivers/media/firewire/firedtv-fe.c
+++ b/drivers/media/firewire/firedtv-fe.c
@@ -152,7 +152,7 @@ static int fdtv_set_frontend(struct dvb_frontend *fe)
 void fdtv_frontend_init(struct firedtv *fdtv, const char *name)
 {
 	struct dvb_frontend_ops *ops = &fdtv->fe.ops;
-	struct dvb_frontend_info *fi = &ops->info;
+	struct dvb_frontend_internal_info *fi = &ops->info;
 
 	ops->init			= fdtv_dvb_init;
 	ops->sleep			= fdtv_sleep;
@@ -174,9 +174,9 @@ void fdtv_frontend_init(struct firedtv *fdtv, const char *name)
 	case FIREDTV_DVB_S:
 		ops->delsys[0]		= SYS_DVBS;
 
-		fi->frequency_min	= 950000;
-		fi->frequency_max	= 2150000;
-		fi->frequency_stepsize	= 125;
+		fi->frequency_min_hz	=   950 * MHz;
+		fi->frequency_max_hz	=  2150 * MHz;
+		fi->frequency_stepsize_hz = 125 * kHz;
 		fi->symbol_rate_min	= 1000000;
 		fi->symbol_rate_max	= 40000000;
 
@@ -194,9 +194,9 @@ void fdtv_frontend_init(struct firedtv *fdtv, const char *name)
 		ops->delsys[0]		= SYS_DVBS;
 		ops->delsys[1]		= SYS_DVBS2;
 
-		fi->frequency_min	= 950000;
-		fi->frequency_max	= 2150000;
-		fi->frequency_stepsize	= 125;
+		fi->frequency_min_hz	=   950 * MHz;
+		fi->frequency_max_hz	=  2150 * MHz;
+		fi->frequency_stepsize_hz = 125 * kHz;
 		fi->symbol_rate_min	= 1000000;
 		fi->symbol_rate_max	= 40000000;
 
@@ -214,9 +214,9 @@ void fdtv_frontend_init(struct firedtv *fdtv, const char *name)
 	case FIREDTV_DVB_C:
 		ops->delsys[0]		= SYS_DVBC_ANNEX_A;
 
-		fi->frequency_min	= 47000000;
-		fi->frequency_max	= 866000000;
-		fi->frequency_stepsize	= 62500;
+		fi->frequency_min_hz	=      47 * MHz;
+		fi->frequency_max_hz	=     866 * MHz;
+		fi->frequency_stepsize_hz = 62500;
 		fi->symbol_rate_min	= 870000;
 		fi->symbol_rate_max	= 6900000;
 
@@ -232,9 +232,9 @@ void fdtv_frontend_init(struct firedtv *fdtv, const char *name)
 	case FIREDTV_DVB_T:
 		ops->delsys[0]		= SYS_DVBT;
 
-		fi->frequency_min	= 49000000;
-		fi->frequency_max	= 861000000;
-		fi->frequency_stepsize	= 62500;
+		fi->frequency_min_hz	=  49 * MHz;
+		fi->frequency_max_hz	= 861 * MHz;
+		fi->frequency_stepsize_hz = 62500;
 
 		fi->caps		= FE_CAN_INVERSION_AUTO		|
 					  FE_CAN_FEC_2_3		|
diff --git a/drivers/media/pci/bt8xx/dst.c b/drivers/media/pci/bt8xx/dst.c
index 2e33b7236672..b98de2a22f78 100644
--- a/drivers/media/pci/bt8xx/dst.c
+++ b/drivers/media/pci/bt8xx/dst.c
@@ -1739,9 +1739,9 @@ static const struct dvb_frontend_ops dst_dvbt_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "DST DVB-T",
-		.frequency_min = 137000000,
-		.frequency_max = 858000000,
-		.frequency_stepsize = 166667,
+		.frequency_min_hz = 137 * MHz,
+		.frequency_max_hz = 858 * MHz,
+		.frequency_stepsize_hz = 166667,
 		.caps = FE_CAN_FEC_AUTO			|
 			FE_CAN_QAM_AUTO			|
 			FE_CAN_QAM_16			|
@@ -1768,10 +1768,10 @@ static const struct dvb_frontend_ops dst_dvbs_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name = "DST DVB-S",
-		.frequency_min = 950000,
-		.frequency_max = 2150000,
-		.frequency_stepsize = 1000,	/* kHz for QPSK frontends */
-		.frequency_tolerance = 29500,
+		.frequency_min_hz   =  950 * MHz,
+		.frequency_max_hz   = 2150 * MHz,
+		.frequency_stepsize_hz = 1 * MHz,
+		.frequency_tolerance_hz = 29500 * kHz,
 		.symbol_rate_min = 1000000,
 		.symbol_rate_max = 45000000,
 	/*     . symbol_rate_tolerance	=	???,*/
@@ -1797,9 +1797,9 @@ static const struct dvb_frontend_ops dst_dvbc_ops = {
 	.delsys = { SYS_DVBC_ANNEX_A },
 	.info = {
 		.name = "DST DVB-C",
-		.frequency_stepsize = 62500,
-		.frequency_min = 51000000,
-		.frequency_max = 858000000,
+		.frequency_min_hz =  51 * MHz,
+		.frequency_max_hz = 858 * MHz,
+		.frequency_stepsize_hz = 62500,
 		.symbol_rate_min = 1000000,
 		.symbol_rate_max = 45000000,
 		.caps = FE_CAN_FEC_AUTO |
@@ -1826,9 +1826,9 @@ static const struct dvb_frontend_ops dst_atsc_ops = {
 	.delsys = { SYS_ATSC },
 	.info = {
 		.name = "DST ATSC",
-		.frequency_stepsize = 62500,
-		.frequency_min = 510000000,
-		.frequency_max = 858000000,
+		.frequency_min_hz = 510 * MHz,
+		.frequency_max_hz = 858 * MHz,
+		.frequency_stepsize_hz = 62500,
 		.symbol_rate_min = 1000000,
 		.symbol_rate_max = 45000000,
 		.caps = FE_CAN_FEC_AUTO | FE_CAN_QAM_AUTO | FE_CAN_QAM_64 | FE_CAN_QAM_256 | FE_CAN_8VSB
diff --git a/drivers/media/pci/bt8xx/dvb-bt8xx.c b/drivers/media/pci/bt8xx/dvb-bt8xx.c
index 5ef6e2051d45..869733561ccb 100644
--- a/drivers/media/pci/bt8xx/dvb-bt8xx.c
+++ b/drivers/media/pci/bt8xx/dvb-bt8xx.c
@@ -606,8 +606,8 @@ static void frontend_init(struct dvb_bt8xx_card *card, u32 type)
 
 		if (card->fe != NULL) {
 			card->fe->ops.tuner_ops.calc_regs = thomson_dtt7579_tuner_calc_regs;
-			card->fe->ops.info.frequency_min = 174000000;
-			card->fe->ops.info.frequency_max = 862000000;
+			card->fe->ops.info.frequency_min_hz = 174 * MHz;
+			card->fe->ops.info.frequency_max_hz = 862 * MHz;
 		}
 		break;
 
@@ -659,8 +659,8 @@ static void frontend_init(struct dvb_bt8xx_card *card, u32 type)
 		card->fe = dvb_attach(mt352_attach, &advbt771_samsung_tdtc9251dh0_config, card->i2c_adapter);
 		if (card->fe != NULL) {
 			card->fe->ops.tuner_ops.calc_regs = advbt771_samsung_tdtc9251dh0_tuner_calc_regs;
-			card->fe->ops.info.frequency_min = 174000000;
-			card->fe->ops.info.frequency_max = 862000000;
+			card->fe->ops.info.frequency_min_hz = 174 * MHz;
+			card->fe->ops.info.frequency_max_hz = 862 * MHz;
 		}
 		break;
 
diff --git a/drivers/media/pci/ddbridge/ddbridge-mci.c b/drivers/media/pci/ddbridge/ddbridge-mci.c
index 4ac634fc96e4..396f60d30024 100644
--- a/drivers/media/pci/ddbridge/ddbridge-mci.c
+++ b/drivers/media/pci/ddbridge/ddbridge-mci.c
@@ -463,10 +463,8 @@ static struct dvb_frontend_ops mci_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2 },
 	.info = {
 		.name			= "Digital Devices MaxSX8 MCI DVB-S/S2/S2X",
-		.frequency_min		= 950000,
-		.frequency_max		= 2150000,
-		.frequency_stepsize	= 0,
-		.frequency_tolerance	= 0,
+		.frequency_min_hz	=  950 * MHz,
+		.frequency_max_hz	= 2150 * MHz,
 		.symbol_rate_min	= 100000,
 		.symbol_rate_max	= 100000000,
 		.caps			= FE_CAN_INVERSION_AUTO |
diff --git a/drivers/media/pci/mantis/mantis_vp3030.c b/drivers/media/pci/mantis/mantis_vp3030.c
index 14f6e153000c..9797c9fd8259 100644
--- a/drivers/media/pci/mantis/mantis_vp3030.c
+++ b/drivers/media/pci/mantis/mantis_vp3030.c
@@ -42,8 +42,8 @@ static struct zl10353_config mantis_vp3030_config = {
 static struct tda665x_config env57h12d5_config = {
 	.name			= "ENV57H12D5 (ET-50DT)",
 	.addr			= 0x60,
-	.frequency_min		=  47000000,
-	.frequency_max		= 862000000,
+	.frequency_min		=  47 * MHz,
+	.frequency_max		= 862 * MHz,
 	.frequency_offst	=   3616667,
 	.ref_multiplier		= 6, /* 1/6 MHz */
 	.ref_divider		= 100000, /* 1/6 MHz */
diff --git a/drivers/media/tuners/mxl5007t.c b/drivers/media/tuners/mxl5007t.c
index 4081fd97c3b2..54d9226aaff7 100644
--- a/drivers/media/tuners/mxl5007t.c
+++ b/drivers/media/tuners/mxl5007t.c
@@ -59,8 +59,6 @@ MODULE_PARM_DESC(debug, "set debug level");
 
 /* ------------------------------------------------------------------------- */
 
-#define MHz 1000000
-
 enum mxl5007t_mode {
 	MxL_MODE_ISDBT     =    0,
 	MxL_MODE_DVBT      =    1,
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c b/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c
index 221cf46b4140..9f74453799a2 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c
@@ -554,9 +554,9 @@ static const struct dvb_frontend_ops mxl111sf_demod_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name               = "MaxLinear MxL111SF DVB-T demodulator",
-		.frequency_min      = 177000000,
-		.frequency_max      = 858000000,
-		.frequency_stepsize = 166666,
+		.frequency_min_hz      = 177 * MHz,
+		.frequency_max_hz      = 858 * MHz,
+		.frequency_stepsize_hz = 166666,
 		.caps = FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 			FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
 			FE_CAN_QPSK | FE_CAN_QAM_16 | FE_CAN_QAM_64 |
diff --git a/drivers/media/usb/dvb-usb/af9005-fe.c b/drivers/media/usb/dvb-usb/af9005-fe.c
index 7fbbc954da16..09cc3a21af65 100644
--- a/drivers/media/usb/dvb-usb/af9005-fe.c
+++ b/drivers/media/usb/dvb-usb/af9005-fe.c
@@ -1455,9 +1455,9 @@ static const struct dvb_frontend_ops af9005_fe_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		 .name = "AF9005 USB DVB-T",
-		 .frequency_min = 44250000,
-		 .frequency_max = 867250000,
-		 .frequency_stepsize = 250000,
+		 .frequency_min_hz =    44250 * kHz,
+		 .frequency_max_hz =   867250 * kHz,
+		 .frequency_stepsize_hz = 250 * kHz,
 		 .caps = FE_CAN_INVERSION_AUTO |
 		 FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 		 FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
diff --git a/drivers/media/usb/dvb-usb/cinergyT2-fe.c b/drivers/media/usb/dvb-usb/cinergyT2-fe.c
index 5a2f81311fb7..df71df7ed524 100644
--- a/drivers/media/usb/dvb-usb/cinergyT2-fe.c
+++ b/drivers/media/usb/dvb-usb/cinergyT2-fe.c
@@ -295,9 +295,9 @@ static const struct dvb_frontend_ops cinergyt2_fe_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= DRIVER_NAME,
-		.frequency_min		= 174000000,
-		.frequency_max		= 862000000,
-		.frequency_stepsize	= 166667,
+		.frequency_min_hz	= 174 * MHz,
+		.frequency_max_hz	= 862 * MHz,
+		.frequency_stepsize_hz	= 166667,
 		.caps = FE_CAN_INVERSION_AUTO | FE_CAN_FEC_1_2
 			| FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4
 			| FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8
diff --git a/drivers/media/usb/dvb-usb/dtt200u-fe.c b/drivers/media/usb/dvb-usb/dtt200u-fe.c
index 7e75aae34fb8..1ca3a51b2ae3 100644
--- a/drivers/media/usb/dvb-usb/dtt200u-fe.c
+++ b/drivers/media/usb/dvb-usb/dtt200u-fe.c
@@ -230,9 +230,9 @@ static const struct dvb_frontend_ops dtt200u_fe_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "WideView USB DVB-T",
-		.frequency_min		= 44250000,
-		.frequency_max		= 867250000,
-		.frequency_stepsize	= 250000,
+		.frequency_min_hz	=  44250 * kHz,
+		.frequency_max_hz	= 867250 * kHz,
+		.frequency_stepsize_hz	=    250 * kHz,
 		.caps = FE_CAN_INVERSION_AUTO |
 				FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 				FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
diff --git a/drivers/media/usb/dvb-usb/friio-fe.c b/drivers/media/usb/dvb-usb/friio-fe.c
index 932f262452eb..e6bd0ed8d789 100644
--- a/drivers/media/usb/dvb-usb/friio-fe.c
+++ b/drivers/media/usb/dvb-usb/friio-fe.c
@@ -133,10 +133,10 @@ static int jdvbt90502_pll_set_freq(struct jdvbt90502_state *state, u32 freq)
 	u32 f;
 
 	deb_fe("%s: freq=%d, step=%d\n", __func__, freq,
-	       state->frontend.ops.info.frequency_stepsize);
+	       state->frontend.ops.info.frequency_stepsize_hz);
 	/* freq -> oscilator frequency conversion. */
 	/* freq: 473,000,000 + n*6,000,000 [+ 142857 (center freq. shift)] */
-	f = freq / state->frontend.ops.info.frequency_stepsize;
+	f = freq / state->frontend.ops.info.frequency_stepsize_hz;
 	/* add 399[1/7 MHZ] = 57MHz for the IF  */
 	f += 399;
 	/* add center frequency shift if necessary */
@@ -413,10 +413,9 @@ static const struct dvb_frontend_ops jdvbt90502_ops = {
 	.delsys = { SYS_ISDBT },
 	.info = {
 		.name			= "Comtech JDVBT90502 ISDB-T",
-		.frequency_min		= 473000000, /* UHF 13ch, center */
-		.frequency_max		= 767142857, /* UHF 62ch, center */
-		.frequency_stepsize	= JDVBT90502_PLL_CLK / JDVBT90502_PLL_DIVIDER,
-		.frequency_tolerance	= 0,
+		.frequency_min_hz	= 473000000, /* UHF 13ch, center */
+		.frequency_max_hz	= 767142857, /* UHF 62ch, center */
+		.frequency_stepsize_hz	= JDVBT90502_PLL_CLK / JDVBT90502_PLL_DIVIDER,
 
 		/* NOTE: this driver ignores all parameters but frequency. */
 		.caps = FE_CAN_INVERSION_AUTO |
diff --git a/drivers/media/usb/dvb-usb/vp702x-fe.c b/drivers/media/usb/dvb-usb/vp702x-fe.c
index ae48146e005c..9eb811452f2e 100644
--- a/drivers/media/usb/dvb-usb/vp702x-fe.c
+++ b/drivers/media/usb/dvb-usb/vp702x-fe.c
@@ -349,10 +349,9 @@ static const struct dvb_frontend_ops vp702x_fe_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name           = "Twinhan DST-like frontend (VP7021/VP7020) DVB-S",
-		.frequency_min       = 950000,
-		.frequency_max       = 2150000,
-		.frequency_stepsize  = 1000,   /* kHz for QPSK frontends */
-		.frequency_tolerance = 0,
+		.frequency_min_hz       =  950 * MHz,
+		.frequency_max_hz       = 2150 * MHz,
+		.frequency_stepsize_hz  =    1 * MHz,
 		.symbol_rate_min     = 1000000,
 		.symbol_rate_max     = 45000000,
 		.symbol_rate_tolerance = 500,  /* ppm */
diff --git a/drivers/media/usb/dvb-usb/vp7045-fe.c b/drivers/media/usb/dvb-usb/vp7045-fe.c
index f86040173b8d..1173ae29885b 100644
--- a/drivers/media/usb/dvb-usb/vp7045-fe.c
+++ b/drivers/media/usb/dvb-usb/vp7045-fe.c
@@ -162,9 +162,9 @@ static const struct dvb_frontend_ops vp7045_fe_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Twinhan VP7045/46 USB DVB-T",
-		.frequency_min		= 44250000,
-		.frequency_max		= 867250000,
-		.frequency_stepsize	= 1000,
+		.frequency_min_hz	=  44250 * kHz,
+		.frequency_max_hz	= 867250 * kHz,
+		.frequency_stepsize_hz	=      1 * kHz,
 		.caps = FE_CAN_INVERSION_AUTO |
 				FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 				FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
diff --git a/drivers/media/usb/ttusb-dec/ttusbdecfe.c b/drivers/media/usb/ttusb-dec/ttusbdecfe.c
index 6ea05d909024..278bf6c5855b 100644
--- a/drivers/media/usb/ttusb-dec/ttusbdecfe.c
+++ b/drivers/media/usb/ttusb-dec/ttusbdecfe.c
@@ -247,9 +247,9 @@ static const struct dvb_frontend_ops ttusbdecfe_dvbt_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "TechnoTrend/Hauppauge DEC2000-t Frontend",
-		.frequency_min		= 51000000,
-		.frequency_max		= 858000000,
-		.frequency_stepsize	= 62500,
+		.frequency_min_hz	=  51 * MHz,
+		.frequency_max_hz	= 858 * MHz,
+		.frequency_stepsize_hz	= 62500,
 		.caps =	FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 			FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
 			FE_CAN_QAM_16 | FE_CAN_QAM_64 | FE_CAN_QAM_AUTO |
@@ -270,9 +270,9 @@ static const struct dvb_frontend_ops ttusbdecfe_dvbs_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "TechnoTrend/Hauppauge DEC3000-s Frontend",
-		.frequency_min		= 950000,
-		.frequency_max		= 2150000,
-		.frequency_stepsize	= 125,
+		.frequency_min_hz	=  950 * MHz,
+		.frequency_max_hz	= 2150 * MHz,
+		.frequency_stepsize_hz	=  125 * kHz,
 		.symbol_rate_min        = 1000000,  /* guessed */
 		.symbol_rate_max        = 45000000, /* guessed */
 		.caps =	FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
diff --git a/include/media/dvb_frontend.h b/include/media/dvb_frontend.h
index aebaec2dc725..6f7a85ab3541 100644
--- a/include/media/dvb_frontend.h
+++ b/include/media/dvb_frontend.h
@@ -317,6 +317,34 @@ struct analog_demod_ops {
 
 struct dtv_frontend_properties;
 
+/**
+ * struct dvb_frontend_internal_info - Frontend properties and capabilities
+ *
+ * @name:			Name of the frontend
+ * @frequency_min_hz:		Minimal frequency supported by the frontend.
+ * @frequency_max_hz:		Minimal frequency supported by the frontend.
+ * @frequency_stepsize_hz:	All frequencies are multiple of this value.
+ * @frequency_tolerance_hz:	Frequency tolerance.
+ * @symbol_rate_min:		Minimal symbol rate, in bauds
+ *				(for Cable/Satellite systems).
+ * @symbol_rate_max:		Maximal symbol rate, in bauds
+ *				(for Cable/Satellite systems).
+ * @symbol_rate_tolerance:	Maximal symbol rate tolerance, in ppm
+ *				(for Cable/Satellite systems).
+ * @caps:			Capabilities supported by the frontend,
+ *				as specified in &enum fe_caps.
+ */
+struct dvb_frontend_internal_info {
+	char	name[128];
+	u32	frequency_min_hz;
+	u32	frequency_max_hz;
+	u32	frequency_stepsize_hz;
+	u32	frequency_tolerance_hz;
+	u32	symbol_rate_min;
+	u32	symbol_rate_max;
+	u32	symbol_rate_tolerance;
+	enum fe_caps caps;
+};
 
 /**
  * struct dvb_frontend_ops - Demodulation information and callbacks for
@@ -404,7 +432,7 @@ struct dtv_frontend_properties;
  * @analog_ops:		pointer to &struct analog_demod_ops
  */
 struct dvb_frontend_ops {
-	struct dvb_frontend_info info;
+	struct dvb_frontend_internal_info info;
 
 	u8 delsys[MAX_DELSYS];
 
-- 
2.17.1
