Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34090 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750844AbdBSSHF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Feb 2017 13:07:05 -0500
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] media: pci: constify stv0299_config structures
Date: Sun, 19 Feb 2017 23:34:41 +0530
Message-Id: <1487527481-20392-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Declare stv0299_config structures as const as they are only passed as
an argument to the function dvb_attach. dvb_attach
calls its first argument on the rest of its arguments. The first
argument of dvb_attach in the changed cases is stv0299_attach and 
the parameter of this function to which the object references are passed
is of type const. So, stv0299_config structures having this property 
can be made const.

First line shows the file size before patching and second one shows size 
after patching.

   text	   data	    bss	    dec	    hex	filename
   9572	    926	     40	  10538	   292a media/pci/dm1105/dm1105.o
   9636	    862	     40	  10538	   292a media/pci/dm1105/dm1105.o

  15133	   5408	      0	  20541	   503d	media/pci/ttpci/budget-av.o
  15389	   5152	      0	  20541	   503d media/pci/ttpci/budget-av.o

  15703	   2326	     36	  18065	   4691	media/pci/ttpci/budget-ci.o
  15767	   2262	     36	  18065	   4691 media/pci/ttpci/budget-ci.o

  10555	   1918	      4	  12477	   30bd	drivers/media/pci/ttpci/budget.o
  10683	   1822	      4	  12509	   30dd	drivers/media/pci/ttpci/budget.o

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/pci/dm1105/dm1105.c   | 2 +-
 drivers/media/pci/ttpci/budget-av.c | 8 ++++----
 drivers/media/pci/ttpci/budget-ci.c | 2 +-
 drivers/media/pci/ttpci/budget.c    | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
index a589aa7..c97a98b 100644
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -820,7 +820,7 @@ static void dm1105_hw_exit(struct dm1105_dev *dev)
 	dm1105_dma_unmap(dev);
 }
 
-static struct stv0299_config sharp_z0194a_config = {
+static const struct stv0299_config sharp_z0194a_config = {
 	.demod_address = 0x68,
 	.inittab = sharp_z0194a_inittab,
 	.mclk = 88000000UL,
diff --git a/drivers/media/pci/ttpci/budget-av.c b/drivers/media/pci/ttpci/budget-av.c
index 896c66d..48ea605 100644
--- a/drivers/media/pci/ttpci/budget-av.c
+++ b/drivers/media/pci/ttpci/budget-av.c
@@ -580,7 +580,7 @@ static int philips_su1278_ty_ci_tuner_set_params(struct dvb_frontend *fe)
 	0xff, 0xff
 };
 
-static struct stv0299_config typhoon_config = {
+static const struct stv0299_config typhoon_config = {
 	.demod_address = 0x68,
 	.inittab = typhoon_cinergy1200s_inittab,
 	.mclk = 88000000UL,
@@ -593,7 +593,7 @@ static int philips_su1278_ty_ci_tuner_set_params(struct dvb_frontend *fe)
 };
 
 
-static struct stv0299_config cinergy_1200s_config = {
+static const struct stv0299_config cinergy_1200s_config = {
 	.demod_address = 0x68,
 	.inittab = typhoon_cinergy1200s_inittab,
 	.mclk = 88000000UL,
@@ -605,7 +605,7 @@ static int philips_su1278_ty_ci_tuner_set_params(struct dvb_frontend *fe)
 	.set_symbol_rate = philips_su1278_ty_ci_set_symbol_rate,
 };
 
-static struct stv0299_config cinergy_1200s_1894_0010_config = {
+static const struct stv0299_config cinergy_1200s_1894_0010_config = {
 	.demod_address = 0x68,
 	.inittab = typhoon_cinergy1200s_inittab,
 	.mclk = 88000000UL,
@@ -879,7 +879,7 @@ static int philips_sd1878_ci_set_symbol_rate(struct dvb_frontend *fe,
 	return 0;
 }
 
-static struct stv0299_config philips_sd1878_config = {
+static const struct stv0299_config philips_sd1878_config = {
 	.demod_address = 0x68,
      .inittab = philips_sd1878_inittab,
 	.mclk = 88000000UL,
diff --git a/drivers/media/pci/ttpci/budget-ci.c b/drivers/media/pci/ttpci/budget-ci.c
index 20ad93b..ff8a60e 100644
--- a/drivers/media/pci/ttpci/budget-ci.c
+++ b/drivers/media/pci/ttpci/budget-ci.c
@@ -696,7 +696,7 @@ static int philips_su1278_tt_tuner_set_params(struct dvb_frontend *fe)
 	return 0;
 }
 
-static struct stv0299_config philips_su1278_tt_config = {
+static const struct stv0299_config philips_su1278_tt_config = {
 
 	.demod_address = 0x68,
 	.inittab = philips_su1278_tt_inittab,
diff --git a/drivers/media/pci/ttpci/budget.c b/drivers/media/pci/ttpci/budget.c
index 3091b48..83510df 100644
--- a/drivers/media/pci/ttpci/budget.c
+++ b/drivers/media/pci/ttpci/budget.c
@@ -400,7 +400,7 @@ static int s5h1420_tuner_set_params(struct dvb_frontend *fe)
 	.xtal_freq = TDA10086_XTAL_16M,
 };
 
-static struct stv0299_config alps_bsru6_config_activy = {
+static const struct stv0299_config alps_bsru6_config_activy = {
 	.demod_address = 0x68,
 	.inittab = alps_bsru6_inittab,
 	.mclk = 88000000UL,
@@ -410,7 +410,7 @@ static int s5h1420_tuner_set_params(struct dvb_frontend *fe)
 	.set_symbol_rate = alps_bsru6_set_symbol_rate,
 };
 
-static struct stv0299_config alps_bsbe1_config_activy = {
+static const struct stv0299_config alps_bsbe1_config_activy = {
 	.demod_address = 0x68,
 	.inittab = alps_bsbe1_inittab,
 	.mclk = 88000000UL,
-- 
1.9.1
