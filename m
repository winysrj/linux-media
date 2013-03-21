Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755559Ab3CUK4C (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 06:56:02 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2LAu2hB013262
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 21 Mar 2013 06:56:02 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] [media] siano: add MODULE_FIRMWARE() macros
Date: Thu, 21 Mar 2013 07:55:55 -0300
Message-Id: <1363863355-3648-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363863355-3648-1-git-send-email-mchehab@redhat.com>
References: <1363863355-3648-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver can use several firmwares. Provide such info at
module firmware metadata.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smscoreapi.c | 24 ++++++++++++++++++++++++
 drivers/media/common/siano/smscoreapi.h |  6 +++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index b7aa63f..5006d1c 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -2174,3 +2174,27 @@ module_exit(smscore_module_exit);
 MODULE_DESCRIPTION("Siano MDTV Core module");
 MODULE_AUTHOR("Siano Mobile Silicon, Inc. (uris@siano-ms.com)");
 MODULE_LICENSE("GPL");
+
+/* This should match what's defined at smscoreapi.h */
+MODULE_FIRMWARE(SMS_FW_ATSC_DENVER);
+MODULE_FIRMWARE(SMS_FW_CMMB_MING_APP);
+MODULE_FIRMWARE(SMS_FW_CMMB_VEGA_12MHZ);
+MODULE_FIRMWARE(SMS_FW_CMMB_VENICE_12MHZ);
+MODULE_FIRMWARE(SMS_FW_DVBH_RIO);
+MODULE_FIRMWARE(SMS_FW_DVB_NOVA_12MHZ_B0);
+MODULE_FIRMWARE(SMS_FW_DVB_NOVA_12MHZ);
+MODULE_FIRMWARE(SMS_FW_DVB_RIO);
+MODULE_FIRMWARE(SMS_FW_FM_RADIO);
+MODULE_FIRMWARE(SMS_FW_FM_RADIO_RIO);
+MODULE_FIRMWARE(SMS_FW_DVBT_HCW_55XXX);
+MODULE_FIRMWARE(SMS_FW_ISDBT_HCW_55XXX);
+MODULE_FIRMWARE(SMS_FW_ISDBT_NOVA_12MHZ_B0);
+MODULE_FIRMWARE(SMS_FW_ISDBT_NOVA_12MHZ);
+MODULE_FIRMWARE(SMS_FW_ISDBT_PELE);
+MODULE_FIRMWARE(SMS_FW_ISDBT_RIO);
+MODULE_FIRMWARE(SMS_FW_DVBT_NOVA_A);
+MODULE_FIRMWARE(SMS_FW_DVBT_NOVA_B);
+MODULE_FIRMWARE(SMS_FW_DVBT_STELLAR);
+MODULE_FIRMWARE(SMS_FW_TDMB_DENVER);
+MODULE_FIRMWARE(SMS_FW_TDMB_NOVA_12MHZ_B0);
+MODULE_FIRMWARE(SMS_FW_TDMB_NOVA_12MHZ);
diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index a9672e0..bb74246 100644
--- a/drivers/media/common/siano/smscoreapi.h
+++ b/drivers/media/common/siano/smscoreapi.h
@@ -44,7 +44,11 @@ along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #define min(a, b) (((a) < (b)) ? (a) : (b))
 #endif
 
-/* Define the firmware names used by the driver */
+/*
+ * Define the firmware names used by the driver.
+ * Those should match what's used at smscoreapi.c and sms-cards.c
+ * including the MODULE_FIRMWARE() macros at the end of smscoreapi.c
+ */
 #define SMS_FW_ATSC_DENVER         "atsc_denver.inp"
 #define SMS_FW_CMMB_MING_APP       "cmmb_ming_app.inp"
 #define SMS_FW_CMMB_VEGA_12MHZ     "cmmb_vega_12mhz.inp"
-- 
1.8.1.4

