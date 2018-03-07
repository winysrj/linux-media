Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:53294 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751225AbeCGKOA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Mar 2018 05:14:00 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
Subject: [PATCH] media: cxd2880: Fix location of DVB headers
Date: Wed,  7 Mar 2018 05:13:55 -0500
Message-Id: <7cbc3013f60dbc22955645443855c8f092d3c534.1520417633.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a trivial conflict, where the location of DVB headers
got moved.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c           | 2 +-
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.c      | 2 +-
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c     | 2 +-
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.c | 2 +-
 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.c  | 2 +-
 drivers/media/dvb-frontends/cxd2880/cxd2880_top.c              | 4 ++--
 drivers/media/spi/cxd2880-spi.c                                | 6 +++---
 7 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c
index b9ef134aed79..25851bbb846e 100644
--- a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c
@@ -7,7 +7,7 @@
  * Copyright (C) 2016, 2017, 2018 Sony Semiconductor Solutions Corporation
  */
 
-#include "dvb_frontend.h"
+#include <media/dvb_frontend.h>
 #include "cxd2880_common.h"
 #include "cxd2880_tnrdmd.h"
 #include "cxd2880_tnrdmd_mon.h"
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.c
index e1ad5187ad8f..fe3c6f8b1b3e 100644
--- a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.c
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.c
@@ -7,7 +7,7 @@
  * Copyright (C) 2016, 2017, 2018 Sony Semiconductor Solutions Corporation
  */
 
-#include "dvb_frontend.h"
+#include <media/dvb_frontend.h>
 
 #include "cxd2880_tnrdmd_dvbt.h"
 #include "cxd2880_tnrdmd_dvbt_mon.h"
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c
index 81903102b12f..dd32004a12d8 100644
--- a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c
@@ -7,7 +7,7 @@
  * Copyright (C) 2016, 2017, 2018 Sony Semiconductor Solutions Corporation
  */
 
-#include "dvb_frontend.h"
+#include <media/dvb_frontend.h>
 
 #include "cxd2880_tnrdmd_dvbt2.h"
 #include "cxd2880_tnrdmd_dvbt2_mon.h"
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.c
index 5296cbbca8bd..604580bf7cf7 100644
--- a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.c
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.c
@@ -11,7 +11,7 @@
 #include "cxd2880_tnrdmd_dvbt2.h"
 #include "cxd2880_tnrdmd_dvbt2_mon.h"
 
-#include "dvb_math.h"
+#include <media/dvb_math.h>
 
 static const int ref_dbm_1000[4][8] = {
 	{-96000, -95000, -94000, -93000, -92000, -92000, -98000, -97000},
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.c
index 78214a99a5df..fedc3b4a2fa0 100644
--- a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.c
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.c
@@ -11,7 +11,7 @@
 #include "cxd2880_tnrdmd_dvbt.h"
 #include "cxd2880_tnrdmd_dvbt_mon.h"
 
-#include "dvb_math.h"
+#include <media/dvb_math.h>
 
 static const int ref_dbm_1000[3][5] = {
 	{-93000, -91000, -90000, -89000, -88000},
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_top.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_top.c
index f109e9d98cc0..05360a11bea9 100644
--- a/drivers/media/dvb-frontends/cxd2880/cxd2880_top.c
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_top.c
@@ -10,8 +10,8 @@
 
 #include <linux/spi/spi.h>
 
-#include "dvb_frontend.h"
-#include "dvb_math.h"
+#include <media/dvb_frontend.h>
+#include <media/dvb_math.h>
 
 #include "cxd2880.h"
 #include "cxd2880_tnrdmd_mon.h"
diff --git a/drivers/media/spi/cxd2880-spi.c b/drivers/media/spi/cxd2880-spi.c
index 857e4c0d7a92..4df3bd312f48 100644
--- a/drivers/media/spi/cxd2880-spi.c
+++ b/drivers/media/spi/cxd2880-spi.c
@@ -12,9 +12,9 @@
 #include <linux/spi/spi.h>
 #include <linux/ktime.h>
 
-#include "dvb_demux.h"
-#include "dmxdev.h"
-#include "dvb_frontend.h"
+#include <media/dvb_demux.h>
+#include <media/dmxdev.h>
+#include <media/dvb_frontend.h>
 #include "cxd2880.h"
 
 #define CXD2880_MAX_FILTER_SIZE 32
-- 
2.14.3
