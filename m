Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab1L3PJV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:21 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9LWm024137
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:21 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 02/94] [media] Rename set_frontend fops to set_frontend_legacy
Date: Fri, 30 Dec 2011 13:06:59 -0200
Message-Id: <1325257711-12274-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Passing DVBv3 parameters to set_frontend is not fun, as the
core doesn't have any way to know if the driver is using the
v3 or v5 parameters. So, rename the callback and add a new
one to allow distinguish between a mixed v3/v5 paramenter call
from a pure v5 call.

After having all frontends to use the new way, the legacy
call can be removed.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/bt8xx/dst.c               |    8 ++++----
 drivers/media/dvb/dvb-core/dvb_frontend.c   |    8 ++++++--
 drivers/media/dvb/dvb-core/dvb_frontend.h   |    3 ++-
 drivers/media/dvb/dvb-usb/af9005-fe.c       |    2 +-
 drivers/media/dvb/dvb-usb/cinergyT2-fe.c    |    2 +-
 drivers/media/dvb/dvb-usb/dtt200u-fe.c      |    2 +-
 drivers/media/dvb/dvb-usb/friio-fe.c        |    2 +-
 drivers/media/dvb/dvb-usb/gp8psk-fe.c       |    2 +-
 drivers/media/dvb/dvb-usb/mxl111sf-demod.c  |    2 +-
 drivers/media/dvb/dvb-usb/vp702x-fe.c       |    2 +-
 drivers/media/dvb/dvb-usb/vp7045-fe.c       |    2 +-
 drivers/media/dvb/firewire/firedtv-fe.c     |    2 +-
 drivers/media/dvb/frontends/af9013.c        |    2 +-
 drivers/media/dvb/frontends/atbm8830.c      |    2 +-
 drivers/media/dvb/frontends/au8522_dig.c    |    2 +-
 drivers/media/dvb/frontends/bcm3510.c       |    2 +-
 drivers/media/dvb/frontends/cx22700.c       |    2 +-
 drivers/media/dvb/frontends/cx22702.c       |    2 +-
 drivers/media/dvb/frontends/cx24110.c       |    2 +-
 drivers/media/dvb/frontends/cx24116.c       |    2 +-
 drivers/media/dvb/frontends/cx24123.c       |    2 +-
 drivers/media/dvb/frontends/cxd2820r_core.c |    2 +-
 drivers/media/dvb/frontends/dib3000mb.c     |    2 +-
 drivers/media/dvb/frontends/dib3000mc.c     |    2 +-
 drivers/media/dvb/frontends/dib7000m.c      |    2 +-
 drivers/media/dvb/frontends/dib7000p.c      |    2 +-
 drivers/media/dvb/frontends/dib8000.c       |    2 +-
 drivers/media/dvb/frontends/dib9000.c       |    2 +-
 drivers/media/dvb/frontends/drxd_hard.c     |    2 +-
 drivers/media/dvb/frontends/drxk_hard.c     |    4 ++--
 drivers/media/dvb/frontends/ds3000.c        |    2 +-
 drivers/media/dvb/frontends/dvb_dummy_fe.c  |    6 +++---
 drivers/media/dvb/frontends/ec100.c         |    2 +-
 drivers/media/dvb/frontends/it913x-fe.c     |    2 +-
 drivers/media/dvb/frontends/l64781.c        |    2 +-
 drivers/media/dvb/frontends/lgdt3305.c      |    4 ++--
 drivers/media/dvb/frontends/lgdt330x.c      |    4 ++--
 drivers/media/dvb/frontends/lgs8gl5.c       |    2 +-
 drivers/media/dvb/frontends/lgs8gxx.c       |    2 +-
 drivers/media/dvb/frontends/mb86a20s.c      |    2 +-
 drivers/media/dvb/frontends/mt312.c         |    2 +-
 drivers/media/dvb/frontends/mt352.c         |    2 +-
 drivers/media/dvb/frontends/nxt200x.c       |    2 +-
 drivers/media/dvb/frontends/nxt6000.c       |    2 +-
 drivers/media/dvb/frontends/or51132.c       |    2 +-
 drivers/media/dvb/frontends/or51211.c       |    2 +-
 drivers/media/dvb/frontends/s5h1409.c       |    2 +-
 drivers/media/dvb/frontends/s5h1411.c       |    2 +-
 drivers/media/dvb/frontends/s5h1420.c       |    2 +-
 drivers/media/dvb/frontends/s5h1432.c       |    2 +-
 drivers/media/dvb/frontends/s921.c          |    2 +-
 drivers/media/dvb/frontends/si21xx.c        |    2 +-
 drivers/media/dvb/frontends/sp8870.c        |    2 +-
 drivers/media/dvb/frontends/sp887x.c        |    2 +-
 drivers/media/dvb/frontends/stv0288.c       |    2 +-
 drivers/media/dvb/frontends/stv0297.c       |    2 +-
 drivers/media/dvb/frontends/stv0299.c       |    2 +-
 drivers/media/dvb/frontends/stv0367.c       |    4 ++--
 drivers/media/dvb/frontends/tda10021.c      |    2 +-
 drivers/media/dvb/frontends/tda10023.c      |    2 +-
 drivers/media/dvb/frontends/tda10048.c      |    2 +-
 drivers/media/dvb/frontends/tda1004x.c      |    4 ++--
 drivers/media/dvb/frontends/tda10071.c      |    2 +-
 drivers/media/dvb/frontends/tda10086.c      |    2 +-
 drivers/media/dvb/frontends/tda8083.c       |    2 +-
 drivers/media/dvb/frontends/ves1820.c       |    2 +-
 drivers/media/dvb/frontends/ves1x93.c       |    2 +-
 drivers/media/dvb/frontends/zl10353.c       |    2 +-
 drivers/media/dvb/siano/smsdvb.c            |    2 +-
 drivers/media/dvb/ttpci/av7110.c            |    2 +-
 drivers/media/dvb/ttusb-dec/ttusbdecfe.c    |    4 ++--
 drivers/media/video/tlg2300/pd-dvb.c        |    2 +-
 drivers/staging/media/as102/as102_fe.c      |    2 +-
 73 files changed, 90 insertions(+), 85 deletions(-)

diff --git a/drivers/media/dvb/bt8xx/dst.c b/drivers/media/dvb/bt8xx/dst.c
index caa4e18..4658bd6 100644
--- a/drivers/media/dvb/bt8xx/dst.c
+++ b/drivers/media/dvb/bt8xx/dst.c
@@ -1777,7 +1777,7 @@ static struct dvb_frontend_ops dst_dvbt_ops = {
 	.release = dst_release,
 	.init = dst_init,
 	.tune = dst_tune_frontend,
-	.set_frontend = dst_set_frontend,
+	.set_frontend_legacy = dst_set_frontend,
 	.get_frontend = dst_get_frontend,
 	.get_frontend_algo = dst_get_tuning_algo,
 	.read_status = dst_read_status,
@@ -1803,7 +1803,7 @@ static struct dvb_frontend_ops dst_dvbs_ops = {
 	.release = dst_release,
 	.init = dst_init,
 	.tune = dst_tune_frontend,
-	.set_frontend = dst_set_frontend,
+	.set_frontend_legacy = dst_set_frontend,
 	.get_frontend = dst_get_frontend,
 	.get_frontend_algo = dst_get_tuning_algo,
 	.read_status = dst_read_status,
@@ -1837,7 +1837,7 @@ static struct dvb_frontend_ops dst_dvbc_ops = {
 	.release = dst_release,
 	.init = dst_init,
 	.tune = dst_tune_frontend,
-	.set_frontend = dst_set_frontend,
+	.set_frontend_legacy = dst_set_frontend,
 	.get_frontend = dst_get_frontend,
 	.get_frontend_algo = dst_get_tuning_algo,
 	.read_status = dst_read_status,
@@ -1860,7 +1860,7 @@ static struct dvb_frontend_ops dst_atsc_ops = {
 	.release = dst_release,
 	.init = dst_init,
 	.tune = dst_tune_frontend,
-	.set_frontend = dst_set_frontend,
+	.set_frontend_legacy = dst_set_frontend,
 	.get_frontend = dst_get_frontend,
 	.get_frontend_algo = dst_get_tuning_algo,
 	.read_status = dst_read_status,
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index f17c411..eca6170 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -352,7 +352,9 @@ static int dvb_frontend_swzigzag_autotune(struct dvb_frontend *fe, int check_wra
 	if (autoinversion)
 		fepriv->parameters_in.inversion = fepriv->inversion;
 	if (fe->ops.set_frontend)
-		fe_set_err = fe->ops.set_frontend(fe, &fepriv->parameters_in);
+		fe_set_err = fe->ops.set_frontend(fe);
+	else if (fe->ops.set_frontend_legacy)
+		fe_set_err = fe->ops.set_frontend_legacy(fe, &fepriv->parameters_in);
 	fepriv->parameters_out = fepriv->parameters_in;
 	if (fe_set_err < 0) {
 		fepriv->state = FESTATE_ERROR;
@@ -383,7 +385,9 @@ static void dvb_frontend_swzigzag(struct dvb_frontend *fe)
 	if (fepriv->tune_mode_flags & FE_TUNE_MODE_ONESHOT) {
 		if (fepriv->state & FESTATE_RETUNE) {
 			if (fe->ops.set_frontend)
-				retval = fe->ops.set_frontend(fe,
+				retval = fe->ops.set_frontend(fe);
+			else if (fe->ops.set_frontend_legacy)
+				retval = fe->ops.set_frontend_legacy(fe,
 							&fepriv->parameters_in);
 			fepriv->parameters_out = fepriv->parameters_in;
 			if (retval < 0)
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index 95f2134..dd44964 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -280,7 +280,8 @@ struct dvb_frontend_ops {
 	enum dvbfe_algo (*get_frontend_algo)(struct dvb_frontend *fe);
 
 	/* these two are only used for the swzigzag code */
-	int (*set_frontend)(struct dvb_frontend* fe, struct dvb_frontend_parameters* params);
+	int (*set_frontend_legacy)(struct dvb_frontend* fe, struct dvb_frontend_parameters* params);
+	int (*set_frontend)(struct dvb_frontend* fe);
 	int (*get_tune_settings)(struct dvb_frontend* fe, struct dvb_frontend_tune_settings* settings);
 
 	int (*get_frontend)(struct dvb_frontend* fe, struct dvb_frontend_parameters* params);
diff --git a/drivers/media/dvb/dvb-usb/af9005-fe.c b/drivers/media/dvb/dvb-usb/af9005-fe.c
index aa44f65..f216933 100644
--- a/drivers/media/dvb/dvb-usb/af9005-fe.c
+++ b/drivers/media/dvb/dvb-usb/af9005-fe.c
@@ -1475,7 +1475,7 @@ static struct dvb_frontend_ops af9005_fe_ops = {
 	.sleep = af9005_fe_sleep,
 	.ts_bus_ctrl = af9005_ts_bus_ctrl,
 
-	.set_frontend = af9005_fe_set_frontend,
+	.set_frontend_legacy = af9005_fe_set_frontend,
 	.get_frontend = af9005_fe_get_frontend,
 
 	.read_status = af9005_fe_read_status,
diff --git a/drivers/media/dvb/dvb-usb/cinergyT2-fe.c b/drivers/media/dvb/dvb-usb/cinergyT2-fe.c
index 9cd51ac..cad2284 100644
--- a/drivers/media/dvb/dvb-usb/cinergyT2-fe.c
+++ b/drivers/media/dvb/dvb-usb/cinergyT2-fe.c
@@ -340,7 +340,7 @@ static struct dvb_frontend_ops cinergyt2_fe_ops = {
 	.init			= cinergyt2_fe_init,
 	.sleep			= cinergyt2_fe_sleep,
 
-	.set_frontend		= cinergyt2_fe_set_frontend,
+	.set_frontend_legacy		= cinergyt2_fe_set_frontend,
 	.get_frontend		= cinergyt2_fe_get_frontend,
 	.get_tune_settings	= cinergyt2_fe_get_tune_settings,
 
diff --git a/drivers/media/dvb/dvb-usb/dtt200u-fe.c b/drivers/media/dvb/dvb-usb/dtt200u-fe.c
index 17413ad..ef9f7e4 100644
--- a/drivers/media/dvb/dvb-usb/dtt200u-fe.c
+++ b/drivers/media/dvb/dvb-usb/dtt200u-fe.c
@@ -193,7 +193,7 @@ static struct dvb_frontend_ops dtt200u_fe_ops = {
 	.init = dtt200u_fe_init,
 	.sleep = dtt200u_fe_sleep,
 
-	.set_frontend = dtt200u_fe_set_frontend,
+	.set_frontend_legacy = dtt200u_fe_set_frontend,
 	.get_frontend = dtt200u_fe_get_frontend,
 	.get_tune_settings = dtt200u_fe_get_tune_settings,
 
diff --git a/drivers/media/dvb/dvb-usb/friio-fe.c b/drivers/media/dvb/dvb-usb/friio-fe.c
index 015b4e8..c98e2cc 100644
--- a/drivers/media/dvb/dvb-usb/friio-fe.c
+++ b/drivers/media/dvb/dvb-usb/friio-fe.c
@@ -466,7 +466,7 @@ static struct dvb_frontend_ops jdvbt90502_ops = {
 
 	.set_property = jdvbt90502_set_property,
 
-	.set_frontend = jdvbt90502_set_frontend,
+	.set_frontend_legacy = jdvbt90502_set_frontend,
 	.get_frontend = jdvbt90502_get_frontend,
 
 	.read_status = jdvbt90502_read_status,
diff --git a/drivers/media/dvb/dvb-usb/gp8psk-fe.c b/drivers/media/dvb/dvb-usb/gp8psk-fe.c
index 5426267..6189446 100644
--- a/drivers/media/dvb/dvb-usb/gp8psk-fe.c
+++ b/drivers/media/dvb/dvb-usb/gp8psk-fe.c
@@ -368,7 +368,7 @@ static struct dvb_frontend_ops gp8psk_fe_ops = {
 
 	.set_property = gp8psk_fe_set_property,
 	.get_property = gp8psk_fe_get_property,
-	.set_frontend = gp8psk_fe_set_frontend,
+	.set_frontend_legacy = gp8psk_fe_set_frontend,
 
 	.get_tune_settings = gp8psk_fe_get_tune_settings,
 
diff --git a/drivers/media/dvb/dvb-usb/mxl111sf-demod.c b/drivers/media/dvb/dvb-usb/mxl111sf-demod.c
index 3ae7729..6639d3a 100644
--- a/drivers/media/dvb/dvb-usb/mxl111sf-demod.c
+++ b/drivers/media/dvb/dvb-usb/mxl111sf-demod.c
@@ -570,7 +570,7 @@ static struct dvb_frontend_ops mxl111sf_demod_ops = {
 	.init                 = mxl111sf_init,
 	.i2c_gate_ctrl        = mxl111sf_i2c_gate_ctrl,
 #endif
-	.set_frontend         = mxl111sf_demod_set_frontend,
+	.set_frontend_legacy         = mxl111sf_demod_set_frontend,
 	.get_frontend         = mxl111sf_demod_get_frontend,
 	.get_tune_settings    = mxl111sf_demod_get_tune_settings,
 	.read_status          = mxl111sf_demod_read_status,
diff --git a/drivers/media/dvb/dvb-usb/vp702x-fe.c b/drivers/media/dvb/dvb-usb/vp702x-fe.c
index 2bb8d4c..ee2177e 100644
--- a/drivers/media/dvb/dvb-usb/vp702x-fe.c
+++ b/drivers/media/dvb/dvb-usb/vp702x-fe.c
@@ -370,7 +370,7 @@ static struct dvb_frontend_ops vp702x_fe_ops = {
 	.init  = vp702x_fe_init,
 	.sleep = vp702x_fe_sleep,
 
-	.set_frontend = vp702x_fe_set_frontend,
+	.set_frontend_legacy = vp702x_fe_set_frontend,
 	.get_frontend = vp702x_fe_get_frontend,
 	.get_tune_settings = vp702x_fe_get_tune_settings,
 
diff --git a/drivers/media/dvb/dvb-usb/vp7045-fe.c b/drivers/media/dvb/dvb-usb/vp7045-fe.c
index 8452eef..4f708c7 100644
--- a/drivers/media/dvb/dvb-usb/vp7045-fe.c
+++ b/drivers/media/dvb/dvb-usb/vp7045-fe.c
@@ -180,7 +180,7 @@ static struct dvb_frontend_ops vp7045_fe_ops = {
 	.init = vp7045_fe_init,
 	.sleep = vp7045_fe_sleep,
 
-	.set_frontend = vp7045_fe_set_frontend,
+	.set_frontend_legacy = vp7045_fe_set_frontend,
 	.get_frontend = vp7045_fe_get_frontend,
 	.get_tune_settings = vp7045_fe_get_tune_settings,
 
diff --git a/drivers/media/dvb/firewire/firedtv-fe.c b/drivers/media/dvb/firewire/firedtv-fe.c
index 8748a61..a887abc 100644
--- a/drivers/media/dvb/firewire/firedtv-fe.c
+++ b/drivers/media/dvb/firewire/firedtv-fe.c
@@ -173,7 +173,7 @@ void fdtv_frontend_init(struct firedtv *fdtv, const char *name)
 	ops->init			= fdtv_dvb_init;
 	ops->sleep			= fdtv_sleep;
 
-	ops->set_frontend		= fdtv_set_frontend;
+	ops->set_frontend_legacy	= fdtv_set_frontend;
 	ops->get_frontend		= fdtv_get_frontend;
 
 	ops->get_property		= fdtv_get_property;
diff --git a/drivers/media/dvb/frontends/af9013.c b/drivers/media/dvb/frontends/af9013.c
index 889827d..a041d7f 100644
--- a/drivers/media/dvb/frontends/af9013.c
+++ b/drivers/media/dvb/frontends/af9013.c
@@ -1529,7 +1529,7 @@ static struct dvb_frontend_ops af9013_ops = {
 	.sleep = af9013_sleep,
 	.i2c_gate_ctrl = af9013_i2c_gate_ctrl,
 
-	.set_frontend = af9013_set_frontend,
+	.set_frontend_legacy = af9013_set_frontend,
 	.get_frontend = af9013_get_frontend,
 
 	.get_tune_settings = af9013_get_tune_settings,
diff --git a/drivers/media/dvb/frontends/atbm8830.c b/drivers/media/dvb/frontends/atbm8830.c
index 90480d3..5fc30f3 100644
--- a/drivers/media/dvb/frontends/atbm8830.c
+++ b/drivers/media/dvb/frontends/atbm8830.c
@@ -449,7 +449,7 @@ static struct dvb_frontend_ops atbm8830_ops = {
 	.write = NULL,
 	.i2c_gate_ctrl = atbm8830_i2c_gate_ctrl,
 
-	.set_frontend = atbm8830_set_fe,
+	.set_frontend_legacy = atbm8830_set_fe,
 	.get_frontend = atbm8830_get_fe,
 	.get_tune_settings = atbm8830_get_tune_settings,
 
diff --git a/drivers/media/dvb/frontends/au8522_dig.c b/drivers/media/dvb/frontends/au8522_dig.c
index 1df9d9c..4b74cc8 100644
--- a/drivers/media/dvb/frontends/au8522_dig.c
+++ b/drivers/media/dvb/frontends/au8522_dig.c
@@ -1023,7 +1023,7 @@ static struct dvb_frontend_ops au8522_ops = {
 	.init                 = au8522_init,
 	.sleep                = au8522_sleep,
 	.i2c_gate_ctrl        = au8522_i2c_gate_ctrl,
-	.set_frontend         = au8522_set_frontend,
+	.set_frontend_legacy         = au8522_set_frontend,
 	.get_frontend         = au8522_get_frontend,
 	.get_tune_settings    = au8522_get_tune_settings,
 	.read_status          = au8522_read_status,
diff --git a/drivers/media/dvb/frontends/bcm3510.c b/drivers/media/dvb/frontends/bcm3510.c
index 8aff586..43b17fa 100644
--- a/drivers/media/dvb/frontends/bcm3510.c
+++ b/drivers/media/dvb/frontends/bcm3510.c
@@ -839,7 +839,7 @@ static struct dvb_frontend_ops bcm3510_ops = {
 	.init = bcm3510_init,
 	.sleep = bcm3510_sleep,
 
-	.set_frontend = bcm3510_set_frontend,
+	.set_frontend_legacy = bcm3510_set_frontend,
 	.get_tune_settings = bcm3510_get_tune_settings,
 
 	.read_status = bcm3510_read_status,
diff --git a/drivers/media/dvb/frontends/cx22700.c b/drivers/media/dvb/frontends/cx22700.c
index 6ef82a1..ce1e74f 100644
--- a/drivers/media/dvb/frontends/cx22700.c
+++ b/drivers/media/dvb/frontends/cx22700.c
@@ -419,7 +419,7 @@ static struct dvb_frontend_ops cx22700_ops = {
 	.init = cx22700_init,
 	.i2c_gate_ctrl = cx22700_i2c_gate_ctrl,
 
-	.set_frontend = cx22700_set_frontend,
+	.set_frontend_legacy = cx22700_set_frontend,
 	.get_frontend = cx22700_get_frontend,
 	.get_tune_settings = cx22700_get_tune_settings,
 
diff --git a/drivers/media/dvb/frontends/cx22702.c b/drivers/media/dvb/frontends/cx22702.c
index 73dd87a..2cea13e 100644
--- a/drivers/media/dvb/frontends/cx22702.c
+++ b/drivers/media/dvb/frontends/cx22702.c
@@ -622,7 +622,7 @@ static const struct dvb_frontend_ops cx22702_ops = {
 	.init = cx22702_init,
 	.i2c_gate_ctrl = cx22702_i2c_gate_ctrl,
 
-	.set_frontend = cx22702_set_tps,
+	.set_frontend_legacy = cx22702_set_tps,
 	.get_frontend = cx22702_get_frontend,
 	.get_tune_settings = cx22702_get_tune_settings,
 
diff --git a/drivers/media/dvb/frontends/cx24110.c b/drivers/media/dvb/frontends/cx24110.c
index 1eb9253..c75f9da 100644
--- a/drivers/media/dvb/frontends/cx24110.c
+++ b/drivers/media/dvb/frontends/cx24110.c
@@ -643,7 +643,7 @@ static struct dvb_frontend_ops cx24110_ops = {
 
 	.init = cx24110_initfe,
 	.write = _cx24110_pll_write,
-	.set_frontend = cx24110_set_frontend,
+	.set_frontend_legacy = cx24110_set_frontend,
 	.get_frontend = cx24110_get_frontend,
 	.read_status = cx24110_read_status,
 	.read_ber = cx24110_read_ber,
diff --git a/drivers/media/dvb/frontends/cx24116.c b/drivers/media/dvb/frontends/cx24116.c
index ccd0525..445ae88 100644
--- a/drivers/media/dvb/frontends/cx24116.c
+++ b/drivers/media/dvb/frontends/cx24116.c
@@ -1509,7 +1509,7 @@ static struct dvb_frontend_ops cx24116_ops = {
 
 	.set_property = cx24116_set_property,
 	.get_property = cx24116_get_property,
-	.set_frontend = cx24116_set_frontend,
+	.set_frontend_legacy = cx24116_set_frontend,
 };
 
 MODULE_DESCRIPTION("DVB Frontend module for Conexant cx24116/cx24118 hardware");
diff --git a/drivers/media/dvb/frontends/cx24123.c b/drivers/media/dvb/frontends/cx24123.c
index 4d387d3..1342429 100644
--- a/drivers/media/dvb/frontends/cx24123.c
+++ b/drivers/media/dvb/frontends/cx24123.c
@@ -1146,7 +1146,7 @@ static struct dvb_frontend_ops cx24123_ops = {
 	.release = cx24123_release,
 
 	.init = cx24123_initfe,
-	.set_frontend = cx24123_set_frontend,
+	.set_frontend_legacy = cx24123_set_frontend,
 	.get_frontend = cx24123_get_frontend,
 	.read_status = cx24123_read_status,
 	.read_ber = cx24123_read_ber,
diff --git a/drivers/media/dvb/frontends/cxd2820r_core.c b/drivers/media/dvb/frontends/cxd2820r_core.c
index 036480f..e8ace56 100644
--- a/drivers/media/dvb/frontends/cxd2820r_core.c
+++ b/drivers/media/dvb/frontends/cxd2820r_core.c
@@ -852,7 +852,7 @@ static const struct dvb_frontend_ops cxd2820r_ops[2] = {
 		.get_tune_settings = cxd2820r_get_tune_settings,
 		.i2c_gate_ctrl = cxd2820r_i2c_gate_ctrl,
 
-		.set_frontend = cxd2820r_set_frontend,
+		.set_frontend_legacy = cxd2820r_set_frontend,
 		.get_frontend = cxd2820r_get_frontend,
 
 		.read_status = cxd2820r_read_status,
diff --git a/drivers/media/dvb/frontends/dib3000mb.c b/drivers/media/dvb/frontends/dib3000mb.c
index 7403198..987eb17 100644
--- a/drivers/media/dvb/frontends/dib3000mb.c
+++ b/drivers/media/dvb/frontends/dib3000mb.c
@@ -816,7 +816,7 @@ static struct dvb_frontend_ops dib3000mb_ops = {
 	.init = dib3000mb_fe_init_nonmobile,
 	.sleep = dib3000mb_sleep,
 
-	.set_frontend = dib3000mb_set_frontend_and_tuner,
+	.set_frontend_legacy = dib3000mb_set_frontend_and_tuner,
 	.get_frontend = dib3000mb_get_frontend,
 	.get_tune_settings = dib3000mb_fe_get_tune_settings,
 
diff --git a/drivers/media/dvb/frontends/dib3000mc.c b/drivers/media/dvb/frontends/dib3000mc.c
index 32cd006..19fca6e 100644
--- a/drivers/media/dvb/frontends/dib3000mc.c
+++ b/drivers/media/dvb/frontends/dib3000mc.c
@@ -918,7 +918,7 @@ static struct dvb_frontend_ops dib3000mc_ops = {
 	.init                 = dib3000mc_init,
 	.sleep                = dib3000mc_sleep,
 
-	.set_frontend         = dib3000mc_set_frontend,
+	.set_frontend_legacy         = dib3000mc_set_frontend,
 	.get_tune_settings    = dib3000mc_fe_get_tune_settings,
 	.get_frontend         = dib3000mc_get_frontend,
 
diff --git a/drivers/media/dvb/frontends/dib7000m.c b/drivers/media/dvb/frontends/dib7000m.c
index a30a482..cc6a710 100644
--- a/drivers/media/dvb/frontends/dib7000m.c
+++ b/drivers/media/dvb/frontends/dib7000m.c
@@ -1451,7 +1451,7 @@ static struct dvb_frontend_ops dib7000m_ops = {
 	.init                 = dib7000m_wakeup,
 	.sleep                = dib7000m_sleep,
 
-	.set_frontend         = dib7000m_set_frontend,
+	.set_frontend_legacy         = dib7000m_set_frontend,
 	.get_tune_settings    = dib7000m_fe_get_tune_settings,
 	.get_frontend         = dib7000m_get_frontend,
 
diff --git a/drivers/media/dvb/frontends/dib7000p.c b/drivers/media/dvb/frontends/dib7000p.c
index 9983207..1e81b5b 100644
--- a/drivers/media/dvb/frontends/dib7000p.c
+++ b/drivers/media/dvb/frontends/dib7000p.c
@@ -2439,7 +2439,7 @@ static struct dvb_frontend_ops dib7000p_ops = {
 	.init = dib7000p_wakeup,
 	.sleep = dib7000p_sleep,
 
-	.set_frontend = dib7000p_set_frontend,
+	.set_frontend_legacy = dib7000p_set_frontend,
 	.get_tune_settings = dib7000p_fe_get_tune_settings,
 	.get_frontend = dib7000p_get_frontend,
 
diff --git a/drivers/media/dvb/frontends/dib8000.c b/drivers/media/dvb/frontends/dib8000.c
index 2da2bb3..f9c98ba 100644
--- a/drivers/media/dvb/frontends/dib8000.c
+++ b/drivers/media/dvb/frontends/dib8000.c
@@ -3479,7 +3479,7 @@ static const struct dvb_frontend_ops dib8000_ops = {
 	.init = dib8000_wakeup,
 	.sleep = dib8000_sleep,
 
-	.set_frontend = dib8000_set_frontend,
+	.set_frontend_legacy = dib8000_set_frontend,
 	.get_tune_settings = dib8000_fe_get_tune_settings,
 	.get_frontend = dib8000_get_frontend,
 
diff --git a/drivers/media/dvb/frontends/dib9000.c b/drivers/media/dvb/frontends/dib9000.c
index 660f806..c7b4910 100644
--- a/drivers/media/dvb/frontends/dib9000.c
+++ b/drivers/media/dvb/frontends/dib9000.c
@@ -2513,7 +2513,7 @@ static struct dvb_frontend_ops dib9000_ops = {
 	.init = dib9000_wakeup,
 	.sleep = dib9000_sleep,
 
-	.set_frontend = dib9000_set_frontend,
+	.set_frontend_legacy = dib9000_set_frontend,
 	.get_tune_settings = dib9000_fe_get_tune_settings,
 	.get_frontend = dib9000_get_frontend,
 
diff --git a/drivers/media/dvb/frontends/drxd_hard.c b/drivers/media/dvb/frontends/drxd_hard.c
index 955d3a5..8118bb3 100644
--- a/drivers/media/dvb/frontends/drxd_hard.c
+++ b/drivers/media/dvb/frontends/drxd_hard.c
@@ -2956,7 +2956,7 @@ static struct dvb_frontend_ops drxd_ops = {
 	.sleep = drxd_sleep,
 	.i2c_gate_ctrl = drxd_i2c_gate_ctrl,
 
-	.set_frontend = drxd_set_frontend,
+	.set_frontend_legacy = drxd_set_frontend,
 	.get_frontend = drxd_get_frontend,
 	.get_tune_settings = drxd_get_tune_settings,
 
diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 83b8474..1205944 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -6406,7 +6406,7 @@ static struct dvb_frontend_ops drxk_c_ops = {
 	.sleep = drxk_c_sleep,
 	.i2c_gate_ctrl = drxk_gate_ctrl,
 
-	.set_frontend = drxk_set_parameters,
+	.set_frontend_legacy = drxk_set_parameters,
 	.get_frontend = drxk_c_get_frontend,
 	.get_property = drxk_c_get_property,
 	.get_tune_settings = drxk_c_get_tune_settings,
@@ -6439,7 +6439,7 @@ static struct dvb_frontend_ops drxk_t_ops = {
 	.sleep = drxk_t_sleep,
 	.i2c_gate_ctrl = drxk_gate_ctrl,
 
-	.set_frontend = drxk_set_parameters,
+	.set_frontend_legacy = drxk_set_parameters,
 	.get_frontend = drxk_t_get_frontend,
 	.get_property = drxk_t_get_property,
 
diff --git a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb/frontends/ds3000.c
index 90bf573..7fa5b92 100644
--- a/drivers/media/dvb/frontends/ds3000.c
+++ b/drivers/media/dvb/frontends/ds3000.c
@@ -1314,7 +1314,7 @@ static struct dvb_frontend_ops ds3000_ops = {
 
 	.set_property = ds3000_set_property,
 	.get_property = ds3000_get_property,
-	.set_frontend = ds3000_set_frontend,
+	.set_frontend_legacy = ds3000_set_frontend,
 	.tune = ds3000_tune,
 };
 
diff --git a/drivers/media/dvb/frontends/dvb_dummy_fe.c b/drivers/media/dvb/frontends/dvb_dummy_fe.c
index e3a7e42..322bcd7 100644
--- a/drivers/media/dvb/frontends/dvb_dummy_fe.c
+++ b/drivers/media/dvb/frontends/dvb_dummy_fe.c
@@ -192,7 +192,7 @@ static struct dvb_frontend_ops dvb_dummy_fe_ofdm_ops = {
 	.init = dvb_dummy_fe_init,
 	.sleep = dvb_dummy_fe_sleep,
 
-	.set_frontend = dvb_dummy_fe_set_frontend,
+	.set_frontend_legacy = dvb_dummy_fe_set_frontend,
 	.get_frontend = dvb_dummy_fe_get_frontend,
 
 	.read_status = dvb_dummy_fe_read_status,
@@ -222,7 +222,7 @@ static struct dvb_frontend_ops dvb_dummy_fe_qam_ops = {
 	.init = dvb_dummy_fe_init,
 	.sleep = dvb_dummy_fe_sleep,
 
-	.set_frontend = dvb_dummy_fe_set_frontend,
+	.set_frontend_legacy = dvb_dummy_fe_set_frontend,
 	.get_frontend = dvb_dummy_fe_get_frontend,
 
 	.read_status = dvb_dummy_fe_read_status,
@@ -254,7 +254,7 @@ static struct dvb_frontend_ops dvb_dummy_fe_qpsk_ops = {
 	.init = dvb_dummy_fe_init,
 	.sleep = dvb_dummy_fe_sleep,
 
-	.set_frontend = dvb_dummy_fe_set_frontend,
+	.set_frontend_legacy = dvb_dummy_fe_set_frontend,
 	.get_frontend = dvb_dummy_fe_get_frontend,
 
 	.read_status = dvb_dummy_fe_read_status,
diff --git a/drivers/media/dvb/frontends/ec100.c b/drivers/media/dvb/frontends/ec100.c
index 1ef79f0..20decd7 100644
--- a/drivers/media/dvb/frontends/ec100.c
+++ b/drivers/media/dvb/frontends/ec100.c
@@ -321,7 +321,7 @@ static struct dvb_frontend_ops ec100_ops = {
 	},
 
 	.release = ec100_release,
-	.set_frontend = ec100_set_frontend,
+	.set_frontend_legacy = ec100_set_frontend,
 	.get_tune_settings = ec100_get_tune_settings,
 	.read_status = ec100_read_status,
 	.read_ber = ec100_read_ber,
diff --git a/drivers/media/dvb/frontends/it913x-fe.c b/drivers/media/dvb/frontends/it913x-fe.c
index 8857710..54d8534 100644
--- a/drivers/media/dvb/frontends/it913x-fe.c
+++ b/drivers/media/dvb/frontends/it913x-fe.c
@@ -939,7 +939,7 @@ static struct dvb_frontend_ops it913x_fe_ofdm_ops = {
 	.init = it913x_fe_init,
 	.sleep = it913x_fe_sleep,
 
-	.set_frontend = it913x_fe_set_frontend,
+	.set_frontend_legacy = it913x_fe_set_frontend,
 	.get_frontend = it913x_fe_get_frontend,
 
 	.read_status = it913x_fe_read_status,
diff --git a/drivers/media/dvb/frontends/l64781.c b/drivers/media/dvb/frontends/l64781.c
index eee6bb5..fd4170a 100644
--- a/drivers/media/dvb/frontends/l64781.c
+++ b/drivers/media/dvb/frontends/l64781.c
@@ -584,7 +584,7 @@ static struct dvb_frontend_ops l64781_ops = {
 	.init = l64781_init,
 	.sleep = l64781_sleep,
 
-	.set_frontend = apply_frontend_param,
+	.set_frontend_legacy = apply_frontend_param,
 	.get_frontend = get_frontend,
 	.get_tune_settings = l64781_get_tune_settings,
 
diff --git a/drivers/media/dvb/frontends/lgdt3305.c b/drivers/media/dvb/frontends/lgdt3305.c
index 321f991..8f15178 100644
--- a/drivers/media/dvb/frontends/lgdt3305.c
+++ b/drivers/media/dvb/frontends/lgdt3305.c
@@ -1176,7 +1176,7 @@ static struct dvb_frontend_ops lgdt3304_ops = {
 	},
 	.i2c_gate_ctrl        = lgdt3305_i2c_gate_ctrl,
 	.init                 = lgdt3305_init,
-	.set_frontend         = lgdt3304_set_parameters,
+	.set_frontend_legacy         = lgdt3304_set_parameters,
 	.get_frontend         = lgdt3305_get_frontend,
 	.get_tune_settings    = lgdt3305_get_tune_settings,
 	.read_status          = lgdt3305_read_status,
@@ -1199,7 +1199,7 @@ static struct dvb_frontend_ops lgdt3305_ops = {
 	.i2c_gate_ctrl        = lgdt3305_i2c_gate_ctrl,
 	.init                 = lgdt3305_init,
 	.sleep                = lgdt3305_sleep,
-	.set_frontend         = lgdt3305_set_parameters,
+	.set_frontend_legacy         = lgdt3305_set_parameters,
 	.get_frontend         = lgdt3305_get_frontend,
 	.get_tune_settings    = lgdt3305_get_tune_settings,
 	.read_status          = lgdt3305_read_status,
diff --git a/drivers/media/dvb/frontends/lgdt330x.c b/drivers/media/dvb/frontends/lgdt330x.c
index 87b6a9c..bdae349 100644
--- a/drivers/media/dvb/frontends/lgdt330x.c
+++ b/drivers/media/dvb/frontends/lgdt330x.c
@@ -773,7 +773,7 @@ static struct dvb_frontend_ops lgdt3302_ops = {
 		.caps = FE_CAN_QAM_64 | FE_CAN_QAM_256 | FE_CAN_8VSB
 	},
 	.init                 = lgdt330x_init,
-	.set_frontend         = lgdt330x_set_parameters,
+	.set_frontend_legacy         = lgdt330x_set_parameters,
 	.get_frontend         = lgdt330x_get_frontend,
 	.get_tune_settings    = lgdt330x_get_tune_settings,
 	.read_status          = lgdt3302_read_status,
@@ -796,7 +796,7 @@ static struct dvb_frontend_ops lgdt3303_ops = {
 		.caps = FE_CAN_QAM_64 | FE_CAN_QAM_256 | FE_CAN_8VSB
 	},
 	.init                 = lgdt330x_init,
-	.set_frontend         = lgdt330x_set_parameters,
+	.set_frontend_legacy         = lgdt330x_set_parameters,
 	.get_frontend         = lgdt330x_get_frontend,
 	.get_tune_settings    = lgdt330x_get_tune_settings,
 	.read_status          = lgdt3303_read_status,
diff --git a/drivers/media/dvb/frontends/lgs8gl5.c b/drivers/media/dvb/frontends/lgs8gl5.c
index 4a9bd99..65a5c5d 100644
--- a/drivers/media/dvb/frontends/lgs8gl5.c
+++ b/drivers/media/dvb/frontends/lgs8gl5.c
@@ -434,7 +434,7 @@ static struct dvb_frontend_ops lgs8gl5_ops = {
 
 	.init = lgs8gl5_init,
 
-	.set_frontend = lgs8gl5_set_frontend,
+	.set_frontend_legacy = lgs8gl5_set_frontend,
 	.get_frontend = lgs8gl5_get_frontend,
 	.get_tune_settings = lgs8gl5_get_tune_settings,
 
diff --git a/drivers/media/dvb/frontends/lgs8gxx.c b/drivers/media/dvb/frontends/lgs8gxx.c
index bf9b12b..5684b61 100644
--- a/drivers/media/dvb/frontends/lgs8gxx.c
+++ b/drivers/media/dvb/frontends/lgs8gxx.c
@@ -1013,7 +1013,7 @@ static struct dvb_frontend_ops lgs8gxx_ops = {
 	.write = lgs8gxx_write,
 	.i2c_gate_ctrl = lgs8gxx_i2c_gate_ctrl,
 
-	.set_frontend = lgs8gxx_set_fe,
+	.set_frontend_legacy = lgs8gxx_set_fe,
 	.get_frontend = lgs8gxx_get_fe,
 	.get_tune_settings = lgs8gxx_get_tune_settings,
 
diff --git a/drivers/media/dvb/frontends/mb86a20s.c b/drivers/media/dvb/frontends/mb86a20s.c
index 8c92070..3ae6d1f 100644
--- a/drivers/media/dvb/frontends/mb86a20s.c
+++ b/drivers/media/dvb/frontends/mb86a20s.c
@@ -627,7 +627,7 @@ static struct dvb_frontend_ops mb86a20s_ops = {
 	.release = mb86a20s_release,
 
 	.init = mb86a20s_initfe,
-	.set_frontend = mb86a20s_set_frontend,
+	.set_frontend_legacy = mb86a20s_set_frontend,
 	.get_frontend = mb86a20s_get_frontend,
 	.read_status = mb86a20s_read_status,
 	.read_signal_strength = mb86a20s_read_signal_strength,
diff --git a/drivers/media/dvb/frontends/mt312.c b/drivers/media/dvb/frontends/mt312.c
index 302d72a..efae45f 100644
--- a/drivers/media/dvb/frontends/mt312.c
+++ b/drivers/media/dvb/frontends/mt312.c
@@ -761,7 +761,7 @@ static struct dvb_frontend_ops mt312_ops = {
 	.sleep = mt312_sleep,
 	.i2c_gate_ctrl = mt312_i2c_gate_ctrl,
 
-	.set_frontend = mt312_set_frontend,
+	.set_frontend_legacy = mt312_set_frontend,
 	.get_frontend = mt312_get_frontend,
 	.get_tune_settings = mt312_get_tune_settings,
 
diff --git a/drivers/media/dvb/frontends/mt352.c b/drivers/media/dvb/frontends/mt352.c
index 16a9fac..2bd68c5 100644
--- a/drivers/media/dvb/frontends/mt352.c
+++ b/drivers/media/dvb/frontends/mt352.c
@@ -592,7 +592,7 @@ static struct dvb_frontend_ops mt352_ops = {
 	.sleep = mt352_sleep,
 	.write = _mt352_write,
 
-	.set_frontend = mt352_set_parameters,
+	.set_frontend_legacy = mt352_set_parameters,
 	.get_frontend = mt352_get_parameters,
 	.get_tune_settings = mt352_get_tune_settings,
 
diff --git a/drivers/media/dvb/frontends/nxt200x.c b/drivers/media/dvb/frontends/nxt200x.c
index ae5c3c3..efb8e46 100644
--- a/drivers/media/dvb/frontends/nxt200x.c
+++ b/drivers/media/dvb/frontends/nxt200x.c
@@ -1220,7 +1220,7 @@ static struct dvb_frontend_ops nxt200x_ops = {
 	.init = nxt200x_init,
 	.sleep = nxt200x_sleep,
 
-	.set_frontend = nxt200x_setup_frontend_parameters,
+	.set_frontend_legacy = nxt200x_setup_frontend_parameters,
 	.get_tune_settings = nxt200x_get_tune_settings,
 
 	.read_status = nxt200x_read_status,
diff --git a/drivers/media/dvb/frontends/nxt6000.c b/drivers/media/dvb/frontends/nxt6000.c
index d17dd2d..a2419e8 100644
--- a/drivers/media/dvb/frontends/nxt6000.c
+++ b/drivers/media/dvb/frontends/nxt6000.c
@@ -592,7 +592,7 @@ static struct dvb_frontend_ops nxt6000_ops = {
 
 	.get_tune_settings = nxt6000_fe_get_tune_settings,
 
-	.set_frontend = nxt6000_set_frontend,
+	.set_frontend_legacy = nxt6000_set_frontend,
 
 	.read_status = nxt6000_read_status,
 	.read_ber = nxt6000_read_ber,
diff --git a/drivers/media/dvb/frontends/or51132.c b/drivers/media/dvb/frontends/or51132.c
index 5cd965b..461f9fd 100644
--- a/drivers/media/dvb/frontends/or51132.c
+++ b/drivers/media/dvb/frontends/or51132.c
@@ -597,7 +597,7 @@ static struct dvb_frontend_ops or51132_ops = {
 	.init = or51132_init,
 	.sleep = or51132_sleep,
 
-	.set_frontend = or51132_set_parameters,
+	.set_frontend_legacy = or51132_set_parameters,
 	.get_frontend = or51132_get_parameters,
 	.get_tune_settings = or51132_get_tune_settings,
 
diff --git a/drivers/media/dvb/frontends/or51211.c b/drivers/media/dvb/frontends/or51211.c
index 92d4dd8..2f2c7f8 100644
--- a/drivers/media/dvb/frontends/or51211.c
+++ b/drivers/media/dvb/frontends/or51211.c
@@ -561,7 +561,7 @@ static struct dvb_frontend_ops or51211_ops = {
 	.init = or51211_init,
 	.sleep = or51211_sleep,
 
-	.set_frontend = or51211_set_parameters,
+	.set_frontend_legacy = or51211_set_parameters,
 	.get_tune_settings = or51211_get_tune_settings,
 
 	.read_status = or51211_read_status,
diff --git a/drivers/media/dvb/frontends/s5h1409.c b/drivers/media/dvb/frontends/s5h1409.c
index 5ffb19e..0b6e6c5 100644
--- a/drivers/media/dvb/frontends/s5h1409.c
+++ b/drivers/media/dvb/frontends/s5h1409.c
@@ -1008,7 +1008,7 @@ static struct dvb_frontend_ops s5h1409_ops = {
 
 	.init                 = s5h1409_init,
 	.i2c_gate_ctrl        = s5h1409_i2c_gate_ctrl,
-	.set_frontend         = s5h1409_set_frontend,
+	.set_frontend_legacy         = s5h1409_set_frontend,
 	.get_frontend         = s5h1409_get_frontend,
 	.get_tune_settings    = s5h1409_get_tune_settings,
 	.read_status          = s5h1409_read_status,
diff --git a/drivers/media/dvb/frontends/s5h1411.c b/drivers/media/dvb/frontends/s5h1411.c
index 6852abe..67ab85c 100644
--- a/drivers/media/dvb/frontends/s5h1411.c
+++ b/drivers/media/dvb/frontends/s5h1411.c
@@ -928,7 +928,7 @@ static struct dvb_frontend_ops s5h1411_ops = {
 	.init                 = s5h1411_init,
 	.sleep                = s5h1411_sleep,
 	.i2c_gate_ctrl        = s5h1411_i2c_gate_ctrl,
-	.set_frontend         = s5h1411_set_frontend,
+	.set_frontend_legacy         = s5h1411_set_frontend,
 	.get_frontend         = s5h1411_get_frontend,
 	.get_tune_settings    = s5h1411_get_tune_settings,
 	.read_status          = s5h1411_read_status,
diff --git a/drivers/media/dvb/frontends/s5h1420.c b/drivers/media/dvb/frontends/s5h1420.c
index c4a8a01..e2cecf4 100644
--- a/drivers/media/dvb/frontends/s5h1420.c
+++ b/drivers/media/dvb/frontends/s5h1420.c
@@ -960,7 +960,7 @@ static struct dvb_frontend_ops s5h1420_ops = {
 	.sleep = s5h1420_sleep,
 	.i2c_gate_ctrl = s5h1420_i2c_gate_ctrl,
 
-	.set_frontend = s5h1420_set_frontend,
+	.set_frontend_legacy = s5h1420_set_frontend,
 	.get_frontend = s5h1420_get_frontend,
 	.get_tune_settings = s5h1420_get_tune_settings,
 
diff --git a/drivers/media/dvb/frontends/s5h1432.c b/drivers/media/dvb/frontends/s5h1432.c
index 2717bae..a0dbbdc 100644
--- a/drivers/media/dvb/frontends/s5h1432.c
+++ b/drivers/media/dvb/frontends/s5h1432.c
@@ -396,7 +396,7 @@ static struct dvb_frontend_ops s5h1432_ops = {
 
 	.init = s5h1432_init,
 	.sleep = s5h1432_sleep,
-	.set_frontend = s5h1432_set_frontend,
+	.set_frontend_legacy = s5h1432_set_frontend,
 	.get_frontend = s5h1432_get_frontend,
 	.get_tune_settings = s5h1432_get_tune_settings,
 	.read_status = s5h1432_read_status,
diff --git a/drivers/media/dvb/frontends/s921.c b/drivers/media/dvb/frontends/s921.c
index ca0103d..6615979 100644
--- a/drivers/media/dvb/frontends/s921.c
+++ b/drivers/media/dvb/frontends/s921.c
@@ -534,7 +534,7 @@ static struct dvb_frontend_ops s921_ops = {
 	.release = s921_release,
 
 	.init = s921_initfe,
-	.set_frontend = s921_set_frontend,
+	.set_frontend_legacy = s921_set_frontend,
 	.get_frontend = s921_get_frontend,
 	.read_status = s921_read_status,
 	.read_signal_strength = s921_read_signal_strength,
diff --git a/drivers/media/dvb/frontends/si21xx.c b/drivers/media/dvb/frontends/si21xx.c
index 4b0c99a..badf449 100644
--- a/drivers/media/dvb/frontends/si21xx.c
+++ b/drivers/media/dvb/frontends/si21xx.c
@@ -910,7 +910,7 @@ static struct dvb_frontend_ops si21xx_ops = {
 
 	.set_property = si21xx_set_property,
 	.get_property = si21xx_get_property,
-	.set_frontend = si21xx_set_frontend,
+	.set_frontend_legacy = si21xx_set_frontend,
 };
 
 struct dvb_frontend *si21xx_attach(const struct si21xx_config *config,
diff --git a/drivers/media/dvb/frontends/sp8870.c b/drivers/media/dvb/frontends/sp8870.c
index 9cff909..d49e48c 100644
--- a/drivers/media/dvb/frontends/sp8870.c
+++ b/drivers/media/dvb/frontends/sp8870.c
@@ -600,7 +600,7 @@ static struct dvb_frontend_ops sp8870_ops = {
 	.sleep = sp8870_sleep,
 	.i2c_gate_ctrl = sp8870_i2c_gate_ctrl,
 
-	.set_frontend = sp8870_set_frontend,
+	.set_frontend_legacy = sp8870_set_frontend,
 	.get_tune_settings = sp8870_get_tune_settings,
 
 	.read_status = sp8870_read_status,
diff --git a/drivers/media/dvb/frontends/sp887x.c b/drivers/media/dvb/frontends/sp887x.c
index efe0926..33ec08a 100644
--- a/drivers/media/dvb/frontends/sp887x.c
+++ b/drivers/media/dvb/frontends/sp887x.c
@@ -598,7 +598,7 @@ static struct dvb_frontend_ops sp887x_ops = {
 	.sleep = sp887x_sleep,
 	.i2c_gate_ctrl = sp887x_i2c_gate_ctrl,
 
-	.set_frontend = sp887x_setup_frontend_parameters,
+	.set_frontend_legacy = sp887x_setup_frontend_parameters,
 	.get_tune_settings = sp887x_get_tune_settings,
 
 	.read_status = sp887x_read_status,
diff --git a/drivers/media/dvb/frontends/stv0288.c b/drivers/media/dvb/frontends/stv0288.c
index a1b4933..105f0bf 100644
--- a/drivers/media/dvb/frontends/stv0288.c
+++ b/drivers/media/dvb/frontends/stv0288.c
@@ -579,7 +579,7 @@ static struct dvb_frontend_ops stv0288_ops = {
 
 	.set_property = stv0288_set_property,
 	.get_property = stv0288_get_property,
-	.set_frontend = stv0288_set_frontend,
+	.set_frontend_legacy = stv0288_set_frontend,
 };
 
 struct dvb_frontend *stv0288_attach(const struct stv0288_config *config,
diff --git a/drivers/media/dvb/frontends/stv0297.c b/drivers/media/dvb/frontends/stv0297.c
index daeaddf..63a3e1b 100644
--- a/drivers/media/dvb/frontends/stv0297.c
+++ b/drivers/media/dvb/frontends/stv0297.c
@@ -706,7 +706,7 @@ static struct dvb_frontend_ops stv0297_ops = {
 	.sleep = stv0297_sleep,
 	.i2c_gate_ctrl = stv0297_i2c_gate_ctrl,
 
-	.set_frontend = stv0297_set_frontend,
+	.set_frontend_legacy = stv0297_set_frontend,
 	.get_frontend = stv0297_get_frontend,
 
 	.read_status = stv0297_read_status,
diff --git a/drivers/media/dvb/frontends/stv0299.c b/drivers/media/dvb/frontends/stv0299.c
index bd79e05..4f248e1 100644
--- a/drivers/media/dvb/frontends/stv0299.c
+++ b/drivers/media/dvb/frontends/stv0299.c
@@ -729,7 +729,7 @@ static struct dvb_frontend_ops stv0299_ops = {
 	.write = stv0299_write,
 	.i2c_gate_ctrl = stv0299_i2c_gate_ctrl,
 
-	.set_frontend = stv0299_set_frontend,
+	.set_frontend_legacy = stv0299_set_frontend,
 	.get_frontend = stv0299_get_frontend,
 	.get_tune_settings = stv0299_get_tune_settings,
 
diff --git a/drivers/media/dvb/frontends/stv0367.c b/drivers/media/dvb/frontends/stv0367.c
index 586295d..7752d13 100644
--- a/drivers/media/dvb/frontends/stv0367.c
+++ b/drivers/media/dvb/frontends/stv0367.c
@@ -2285,7 +2285,7 @@ static struct dvb_frontend_ops stv0367ter_ops = {
 	.init = stv0367ter_init,
 	.sleep = stv0367ter_sleep,
 	.i2c_gate_ctrl = stv0367ter_gate_ctrl,
-	.set_frontend = stv0367ter_set_frontend,
+	.set_frontend_legacy = stv0367ter_set_frontend,
 	.get_frontend = stv0367ter_get_frontend,
 	.get_tune_settings = stv0367_get_tune_settings,
 	.read_status = stv0367ter_read_status,
@@ -3403,7 +3403,7 @@ static struct dvb_frontend_ops stv0367cab_ops = {
 	.init					= stv0367cab_init,
 	.sleep					= stv0367cab_sleep,
 	.i2c_gate_ctrl				= stv0367cab_gate_ctrl,
-	.set_frontend				= stv0367cab_set_frontend,
+	.set_frontend_legacy				= stv0367cab_set_frontend,
 	.get_frontend				= stv0367cab_get_frontend,
 	.read_status				= stv0367cab_read_status,
 /*	.read_ber				= stv0367cab_read_ber, */
diff --git a/drivers/media/dvb/frontends/tda10021.c b/drivers/media/dvb/frontends/tda10021.c
index a1629d1..0bbf681 100644
--- a/drivers/media/dvb/frontends/tda10021.c
+++ b/drivers/media/dvb/frontends/tda10021.c
@@ -524,7 +524,7 @@ static struct dvb_frontend_ops tda10021_ops = {
 	.sleep = tda10021_sleep,
 	.i2c_gate_ctrl = tda10021_i2c_gate_ctrl,
 
-	.set_frontend = tda10021_set_parameters,
+	.set_frontend_legacy = tda10021_set_parameters,
 	.get_frontend = tda10021_get_frontend,
 	.get_property = tda10021_get_property,
 
diff --git a/drivers/media/dvb/frontends/tda10023.c b/drivers/media/dvb/frontends/tda10023.c
index ecc4b55..f79841b 100644
--- a/drivers/media/dvb/frontends/tda10023.c
+++ b/drivers/media/dvb/frontends/tda10023.c
@@ -609,7 +609,7 @@ static struct dvb_frontend_ops tda10023_ops = {
 	.sleep = tda10023_sleep,
 	.i2c_gate_ctrl = tda10023_i2c_gate_ctrl,
 
-	.set_frontend = tda10023_set_parameters,
+	.set_frontend_legacy = tda10023_set_parameters,
 	.get_frontend = tda10023_get_frontend,
 	.get_property = tda10023_get_property,
 	.read_status = tda10023_read_status,
diff --git a/drivers/media/dvb/frontends/tda10048.c b/drivers/media/dvb/frontends/tda10048.c
index d450385..479ff85 100644
--- a/drivers/media/dvb/frontends/tda10048.c
+++ b/drivers/media/dvb/frontends/tda10048.c
@@ -1188,7 +1188,7 @@ static struct dvb_frontend_ops tda10048_ops = {
 	.release = tda10048_release,
 	.init = tda10048_init,
 	.i2c_gate_ctrl = tda10048_i2c_gate_ctrl,
-	.set_frontend = tda10048_set_frontend,
+	.set_frontend_legacy = tda10048_set_frontend,
 	.get_frontend = tda10048_get_frontend,
 	.get_tune_settings = tda10048_get_tune_settings,
 	.read_status = tda10048_read_status,
diff --git a/drivers/media/dvb/frontends/tda1004x.c b/drivers/media/dvb/frontends/tda1004x.c
index dbac35b..dd41057 100644
--- a/drivers/media/dvb/frontends/tda1004x.c
+++ b/drivers/media/dvb/frontends/tda1004x.c
@@ -1251,7 +1251,7 @@ static struct dvb_frontend_ops tda10045_ops = {
 	.write = tda1004x_write,
 	.i2c_gate_ctrl = tda1004x_i2c_gate_ctrl,
 
-	.set_frontend = tda1004x_set_fe,
+	.set_frontend_legacy = tda1004x_set_fe,
 	.get_frontend = tda1004x_get_fe,
 	.get_tune_settings = tda1004x_get_tune_settings,
 
@@ -1321,7 +1321,7 @@ static struct dvb_frontend_ops tda10046_ops = {
 	.write = tda1004x_write,
 	.i2c_gate_ctrl = tda1004x_i2c_gate_ctrl,
 
-	.set_frontend = tda1004x_set_fe,
+	.set_frontend_legacy = tda1004x_set_fe,
 	.get_frontend = tda1004x_get_fe,
 	.get_tune_settings = tda1004x_get_tune_settings,
 
diff --git a/drivers/media/dvb/frontends/tda10071.c b/drivers/media/dvb/frontends/tda10071.c
index 0c37434..7bffa65 100644
--- a/drivers/media/dvb/frontends/tda10071.c
+++ b/drivers/media/dvb/frontends/tda10071.c
@@ -1247,7 +1247,7 @@ static struct dvb_frontend_ops tda10071_ops = {
 	.init = tda10071_init,
 	.sleep = tda10071_sleep,
 
-	.set_frontend = tda10071_set_frontend,
+	.set_frontend_legacy = tda10071_set_frontend,
 	.get_frontend = tda10071_get_frontend,
 
 	.read_status = tda10071_read_status,
diff --git a/drivers/media/dvb/frontends/tda10086.c b/drivers/media/dvb/frontends/tda10086.c
index 7656ff7..be4649f 100644
--- a/drivers/media/dvb/frontends/tda10086.c
+++ b/drivers/media/dvb/frontends/tda10086.c
@@ -722,7 +722,7 @@ static struct dvb_frontend_ops tda10086_ops = {
 	.sleep = tda10086_sleep,
 	.i2c_gate_ctrl = tda10086_i2c_gate_ctrl,
 
-	.set_frontend = tda10086_set_frontend,
+	.set_frontend_legacy = tda10086_set_frontend,
 	.get_frontend = tda10086_get_frontend,
 	.get_tune_settings = tda10086_get_tune_settings,
 
diff --git a/drivers/media/dvb/frontends/tda8083.c b/drivers/media/dvb/frontends/tda8083.c
index 3f2b1b8..9d1466f 100644
--- a/drivers/media/dvb/frontends/tda8083.c
+++ b/drivers/media/dvb/frontends/tda8083.c
@@ -461,7 +461,7 @@ static struct dvb_frontend_ops tda8083_ops = {
 	.init = tda8083_init,
 	.sleep = tda8083_sleep,
 
-	.set_frontend = tda8083_set_frontend,
+	.set_frontend_legacy = tda8083_set_frontend,
 	.get_frontend = tda8083_get_frontend,
 
 	.read_status = tda8083_read_status,
diff --git a/drivers/media/dvb/frontends/ves1820.c b/drivers/media/dvb/frontends/ves1820.c
index 270c7f9..6fb8eb5 100644
--- a/drivers/media/dvb/frontends/ves1820.c
+++ b/drivers/media/dvb/frontends/ves1820.c
@@ -425,7 +425,7 @@ static struct dvb_frontend_ops ves1820_ops = {
 	.init = ves1820_init,
 	.sleep = ves1820_sleep,
 
-	.set_frontend = ves1820_set_parameters,
+	.set_frontend_legacy = ves1820_set_parameters,
 	.get_frontend = ves1820_get_frontend,
 	.get_tune_settings = ves1820_get_tune_settings,
 
diff --git a/drivers/media/dvb/frontends/ves1x93.c b/drivers/media/dvb/frontends/ves1x93.c
index 5ffbf5e..f80f152 100644
--- a/drivers/media/dvb/frontends/ves1x93.c
+++ b/drivers/media/dvb/frontends/ves1x93.c
@@ -529,7 +529,7 @@ static struct dvb_frontend_ops ves1x93_ops = {
 	.sleep = ves1x93_sleep,
 	.i2c_gate_ctrl = ves1x93_i2c_gate_ctrl,
 
-	.set_frontend = ves1x93_set_frontend,
+	.set_frontend_legacy = ves1x93_set_frontend,
 	.get_frontend = ves1x93_get_frontend,
 
 	.read_status = ves1x93_read_status,
diff --git a/drivers/media/dvb/frontends/zl10353.c b/drivers/media/dvb/frontends/zl10353.c
index 0945aa0..8b6c2a4 100644
--- a/drivers/media/dvb/frontends/zl10353.c
+++ b/drivers/media/dvb/frontends/zl10353.c
@@ -675,7 +675,7 @@ static struct dvb_frontend_ops zl10353_ops = {
 	.i2c_gate_ctrl = zl10353_i2c_gate_ctrl,
 	.write = zl10353_write,
 
-	.set_frontend = zl10353_set_parameters,
+	.set_frontend_legacy = zl10353_set_parameters,
 	.get_frontend = zl10353_get_parameters,
 	.get_tune_settings = zl10353_get_tune_settings,
 
diff --git a/drivers/media/dvb/siano/smsdvb.c b/drivers/media/dvb/siano/smsdvb.c
index 37c594f..fa17f02 100644
--- a/drivers/media/dvb/siano/smsdvb.c
+++ b/drivers/media/dvb/siano/smsdvb.c
@@ -805,7 +805,7 @@ static struct dvb_frontend_ops smsdvb_fe_ops = {
 
 	.release = smsdvb_release,
 
-	.set_frontend = smsdvb_set_frontend,
+	.set_frontend_legacy = smsdvb_set_frontend,
 	.get_frontend = smsdvb_get_frontend,
 	.get_tune_settings = smsdvb_get_tune_settings,
 
diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
index 371fb29..c615ed7 100644
--- a/drivers/media/dvb/ttpci/av7110.c
+++ b/drivers/media/dvb/ttpci/av7110.c
@@ -2283,7 +2283,7 @@ static int frontend_init(struct av7110 *av7110)
 		FE_FUNC_OVERRIDE(av7110->fe->ops.set_tone, av7110->fe_set_tone, av7110_fe_set_tone);
 		FE_FUNC_OVERRIDE(av7110->fe->ops.set_voltage, av7110->fe_set_voltage, av7110_fe_set_voltage);
 		FE_FUNC_OVERRIDE(av7110->fe->ops.dishnetwork_send_legacy_command, av7110->fe_dishnetwork_send_legacy_command, av7110_fe_dishnetwork_send_legacy_command);
-		FE_FUNC_OVERRIDE(av7110->fe->ops.set_frontend, av7110->fe_set_frontend, av7110_fe_set_frontend);
+		FE_FUNC_OVERRIDE(av7110->fe->ops.set_frontend_legacy, av7110->fe_set_frontend, av7110_fe_set_frontend);
 
 		ret = dvb_register_frontend(&av7110->dvb_adapter, av7110->fe);
 		if (ret < 0) {
diff --git a/drivers/media/dvb/ttusb-dec/ttusbdecfe.c b/drivers/media/dvb/ttusb-dec/ttusbdecfe.c
index 21260aa..20a1410 100644
--- a/drivers/media/dvb/ttusb-dec/ttusbdecfe.c
+++ b/drivers/media/dvb/ttusb-dec/ttusbdecfe.c
@@ -257,7 +257,7 @@ static struct dvb_frontend_ops ttusbdecfe_dvbt_ops = {
 
 	.release = ttusbdecfe_release,
 
-	.set_frontend = ttusbdecfe_dvbt_set_frontend,
+	.set_frontend_legacy = ttusbdecfe_dvbt_set_frontend,
 
 	.get_tune_settings = ttusbdecfe_dvbt_get_tune_settings,
 
@@ -281,7 +281,7 @@ static struct dvb_frontend_ops ttusbdecfe_dvbs_ops = {
 
 	.release = ttusbdecfe_release,
 
-	.set_frontend = ttusbdecfe_dvbs_set_frontend,
+	.set_frontend_legacy = ttusbdecfe_dvbs_set_frontend,
 
 	.read_status = ttusbdecfe_dvbs_read_status,
 
diff --git a/drivers/media/video/tlg2300/pd-dvb.c b/drivers/media/video/tlg2300/pd-dvb.c
index d0da11a..51a7d55 100644
--- a/drivers/media/video/tlg2300/pd-dvb.c
+++ b/drivers/media/video/tlg2300/pd-dvb.c
@@ -353,7 +353,7 @@ static struct dvb_frontend_ops poseidon_frontend_ops = {
 	.init = poseidon_fe_init,
 	.sleep = poseidon_fe_sleep,
 
-	.set_frontend = poseidon_set_fe,
+	.set_frontend_legacy = poseidon_set_fe,
 	.get_frontend = poseidon_get_fe,
 	.get_tune_settings = poseidon_fe_get_tune_settings,
 
diff --git a/drivers/staging/media/as102/as102_fe.c b/drivers/staging/media/as102/as102_fe.c
index c2adfe5..161bcbe 100644
--- a/drivers/staging/media/as102/as102_fe.c
+++ b/drivers/staging/media/as102/as102_fe.c
@@ -296,7 +296,7 @@ static struct dvb_frontend_ops as102_fe_ops = {
 			| FE_CAN_MUTE_TS
 	},
 
-	.set_frontend		= as102_fe_set_frontend,
+	.set_frontend_legacy	= as102_fe_set_frontend,
 	.get_frontend		= as102_fe_get_frontend,
 	.get_tune_settings	= as102_fe_get_tune_settings,
 
-- 
1.7.8.352.g876a6

