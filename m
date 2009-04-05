Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110804.mail.gq1.yahoo.com ([67.195.13.227]:31278 "HELO
	web110804.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752525AbZDEI0x convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 04:26:53 -0400
Message-ID: <205937.93854.qm@web110804.mail.gq1.yahoo.com>
Date: Sun, 5 Apr 2009 01:26:50 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0904_5] Siano: core header - indentation
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1238692457 -10800
# Node ID eb9fed366b2bb2b8a99760f52b9c0e40d72a71e0
# Parent  83b19eba46dd4f8253d02c26db4f42728d60e28f
[PATCH] [0904_5] Siano: core header - indentation

From: Uri Shkolnik <uris@siano-ms.com>

Some more indentation for the smscoreapi.h
There are no implementation changes in this patch.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 83b19eba46dd -r eb9fed366b2b linux/drivers/media/dvb/siano/smscoreapi.h
--- a/linux/drivers/media/dvb/siano/smscoreapi.h	Thu Apr 02 20:07:49 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.h	Thu Apr 02 20:14:17 2009 +0300
@@ -55,14 +55,14 @@ along with this program.  If not, see <h
 #define min(a, b) (((a) < (b)) ? (a) : (b))
 #endif
 
-#define SMS_PROTOCOL_MAX_RAOUNDTRIP_MS				(10000)
-#define SMS_ALLOC_ALIGNMENT					128
-#define SMS_DMA_ALIGNMENT					16
+#define SMS_PROTOCOL_MAX_RAOUNDTRIP_MS			(10000)
+#define SMS_ALLOC_ALIGNMENT				128
+#define SMS_DMA_ALIGNMENT				16
 #define SMS_ALIGN_ADDRESS(addr) \
 	((((uintptr_t)(addr)) + (SMS_DMA_ALIGNMENT-1)) & ~(SMS_DMA_ALIGNMENT-1))
 
-#define SMS_DEVICE_FAMILY2					1
-#define SMS_ROM_NO_RESPONSE					2
+#define SMS_DEVICE_FAMILY2				1
+#define SMS_ROM_NO_RESPONSE				2
 #define SMS_DEVICE_NOT_READY				0x8000000
 
 enum sms_device_type_st {
@@ -93,13 +93,13 @@ struct smscore_buffer_t {
 struct smscore_buffer_t {
 	/* public members, once passed to clients can be changed freely */
 	struct list_head entry;
-	int				size;
-	int				offset;
+	int size;
+	int offset;
 
 	/* private members, read-only for clients */
-	void			*p;
-	dma_addr_t		phys;
-	unsigned long	offset_in_common;
+	void *p;
+	dma_addr_t phys;
+	unsigned long offset_in_common;
 };
 
 struct smsdevice_params_t {
@@ -126,7 +126,6 @@ struct smsclient_params_t {
 	int data_type;
 	onresponse_t onresponse_handler;
 	onremove_t onremove_handler;
-
 	void *context;
 };
 
@@ -262,13 +261,14 @@ struct smscore_device_t {
 #define MSG_SMS_SIGNAL_DETECTED_IND			827
 #define MSG_SMS_NO_SIGNAL_IND				828
 
-
 #define SMS_INIT_MSG_EX(ptr, type, src, dst, len) do { \
 	(ptr)->msgType = type; (ptr)->msgSrcId = src; (ptr)->msgDstId = dst; \
 	(ptr)->msgLength = len; (ptr)->msgFlags = 0; \
 } while (0)
+
 #define SMS_INIT_MSG(ptr, type, len) \
 	SMS_INIT_MSG_EX(ptr, type, 0, HIF_TASK, len)
+
 enum SMS_DVB3_EVENTS {
 	DVB3_EVENT_INIT = 0,
 	DVB3_EVENT_SLEEP,
@@ -324,11 +324,12 @@ struct SmsVersionRes_ST {
 	u8 Step; /* 0 - Step A */
 	u8 MetalFix; /* 0 - Metal 0 */
 
-	u8 FirmwareId; /* 0xFF � ROM, otherwise the
-	 * value indicated by
-	 * SMSHOSTLIB_DEVICE_MODES_E */
-	u8 SupportedProtocols; /* Bitwise OR combination of
+	/* FirmwareId 0xFF if ROM, otherwise the
+	 * value indicated by SMSHOSTLIB_DEVICE_MODES_E */
+	u8 FirmwareId;
+	/* SupportedProtocols Bitwise OR combination of
 	 * supported protocols */
+	u8 SupportedProtocols;
 
 	u8 VersionMajor;
 	u8 VersionMinor;
@@ -362,10 +363,12 @@ struct SMSHOSTLIB_STATISTICS_ST {
 	s32 SNR; /* dB */
 	u32 BER; /* Post Viterbi BER [1E-5] */
 	u32 FIB_CRC; /* CRC errors percentage, valid only for DAB */
-	u32 TS_PER; /* Transport stream PER, 0xFFFFFFFF indicate N/A,
+	/* Transport stream PER, 0xFFFFFFFF indicate N/A,
 	 * valid only for DVB-T/H */
-	u32 MFER; /* DVB-H frame error rate in percentage,
+	u32 TS_PER;
+	/* DVB-H frame error rate in percentage,
 	 * 0xFFFFFFFF indicate N/A, valid only for DVB-H */
+	u32 MFER;
 	s32 RSSI; /* dBm */
 	s32 InBandPwr; /* In band power in dBM */
 	s32 CarrierOffset; /* Carrier Offset in bin/1024 */
@@ -373,8 +376,9 @@ struct SMSHOSTLIB_STATISTICS_ST {
 	/* Transmission parameters, valid only for DVB-T/H */
 	u32 Frequency; /* Frequency in Hz */
 	u32 Bandwidth; /* Bandwidth in MHz */
-	u32 TransmissionMode; /* Transmission Mode, for DAB modes 1-4,
+	/* Transmission Mode, for DAB modes 1-4,
 	 * for DVB-T/H FFT mode carriers in Kilos */
+	u32 TransmissionMode;
 	u32 ModemState; /* from SMS_DvbModemState_ET */
 	u32 GuardInterval; /* Guard Interval, 1 divided by value */
 	u32 CodeRate; /* Code Rate from SMS_DvbModemState_ET */



      
