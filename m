Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455Ab3CUK4C (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 06:56:02 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2LAu1H5013258
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 21 Mar 2013 06:56:01 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] [media] siano: use defines for firmware names
Date: Thu, 21 Mar 2013 07:55:54 -0300
Message-Id: <1363863355-3648-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are too many firmwares there. As we need to add
MODULE_FIMWARE() macros, the better is to define their names
on just one place and use the macros for both cards/device type
tables and MODULE_FIRMWARE().

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/sms-cards.c  | 14 ++++-----
 drivers/media/common/siano/smscoreapi.c | 56 ++++++++++++++++-----------------
 drivers/media/common/siano/smscoreapi.h | 24 ++++++++++++++
 3 files changed, 59 insertions(+), 35 deletions(-)

diff --git a/drivers/media/common/siano/sms-cards.c b/drivers/media/common/siano/sms-cards.c
index bb6e558..6680134 100644
--- a/drivers/media/common/siano/sms-cards.c
+++ b/drivers/media/common/siano/sms-cards.c
@@ -54,26 +54,26 @@ static struct sms_board sms_boards[] = {
 	[SMS1XXX_BOARD_HAUPPAUGE_CATAMOUNT] = {
 		.name	= "Hauppauge Catamount",
 		.type	= SMS_STELLAR,
-		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-stellar-dvbt-01.fw",
+		.fw[DEVICE_MODE_DVBT_BDA] = SMS_FW_DVBT_STELLAR,
 		.default_mode = DEVICE_MODE_DVBT_BDA,
 	},
 	[SMS1XXX_BOARD_HAUPPAUGE_OKEMO_A] = {
 		.name	= "Hauppauge Okemo-A",
 		.type	= SMS_NOVA_A0,
-		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-nova-a-dvbt-01.fw",
+		.fw[DEVICE_MODE_DVBT_BDA] = SMS_FW_DVBT_NOVA_A,
 		.default_mode = DEVICE_MODE_DVBT_BDA,
 	},
 	[SMS1XXX_BOARD_HAUPPAUGE_OKEMO_B] = {
 		.name	= "Hauppauge Okemo-B",
 		.type	= SMS_NOVA_B0,
-		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-nova-b-dvbt-01.fw",
+		.fw[DEVICE_MODE_DVBT_BDA] = SMS_FW_DVBT_NOVA_B,
 		.default_mode = DEVICE_MODE_DVBT_BDA,
 	},
 	[SMS1XXX_BOARD_HAUPPAUGE_WINDHAM] = {
 		.name	= "Hauppauge WinTV MiniStick",
 		.type	= SMS_NOVA_B0,
-		.fw[DEVICE_MODE_ISDBT_BDA] = "sms1xxx-hcw-55xxx-isdbt-02.fw",
-		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-hcw-55xxx-dvbt-02.fw",
+		.fw[DEVICE_MODE_ISDBT_BDA] = SMS_FW_ISDBT_HCW_55XXX,
+		.fw[DEVICE_MODE_DVBT_BDA]  = SMS_FW_DVBT_HCW_55XXX,
 		.default_mode = DEVICE_MODE_DVBT_BDA,
 		.rc_codes = RC_MAP_HAUPPAUGE,
 		.board_cfg.leds_power = 26,
@@ -87,7 +87,7 @@ static struct sms_board sms_boards[] = {
 	[SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD] = {
 		.name	= "Hauppauge WinTV MiniCard",
 		.type	= SMS_NOVA_B0,
-		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-hcw-55xxx-dvbt-02.fw",
+		.fw[DEVICE_MODE_DVBT_BDA] = SMS_FW_DVBT_HCW_55XXX,
 		.default_mode = DEVICE_MODE_DVBT_BDA,
 		.lna_ctrl  = 29,
 		.board_cfg.foreign_lna0_ctrl = 29,
@@ -97,7 +97,7 @@ static struct sms_board sms_boards[] = {
 	[SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2] = {
 		.name	= "Hauppauge WinTV MiniCard",
 		.type	= SMS_NOVA_B0,
-		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-hcw-55xxx-dvbt-02.fw",
+		.fw[DEVICE_MODE_DVBT_BDA] = SMS_FW_DVBT_HCW_55XXX,
 		.default_mode = DEVICE_MODE_DVBT_BDA,
 		.lna_ctrl  = -1,
 	},
diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index b5e40aa..b7aa63f 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -1048,50 +1048,50 @@ exit_fw_download:
 
 static char *smscore_fw_lkup[][DEVICE_MODE_MAX] = {
 	[SMS_NOVA_A0] = {
-		[DEVICE_MODE_DVBT]		= "dvb_nova_12mhz.inp",
-		[DEVICE_MODE_DVBH]		= "dvb_nova_12mhz.inp",
-		[DEVICE_MODE_DAB_TDMB]		= "tdmb_nova_12mhz.inp",
-		[DEVICE_MODE_DVBT_BDA]		= "dvb_nova_12mhz.inp",
-		[DEVICE_MODE_ISDBT]		= "isdbt_nova_12mhz.inp",
-		[DEVICE_MODE_ISDBT_BDA]		= "isdbt_nova_12mhz.inp",
+		[DEVICE_MODE_DVBT]		= SMS_FW_DVB_NOVA_12MHZ,
+		[DEVICE_MODE_DVBH]		= SMS_FW_DVB_NOVA_12MHZ,
+		[DEVICE_MODE_DAB_TDMB]		= SMS_FW_TDMB_NOVA_12MHZ,
+		[DEVICE_MODE_DVBT_BDA]		= SMS_FW_DVB_NOVA_12MHZ,
+		[DEVICE_MODE_ISDBT]		= SMS_FW_ISDBT_NOVA_12MHZ,
+		[DEVICE_MODE_ISDBT_BDA]		= SMS_FW_ISDBT_NOVA_12MHZ,
 	},
 	[SMS_NOVA_B0] = {
-		[DEVICE_MODE_DVBT]		= "dvb_nova_12mhz_b0.inp",
-		[DEVICE_MODE_DVBH]		= "dvb_nova_12mhz_b0.inp",
-		[DEVICE_MODE_DAB_TDMB]		= "tdmb_nova_12mhz_b0.inp",
-		[DEVICE_MODE_DVBT_BDA]		= "dvb_nova_12mhz_b0.inp",
-		[DEVICE_MODE_ISDBT]		= "isdbt_nova_12mhz_b0.inp",
-		[DEVICE_MODE_ISDBT_BDA]		= "isdbt_nova_12mhz_b0.inp",
-		[DEVICE_MODE_FM_RADIO]		= "fm_radio.inp",
-		[DEVICE_MODE_FM_RADIO_BDA]	= "fm_radio.inp",
+		[DEVICE_MODE_DVBT]		= SMS_FW_DVB_NOVA_12MHZ_B0,
+		[DEVICE_MODE_DVBH]		= SMS_FW_DVB_NOVA_12MHZ_B0,
+		[DEVICE_MODE_DAB_TDMB]		= SMS_FW_TDMB_NOVA_12MHZ_B0,
+		[DEVICE_MODE_DVBT_BDA]		= SMS_FW_DVB_NOVA_12MHZ_B0,
+		[DEVICE_MODE_ISDBT]		= SMS_FW_ISDBT_NOVA_12MHZ_B0,
+		[DEVICE_MODE_ISDBT_BDA]		= SMS_FW_ISDBT_NOVA_12MHZ_B0,
+		[DEVICE_MODE_FM_RADIO]		= SMS_FW_FM_RADIO,
+		[DEVICE_MODE_FM_RADIO_BDA]	= SMS_FW_FM_RADIO,
 	},
 	[SMS_VEGA] = {
-		[DEVICE_MODE_CMMB]		= "cmmb_vega_12mhz.inp",
+		[DEVICE_MODE_CMMB]		= SMS_FW_CMMB_VEGA_12MHZ,
 	},
 	[SMS_VENICE] = {
-		[DEVICE_MODE_CMMB]		= "cmmb_venice_12mhz.inp",
+		[DEVICE_MODE_CMMB]		= SMS_FW_CMMB_VENICE_12MHZ,
 	},
 	[SMS_MING] = {
-		[DEVICE_MODE_CMMB]		= "cmmb_ming_app.inp",
+		[DEVICE_MODE_CMMB]		= SMS_FW_CMMB_MING_APP,
 	},
 	[SMS_PELE] = {
-		[DEVICE_MODE_ISDBT]		= "isdbt_pele.inp",
-		[DEVICE_MODE_ISDBT_BDA]		= "isdbt_pele.inp",
+		[DEVICE_MODE_ISDBT]		= SMS_FW_ISDBT_PELE,
+		[DEVICE_MODE_ISDBT_BDA]		= SMS_FW_ISDBT_PELE,
 	},
 	[SMS_RIO] = {
-		[DEVICE_MODE_DVBT]		= "dvb_rio.inp",
-		[DEVICE_MODE_DVBH]		= "dvbh_rio.inp",
-		[DEVICE_MODE_DVBT_BDA]		= "dvb_rio.inp",
-		[DEVICE_MODE_ISDBT]		= "isdbt_rio.inp",
-		[DEVICE_MODE_ISDBT_BDA]		= "isdbt_rio.inp",
-		[DEVICE_MODE_FM_RADIO]		= "fm_radio_rio.inp",
-		[DEVICE_MODE_FM_RADIO_BDA]	= "fm_radio_rio.inp",
+		[DEVICE_MODE_DVBT]		= SMS_FW_DVB_RIO,
+		[DEVICE_MODE_DVBH]		= SMS_FW_DVBH_RIO,
+		[DEVICE_MODE_DVBT_BDA]		= SMS_FW_DVB_RIO,
+		[DEVICE_MODE_ISDBT]		= SMS_FW_ISDBT_RIO,
+		[DEVICE_MODE_ISDBT_BDA]		= SMS_FW_ISDBT_RIO,
+		[DEVICE_MODE_FM_RADIO]		= SMS_FW_FM_RADIO_RIO,
+		[DEVICE_MODE_FM_RADIO_BDA]	= SMS_FW_FM_RADIO_RIO,
 	},
 	[SMS_DENVER_1530] = {
-		[DEVICE_MODE_ATSC]		= "atsc_denver.inp",
+		[DEVICE_MODE_ATSC]		= SMS_FW_ATSC_DENVER,
 	},
 	[SMS_DENVER_2160] = {
-		[DEVICE_MODE_DAB_TDMB]		= "tdmb_denver.inp",
+		[DEVICE_MODE_DAB_TDMB]		= SMS_FW_TDMB_DENVER,
 	},
 };
 
diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index 53b81cb..a9672e0 100644
--- a/drivers/media/common/siano/smscoreapi.h
+++ b/drivers/media/common/siano/smscoreapi.h
@@ -44,6 +44,30 @@ along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #define min(a, b) (((a) < (b)) ? (a) : (b))
 #endif
 
+/* Define the firmware names used by the driver */
+#define SMS_FW_ATSC_DENVER         "atsc_denver.inp"
+#define SMS_FW_CMMB_MING_APP       "cmmb_ming_app.inp"
+#define SMS_FW_CMMB_VEGA_12MHZ     "cmmb_vega_12mhz.inp"
+#define SMS_FW_CMMB_VENICE_12MHZ   "cmmb_venice_12mhz.inp"
+#define SMS_FW_DVBH_RIO            "dvbh_rio.inp"
+#define SMS_FW_DVB_NOVA_12MHZ_B0   "dvb_nova_12mhz_b0.inp"
+#define SMS_FW_DVB_NOVA_12MHZ      "dvb_nova_12mhz.inp"
+#define SMS_FW_DVB_RIO             "dvb_rio.inp"
+#define SMS_FW_FM_RADIO            "fm_radio.inp"
+#define SMS_FW_FM_RADIO_RIO        "fm_radio_rio.inp"
+#define SMS_FW_DVBT_HCW_55XXX      "sms1xxx-hcw-55xxx-dvbt-02.fw"
+#define SMS_FW_ISDBT_HCW_55XXX     "sms1xxx-hcw-55xxx-isdbt-02.fw"
+#define SMS_FW_ISDBT_NOVA_12MHZ_B0 "isdbt_nova_12mhz_b0.inp"
+#define SMS_FW_ISDBT_NOVA_12MHZ    "isdbt_nova_12mhz.inp"
+#define SMS_FW_ISDBT_PELE          "isdbt_pele.inp"
+#define SMS_FW_ISDBT_RIO           "isdbt_rio.inp"
+#define SMS_FW_DVBT_NOVA_A         "sms1xxx-nova-a-dvbt-01.fw"
+#define SMS_FW_DVBT_NOVA_B         "sms1xxx-nova-b-dvbt-01.fw"
+#define SMS_FW_DVBT_STELLAR        "sms1xxx-stellar-dvbt-01.fw"
+#define SMS_FW_TDMB_DENVER         "tdmb_denver.inp"
+#define SMS_FW_TDMB_NOVA_12MHZ_B0  "tdmb_nova_12mhz_b0.inp"
+#define SMS_FW_TDMB_NOVA_12MHZ     "tdmb_nova_12mhz.inp"
+
 #define SMS_PROTOCOL_MAX_RAOUNDTRIP_MS			(10000)
 #define SMS_ALLOC_ALIGNMENT				128
 #define SMS_DMA_ALIGNMENT				16
-- 
1.8.1.4

