Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933182Ab3CSQu0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:50:26 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 06/46] [media] siano: add the remaining new defines from new driver
Date: Tue, 19 Mar 2013 13:48:55 -0300
Message-Id: <1363711775-2120-7-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the remaining new defines/enums from Doron Cohen's patch:
        http://patchwork.linuxtv.org/patch/7882/

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smscoreapi.h | 39 ++++++++++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 6 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index 0078fef..fc451e2 100644
--- a/drivers/media/common/siano/smscoreapi.h
+++ b/drivers/media/common/siano/smscoreapi.h
@@ -50,18 +50,31 @@ along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #define SMS_ALIGN_ADDRESS(addr) \
 	((((uintptr_t)(addr)) + (SMS_DMA_ALIGNMENT-1)) & ~(SMS_DMA_ALIGNMENT-1))
 
+#define SMS_DEVICE_FAMILY1				0
 #define SMS_DEVICE_FAMILY2				1
 #define SMS_ROM_NO_RESPONSE				2
 #define SMS_DEVICE_NOT_READY				0x8000000
 
 enum sms_device_type_st {
+	SMS_UNKNOWN_TYPE = -1,
 	SMS_STELLAR = 0,
 	SMS_NOVA_A0,
 	SMS_NOVA_B0,
 	SMS_VEGA,
+	SMS_VENICE,
+	SMS_MING,
+	SMS_PELE,
+	SMS_RIO,
+	SMS_DENVER_1530,
+	SMS_DENVER_2160,
 	SMS_NUM_OF_DEVICE_TYPES
 };
 
+enum sms_power_mode_st {
+	SMS_POWER_MODE_ACTIVE,
+	SMS_POWER_MODE_SUSPENDED
+};
+
 struct smscore_device_t;
 struct smscore_client_t;
 struct smscore_buffer_t;
@@ -176,18 +189,29 @@ struct smscore_device_t {
 #define SMS_ANTENNA_GPIO_0					1
 #define SMS_ANTENNA_GPIO_1					0
 
-#define BW_8_MHZ							0
-#define BW_7_MHZ							1
-#define BW_6_MHZ							2
-#define BW_5_MHZ							3
-#define BW_ISDBT_1SEG						4
-#define BW_ISDBT_3SEG						5
+enum sms_bandwidth_mode {
+	BW_8_MHZ = 0,
+	BW_7_MHZ = 1,
+	BW_6_MHZ = 2,
+	BW_5_MHZ = 3,
+	BW_ISDBT_1SEG = 4,
+	BW_ISDBT_3SEG = 5,
+	BW_2_MHZ = 6,
+	BW_FM_RADIO = 7,
+	BW_ISDBT_13SEG = 8,
+	BW_1_5_MHZ = 15,
+	BW_UNKNOWN = 0xffff
+};
+
 
 #define MSG_HDR_FLAG_SPLIT_MSG				4
 
 #define MAX_GPIO_PIN_NUMBER					31
 
 #define HIF_TASK							11
+#define HIF_TASK_SLAVE					22
+#define HIF_TASK_SLAVE2					33
+#define HIF_TASK_SLAVE3					44
 #define SMS_HOST_LIB						150
 #define DVBT_BDA_CONTROL_MSG_ID				201
 
@@ -545,6 +569,9 @@ enum SMS_DEVICE_MODE {
 	DEVICE_MODE_ISDBT_BDA,
 	DEVICE_MODE_CMMB,
 	DEVICE_MODE_RAW_TUNER,
+	DEVICE_MODE_FM_RADIO,
+	DEVICE_MODE_FM_RADIO_BDA,
+	DEVICE_MODE_ATSC,
 	DEVICE_MODE_MAX,
 };
 
-- 
1.8.1.4

