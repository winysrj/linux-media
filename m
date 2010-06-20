Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:58330 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755875Ab0FTRaL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Jun 2010 13:30:11 -0400
From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>, stable@kernel.org
Subject: [PATCH] V4L/DVB: mantis: use dvb_attach to avoid double dereferencing on module removal
Date: Sun, 20 Jun 2010 19:14:05 +0200
Message-Id: <1277054045-13518-1-git-send-email-bjorn@mork.no>
In-Reply-To: <87r5k1bpdr.fsf@nemi.mork.no>
References: <87r5k1bpdr.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert the driver to use the dvb_attach macro to avoid the hard dependency
on the frontend drivers.  The hard dependecy will result in loading a
number of unused frontends, and unwanted automatic dereferencing.

This fixes a bug where unloading the mantis driver will derefence any
attached frontend twice, which will cause an oops if the same frontend is
used by another driver.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Cc: stable@kernel.org
---
 drivers/media/dvb/mantis/hopper_vp3028.c |    2 +-
 drivers/media/dvb/mantis/mantis_vp1033.c |    2 +-
 drivers/media/dvb/mantis/mantis_vp1034.c |    2 +-
 drivers/media/dvb/mantis/mantis_vp1041.c |    6 +++---
 drivers/media/dvb/mantis/mantis_vp2033.c |    4 ++--
 drivers/media/dvb/mantis/mantis_vp2040.c |    4 ++--
 drivers/media/dvb/mantis/mantis_vp3030.c |    4 ++--
 7 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb/mantis/hopper_vp3028.c b/drivers/media/dvb/mantis/hopper_vp3028.c
index 96674c7..567ed24 100644
--- a/drivers/media/dvb/mantis/hopper_vp3028.c
+++ b/drivers/media/dvb/mantis/hopper_vp3028.c
@@ -57,7 +57,7 @@ static int vp3028_frontend_init(struct mantis_pci *mantis, struct dvb_frontend *
 	if (err == 0) {
 		msleep(250);
 		dprintk(MANTIS_ERROR, 1, "Probing for 10353 (DVB-T)");
-		fe = zl10353_attach(&hopper_vp3028_config, adapter);
+		fe = dvb_attach(zl10353_attach, &hopper_vp3028_config, adapter);
 
 		if (!fe)
 			return -1;
diff --git a/drivers/media/dvb/mantis/mantis_vp1033.c b/drivers/media/dvb/mantis/mantis_vp1033.c
index 4a723bd..deec927 100644
--- a/drivers/media/dvb/mantis/mantis_vp1033.c
+++ b/drivers/media/dvb/mantis/mantis_vp1033.c
@@ -173,7 +173,7 @@ static int vp1033_frontend_init(struct mantis_pci *mantis, struct dvb_frontend *
 		msleep(250);
 
 		dprintk(MANTIS_ERROR, 1, "Probing for STV0299 (DVB-S)");
-		fe = stv0299_attach(&lgtdqcs001f_config, adapter);
+		fe = dvb_attach(stv0299_attach, &lgtdqcs001f_config, adapter);
 
 		if (fe) {
 			fe->ops.tuner_ops.set_params = lgtdqcs001f_tuner_set;
diff --git a/drivers/media/dvb/mantis/mantis_vp1034.c b/drivers/media/dvb/mantis/mantis_vp1034.c
index 8e6ae55..bf62338 100644
--- a/drivers/media/dvb/mantis/mantis_vp1034.c
+++ b/drivers/media/dvb/mantis/mantis_vp1034.c
@@ -82,7 +82,7 @@ static int vp1034_frontend_init(struct mantis_pci *mantis, struct dvb_frontend *
 		msleep(250);
 
 		dprintk(MANTIS_ERROR, 1, "Probing for MB86A16 (DVB-S/DSS)");
-		fe = mb86a16_attach(&vp1034_mb86a16_config, adapter);
+		fe = dvb_attach(mb86a16_attach, &vp1034_mb86a16_config, adapter);
 		if (fe) {
 			dprintk(MANTIS_ERROR, 1,
 			"found MB86A16 DVB-S/DSS frontend @0x%02x",
diff --git a/drivers/media/dvb/mantis/mantis_vp1041.c b/drivers/media/dvb/mantis/mantis_vp1041.c
index d1aa2bc..38a436c 100644
--- a/drivers/media/dvb/mantis/mantis_vp1041.c
+++ b/drivers/media/dvb/mantis/mantis_vp1041.c
@@ -316,14 +316,14 @@ static int vp1041_frontend_init(struct mantis_pci *mantis, struct dvb_frontend *
 	if (err == 0) {
 		mantis_frontend_soft_reset(mantis);
 		msleep(250);
-		mantis->fe = stb0899_attach(&vp1041_stb0899_config, adapter);
+		mantis->fe = dvb_attach(stb0899_attach, &vp1041_stb0899_config, adapter);
 		if (mantis->fe) {
 			dprintk(MANTIS_ERROR, 1,
 				"found STB0899 DVB-S/DVB-S2 frontend @0x%02x",
 				vp1041_stb0899_config.demod_address);
 
-			if (stb6100_attach(mantis->fe, &vp1041_stb6100_config, adapter)) {
-				if (!lnbp21_attach(mantis->fe, adapter, 0, 0))
+			if (dvb_attach(stb6100_attach, mantis->fe, &vp1041_stb6100_config, adapter)) {
+				if (!dvb_attach(lnbp21_attach, mantis->fe, adapter, 0, 0))
 					dprintk(MANTIS_ERROR, 1, "No LNBP21 found!");
 			}
 		} else {
diff --git a/drivers/media/dvb/mantis/mantis_vp2033.c b/drivers/media/dvb/mantis/mantis_vp2033.c
index 10ce817..06da0dd 100644
--- a/drivers/media/dvb/mantis/mantis_vp2033.c
+++ b/drivers/media/dvb/mantis/mantis_vp2033.c
@@ -132,7 +132,7 @@ static int vp2033_frontend_init(struct mantis_pci *mantis, struct dvb_frontend *
 		msleep(250);
 
 		dprintk(MANTIS_ERROR, 1, "Probing for CU1216 (DVB-C)");
-		fe = tda10021_attach(&vp2033_tda1002x_cu1216_config,
+		fe = dvb_attach(tda10021_attach, &vp2033_tda1002x_cu1216_config,
 				     adapter,
 				     read_pwm(mantis));
 
@@ -141,7 +141,7 @@ static int vp2033_frontend_init(struct mantis_pci *mantis, struct dvb_frontend *
 				"found Philips CU1216 DVB-C frontend (TDA10021) @ 0x%02x",
 				vp2033_tda1002x_cu1216_config.demod_address);
 		} else {
-			fe = tda10023_attach(&vp2033_tda10023_cu1216_config,
+			fe = dvb_attach(tda10023_attach, &vp2033_tda10023_cu1216_config,
 					     adapter,
 					     read_pwm(mantis));
 
diff --git a/drivers/media/dvb/mantis/mantis_vp2040.c b/drivers/media/dvb/mantis/mantis_vp2040.c
index a7ca233..f72b137 100644
--- a/drivers/media/dvb/mantis/mantis_vp2040.c
+++ b/drivers/media/dvb/mantis/mantis_vp2040.c
@@ -132,7 +132,7 @@ static int vp2040_frontend_init(struct mantis_pci *mantis, struct dvb_frontend *
 		msleep(250);
 
 		dprintk(MANTIS_ERROR, 1, "Probing for CU1216 (DVB-C)");
-		fe = tda10021_attach(&vp2040_tda1002x_cu1216_config,
+		fe = dvb_attach(tda10021_attach, &vp2040_tda1002x_cu1216_config,
 				     adapter,
 				     read_pwm(mantis));
 
@@ -141,7 +141,7 @@ static int vp2040_frontend_init(struct mantis_pci *mantis, struct dvb_frontend *
 				"found Philips CU1216 DVB-C frontend (TDA10021) @ 0x%02x",
 				vp2040_tda1002x_cu1216_config.demod_address);
 		} else {
-			fe = tda10023_attach(&vp2040_tda10023_cu1216_config,
+			fe = dvb_attach(tda10023_attach, &vp2040_tda10023_cu1216_config,
 					     adapter,
 					     read_pwm(mantis));
 
diff --git a/drivers/media/dvb/mantis/mantis_vp3030.c b/drivers/media/dvb/mantis/mantis_vp3030.c
index 1f43342..be4d87c 100644
--- a/drivers/media/dvb/mantis/mantis_vp3030.c
+++ b/drivers/media/dvb/mantis/mantis_vp3030.c
@@ -68,12 +68,12 @@ static int vp3030_frontend_init(struct mantis_pci *mantis, struct dvb_frontend *
 	if (err == 0) {
 		msleep(250);
 		dprintk(MANTIS_ERROR, 1, "Probing for 10353 (DVB-T)");
-		fe = zl10353_attach(&mantis_vp3030_config, adapter);
+		fe = dvb_attach(zl10353_attach, &mantis_vp3030_config, adapter);
 
 		if (!fe)
 			return -1;
 
-		tda665x_attach(fe, &env57h12d5_config, adapter);
+		dvb_attach(tda665x_attach, fe, &env57h12d5_config, adapter);
 	} else {
 		dprintk(MANTIS_ERROR, 1, "Frontend on <%s> POWER ON failed! <%d>",
 			adapter->name,
-- 
1.7.1

