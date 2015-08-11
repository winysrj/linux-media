Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42771 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbbHKSNV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 14:13:21 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Sergey Kozlov <serjk@netup.ru>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] cxd2841er: declare static functions as such
Date: Tue, 11 Aug 2015 15:11:39 -0300
Message-Id: <1439316699-3487-1-git-send-email-mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/cxd2841er.c:992:5: warning: no previous prototype for 'cxd2841er_get_carrier_offset_t2' [-Wmissing-prototypes]
 int cxd2841er_get_carrier_offset_t2(
     ^
drivers/media/dvb-frontends/cxd2841er.c:1032:5: warning: no previous prototype for 'cxd2841er_get_carrier_offset_c' [-Wmissing-prototypes]
 int cxd2841er_get_carrier_offset_c(
     ^
drivers/media/dvb-frontends/cxd2841er.c:1360:5: warning: no previous prototype for 'cxd2841er_read_snr_t2' [-Wmissing-prototypes]
 int cxd2841er_read_snr_t2(struct cxd2841er_priv *priv, u32 *snr)
     ^

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-frontends/cxd2841er.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index d3813cc22770..0d1a15109d1e 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -989,8 +989,8 @@ static int cxd2841er_get_carrier_offset_s_s2(struct cxd2841er_priv *priv,
 	return 0;
 }
 
-int cxd2841er_get_carrier_offset_t2(
-	struct cxd2841er_priv *priv, u32 bandwidth, int *offset)
+static int cxd2841er_get_carrier_offset_t2(struct cxd2841er_priv *priv,
+					   u32 bandwidth, int *offset)
 {
 	u8 data[4];
 
@@ -1029,8 +1029,8 @@ int cxd2841er_get_carrier_offset_t2(
 	return 0;
 }
 
-int cxd2841er_get_carrier_offset_c(
-	struct cxd2841er_priv *priv, int *offset)
+static int cxd2841er_get_carrier_offset_c(struct cxd2841er_priv *priv,
+					  int *offset)
 {
 	u8 data[2];
 
@@ -1357,7 +1357,7 @@ static int cxd2841er_read_snr_t(struct cxd2841er_priv *priv, u32 *snr)
 	return 0;
 }
 
-int cxd2841er_read_snr_t2(struct cxd2841er_priv *priv, u32 *snr)
+static int cxd2841er_read_snr_t2(struct cxd2841er_priv *priv, u32 *snr)
 {
 	u32 reg;
 	u8 data[2];
-- 
2.4.3

