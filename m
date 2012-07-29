Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp23.services.sfr.fr ([93.17.128.19]:36429 "EHLO
	smtp23.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab2G2Uu4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Jul 2012 16:50:56 -0400
Message-ID: <5015A22C.7050501@sfr.fr>
Date: Sun, 29 Jul 2012 22:50:52 +0200
From: Patrice Chotard <patrice.chotard@sfr.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Patrice Chotard <patrice.chotard@sfr.fr>
Subject: [PATCH 1/2] [media] dvb: add support for Thomson DTT7520X
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[media] dvb: add support for Thomson DTT7520X

Add support for Thomson DTT7520X pll needed by
ngene card Terratec Cynergy 2400i DT

Signed-off-by: Patrice Chotard <patricechotard@free.fr>
---
 drivers/media/dvb/frontends/dvb-pll.c |   26 ++++++++++++++++++++++++++
 drivers/media/dvb/frontends/dvb-pll.h |    1 +
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/frontends/dvb-pll.c
b/drivers/media/dvb/frontends/dvb-pll.c
index 1ab3483..6d8fe88 100644
--- a/drivers/media/dvb/frontends/dvb-pll.c
+++ b/drivers/media/dvb/frontends/dvb-pll.c
@@ -116,6 +116,31 @@ static struct dvb_pll_desc dvb_pll_thomson_dtt759x = {
 	},
 };

+static void thomson_dtt7520x_bw(struct dvb_frontend *fe, u8 *buf)
+{
+	u32 bw = fe->dtv_property_cache.bandwidth_hz;
+	if (bw == 8000000)
+		buf[3] ^= 0x10;
+}
+
+static struct dvb_pll_desc dvb_pll_thomson_dtt7520x = {
+	.name  = "Thomson dtt7520x",
+	.min   = 185000000,
+	.max   = 900000000,
+	.set   = thomson_dtt7520x_bw,
+	.iffreq = 36166667,
+	.count = 7,
+	.entries = {
+		{  305000000, 166667, 0xb4, 0x12 },
+		{  405000000, 166667, 0xbc, 0x12 },
+		{  445000000, 166667, 0xbc, 0x12 },
+		{  465000000, 166667, 0xf4, 0x18 },
+		{  735000000, 166667, 0xfc, 0x18 },
+		{  835000000, 166667, 0xbc, 0x18 },
+		{  999999999, 166667, 0xfc, 0x18 },
+	},
+};
+
 static struct dvb_pll_desc dvb_pll_lg_z201 = {
 	.name  = "LG z201",
 	.min   = 174000000,
@@ -513,6 +538,7 @@ static struct dvb_pll_desc *pll_list[] = {
 	[DVB_PLL_UNDEFINED]              = NULL,
 	[DVB_PLL_THOMSON_DTT7579]        = &dvb_pll_thomson_dtt7579,
 	[DVB_PLL_THOMSON_DTT759X]        = &dvb_pll_thomson_dtt759x,
+	[DVB_PLL_THOMSON_DTT7520X]       = &dvb_pll_thomson_dtt7520x,
 	[DVB_PLL_LG_Z201]                = &dvb_pll_lg_z201,
 	[DVB_PLL_UNKNOWN_1]              = &dvb_pll_unknown_1,
 	[DVB_PLL_TUA6010XS]              = &dvb_pll_tua6010xs,
diff --git a/drivers/media/dvb/frontends/dvb-pll.h
b/drivers/media/dvb/frontends/dvb-pll.h
index 0869643..4de754f 100644
--- a/drivers/media/dvb/frontends/dvb-pll.h
+++ b/drivers/media/dvb/frontends/dvb-pll.h
@@ -27,6 +27,7 @@
 #define DVB_PLL_SAMSUNG_TBDU18132      16
 #define DVB_PLL_SAMSUNG_TBMU24112      17
 #define DVB_PLL_TDEE4		       18
+#define DVB_PLL_THOMSON_DTT7520X       19

 /**
  * Attach a dvb-pll to the supplied frontend structure.
-- 1.7.9.1
