Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:44312 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932747AbcJQMZV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 08:25:21 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Chris Mayo <aklhfex@gmail.com>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] libdvbv5: Improve vdr format output for DVB-T(2)
Date: Mon, 17 Oct 2016 14:24:32 +0200
Message-Id: <1476707072-21985-3-git-send-email-markus.heiser@darmarit.de>
In-Reply-To: <1476707072-21985-1-git-send-email-markus.heiser@darmarit.de>
References: <7C627C3A-DF3F-4E50-9876-7130D9221D96@darmarit.de>
 <1476707072-21985-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Chris Mayo <aklhfex@gmail.com>

Before (1.10.1):
BBC TWO:498000:S0B8C23D12I999M64T8G32Y0:T:27500:201:202,206:0:0:4287:0:0:0
BBC TWO HD:474167:S1B8C23D999I999M256T32G128Y0:T:27500:101:102,106:0:0:17472:0:0:0
After:
BBC TWO:498000:B8C23D12G32I999M64S0T8Y0:T:0:201:202,206:0:0:4287:0:0:0
BBC TWO HD:474167:B8C23D999G128I999M256S1T32Y0:T:27500:101:102,106:0:0:17472:0:0:0

channels.conf (vdr 2.2.0):
BBC TWO:498000000:B8C23D12G32M64S0T8Y0:T:0:201=2:202=eng@3,206=eng@3:0;205=eng:0:4287:9018:4163:0
BBC TWO HD:474166670:C23G128M256P0Q16436S1T32X1Y0:T:27500:101=27:102=eng@17,106=eng@17:0;105=eng:0:17472:9018:16515:0

Signed-off-by: Chris Mayo <aklhfex@gmail.com>
---
 lib/libdvbv5/dvb-vdr-format.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/lib/libdvbv5/dvb-vdr-format.c b/lib/libdvbv5/dvb-vdr-format.c
index ab0e5cf..3d09237 100644
--- a/lib/libdvbv5/dvb-vdr-format.c
+++ b/lib/libdvbv5/dvb-vdr-format.c
@@ -198,26 +198,26 @@ static const struct dvb_parse_table sys_dvbs2_table[] = {
 };
 
 static const struct dvb_parse_table sys_dvbt_table[] = {
-	{ DTV_DELIVERY_SYSTEM, PTABLE(vdr_parse_delivery_system) },
 	{ DTV_BANDWIDTH_HZ, PTABLE(vdr_parse_bandwidth) },
 	{ DTV_CODE_RATE_HP, PTABLE(vdr_parse_code_rate_hp) },
 	{ DTV_CODE_RATE_LP, PTABLE(vdr_parse_code_rate_lp) },
+	{ DTV_GUARD_INTERVAL, PTABLE(vdr_parse_guard_interval) },
 	{ DTV_INVERSION, PTABLE(vdr_parse_inversion) },
 	{ DTV_MODULATION, PTABLE(vdr_parse_modulation) },
+	{ DTV_DELIVERY_SYSTEM, PTABLE(vdr_parse_delivery_system) },
 	{ DTV_TRANSMISSION_MODE, PTABLE(vdr_parse_trans_mode) },
-	{ DTV_GUARD_INTERVAL, PTABLE(vdr_parse_guard_interval) },
 	{ DTV_HIERARCHY, PTABLE(vdr_parse_hierarchy) },
 };
 
 static const struct dvb_parse_table sys_dvbt2_table[] = {
-	{ DTV_DELIVERY_SYSTEM, PTABLE(vdr_parse_delivery_system) },
 	{ DTV_BANDWIDTH_HZ, PTABLE(vdr_parse_bandwidth) },
 	{ DTV_CODE_RATE_HP, PTABLE(vdr_parse_code_rate_hp) },
 	{ DTV_CODE_RATE_LP, PTABLE(vdr_parse_code_rate_lp) },
+	{ DTV_GUARD_INTERVAL, PTABLE(vdr_parse_guard_interval) },
 	{ DTV_INVERSION, PTABLE(vdr_parse_inversion) },
 	{ DTV_MODULATION, PTABLE(vdr_parse_modulation) },
+	{ DTV_DELIVERY_SYSTEM, PTABLE(vdr_parse_delivery_system) },
 	{ DTV_TRANSMISSION_MODE, PTABLE(vdr_parse_trans_mode) },
-	{ DTV_GUARD_INTERVAL, PTABLE(vdr_parse_guard_interval) },
 	{ DTV_HIERARCHY, PTABLE(vdr_parse_hierarchy) },
 	/* DVB-T2 specifics */
 	{ DTV_STREAM_ID, NULL, },
@@ -378,6 +378,9 @@ int dvb_write_format_vdr(const char *fname,
 		/* Output symbol rate */
 		srate = 27500000;
 		switch(delsys) {
+		case SYS_DVBT:
+			srate = 0;
+			break;
 		case SYS_DVBS:
 		case SYS_DVBS2:
 		case SYS_DVBC_ANNEX_A:
-- 
2.7.4

