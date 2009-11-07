Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42365 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753401AbZKGVul convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2009 16:50:41 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Nov 2009 21:50:44 +0000
Message-ID: <1257630644.15927.417.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 24/75] smsmdtv/smsusb: declare MODULE_FIRMWARE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/dvb/siano/sms-cards.c  |    4 ++++
 drivers/media/dvb/siano/smscoreapi.c |    7 +++++++
 drivers/media/dvb/siano/smsusb.c     |    4 ++++
 3 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/siano/sms-cards.c b/drivers/media/dvb/siano/sms-cards.c
index e216389..9c425d7 100644
--- a/drivers/media/dvb/siano/sms-cards.c
+++ b/drivers/media/dvb/siano/sms-cards.c
@@ -96,6 +96,10 @@ static struct sms_board sms_boards[] = {
 		.type = SMS_VEGA,
 	},
 };
+MODULE_FIRMWARE("sms1xxx-stellar-dvbt-01.fw");
+MODULE_FIRMWARE("sms1xxx-nova-a-dvbt-01.fw");
+MODULE_FIRMWARE("sms1xxx-nova-b-dvbt-01.fw");
+MODULE_FIRMWARE("sms1xxx-hcw-55xxx-dvbt-02.fw");
 
 struct sms_board *sms_get_board(int id)
 {
diff --git a/drivers/media/dvb/siano/smscoreapi.c b/drivers/media/dvb/siano/smscoreapi.c
index ca758bc..c613f0d 100644
--- a/drivers/media/dvb/siano/smscoreapi.c
+++ b/drivers/media/dvb/siano/smscoreapi.c
@@ -790,6 +790,13 @@ static char *smscore_fw_lkup[][SMS_NUM_OF_DEVICE_TYPES] = {
 	/*CMMB*/
 	{"none", "none", "none", "cmmb_vega_12mhz.inp"}
 };
+MODULE_FIRMWARE("dvb_nova_12mhz.inp");
+MODULE_FIRMWARE("dvb_nova_12mhz_b0.inp");
+MODULE_FIRMWARE("tdmb_nova_12mhz.inp");
+MODULE_FIRMWARE("tdmb_nova_12mhz_b0.inp");
+MODULE_FIRMWARE("isdbt_nova_12mhz.inp");
+MODULE_FIRMWARE("isdbt_nova_12mhz_b0.inp");
+MODULE_FIRMWARE("cmmb_vega_12mhz.inp");
 
 static inline char *sms_get_fw_name(struct smscore_device_t *coredev,
 				    int mode, enum sms_device_type_st type)
diff --git a/drivers/media/dvb/siano/smsusb.c b/drivers/media/dvb/siano/smsusb.c
index 8f88a58..a97bf96 100644
--- a/drivers/media/dvb/siano/smsusb.c
+++ b/drivers/media/dvb/siano/smsusb.c
@@ -193,6 +193,10 @@ static char *smsusb1_fw_lkup[] = {
 	"none",
 	"dvbt_bda_stellar_usb.inp",
 };
+MODULE_FIRMWARE("dvbt_stellar_usb.inp");
+MODULE_FIRMWARE("dvbh_stellar_usb.inp");
+MODULE_FIRMWARE("tdmb_stellar_usb.inp");
+MODULE_FIRMWARE("dvbt_bda_stellar_usb.inp");
 
 static inline char *sms_get_fw_name(int mode, int board_id)
 {
-- 
1.6.5.2



