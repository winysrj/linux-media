Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36758 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752020AbdHSKet (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Aug 2017 06:34:49 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, wsa@the-dreams.de, jacmet@sunsite.dk,
        jglauber@cavium.com, david.daney@cavium.com,
        hans.verkuil@cisco.com, mchehab@kernel.org,
        awalls@md.metrocast.net, serjk@netup.ru, aospan@netup.ru,
        isely@pobox.com, ezequiel@vanguardiasur.com.ar,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 2/4] [media] media: pci: make i2c_adapter const
Date: Sat, 19 Aug 2017 16:04:13 +0530
Message-Id: <1503138855-585-3-git-send-email-bhumirks@gmail.com>
In-Reply-To: <1503138855-585-1-git-send-email-bhumirks@gmail.com>
References: <1503138855-585-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make these const as they are only used in a copy operation.
Done using Coccinelle

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/pci/cobalt/cobalt-i2c.c             | 2 +-
 drivers/media/pci/cx18/cx18-i2c.c                 | 2 +-
 drivers/media/pci/cx23885/cx23885-i2c.c           | 2 +-
 drivers/media/pci/cx25821/cx25821-i2c.c           | 2 +-
 drivers/media/pci/ivtv/ivtv-i2c.c                 | 4 ++--
 drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c | 2 +-
 drivers/media/pci/saa7134/saa7134-i2c.c           | 2 +-
 drivers/media/pci/saa7164/saa7164-i2c.c           | 2 +-
 8 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/pci/cobalt/cobalt-i2c.c b/drivers/media/pci/cobalt/cobalt-i2c.c
index ad16b89..1a5c556 100644
--- a/drivers/media/pci/cobalt/cobalt-i2c.c
+++ b/drivers/media/pci/cobalt/cobalt-i2c.c
@@ -301,7 +301,7 @@ static u32 cobalt_func(struct i2c_adapter *adap)
 }
 
 /* template for i2c-bit-algo */
-static struct i2c_adapter cobalt_i2c_adap_template = {
+static const struct i2c_adapter cobalt_i2c_adap_template = {
 	.name = "cobalt i2c driver",
 	.algo = NULL,                   /* set by i2c-algo-bit */
 	.algo_data = NULL,              /* filled from template */
diff --git a/drivers/media/pci/cx18/cx18-i2c.c b/drivers/media/pci/cx18/cx18-i2c.c
index eabdd4c..2eb62b2 100644
--- a/drivers/media/pci/cx18/cx18-i2c.c
+++ b/drivers/media/pci/cx18/cx18-i2c.c
@@ -206,7 +206,7 @@ static int cx18_getsda(void *data)
 }
 
 /* template for i2c-bit-algo */
-static struct i2c_adapter cx18_i2c_adap_template = {
+static const struct i2c_adapter cx18_i2c_adap_template = {
 	.name = "cx18 i2c driver",
 	.algo = NULL,                   /* set by i2c-algo-bit */
 	.algo_data = NULL,              /* filled from template */
diff --git a/drivers/media/pci/cx23885/cx23885-i2c.c b/drivers/media/pci/cx23885/cx23885-i2c.c
index 8528032..0f21467 100644
--- a/drivers/media/pci/cx23885/cx23885-i2c.c
+++ b/drivers/media/pci/cx23885/cx23885-i2c.c
@@ -264,7 +264,7 @@ static u32 cx23885_functionality(struct i2c_adapter *adap)
 
 /* ----------------------------------------------------------------------- */
 
-static struct i2c_adapter cx23885_i2c_adap_template = {
+static const struct i2c_adapter cx23885_i2c_adap_template = {
 	.name              = "cx23885",
 	.owner             = THIS_MODULE,
 	.algo              = &cx23885_i2c_algo_template,
diff --git a/drivers/media/pci/cx25821/cx25821-i2c.c b/drivers/media/pci/cx25821/cx25821-i2c.c
index 263a1cf..000049d 100644
--- a/drivers/media/pci/cx25821/cx25821-i2c.c
+++ b/drivers/media/pci/cx25821/cx25821-i2c.c
@@ -285,7 +285,7 @@ static u32 cx25821_functionality(struct i2c_adapter *adap)
 #endif
 };
 
-static struct i2c_adapter cx25821_i2c_adap_template = {
+static const struct i2c_adapter cx25821_i2c_adap_template = {
 	.name = "cx25821",
 	.owner = THIS_MODULE,
 	.algo = &cx25821_i2c_algo_template,
diff --git a/drivers/media/pci/ivtv/ivtv-i2c.c b/drivers/media/pci/ivtv/ivtv-i2c.c
index dea80ef..1ef6c72 100644
--- a/drivers/media/pci/ivtv/ivtv-i2c.c
+++ b/drivers/media/pci/ivtv/ivtv-i2c.c
@@ -632,7 +632,7 @@ static u32 ivtv_functionality(struct i2c_adapter *adap)
 };
 
 /* template for our-bit banger */
-static struct i2c_adapter ivtv_i2c_adap_hw_template = {
+static const struct i2c_adapter ivtv_i2c_adap_hw_template = {
 	.name = "ivtv i2c driver",
 	.algo = &ivtv_algo,
 	.algo_data = NULL,			/* filled from template */
@@ -682,7 +682,7 @@ static int ivtv_getsda_old(void *data)
 }
 
 /* template for i2c-bit-algo */
-static struct i2c_adapter ivtv_i2c_adap_template = {
+static const struct i2c_adapter ivtv_i2c_adap_template = {
 	.name = "ivtv i2c driver",
 	.algo = NULL,                   /* set by i2c-algo-bit */
 	.algo_data = NULL,              /* filled from template */
diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c b/drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c
index b49e4f9..b13e319 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c
@@ -300,7 +300,7 @@ static u32 netup_i2c_func(struct i2c_adapter *adap)
 	.functionality	= netup_i2c_func,
 };
 
-static struct i2c_adapter netup_i2c_adapter = {
+static const struct i2c_adapter netup_i2c_adapter = {
 	.owner		= THIS_MODULE,
 	.name		= NETUP_UNIDVB_NAME,
 	.class		= I2C_CLASS_HWMON | I2C_CLASS_SPD,
diff --git a/drivers/media/pci/saa7134/saa7134-i2c.c b/drivers/media/pci/saa7134/saa7134-i2c.c
index 9d0e69e..8f2ed63 100644
--- a/drivers/media/pci/saa7134/saa7134-i2c.c
+++ b/drivers/media/pci/saa7134/saa7134-i2c.c
@@ -339,7 +339,7 @@ static u32 functionality(struct i2c_adapter *adap)
 	.functionality = functionality,
 };
 
-static struct i2c_adapter saa7134_adap_template = {
+static const struct i2c_adapter saa7134_adap_template = {
 	.owner         = THIS_MODULE,
 	.name          = "saa7134",
 	.algo          = &saa7134_algo,
diff --git a/drivers/media/pci/saa7164/saa7164-i2c.c b/drivers/media/pci/saa7164/saa7164-i2c.c
index 430f678..4bcde7c 100644
--- a/drivers/media/pci/saa7164/saa7164-i2c.c
+++ b/drivers/media/pci/saa7164/saa7164-i2c.c
@@ -78,7 +78,7 @@ static u32 saa7164_functionality(struct i2c_adapter *adap)
 
 /* ----------------------------------------------------------------------- */
 
-static struct i2c_adapter saa7164_i2c_adap_template = {
+static const struct i2c_adapter saa7164_i2c_adap_template = {
 	.name              = "saa7164",
 	.owner             = THIS_MODULE,
 	.algo              = &saa7164_i2c_algo_template,
-- 
1.9.1
