Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965Ab2AAULY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Jan 2012 15:11:24 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q01KBOQH021917
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 1 Jan 2012 15:11:24 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 9/9] [media] dvb: Remove ops->info.type from frontends
Date: Sun,  1 Jan 2012 18:11:18 -0200
Message-Id: <1325448678-13001-10-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325448678-13001-1-git-send-email-mchehab@redhat.com>
References: <1325448678-13001-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that this field is deprecated, and core generates it for
DVBv3 calls, remove it from the drivers.

It also adds .delsys on the few drivers where this were missed.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/bt8xx/dst.c               |    5 +----
 drivers/media/dvb/dvb-usb/af9005-fe.c       |    1 -
 drivers/media/dvb/dvb-usb/cinergyT2-fe.c    |    1 -
 drivers/media/dvb/dvb-usb/dtt200u-fe.c      |    1 -
 drivers/media/dvb/dvb-usb/friio-fe.c        |    1 -
 drivers/media/dvb/dvb-usb/gp8psk-fe.c       |    1 -
 drivers/media/dvb/dvb-usb/mxl111sf-demod.c  |    1 -
 drivers/media/dvb/dvb-usb/vp702x-fe.c       |    1 -
 drivers/media/dvb/dvb-usb/vp7045-fe.c       |    1 -
 drivers/media/dvb/frontends/af9013.c        |    1 -
 drivers/media/dvb/frontends/atbm8830.c      |    1 -
 drivers/media/dvb/frontends/au8522_dig.c    |    1 -
 drivers/media/dvb/frontends/bcm3510.c       |    1 -
 drivers/media/dvb/frontends/cx22700.c       |    1 -
 drivers/media/dvb/frontends/cx22702.c       |    1 -
 drivers/media/dvb/frontends/cx24110.c       |    1 -
 drivers/media/dvb/frontends/cx24116.c       |    1 -
 drivers/media/dvb/frontends/cx24123.c       |    1 -
 drivers/media/dvb/frontends/cxd2820r_core.c |    2 --
 drivers/media/dvb/frontends/dib3000mb.c     |    1 -
 drivers/media/dvb/frontends/dib3000mc.c     |    1 -
 drivers/media/dvb/frontends/dib7000m.c      |    1 -
 drivers/media/dvb/frontends/dib7000p.c      |    1 -
 drivers/media/dvb/frontends/dib8000.c       |    1 -
 drivers/media/dvb/frontends/dib9000.c       |    1 -
 drivers/media/dvb/frontends/drxd_hard.c     |    1 -
 drivers/media/dvb/frontends/drxk_hard.c     |    2 --
 drivers/media/dvb/frontends/ds3000.c        |    1 -
 drivers/media/dvb/frontends/dvb_dummy_fe.c  |    3 ---
 drivers/media/dvb/frontends/ec100.c         |    1 -
 drivers/media/dvb/frontends/it913x-fe.c     |    1 -
 drivers/media/dvb/frontends/l64781.c        |    1 -
 drivers/media/dvb/frontends/lgdt3305.c      |    3 +--
 drivers/media/dvb/frontends/lgdt330x.c      |    2 --
 drivers/media/dvb/frontends/lgs8gl5.c       |    1 -
 drivers/media/dvb/frontends/lgs8gxx.c       |    1 -
 drivers/media/dvb/frontends/mb86a16.c       |    1 -
 drivers/media/dvb/frontends/mb86a20s.c      |    1 -
 drivers/media/dvb/frontends/mt312.c         |    1 -
 drivers/media/dvb/frontends/mt352.c         |    1 -
 drivers/media/dvb/frontends/nxt200x.c       |    1 -
 drivers/media/dvb/frontends/nxt6000.c       |    1 -
 drivers/media/dvb/frontends/or51132.c       |    1 -
 drivers/media/dvb/frontends/or51211.c       |    1 -
 drivers/media/dvb/frontends/s5h1409.c       |    1 -
 drivers/media/dvb/frontends/s5h1411.c       |    1 -
 drivers/media/dvb/frontends/s5h1420.c       |    1 -
 drivers/media/dvb/frontends/s5h1432.c       |    1 -
 drivers/media/dvb/frontends/s921.c          |    1 -
 drivers/media/dvb/frontends/si21xx.c        |    1 -
 drivers/media/dvb/frontends/sp8870.c        |    1 -
 drivers/media/dvb/frontends/sp887x.c        |    1 -
 drivers/media/dvb/frontends/stb0899_drv.c   |   20 +-------------------
 drivers/media/dvb/frontends/stv0288.c       |    8 --------
 drivers/media/dvb/frontends/stv0297.c       |    1 -
 drivers/media/dvb/frontends/stv0299.c       |    1 -
 drivers/media/dvb/frontends/stv0367.c       |    2 --
 drivers/media/dvb/frontends/stv0900_core.c  |    1 -
 drivers/media/dvb/frontends/stv090x.c       |    1 -
 drivers/media/dvb/frontends/tda10021.c      |    1 -
 drivers/media/dvb/frontends/tda10023.c      |    1 -
 drivers/media/dvb/frontends/tda10048.c      |    1 -
 drivers/media/dvb/frontends/tda1004x.c      |    2 --
 drivers/media/dvb/frontends/tda10071.c      |    1 -
 drivers/media/dvb/frontends/tda10086.c      |    1 -
 drivers/media/dvb/frontends/tda8083.c       |    1 -
 drivers/media/dvb/frontends/ves1820.c       |    1 -
 drivers/media/dvb/frontends/ves1x93.c       |    1 -
 drivers/media/dvb/frontends/zl10353.c       |    1 -
 drivers/media/dvb/pt1/va1j5jf8007s.c        |    1 -
 drivers/media/dvb/pt1/va1j5jf8007t.c        |    1 -
 drivers/media/dvb/siano/smsdvb.c            |    1 -
 drivers/media/dvb/ttusb-dec/ttusbdecfe.c    |    2 --
 drivers/media/video/tlg2300/pd-dvb.c        |    1 -
 74 files changed, 3 insertions(+), 111 deletions(-)

diff --git a/drivers/media/dvb/bt8xx/dst.c b/drivers/media/dvb/bt8xx/dst.c
index 9c5cbf1..430b3eb 100644
--- a/drivers/media/dvb/bt8xx/dst.c
+++ b/drivers/media/dvb/bt8xx/dst.c
@@ -1762,7 +1762,6 @@ static struct dvb_frontend_ops dst_dvbt_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "DST DVB-T",
-		.type = FE_OFDM,
 		.frequency_min = 137000000,
 		.frequency_max = 858000000,
 		.frequency_stepsize = 166667,
@@ -1792,7 +1791,6 @@ static struct dvb_frontend_ops dst_dvbs_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name = "DST DVB-S",
-		.type = FE_QPSK,
 		.frequency_min = 950000,
 		.frequency_max = 2150000,
 		.frequency_stepsize = 1000,	/* kHz for QPSK frontends */
@@ -1822,7 +1820,6 @@ static struct dvb_frontend_ops dst_dvbc_ops = {
 	.delsys = { SYS_DVBC_ANNEX_A },
 	.info = {
 		.name = "DST DVB-C",
-		.type = FE_QAM,
 		.frequency_stepsize = 62500,
 		.frequency_min = 51000000,
 		.frequency_max = 858000000,
@@ -1849,9 +1846,9 @@ static struct dvb_frontend_ops dst_dvbc_ops = {
 };
 
 static struct dvb_frontend_ops dst_atsc_ops = {
+	.delsys = { SYS_ATSC },
 	.info = {
 		.name = "DST ATSC",
-		.type = FE_ATSC,
 		.frequency_stepsize = 62500,
 		.frequency_min = 510000000,
 		.frequency_max = 858000000,
diff --git a/drivers/media/dvb/dvb-usb/af9005-fe.c b/drivers/media/dvb/dvb-usb/af9005-fe.c
index 0e1b04f..740f3f4 100644
--- a/drivers/media/dvb/dvb-usb/af9005-fe.c
+++ b/drivers/media/dvb/dvb-usb/af9005-fe.c
@@ -1458,7 +1458,6 @@ static struct dvb_frontend_ops af9005_fe_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		 .name = "AF9005 USB DVB-T",
-		 .type = FE_OFDM,
 		 .frequency_min = 44250000,
 		 .frequency_max = 867250000,
 		 .frequency_stepsize = 250000,
diff --git a/drivers/media/dvb/dvb-usb/cinergyT2-fe.c b/drivers/media/dvb/dvb-usb/cinergyT2-fe.c
index 0315db8..8a57ed8 100644
--- a/drivers/media/dvb/dvb-usb/cinergyT2-fe.c
+++ b/drivers/media/dvb/dvb-usb/cinergyT2-fe.c
@@ -323,7 +323,6 @@ static struct dvb_frontend_ops cinergyt2_fe_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= DRIVER_NAME,
-		.type			= FE_OFDM,
 		.frequency_min		= 174000000,
 		.frequency_max		= 862000000,
 		.frequency_stepsize	= 166667,
diff --git a/drivers/media/dvb/dvb-usb/dtt200u-fe.c b/drivers/media/dvb/dvb-usb/dtt200u-fe.c
index c94da3c..3d81daa 100644
--- a/drivers/media/dvb/dvb-usb/dtt200u-fe.c
+++ b/drivers/media/dvb/dvb-usb/dtt200u-fe.c
@@ -180,7 +180,6 @@ static struct dvb_frontend_ops dtt200u_fe_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "WideView USB DVB-T",
-		.type			= FE_OFDM,
 		.frequency_min		= 44250000,
 		.frequency_max		= 867250000,
 		.frequency_stepsize	= 250000,
diff --git a/drivers/media/dvb/dvb-usb/friio-fe.c b/drivers/media/dvb/dvb-usb/friio-fe.c
index 0660a87..90a70c6 100644
--- a/drivers/media/dvb/dvb-usb/friio-fe.c
+++ b/drivers/media/dvb/dvb-usb/friio-fe.c
@@ -442,7 +442,6 @@ static struct dvb_frontend_ops jdvbt90502_ops = {
 	.delsys = { SYS_ISDBT },
 	.info = {
 		.name			= "Comtech JDVBT90502 ISDB-T",
-		.type			= FE_OFDM,
 		.frequency_min		= 473000000, /* UHF 13ch, center */
 		.frequency_max		= 767142857, /* UHF 62ch, center */
 		.frequency_stepsize	= JDVBT90502_PLL_CLK / JDVBT90502_PLL_DIVIDER,
diff --git a/drivers/media/dvb/dvb-usb/gp8psk-fe.c b/drivers/media/dvb/dvb-usb/gp8psk-fe.c
index 79db9d6..67957dd 100644
--- a/drivers/media/dvb/dvb-usb/gp8psk-fe.c
+++ b/drivers/media/dvb/dvb-usb/gp8psk-fe.c
@@ -329,7 +329,6 @@ static struct dvb_frontend_ops gp8psk_fe_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "Genpix DVB-S",
-		.type			= FE_QPSK,
 		.frequency_min		= 800000,
 		.frequency_max		= 2250000,
 		.frequency_stepsize	= 100,
diff --git a/drivers/media/dvb/dvb-usb/mxl111sf-demod.c b/drivers/media/dvb/dvb-usb/mxl111sf-demod.c
index 694e207..d83df4b 100644
--- a/drivers/media/dvb/dvb-usb/mxl111sf-demod.c
+++ b/drivers/media/dvb/dvb-usb/mxl111sf-demod.c
@@ -553,7 +553,6 @@ static struct dvb_frontend_ops mxl111sf_demod_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name               = "MaxLinear MxL111SF DVB-T demodulator",
-		.type               = FE_OFDM,
 		.frequency_min      = 177000000,
 		.frequency_max      = 858000000,
 		.frequency_stepsize = 166666,
diff --git a/drivers/media/dvb/dvb-usb/vp702x-fe.c b/drivers/media/dvb/dvb-usb/vp702x-fe.c
index 8d8c6ad..5eab468 100644
--- a/drivers/media/dvb/dvb-usb/vp702x-fe.c
+++ b/drivers/media/dvb/dvb-usb/vp702x-fe.c
@@ -346,7 +346,6 @@ static struct dvb_frontend_ops vp702x_fe_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name           = "Twinhan DST-like frontend (VP7021/VP7020) DVB-S",
-		.type           = FE_QPSK,
 		.frequency_min       = 950000,
 		.frequency_max       = 2150000,
 		.frequency_stepsize  = 1000,   /* kHz for QPSK frontends */
diff --git a/drivers/media/dvb/dvb-usb/vp7045-fe.c b/drivers/media/dvb/dvb-usb/vp7045-fe.c
index ecbd623..b8825b1 100644
--- a/drivers/media/dvb/dvb-usb/vp7045-fe.c
+++ b/drivers/media/dvb/dvb-usb/vp7045-fe.c
@@ -161,7 +161,6 @@ static struct dvb_frontend_ops vp7045_fe_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Twinhan VP7045/46 USB DVB-T",
-		.type			= FE_OFDM,
 		.frequency_min		= 44250000,
 		.frequency_max		= 867250000,
 		.frequency_stepsize	= 1000,
diff --git a/drivers/media/dvb/frontends/af9013.c b/drivers/media/dvb/frontends/af9013.c
index e6ba3e0..d4227c6 100644
--- a/drivers/media/dvb/frontends/af9013.c
+++ b/drivers/media/dvb/frontends/af9013.c
@@ -1483,7 +1483,6 @@ static struct dvb_frontend_ops af9013_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "Afatech AF9013",
-		.type = FE_OFDM,
 		.frequency_min = 174000000,
 		.frequency_max = 862000000,
 		.frequency_stepsize = 250000,
diff --git a/drivers/media/dvb/frontends/atbm8830.c b/drivers/media/dvb/frontends/atbm8830.c
index ff86074..a2261ea 100644
--- a/drivers/media/dvb/frontends/atbm8830.c
+++ b/drivers/media/dvb/frontends/atbm8830.c
@@ -431,7 +431,6 @@ static struct dvb_frontend_ops atbm8830_ops = {
 	.delsys = { SYS_DMBTH },
 	.info = {
 		.name = "AltoBeam ATBM8830/8831 DMB-TH",
-		.type = FE_OFDM,
 		.frequency_min = 474000000,
 		.frequency_max = 858000000,
 		.frequency_stepsize = 10000,
diff --git a/drivers/media/dvb/frontends/au8522_dig.c b/drivers/media/dvb/frontends/au8522_dig.c
index 762cd5e..c688b95 100644
--- a/drivers/media/dvb/frontends/au8522_dig.c
+++ b/drivers/media/dvb/frontends/au8522_dig.c
@@ -1013,7 +1013,6 @@ static struct dvb_frontend_ops au8522_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name			= "Auvitek AU8522 QAM/8VSB Frontend",
-		.type			= FE_ATSC,
 		.frequency_min		= 54000000,
 		.frequency_max		= 858000000,
 		.frequency_stepsize	= 62500,
diff --git a/drivers/media/dvb/frontends/bcm3510.c b/drivers/media/dvb/frontends/bcm3510.c
index a53f83a..033cd7a 100644
--- a/drivers/media/dvb/frontends/bcm3510.c
+++ b/drivers/media/dvb/frontends/bcm3510.c
@@ -825,7 +825,6 @@ static struct dvb_frontend_ops bcm3510_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name = "Broadcom BCM3510 VSB/QAM frontend",
-		.type = FE_ATSC,
 		.frequency_min =  54000000,
 		.frequency_max = 803000000,
 		/* stepsize is just a guess */
diff --git a/drivers/media/dvb/frontends/cx22700.c b/drivers/media/dvb/frontends/cx22700.c
index a5b1521..f2a90f9 100644
--- a/drivers/media/dvb/frontends/cx22700.c
+++ b/drivers/media/dvb/frontends/cx22700.c
@@ -408,7 +408,6 @@ static struct dvb_frontend_ops cx22700_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Conexant CX22700 DVB-T",
-		.type			= FE_OFDM,
 		.frequency_min		= 470000000,
 		.frequency_max		= 860000000,
 		.frequency_stepsize	= 166667,
diff --git a/drivers/media/dvb/frontends/cx22702.c b/drivers/media/dvb/frontends/cx22702.c
index a0dcbd6..faba824 100644
--- a/drivers/media/dvb/frontends/cx22702.c
+++ b/drivers/media/dvb/frontends/cx22702.c
@@ -606,7 +606,6 @@ static const struct dvb_frontend_ops cx22702_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Conexant CX22702 DVB-T",
-		.type			= FE_OFDM,
 		.frequency_min		= 177000000,
 		.frequency_max		= 858000000,
 		.frequency_stepsize	= 166666,
diff --git a/drivers/media/dvb/frontends/cx24110.c b/drivers/media/dvb/frontends/cx24110.c
index 2f07c49..5101f10 100644
--- a/drivers/media/dvb/frontends/cx24110.c
+++ b/drivers/media/dvb/frontends/cx24110.c
@@ -627,7 +627,6 @@ static struct dvb_frontend_ops cx24110_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name = "Conexant CX24110 DVB-S",
-		.type = FE_QPSK,
 		.frequency_min = 950000,
 		.frequency_max = 2150000,
 		.frequency_stepsize = 1011,  /* kHz for QPSK frontends */
diff --git a/drivers/media/dvb/frontends/cx24116.c b/drivers/media/dvb/frontends/cx24116.c
index e29de1c..b488791 100644
--- a/drivers/media/dvb/frontends/cx24116.c
+++ b/drivers/media/dvb/frontends/cx24116.c
@@ -1469,7 +1469,6 @@ static struct dvb_frontend_ops cx24116_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2 },
 	.info = {
 		.name = "Conexant CX24116/CX24118",
-		.type = FE_QPSK,
 		.frequency_min = 950000,
 		.frequency_max = 2150000,
 		.frequency_stepsize = 1011, /* kHz for QPSK frontends */
diff --git a/drivers/media/dvb/frontends/cx24123.c b/drivers/media/dvb/frontends/cx24123.c
index ad5d1a4..7e28b4e 100644
--- a/drivers/media/dvb/frontends/cx24123.c
+++ b/drivers/media/dvb/frontends/cx24123.c
@@ -1128,7 +1128,6 @@ static struct dvb_frontend_ops cx24123_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name = "Conexant CX24123/CX24109",
-		.type = FE_QPSK,
 		.frequency_min = 950000,
 		.frequency_max = 2150000,
 		.frequency_stepsize = 1011, /* kHz for QPSK frontends */
diff --git a/drivers/media/dvb/frontends/cxd2820r_core.c b/drivers/media/dvb/frontends/cxd2820r_core.c
index 07c1a95..93e1b12 100644
--- a/drivers/media/dvb/frontends/cxd2820r_core.c
+++ b/drivers/media/dvb/frontends/cxd2820r_core.c
@@ -554,11 +554,9 @@ static int cxd2820r_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 
 static const struct dvb_frontend_ops cxd2820r_ops = {
 	.delsys = { SYS_DVBT, SYS_DVBT2, SYS_DVBC_ANNEX_A },
-
 	/* default: DVB-T/T2 */
 	.info = {
 		.name = "Sony CXD2820R (DVB-T/T2)",
-		.type = FE_OFDM,
 
 		.caps =	FE_CAN_FEC_1_2			|
 			FE_CAN_FEC_2_3			|
diff --git a/drivers/media/dvb/frontends/dib3000mb.c b/drivers/media/dvb/frontends/dib3000mb.c
index a1c5bdb..af91e0c 100644
--- a/drivers/media/dvb/frontends/dib3000mb.c
+++ b/drivers/media/dvb/frontends/dib3000mb.c
@@ -793,7 +793,6 @@ static struct dvb_frontend_ops dib3000mb_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "DiBcom 3000M-B DVB-T",
-		.type			= FE_OFDM,
 		.frequency_min		= 44250000,
 		.frequency_max		= 867250000,
 		.frequency_stepsize	= 62500,
diff --git a/drivers/media/dvb/frontends/dib3000mc.c b/drivers/media/dvb/frontends/dib3000mc.c
index e500b89..ffad181 100644
--- a/drivers/media/dvb/frontends/dib3000mc.c
+++ b/drivers/media/dvb/frontends/dib3000mc.c
@@ -906,7 +906,6 @@ static struct dvb_frontend_ops dib3000mc_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "DiBcom 3000MC/P",
-		.type = FE_OFDM,
 		.frequency_min      = 44250000,
 		.frequency_max      = 867250000,
 		.frequency_stepsize = 62500,
diff --git a/drivers/media/dvb/frontends/dib7000m.c b/drivers/media/dvb/frontends/dib7000m.c
index 2a2d646..148bf79 100644
--- a/drivers/media/dvb/frontends/dib7000m.c
+++ b/drivers/media/dvb/frontends/dib7000m.c
@@ -1439,7 +1439,6 @@ static struct dvb_frontend_ops dib7000m_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "DiBcom 7000MA/MB/PA/PB/MC",
-		.type = FE_OFDM,
 		.frequency_min      = 44250000,
 		.frequency_max      = 867250000,
 		.frequency_stepsize = 62500,
diff --git a/drivers/media/dvb/frontends/dib7000p.c b/drivers/media/dvb/frontends/dib7000p.c
index 361bdb1..5ceadc2 100644
--- a/drivers/media/dvb/frontends/dib7000p.c
+++ b/drivers/media/dvb/frontends/dib7000p.c
@@ -2430,7 +2430,6 @@ static struct dvb_frontend_ops dib7000p_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		 .name = "DiBcom 7000PC",
-		 .type = FE_OFDM,
 		 .frequency_min = 44250000,
 		 .frequency_max = 867250000,
 		 .frequency_stepsize = 62500,
diff --git a/drivers/media/dvb/frontends/dib8000.c b/drivers/media/dvb/frontends/dib8000.c
index fe07d74..9ca34f4 100644
--- a/drivers/media/dvb/frontends/dib8000.c
+++ b/drivers/media/dvb/frontends/dib8000.c
@@ -3464,7 +3464,6 @@ static const struct dvb_frontend_ops dib8000_ops = {
 	.delsys = { SYS_ISDBT },
 	.info = {
 		 .name = "DiBcom 8000 ISDB-T",
-		 .type = FE_OFDM,
 		 .frequency_min = 44250000,
 		 .frequency_max = 867250000,
 		 .frequency_stepsize = 62500,
diff --git a/drivers/media/dvb/frontends/dib9000.c b/drivers/media/dvb/frontends/dib9000.c
index 2312b4d..863ef3c 100644
--- a/drivers/media/dvb/frontends/dib9000.c
+++ b/drivers/media/dvb/frontends/dib9000.c
@@ -2500,7 +2500,6 @@ static struct dvb_frontend_ops dib9000_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		 .name = "DiBcom 9000",
-		 .type = FE_OFDM,
 		 .frequency_min = 44250000,
 		 .frequency_max = 867250000,
 		 .frequency_stepsize = 62500,
diff --git a/drivers/media/dvb/frontends/drxd_hard.c b/drivers/media/dvb/frontends/drxd_hard.c
index 2520620..7bf39cd 100644
--- a/drivers/media/dvb/frontends/drxd_hard.c
+++ b/drivers/media/dvb/frontends/drxd_hard.c
@@ -2924,7 +2924,6 @@ static struct dvb_frontend_ops drxd_ops = {
 	.delsys = { SYS_DVBT},
 	.info = {
 		 .name = "Micronas DRXD DVB-T",
-		 .type = FE_OFDM,
 		 .frequency_min = 47125000,
 		 .frequency_max = 855250000,
 		 .frequency_stepsize = 166667,
diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 36e1c82..67a1e39 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -6355,7 +6355,6 @@ static struct dvb_frontend_ops drxk_c_ops = {
 	.delsys = { SYS_DVBC_ANNEX_A, SYS_DVBC_ANNEX_C },
 	.info = {
 		 .name = "DRXK DVB-C",
-		 .type = FE_QAM,
 		 .frequency_stepsize = 62500,
 		 .frequency_min = 47000000,
 		 .frequency_max = 862000000,
@@ -6382,7 +6381,6 @@ static struct dvb_frontend_ops drxk_t_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		 .name = "DRXK DVB-T",
-		 .type = FE_OFDM,
 		 .frequency_min = 47125000,
 		 .frequency_max = 865000000,
 		 .frequency_stepsize = 166667,
diff --git a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb/frontends/ds3000.c
index c6a43c4..9387770 100644
--- a/drivers/media/dvb/frontends/ds3000.c
+++ b/drivers/media/dvb/frontends/ds3000.c
@@ -1267,7 +1267,6 @@ static struct dvb_frontend_ops ds3000_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2},
 	.info = {
 		.name = "Montage Technology DS3000/TS2020",
-		.type = FE_QPSK,
 		.frequency_min = 950000,
 		.frequency_max = 2150000,
 		.frequency_stepsize = 1011, /* kHz for QPSK frontends */
diff --git a/drivers/media/dvb/frontends/dvb_dummy_fe.c b/drivers/media/dvb/frontends/dvb_dummy_fe.c
index ac4c8d2..dcfc902 100644
--- a/drivers/media/dvb/frontends/dvb_dummy_fe.c
+++ b/drivers/media/dvb/frontends/dvb_dummy_fe.c
@@ -177,7 +177,6 @@ static struct dvb_frontend_ops dvb_dummy_fe_ofdm_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Dummy DVB-T",
-		.type			= FE_OFDM,
 		.frequency_min		= 0,
 		.frequency_max		= 863250000,
 		.frequency_stepsize	= 62500,
@@ -209,7 +208,6 @@ static struct dvb_frontend_ops dvb_dummy_fe_qam_ops = {
 	.delsys = { SYS_DVBC_ANNEX_A },
 	.info = {
 		.name			= "Dummy DVB-C",
-		.type			= FE_QAM,
 		.frequency_stepsize	= 62500,
 		.frequency_min		= 51000000,
 		.frequency_max		= 858000000,
@@ -239,7 +237,6 @@ static struct dvb_frontend_ops dvb_dummy_fe_qpsk_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "Dummy DVB-S",
-		.type			= FE_QPSK,
 		.frequency_min		= 950000,
 		.frequency_max		= 2150000,
 		.frequency_stepsize	= 250,           /* kHz for QPSK frontends */
diff --git a/drivers/media/dvb/frontends/ec100.c b/drivers/media/dvb/frontends/ec100.c
index 39e0811..c56fddb 100644
--- a/drivers/media/dvb/frontends/ec100.c
+++ b/drivers/media/dvb/frontends/ec100.c
@@ -309,7 +309,6 @@ static struct dvb_frontend_ops ec100_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "E3C EC100 DVB-T",
-		.type = FE_OFDM,
 		.caps =
 			FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 			FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
diff --git a/drivers/media/dvb/frontends/it913x-fe.c b/drivers/media/dvb/frontends/it913x-fe.c
index 754d0f5..29cb47e 100644
--- a/drivers/media/dvb/frontends/it913x-fe.c
+++ b/drivers/media/dvb/frontends/it913x-fe.c
@@ -930,7 +930,6 @@ static struct dvb_frontend_ops it913x_fe_ofdm_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "it913x-fe DVB-T",
-		.type			= FE_OFDM,
 		.frequency_min		= 51000000,
 		.frequency_max		= 1680000000,
 		.frequency_stepsize	= 62500,
diff --git a/drivers/media/dvb/frontends/l64781.c b/drivers/media/dvb/frontends/l64781.c
index dc3e42c..36fcf55 100644
--- a/drivers/media/dvb/frontends/l64781.c
+++ b/drivers/media/dvb/frontends/l64781.c
@@ -575,7 +575,6 @@ static struct dvb_frontend_ops l64781_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "LSI L64781 DVB-T",
-		.type = FE_OFDM,
 	/*	.frequency_min = ???,*/
 	/*	.frequency_max = ???,*/
 		.frequency_stepsize = 166666,
diff --git a/drivers/media/dvb/frontends/lgdt3305.c b/drivers/media/dvb/frontends/lgdt3305.c
index 0b289b2..1d2c473 100644
--- a/drivers/media/dvb/frontends/lgdt3305.c
+++ b/drivers/media/dvb/frontends/lgdt3305.c
@@ -1166,9 +1166,9 @@ fail:
 EXPORT_SYMBOL(lgdt3305_attach);
 
 static struct dvb_frontend_ops lgdt3304_ops = {
+	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name = "LG Electronics LGDT3304 VSB/QAM Frontend",
-		.type               = FE_ATSC,
 		.frequency_min      = 54000000,
 		.frequency_max      = 858000000,
 		.frequency_stepsize = 62500,
@@ -1191,7 +1191,6 @@ static struct dvb_frontend_ops lgdt3305_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name = "LG Electronics LGDT3305 VSB/QAM Frontend",
-		.type               = FE_ATSC,
 		.frequency_min      = 54000000,
 		.frequency_max      = 858000000,
 		.frequency_stepsize = 62500,
diff --git a/drivers/media/dvb/frontends/lgdt330x.c b/drivers/media/dvb/frontends/lgdt330x.c
index 0e6f41b..c990d35 100644
--- a/drivers/media/dvb/frontends/lgdt330x.c
+++ b/drivers/media/dvb/frontends/lgdt330x.c
@@ -774,7 +774,6 @@ static struct dvb_frontend_ops lgdt3302_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name= "LG Electronics LGDT3302 VSB/QAM Frontend",
-		.type = FE_ATSC,
 		.frequency_min= 54000000,
 		.frequency_max= 858000000,
 		.frequency_stepsize= 62500,
@@ -798,7 +797,6 @@ static struct dvb_frontend_ops lgdt3303_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name= "LG Electronics LGDT3303 VSB/QAM Frontend",
-		.type = FE_ATSC,
 		.frequency_min= 54000000,
 		.frequency_max= 858000000,
 		.frequency_stepsize= 62500,
diff --git a/drivers/media/dvb/frontends/lgs8gl5.c b/drivers/media/dvb/frontends/lgs8gl5.c
index 8f2f43b..2cec804 100644
--- a/drivers/media/dvb/frontends/lgs8gl5.c
+++ b/drivers/media/dvb/frontends/lgs8gl5.c
@@ -415,7 +415,6 @@ static struct dvb_frontend_ops lgs8gl5_ops = {
 	.delsys = { SYS_DMBTH },
 	.info = {
 		.name			= "Legend Silicon LGS-8GL5 DMB-TH",
-		.type			= FE_OFDM,
 		.frequency_min		= 474000000,
 		.frequency_max		= 858000000,
 		.frequency_stepsize	= 10000,
diff --git a/drivers/media/dvb/frontends/lgs8gxx.c b/drivers/media/dvb/frontends/lgs8gxx.c
index a47add2..4de1d35 100644
--- a/drivers/media/dvb/frontends/lgs8gxx.c
+++ b/drivers/media/dvb/frontends/lgs8gxx.c
@@ -997,7 +997,6 @@ static struct dvb_frontend_ops lgs8gxx_ops = {
 	.delsys = { SYS_DMBTH },
 	.info = {
 		.name = "Legend Silicon LGS8913/LGS8GXX DMB-TH",
-		.type = FE_OFDM,
 		.frequency_min = 474000000,
 		.frequency_max = 858000000,
 		.frequency_stepsize = 10000,
diff --git a/drivers/media/dvb/frontends/mb86a16.c b/drivers/media/dvb/frontends/mb86a16.c
index 45844f4..9ae40ab 100644
--- a/drivers/media/dvb/frontends/mb86a16.c
+++ b/drivers/media/dvb/frontends/mb86a16.c
@@ -1817,7 +1817,6 @@ static struct dvb_frontend_ops mb86a16_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "Fujitsu MB86A16 DVB-S",
-		.type			= FE_QPSK,
 		.frequency_min		= 950000,
 		.frequency_max		= 2150000,
 		.frequency_stepsize	= 3000,
diff --git a/drivers/media/dvb/frontends/mb86a20s.c b/drivers/media/dvb/frontends/mb86a20s.c
index 4267e51..82d3301 100644
--- a/drivers/media/dvb/frontends/mb86a20s.c
+++ b/drivers/media/dvb/frontends/mb86a20s.c
@@ -617,7 +617,6 @@ static struct dvb_frontend_ops mb86a20s_ops = {
 	/* Use dib8000 values per default */
 	.info = {
 		.name = "Fujitsu mb86A20s",
-		.type = FE_OFDM,
 		.caps = FE_CAN_INVERSION_AUTO | FE_CAN_RECOVER |
 			FE_CAN_FEC_1_2  | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 			FE_CAN_FEC_5_6  | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
diff --git a/drivers/media/dvb/frontends/mt312.c b/drivers/media/dvb/frontends/mt312.c
index 90aac0d..e20bf13 100644
--- a/drivers/media/dvb/frontends/mt312.c
+++ b/drivers/media/dvb/frontends/mt312.c
@@ -741,7 +741,6 @@ static struct dvb_frontend_ops mt312_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name = "Zarlink ???? DVB-S",
-		.type = FE_QPSK,
 		.frequency_min = 950000,
 		.frequency_max = 2150000,
 		/* FIXME: adjust freq to real used xtal */
diff --git a/drivers/media/dvb/frontends/mt352.c b/drivers/media/dvb/frontends/mt352.c
index 0321eec..2c3b50e 100644
--- a/drivers/media/dvb/frontends/mt352.c
+++ b/drivers/media/dvb/frontends/mt352.c
@@ -570,7 +570,6 @@ static struct dvb_frontend_ops mt352_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Zarlink MT352 DVB-T",
-		.type			= FE_OFDM,
 		.frequency_min		= 174000000,
 		.frequency_max		= 862000000,
 		.frequency_stepsize	= 166667,
diff --git a/drivers/media/dvb/frontends/nxt200x.c b/drivers/media/dvb/frontends/nxt200x.c
index b541614..49ca78d 100644
--- a/drivers/media/dvb/frontends/nxt200x.c
+++ b/drivers/media/dvb/frontends/nxt200x.c
@@ -1206,7 +1206,6 @@ static struct dvb_frontend_ops nxt200x_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name = "Nextwave NXT200X VSB/QAM frontend",
-		.type = FE_ATSC,
 		.frequency_min =  54000000,
 		.frequency_max = 860000000,
 		.frequency_stepsize = 166666,	/* stepsize is just a guess */
diff --git a/drivers/media/dvb/frontends/nxt6000.c b/drivers/media/dvb/frontends/nxt6000.c
index 89021bd..90ae6c7 100644
--- a/drivers/media/dvb/frontends/nxt6000.c
+++ b/drivers/media/dvb/frontends/nxt6000.c
@@ -576,7 +576,6 @@ static struct dvb_frontend_ops nxt6000_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "NxtWave NXT6000 DVB-T",
-		.type = FE_OFDM,
 		.frequency_min = 0,
 		.frequency_max = 863250000,
 		.frequency_stepsize = 62500,
diff --git a/drivers/media/dvb/frontends/or51132.c b/drivers/media/dvb/frontends/or51132.c
index 82ee2959..5ef9218 100644
--- a/drivers/media/dvb/frontends/or51132.c
+++ b/drivers/media/dvb/frontends/or51132.c
@@ -589,7 +589,6 @@ static struct dvb_frontend_ops or51132_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name			= "Oren OR51132 VSB/QAM Frontend",
-		.type			= FE_ATSC,
 		.frequency_min		= 44000000,
 		.frequency_max		= 958000000,
 		.frequency_stepsize	= 166666,
diff --git a/drivers/media/dvb/frontends/or51211.c b/drivers/media/dvb/frontends/or51211.c
index d2b52e5..c625b57 100644
--- a/drivers/media/dvb/frontends/or51211.c
+++ b/drivers/media/dvb/frontends/or51211.c
@@ -547,7 +547,6 @@ static struct dvb_frontend_ops or51211_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name               = "Oren OR51211 VSB Frontend",
-		.type               = FE_ATSC,
 		.frequency_min      = 44000000,
 		.frequency_max      = 958000000,
 		.frequency_stepsize = 166666,
diff --git a/drivers/media/dvb/frontends/s5h1409.c b/drivers/media/dvb/frontends/s5h1409.c
index 21baea8..f71b062 100644
--- a/drivers/media/dvb/frontends/s5h1409.c
+++ b/drivers/media/dvb/frontends/s5h1409.c
@@ -999,7 +999,6 @@ static struct dvb_frontend_ops s5h1409_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name			= "Samsung S5H1409 QAM/8VSB Frontend",
-		.type			= FE_ATSC,
 		.frequency_min		= 54000000,
 		.frequency_max		= 858000000,
 		.frequency_stepsize	= 62500,
diff --git a/drivers/media/dvb/frontends/s5h1411.c b/drivers/media/dvb/frontends/s5h1411.c
index b8c7feb..6cc4b7a 100644
--- a/drivers/media/dvb/frontends/s5h1411.c
+++ b/drivers/media/dvb/frontends/s5h1411.c
@@ -918,7 +918,6 @@ static struct dvb_frontend_ops s5h1411_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name			= "Samsung S5H1411 QAM/8VSB Frontend",
-		.type			= FE_ATSC,
 		.frequency_min		= 54000000,
 		.frequency_max		= 858000000,
 		.frequency_stepsize	= 62500,
diff --git a/drivers/media/dvb/frontends/s5h1420.c b/drivers/media/dvb/frontends/s5h1420.c
index d83d20a..2322257 100644
--- a/drivers/media/dvb/frontends/s5h1420.c
+++ b/drivers/media/dvb/frontends/s5h1420.c
@@ -940,7 +940,6 @@ static struct dvb_frontend_ops s5h1420_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name     = "Samsung S5H1420/PnpNetwork PN1010 DVB-S",
-		.type     = FE_QPSK,
 		.frequency_min    = 950000,
 		.frequency_max    = 2150000,
 		.frequency_stepsize = 125,     /* kHz for QPSK frontends */
diff --git a/drivers/media/dvb/frontends/s5h1432.c b/drivers/media/dvb/frontends/s5h1432.c
index baa3aae..8352ce1 100644
--- a/drivers/media/dvb/frontends/s5h1432.c
+++ b/drivers/media/dvb/frontends/s5h1432.c
@@ -378,7 +378,6 @@ static struct dvb_frontend_ops s5h1432_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		 .name = "Samsung s5h1432 DVB-T Frontend",
-		 .type = FE_OFDM,
 		 .frequency_min = 177000000,
 		 .frequency_max = 858000000,
 		 .frequency_stepsize = 166666,
diff --git a/drivers/media/dvb/frontends/s921.c b/drivers/media/dvb/frontends/s921.c
index 6012e10..cd2288c 100644
--- a/drivers/media/dvb/frontends/s921.c
+++ b/drivers/media/dvb/frontends/s921.c
@@ -515,7 +515,6 @@ static struct dvb_frontend_ops s921_ops = {
 	/* Use dib8000 values per default */
 	.info = {
 		.name = "Sharp S921",
-		.type = FE_OFDM,
 		.frequency_min = 470000000,
 		/*
 		 * Max should be 770MHz instead, according with Sharp docs,
diff --git a/drivers/media/dvb/frontends/si21xx.c b/drivers/media/dvb/frontends/si21xx.c
index e223f35..a68a648 100644
--- a/drivers/media/dvb/frontends/si21xx.c
+++ b/drivers/media/dvb/frontends/si21xx.c
@@ -867,7 +867,6 @@ static struct dvb_frontend_ops si21xx_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "SL SI21XX DVB-S",
-		.type			= FE_QPSK,
 		.frequency_min		= 950000,
 		.frequency_max		= 2150000,
 		.frequency_stepsize	= 125,	 /* kHz for QPSK frontends */
diff --git a/drivers/media/dvb/frontends/sp8870.c b/drivers/media/dvb/frontends/sp8870.c
index 58e4792..e37274c 100644
--- a/drivers/media/dvb/frontends/sp8870.c
+++ b/drivers/media/dvb/frontends/sp8870.c
@@ -584,7 +584,6 @@ static struct dvb_frontend_ops sp8870_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Spase SP8870 DVB-T",
-		.type			= FE_OFDM,
 		.frequency_min		= 470000000,
 		.frequency_max		= 860000000,
 		.frequency_stepsize	= 166666,
diff --git a/drivers/media/dvb/frontends/sp887x.c b/drivers/media/dvb/frontends/sp887x.c
index 6fd8513..f4096cc 100644
--- a/drivers/media/dvb/frontends/sp887x.c
+++ b/drivers/media/dvb/frontends/sp887x.c
@@ -595,7 +595,6 @@ static struct dvb_frontend_ops sp887x_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "Spase SP887x DVB-T",
-		.type = FE_OFDM,
 		.frequency_min =  50500000,
 		.frequency_max = 858000000,
 		.frequency_stepsize = 166666,
diff --git a/drivers/media/dvb/frontends/stb0899_drv.c b/drivers/media/dvb/frontends/stb0899_drv.c
index c9e1785..38565be 100644
--- a/drivers/media/dvb/frontends/stb0899_drv.c
+++ b/drivers/media/dvb/frontends/stb0899_drv.c
@@ -1586,26 +1586,10 @@ static enum dvbfe_algo stb0899_frontend_algo(struct dvb_frontend *fe)
 	return DVBFE_ALGO_CUSTOM;
 }
 
-static int stb0899_get_property(struct dvb_frontend *fe, struct dtv_property *p)
-{
-	switch (p->cmd) {
-	case DTV_ENUM_DELSYS:
-		p->u.buffer.data[0] = SYS_DSS;
-		p->u.buffer.data[1] = SYS_DVBS;
-		p->u.buffer.data[2] = SYS_DVBS2;
-		p->u.buffer.len = 3;
-		break;
-	default:
-		break;
-	}
-	return 0;
-}
-
 static struct dvb_frontend_ops stb0899_ops = {
-
+	.delsys = { SYS_DVBS, SYS_DVBS2, SYS_DSS },
 	.info = {
 		.name 			= "STB0899 Multistandard",
-		.type 			= FE_QPSK,
 		.frequency_min		= 950000,
 		.frequency_max 		= 2150000,
 		.frequency_stepsize	= 0,
@@ -1642,8 +1626,6 @@ static struct dvb_frontend_ops stb0899_ops = {
 	.diseqc_send_master_cmd		= stb0899_send_diseqc_msg,
 	.diseqc_recv_slave_reply	= stb0899_recv_slave_reply,
 	.diseqc_send_burst		= stb0899_send_diseqc_burst,
-
-	.get_property			= stb0899_get_property,
 };
 
 struct dvb_frontend *stb0899_attach(struct stb0899_config *config, struct i2c_adapter *i2c)
diff --git a/drivers/media/dvb/frontends/stv0288.c b/drivers/media/dvb/frontends/stv0288.c
index b0ddebc..fb5548a 100644
--- a/drivers/media/dvb/frontends/stv0288.c
+++ b/drivers/media/dvb/frontends/stv0288.c
@@ -452,12 +452,6 @@ static int stv0288_set_property(struct dvb_frontend *fe, struct dtv_property *p)
 	return 0;
 }
 
-static int stv0288_get_property(struct dvb_frontend *fe, struct dtv_property *p)
-{
-	dprintk("%s(..)\n", __func__);
-	return 0;
-}
-
 static int stv0288_set_frontend(struct dvb_frontend *fe)
 {
 	struct stv0288_state *state = fe->demodulator_priv;
@@ -545,7 +539,6 @@ static struct dvb_frontend_ops stv0288_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "ST STV0288 DVB-S",
-		.type			= FE_QPSK,
 		.frequency_min		= 950000,
 		.frequency_max		= 2150000,
 		.frequency_stepsize	= 1000,	 /* kHz for QPSK frontends */
@@ -575,7 +568,6 @@ static struct dvb_frontend_ops stv0288_ops = {
 	.set_voltage = stv0288_set_voltage,
 
 	.set_property = stv0288_set_property,
-	.get_property = stv0288_get_property,
 	.set_frontend = stv0288_set_frontend,
 };
 
diff --git a/drivers/media/dvb/frontends/stv0297.c b/drivers/media/dvb/frontends/stv0297.c
index 8e5bd69..85c157a 100644
--- a/drivers/media/dvb/frontends/stv0297.c
+++ b/drivers/media/dvb/frontends/stv0297.c
@@ -693,7 +693,6 @@ static struct dvb_frontend_ops stv0297_ops = {
 	.delsys = { SYS_DVBC_ANNEX_A },
 	.info = {
 		 .name = "ST STV0297 DVB-C",
-		 .type = FE_QAM,
 		 .frequency_min = 47000000,
 		 .frequency_max = 862000000,
 		 .frequency_stepsize = 62500,
diff --git a/drivers/media/dvb/frontends/stv0299.c b/drivers/media/dvb/frontends/stv0299.c
index a7abc82..057b5f8 100644
--- a/drivers/media/dvb/frontends/stv0299.c
+++ b/drivers/media/dvb/frontends/stv0299.c
@@ -711,7 +711,6 @@ static struct dvb_frontend_ops stv0299_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "ST STV0299 DVB-S",
-		.type			= FE_QPSK,
 		.frequency_min		= 950000,
 		.frequency_max		= 2150000,
 		.frequency_stepsize	= 125,	 /* kHz for QPSK frontends */
diff --git a/drivers/media/dvb/frontends/stv0367.c b/drivers/media/dvb/frontends/stv0367.c
index 6786b9e..fdd20c7 100644
--- a/drivers/media/dvb/frontends/stv0367.c
+++ b/drivers/media/dvb/frontends/stv0367.c
@@ -2265,7 +2265,6 @@ static struct dvb_frontend_ops stv0367ter_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "ST STV0367 DVB-T",
-		.type			= FE_OFDM,
 		.frequency_min		= 47000000,
 		.frequency_max		= 862000000,
 		.frequency_stepsize	= 15625,
@@ -3384,7 +3383,6 @@ static struct dvb_frontend_ops stv0367cab_ops = {
 	.delsys = { SYS_DVBC_ANNEX_A },
 	.info = {
 		.name = "ST STV0367 DVB-C",
-		.type = FE_QAM,
 		.frequency_min = 47000000,
 		.frequency_max = 862000000,
 		.frequency_stepsize = 62500,
diff --git a/drivers/media/dvb/frontends/stv0900_core.c b/drivers/media/dvb/frontends/stv0900_core.c
index 33325ae..7f1bada 100644
--- a/drivers/media/dvb/frontends/stv0900_core.c
+++ b/drivers/media/dvb/frontends/stv0900_core.c
@@ -1860,7 +1860,6 @@ static struct dvb_frontend_ops stv0900_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2, SYS_DSS },
 	.info = {
 		.name			= "STV0900 frontend",
-		.type			= FE_QPSK,
 		.frequency_min		= 950000,
 		.frequency_max		= 2150000,
 		.frequency_stepsize	= 125,
diff --git a/drivers/media/dvb/frontends/stv090x.c b/drivers/media/dvb/frontends/stv090x.c
index dd8ded5..4aef187 100644
--- a/drivers/media/dvb/frontends/stv090x.c
+++ b/drivers/media/dvb/frontends/stv090x.c
@@ -4715,7 +4715,6 @@ static struct dvb_frontend_ops stv090x_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2, SYS_DSS },
 	.info = {
 		.name			= "STV090x Multistandard",
-		.type			= FE_QPSK,
 		.frequency_min		= 950000,
 		.frequency_max 		= 2150000,
 		.frequency_stepsize	= 0,
diff --git a/drivers/media/dvb/frontends/tda10021.c b/drivers/media/dvb/frontends/tda10021.c
index a330831..1bff7f4 100644
--- a/drivers/media/dvb/frontends/tda10021.c
+++ b/drivers/media/dvb/frontends/tda10021.c
@@ -487,7 +487,6 @@ static struct dvb_frontend_ops tda10021_ops = {
 	.delsys = { SYS_DVBC_ANNEX_A, SYS_DVBC_ANNEX_C },
 	.info = {
 		.name = "Philips TDA10021 DVB-C",
-		.type = FE_QAM,
 		.frequency_stepsize = 62500,
 		.frequency_min = 47000000,
 		.frequency_max = 862000000,
diff --git a/drivers/media/dvb/frontends/tda10023.c b/drivers/media/dvb/frontends/tda10023.c
index d0b8e86..ca1e0d5 100644
--- a/drivers/media/dvb/frontends/tda10023.c
+++ b/drivers/media/dvb/frontends/tda10023.c
@@ -576,7 +576,6 @@ static struct dvb_frontend_ops tda10023_ops = {
 	.delsys = { SYS_DVBC_ANNEX_A, SYS_DVBC_ANNEX_C },
 	.info = {
 		.name = "Philips TDA10023 DVB-C",
-		.type = FE_QAM,
 		.frequency_stepsize = 62500,
 		.frequency_min =  47000000,
 		.frequency_max = 862000000,
diff --git a/drivers/media/dvb/frontends/tda10048.c b/drivers/media/dvb/frontends/tda10048.c
index 57711cb..71fb632 100644
--- a/drivers/media/dvb/frontends/tda10048.c
+++ b/drivers/media/dvb/frontends/tda10048.c
@@ -1160,7 +1160,6 @@ static struct dvb_frontend_ops tda10048_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "NXP TDA10048HN DVB-T",
-		.type			= FE_OFDM,
 		.frequency_min		= 177000000,
 		.frequency_max		= 858000000,
 		.frequency_stepsize	= 166666,
diff --git a/drivers/media/dvb/frontends/tda1004x.c b/drivers/media/dvb/frontends/tda1004x.c
index bbab4a1..ae6f22a 100644
--- a/drivers/media/dvb/frontends/tda1004x.c
+++ b/drivers/media/dvb/frontends/tda1004x.c
@@ -1235,7 +1235,6 @@ static struct dvb_frontend_ops tda10045_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "Philips TDA10045H DVB-T",
-		.type = FE_OFDM,
 		.frequency_min = 51000000,
 		.frequency_max = 858000000,
 		.frequency_stepsize = 166667,
@@ -1306,7 +1305,6 @@ static struct dvb_frontend_ops tda10046_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "Philips TDA10046H DVB-T",
-		.type = FE_OFDM,
 		.frequency_min = 51000000,
 		.frequency_max = 858000000,
 		.frequency_stepsize = 166667,
diff --git a/drivers/media/dvb/frontends/tda10071.c b/drivers/media/dvb/frontends/tda10071.c
index 54e2aa0..a992050 100644
--- a/drivers/media/dvb/frontends/tda10071.c
+++ b/drivers/media/dvb/frontends/tda10071.c
@@ -1218,7 +1218,6 @@ static struct dvb_frontend_ops tda10071_ops = {
 	.delsys = { SYS_DVBT, SYS_DVBT2 },
 	.info = {
 		.name = "NXP TDA10071",
-		.type = FE_QPSK,
 		.frequency_min = 950000,
 		.frequency_max = 2150000,
 		.frequency_tolerance = 5000,
diff --git a/drivers/media/dvb/frontends/tda10086.c b/drivers/media/dvb/frontends/tda10086.c
index e0d2fc1..fcfe2e0 100644
--- a/drivers/media/dvb/frontends/tda10086.c
+++ b/drivers/media/dvb/frontends/tda10086.c
@@ -707,7 +707,6 @@ static struct dvb_frontend_ops tda10086_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name     = "Philips TDA10086 DVB-S",
-		.type     = FE_QPSK,
 		.frequency_min    = 950000,
 		.frequency_max    = 2150000,
 		.frequency_stepsize = 125,     /* kHz for QPSK frontends */
diff --git a/drivers/media/dvb/frontends/tda8083.c b/drivers/media/dvb/frontends/tda8083.c
index b613dfc..15912c9 100644
--- a/drivers/media/dvb/frontends/tda8083.c
+++ b/drivers/media/dvb/frontends/tda8083.c
@@ -443,7 +443,6 @@ static struct dvb_frontend_ops tda8083_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "Philips TDA8083 DVB-S",
-		.type			= FE_QPSK,
 		.frequency_min		= 920000,     /* TDA8060 */
 		.frequency_max		= 2200000,    /* TDA8060 */
 		.frequency_stepsize	= 125,   /* kHz for QPSK frontends */
diff --git a/drivers/media/dvb/frontends/ves1820.c b/drivers/media/dvb/frontends/ves1820.c
index e85a823..bb42b56 100644
--- a/drivers/media/dvb/frontends/ves1820.c
+++ b/drivers/media/dvb/frontends/ves1820.c
@@ -410,7 +410,6 @@ static struct dvb_frontend_ops ves1820_ops = {
 	.delsys = { SYS_DVBC_ANNEX_A },
 	.info = {
 		.name = "VLSI VES1820 DVB-C",
-		.type = FE_QAM,
 		.frequency_stepsize = 62500,
 		.frequency_min = 47000000,
 		.frequency_max = 862000000,
diff --git a/drivers/media/dvb/frontends/ves1x93.c b/drivers/media/dvb/frontends/ves1x93.c
index 0ccd851..9c17eac 100644
--- a/drivers/media/dvb/frontends/ves1x93.c
+++ b/drivers/media/dvb/frontends/ves1x93.c
@@ -513,7 +513,6 @@ static struct dvb_frontend_ops ves1x93_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "VLSI VES1x93 DVB-S",
-		.type			= FE_QPSK,
 		.frequency_min		= 950000,
 		.frequency_max		= 2150000,
 		.frequency_stepsize	= 125,		 /* kHz for QPSK frontends */
diff --git a/drivers/media/dvb/frontends/zl10353.c b/drivers/media/dvb/frontends/zl10353.c
index 816fa86..ac72378 100644
--- a/drivers/media/dvb/frontends/zl10353.c
+++ b/drivers/media/dvb/frontends/zl10353.c
@@ -641,7 +641,6 @@ static struct dvb_frontend_ops zl10353_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Zarlink ZL10353 DVB-T",
-		.type			= FE_OFDM,
 		.frequency_min		= 174000000,
 		.frequency_max		= 862000000,
 		.frequency_stepsize	= 166667,
diff --git a/drivers/media/dvb/pt1/va1j5jf8007s.c b/drivers/media/dvb/pt1/va1j5jf8007s.c
index ef74440..d980dfb 100644
--- a/drivers/media/dvb/pt1/va1j5jf8007s.c
+++ b/drivers/media/dvb/pt1/va1j5jf8007s.c
@@ -582,7 +582,6 @@ static struct dvb_frontend_ops va1j5jf8007s_ops = {
 	.delsys = { SYS_ISDBS },
 	.info = {
 		.name = "VA1J5JF8007/VA1J5JF8011 ISDB-S",
-		.type = FE_QPSK,
 		.frequency_min = 950000,
 		.frequency_max = 2150000,
 		.frequency_stepsize = 1000,
diff --git a/drivers/media/dvb/pt1/va1j5jf8007t.c b/drivers/media/dvb/pt1/va1j5jf8007t.c
index 6eeabc8..2db15159 100644
--- a/drivers/media/dvb/pt1/va1j5jf8007t.c
+++ b/drivers/media/dvb/pt1/va1j5jf8007t.c
@@ -431,7 +431,6 @@ static struct dvb_frontend_ops va1j5jf8007t_ops = {
 	.delsys = { SYS_ISDBT },
 	.info = {
 		.name = "VA1J5JF8007/VA1J5JF8011 ISDB-T",
-		.type = FE_OFDM,
 		.frequency_min = 90000000,
 		.frequency_max = 770000000,
 		.frequency_stepsize = 142857,
diff --git a/drivers/media/dvb/siano/smsdvb.c b/drivers/media/dvb/siano/smsdvb.c
index 198cc0e..654685c 100644
--- a/drivers/media/dvb/siano/smsdvb.c
+++ b/drivers/media/dvb/siano/smsdvb.c
@@ -786,7 +786,6 @@ static void smsdvb_release(struct dvb_frontend *fe)
 static struct dvb_frontend_ops smsdvb_fe_ops = {
 	.info = {
 		.name			= "Siano Mobile Digital MDTV Receiver",
-		.type			= FE_OFDM,
 		.frequency_min		= 44250000,
 		.frequency_max		= 867250000,
 		.frequency_stepsize	= 250000,
diff --git a/drivers/media/dvb/ttusb-dec/ttusbdecfe.c b/drivers/media/dvb/ttusb-dec/ttusbdecfe.c
index a498f5a..5c45c9d 100644
--- a/drivers/media/dvb/ttusb-dec/ttusbdecfe.c
+++ b/drivers/media/dvb/ttusb-dec/ttusbdecfe.c
@@ -246,7 +246,6 @@ static struct dvb_frontend_ops ttusbdecfe_dvbt_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "TechnoTrend/Hauppauge DEC2000-t Frontend",
-		.type			= FE_OFDM,
 		.frequency_min		= 51000000,
 		.frequency_max		= 858000000,
 		.frequency_stepsize	= 62500,
@@ -270,7 +269,6 @@ static struct dvb_frontend_ops ttusbdecfe_dvbs_ops = {
 	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "TechnoTrend/Hauppauge DEC3000-s Frontend",
-		.type			= FE_QPSK,
 		.frequency_min		= 950000,
 		.frequency_max		= 2150000,
 		.frequency_stepsize	= 125,
diff --git a/drivers/media/video/tlg2300/pd-dvb.c b/drivers/media/video/tlg2300/pd-dvb.c
index d7aac42..30fcb11 100644
--- a/drivers/media/video/tlg2300/pd-dvb.c
+++ b/drivers/media/video/tlg2300/pd-dvb.c
@@ -335,7 +335,6 @@ static struct dvb_frontend_ops poseidon_frontend_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
 		.name		= "Poseidon DVB-T",
-		.type		= FE_OFDM,
 		.frequency_min	= 174000000,
 		.frequency_max  = 862000000,
 		.frequency_stepsize	  = 62500,/* FIXME */
-- 
1.7.8.352.g876a6

