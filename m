Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:23026
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932750AbcH2N3y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Aug 2016 09:29:54 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andy Walls <awalls@md.metrocast.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH] [media]: constify i2c_algorithm structures
Date: Mon, 29 Aug 2016 15:12:01 +0200
Message-Id: <1472476321-16672-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These i2c_algorithm structures are only stored in the alg field of an
i2c_adapter structure, which is declared as const.  This declare the
structures as const as well.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r disable optional_qualifier@
identifier i;
position p;
@@
static struct i2c_algorithm i@p = { ... };

@ok@
identifier r.i;
struct i2c_adapter e;
position p;
@@
e.alg = &i@p;

@bad@
position p != {r.p,ok.p};
identifier r.i;
@@
i@p

@depends on !bad disable optional_qualifier@
identifier r.i;
@@
static
+const
 struct i2c_algorithm i = { ... };
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/pci/cx23885/cx23885-i2c.c       |    2 +-
 drivers/media/pci/cx25821/cx25821-i2c.c       |    2 +-
 drivers/media/pci/ivtv/ivtv-i2c.c             |    2 +-
 drivers/media/pci/saa7134/saa7134-i2c.c       |    2 +-
 drivers/media/pci/saa7164/saa7164-i2c.c       |    2 +-
 drivers/media/radio/si4713/radio-usb-si4713.c |    2 +-
 drivers/media/usb/cx231xx/cx231xx-i2c.c       |    2 +-
 drivers/media/usb/em28xx/em28xx-i2c.c         |    2 +-
 drivers/media/usb/go7007/go7007-i2c.c         |    2 +-
 drivers/media/usb/go7007/go7007-usb.c         |    2 +-
 drivers/media/usb/hdpvr/hdpvr-i2c.c           |    2 +-
 drivers/media/usb/stk1160/stk1160-i2c.c       |    2 +-
 12 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtv-i2c.c b/drivers/media/pci/ivtv/ivtv-i2c.c
index bccbf2d..dd57442 100644
--- a/drivers/media/pci/ivtv/ivtv-i2c.c
+++ b/drivers/media/pci/ivtv/ivtv-i2c.c
@@ -625,7 +625,7 @@ static u32 ivtv_functionality(struct i2c_adapter *adap)
 	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
 }
 
-static struct i2c_algorithm ivtv_algo = {
+static const struct i2c_algorithm ivtv_algo = {
 	.master_xfer   = ivtv_xfer,
 	.functionality = ivtv_functionality,
 };
diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 1a9e1e5..8b690ac 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -855,7 +855,7 @@ static u32 functionality(struct i2c_adapter *i2c_adap)
 	return 0;
 }
 
-static struct i2c_algorithm em28xx_algo = {
+static const struct i2c_algorithm em28xx_algo = {
 	.master_xfer   = em28xx_i2c_xfer,
 	.functionality = functionality,
 };
diff --git a/drivers/media/radio/si4713/radio-usb-si4713.c b/drivers/media/radio/si4713/radio-usb-si4713.c
index 5146be2..e5e5a16 100644
--- a/drivers/media/radio/si4713/radio-usb-si4713.c
+++ b/drivers/media/radio/si4713/radio-usb-si4713.c
@@ -402,7 +402,7 @@ static u32 si4713_functionality(struct i2c_adapter *adapter)
 	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
 }
 
-static struct i2c_algorithm si4713_algo = {
+static const struct i2c_algorithm si4713_algo = {
 	.master_xfer   = si4713_transfer,
 	.functionality = si4713_functionality,
 };
diff --git a/drivers/media/usb/go7007/go7007-i2c.c b/drivers/media/usb/go7007/go7007-i2c.c
index 55addfa..c084bf7 100644
--- a/drivers/media/usb/go7007/go7007-i2c.c
+++ b/drivers/media/usb/go7007/go7007-i2c.c
@@ -191,7 +191,7 @@ static u32 go7007_functionality(struct i2c_adapter *adapter)
 	return I2C_FUNC_SMBUS_BYTE_DATA;
 }
 
-static struct i2c_algorithm go7007_algo = {
+static const struct i2c_algorithm go7007_algo = {
 	.smbus_xfer	= go7007_smbus_xfer,
 	.master_xfer	= go7007_i2c_master_xfer,
 	.functionality	= go7007_functionality,
diff --git a/drivers/media/usb/go7007/go7007-usb.c b/drivers/media/usb/go7007/go7007-usb.c
index 14d3f8c..ed9bcaf 100644
--- a/drivers/media/usb/go7007/go7007-usb.c
+++ b/drivers/media/usb/go7007/go7007-usb.c
@@ -1032,7 +1032,7 @@ static u32 go7007_usb_functionality(struct i2c_adapter *adapter)
 	return (I2C_FUNC_SMBUS_EMUL) & ~I2C_FUNC_SMBUS_QUICK;
 }
 
-static struct i2c_algorithm go7007_usb_algo = {
+static const struct i2c_algorithm go7007_usb_algo = {
 	.master_xfer	= go7007_usb_i2c_master_xfer,
 	.functionality	= go7007_usb_functionality,
 };
diff --git a/drivers/media/pci/cx23885/cx23885-i2c.c b/drivers/media/pci/cx23885/cx23885-i2c.c
index ae061b3..6159122 100644
--- a/drivers/media/pci/cx23885/cx23885-i2c.c
+++ b/drivers/media/pci/cx23885/cx23885-i2c.c
@@ -258,7 +258,7 @@ static u32 cx23885_functionality(struct i2c_adapter *adap)
 	return I2C_FUNC_SMBUS_EMUL | I2C_FUNC_I2C;
 }
 
-static struct i2c_algorithm cx23885_i2c_algo_template = {
+static const struct i2c_algorithm cx23885_i2c_algo_template = {
 	.master_xfer	= i2c_xfer,
 	.functionality	= cx23885_functionality,
 };
diff --git a/drivers/media/pci/cx25821/cx25821-i2c.c b/drivers/media/pci/cx25821/cx25821-i2c.c
index dca37c7..63ba25b 100644
--- a/drivers/media/pci/cx25821/cx25821-i2c.c
+++ b/drivers/media/pci/cx25821/cx25821-i2c.c
@@ -281,7 +281,7 @@ static u32 cx25821_functionality(struct i2c_adapter *adap)
 		I2C_FUNC_SMBUS_READ_WORD_DATA | I2C_FUNC_SMBUS_WRITE_WORD_DATA;
 }
 
-static struct i2c_algorithm cx25821_i2c_algo_template = {
+static const struct i2c_algorithm cx25821_i2c_algo_template = {
 	.master_xfer = i2c_xfer,
 	.functionality = cx25821_functionality,
 #ifdef NEED_ALGO_CONTROL
diff --git a/drivers/media/pci/saa7164/saa7164-i2c.c b/drivers/media/pci/saa7164/saa7164-i2c.c
index 0342d84..024f4e2 100644
--- a/drivers/media/pci/saa7164/saa7164-i2c.c
+++ b/drivers/media/pci/saa7164/saa7164-i2c.c
@@ -75,7 +75,7 @@ static u32 saa7164_functionality(struct i2c_adapter *adap)
 	return I2C_FUNC_I2C;
 }
 
-static struct i2c_algorithm saa7164_i2c_algo_template = {
+static const struct i2c_algorithm saa7164_i2c_algo_template = {
 	.master_xfer	= i2c_xfer,
 	.functionality	= saa7164_functionality,
 };
diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index 473cd34..f04b471 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -454,7 +454,7 @@ static u32 functionality(struct i2c_adapter *adap)
 	return I2C_FUNC_SMBUS_EMUL | I2C_FUNC_I2C;
 }
 
-static struct i2c_algorithm cx231xx_algo = {
+static const struct i2c_algorithm cx231xx_algo = {
 	.master_xfer = cx231xx_i2c_xfer,
 	.functionality = functionality,
 };
diff --git a/drivers/media/usb/hdpvr/hdpvr-i2c.c b/drivers/media/usb/hdpvr/hdpvr-i2c.c
index a38f58c..608ae96 100644
--- a/drivers/media/usb/hdpvr/hdpvr-i2c.c
+++ b/drivers/media/usb/hdpvr/hdpvr-i2c.c
@@ -180,7 +180,7 @@ static u32 hdpvr_functionality(struct i2c_adapter *adapter)
 	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
 }
 
-static struct i2c_algorithm hdpvr_algo = {
+static const struct i2c_algorithm hdpvr_algo = {
 	.master_xfer   = hdpvr_transfer,
 	.functionality = hdpvr_functionality,
 };
diff --git a/drivers/media/pci/saa7134/saa7134-i2c.c b/drivers/media/pci/saa7134/saa7134-i2c.c
index 8ef6399..2dac48f 100644
--- a/drivers/media/pci/saa7134/saa7134-i2c.c
+++ b/drivers/media/pci/saa7134/saa7134-i2c.c
@@ -338,7 +338,7 @@ static u32 functionality(struct i2c_adapter *adap)
 	return I2C_FUNC_SMBUS_EMUL;
 }
 
-static struct i2c_algorithm saa7134_algo = {
+static const struct i2c_algorithm saa7134_algo = {
 	.master_xfer   = saa7134_i2c_xfer,
 	.functionality = functionality,
 };
diff --git a/drivers/media/usb/stk1160/stk1160-i2c.c b/drivers/media/usb/stk1160/stk1160-i2c.c
index 850cf28..3f2517b 100644
--- a/drivers/media/usb/stk1160/stk1160-i2c.c
+++ b/drivers/media/usb/stk1160/stk1160-i2c.c
@@ -235,7 +235,7 @@ static u32 functionality(struct i2c_adapter *adap)
 	return I2C_FUNC_SMBUS_EMUL;
 }
 
-static struct i2c_algorithm algo = {
+static const struct i2c_algorithm algo = {
 	.master_xfer   = stk1160_i2c_xfer,
 	.functionality = functionality,
 };

