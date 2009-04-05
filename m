Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110814.mail.gq1.yahoo.com ([67.195.13.237]:42884 "HELO
	web110814.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758013AbZDEIMx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 04:12:53 -0400
Message-ID: <635462.50750.qm@web110814.mail.gq1.yahoo.com>
Date: Sun, 5 Apr 2009 01:12:51 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0904_2] Siano: core header - add definitions and structures
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1238690859 -10800
# Node ID 05cf6606192642241ff25a152e249118cb8a129b
# Parent  c3f0f50d46058f07fb355d8e5531f35cfd0ca37e
[PATCH] [0904_2] Siano: core header - add definitions and structures

From: Uri Shkolnik <uris@siano-ms.com>

Add new definitions (of Siano's protocol messages),
and protocol structures (for future commits usage)

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r c3f0f50d4605 -r 05cf66061926 linux/drivers/media/dvb/siano/smscoreapi.h
--- a/linux/drivers/media/dvb/siano/smscoreapi.h	Thu Apr 02 19:32:10 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.h	Thu Apr 02 19:47:39 2009 +0300
@@ -55,6 +55,7 @@ along with this program.  If not, see <h
 #define min(a, b) (((a) < (b)) ? (a) : (b))
 #endif
 
+#define SMS_PROTOCOL_MAX_RAOUNDTRIP_MS				(10000)
 #define SMS_ALLOC_ALIGNMENT					128
 #define SMS_DMA_ALIGNMENT					16
 #define SMS_ALIGN_ADDRESS(addr) \
@@ -170,6 +171,7 @@ struct smsclient_params_t {
 #define MSG_SMS_GET_PID_FILTER_LIST_RES		609
 #define MSG_SMS_GET_STATISTICS_REQ			615
 #define MSG_SMS_GET_STATISTICS_RES			616
+#define MSG_SMS_HO_PER_SLICES_IND			630
 #define MSG_SMS_SET_ANTENNA_CONFIG_REQ		651
 #define MSG_SMS_SET_ANTENNA_CONFIG_RES		652
 #define MSG_SMS_GET_STATISTICS_EX_REQ		653
@@ -199,6 +201,13 @@ struct smsclient_params_t {
 #define MSG_SMS_GPIO_CONFIG_EX_RES			713
 #define MSG_SMS_ISDBT_TUNE_REQ				776
 #define MSG_SMS_ISDBT_TUNE_RES				777
+#define MSG_SMS_TRANSMISSION_IND			782
+#define MSG_SMS_START_IR_REQ				800
+#define MSG_SMS_START_IR_RES				801
+#define MSG_SMS_IR_SAMPLES_IND				802
+#define MSG_SMS_SIGNAL_DETECTED_IND			827
+#define MSG_SMS_NO_SIGNAL_IND				828
+
 
 #define SMS_INIT_MSG_EX(ptr, type, src, dst, len) do { \
 	(ptr)->msgType = type; (ptr)->msgSrcId = src; (ptr)->msgDstId = dst; \
@@ -206,6 +215,15 @@ struct smsclient_params_t {
 } while (0)
 #define SMS_INIT_MSG(ptr, type, len) \
 	SMS_INIT_MSG_EX(ptr, type, 0, HIF_TASK, len)
+enum SMS_DVB3_EVENTS {
+	DVB3_EVENT_INIT = 0,
+	DVB3_EVENT_SLEEP,
+	DVB3_EVENT_HOTPLUG,
+	DVB3_EVENT_FE_LOCK,
+	DVB3_EVENT_FE_UNLOCK,
+	DVB3_EVENT_UNC_OK,
+	DVB3_EVENT_UNC_ERR
+};
 
 enum SMS_DEVICE_MODE {
 	DEVICE_MODE_NONE = -1,
@@ -230,8 +248,13 @@ struct SmsMsgHdr_ST {
 };
 
 struct SmsMsgData_ST {
-	struct SmsMsgHdr_ST	xMsgHeader;
-	u32			msgData[1];
+	struct SmsMsgHdr_ST xMsgHeader;
+	u32 msgData[1];
+};
+
+struct SmsMsgData_ST2 {
+	struct SmsMsgHdr_ST xMsgHeader;
+	u32 msgData[2];
 };
 
 struct SmsDataDownload_ST {



      
