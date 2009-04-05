Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110811.mail.gq1.yahoo.com ([67.195.13.234]:25251 "HELO
	web110811.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1767037AbZDEOGW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 10:06:22 -0400
Message-ID: <663737.91393.qm@web110811.mail.gq1.yahoo.com>
Date: Sun, 5 Apr 2009 01:23:37 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0904_4] Siano: core header indentation
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1238692069 -10800
# Node ID 83b19eba46dd4f8253d02c26db4f42728d60e28f
# Parent  19925582e5dded86fccce7d8c9965285c1240836
siano: core header identation
[PATCH] [0904_4] Siano: core header indentation

From: Uri Shkolnik <uris@siano-ms.com>

smscoreapi.h - indentation and removing lots of white spaces
There are no implementation changes in this patch.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 19925582e5dd -r 83b19eba46dd linux/drivers/media/dvb/siano/smscoreapi.h
--- a/linux/drivers/media/dvb/siano/smscoreapi.h	Thu Apr 02 19:56:01 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.h	Thu Apr 02 20:07:49 2009 +0300
@@ -103,31 +103,31 @@ struct smscore_buffer_t {
 };
 
 struct smsdevice_params_t {
-	struct device	*device;
+	struct device *device;
 
-	int				buffer_size;
-	int				num_buffers;
+	int buffer_size;
+	int num_buffers;
 
-	char			devpath[32];
-	unsigned long	flags;
+	char devpath[32];
+	unsigned long flags;
 
-	setmode_t		setmode_handler;
-	detectmode_t	detectmode_handler;
-	sendrequest_t	sendrequest_handler;
-	preload_t		preload_handler;
-	postload_t		postload_handler;
+	setmode_t setmode_handler;
+	detectmode_t detectmode_handler;
+	sendrequest_t sendrequest_handler;
+	preload_t preload_handler;
+	postload_t postload_handler;
 
-	void			*context;
+	void *context;
 	enum sms_device_type_st device_type;
 };
 
 struct smsclient_params_t {
-	int				initial_id;
-	int				data_type;
-	onresponse_t	onresponse_handler;
-	onremove_t		onremove_handler;
+	int initial_id;
+	int data_type;
+	onresponse_t onresponse_handler;
+	onremove_t onremove_handler;
 
-	void			*context;
+	void *context;
 };
 
 struct smscore_device_t {
@@ -185,26 +185,26 @@ struct smscore_device_t {
 };
 
 /* GPIO definitions for antenna frequency domain control (SMS8021) */
-#define SMS_ANTENNA_GPIO_0					1
-#define SMS_ANTENNA_GPIO_1					0
+#define SMS_ANTENNA_GPIO_0				1
+#define SMS_ANTENNA_GPIO_1				0
 
-#define BW_8_MHZ							0
-#define BW_7_MHZ							1
-#define BW_6_MHZ							2
-#define BW_5_MHZ							3
-#define BW_ISDBT_1SEG						4
-#define BW_ISDBT_3SEG						5
+#define BW_8_MHZ					0
+#define BW_7_MHZ					1
+#define BW_6_MHZ					2
+#define BW_5_MHZ					3
+#define BW_ISDBT_1SEG					4
+#define BW_ISDBT_3SEG					5
 
 #define MSG_HDR_FLAG_SPLIT_MSG				4
 
-#define MAX_GPIO_PIN_NUMBER					31
+#define MAX_GPIO_PIN_NUMBER				31
 
-#define HIF_TASK							11
-#define SMS_HOST_LIB						150
+#define HIF_TASK					11
+#define SMS_HOST_LIB					150
 #define DVBT_BDA_CONTROL_MSG_ID				201
 
 #define SMS_MAX_PAYLOAD_SIZE				240
-#define SMS_TUNE_TIMEOUT					500
+#define SMS_TUNE_TIMEOUT				500
 
 #define MSG_SMS_GPIO_CONFIG_REQ				507
 #define MSG_SMS_GPIO_CONFIG_RES				508
@@ -212,45 +212,45 @@ struct smscore_device_t {
 #define MSG_SMS_GPIO_SET_LEVEL_RES			510
 #define MSG_SMS_GPIO_GET_LEVEL_REQ			511
 #define MSG_SMS_GPIO_GET_LEVEL_RES			512
-#define MSG_SMS_RF_TUNE_REQ					561
-#define MSG_SMS_RF_TUNE_RES					562
+#define MSG_SMS_RF_TUNE_REQ				561
+#define MSG_SMS_RF_TUNE_RES				562
 #define MSG_SMS_INIT_DEVICE_REQ				578
 #define MSG_SMS_INIT_DEVICE_RES				579
 #define MSG_SMS_ADD_PID_FILTER_REQ			601
 #define MSG_SMS_ADD_PID_FILTER_RES			602
-#define MSG_SMS_REMOVE_PID_FILTER_REQ		603
-#define MSG_SMS_REMOVE_PID_FILTER_RES		604
-#define MSG_SMS_DAB_CHANNEL					607
-#define MSG_SMS_GET_PID_FILTER_LIST_REQ		608
-#define MSG_SMS_GET_PID_FILTER_LIST_RES		609
+#define MSG_SMS_REMOVE_PID_FILTER_REQ			603
+#define MSG_SMS_REMOVE_PID_FILTER_RES			604
+#define MSG_SMS_DAB_CHANNEL				607
+#define MSG_SMS_GET_PID_FILTER_LIST_REQ			608
+#define MSG_SMS_GET_PID_FILTER_LIST_RES			609
 #define MSG_SMS_GET_STATISTICS_REQ			615
 #define MSG_SMS_GET_STATISTICS_RES			616
 #define MSG_SMS_HO_PER_SLICES_IND			630
-#define MSG_SMS_SET_ANTENNA_CONFIG_REQ		651
-#define MSG_SMS_SET_ANTENNA_CONFIG_RES		652
-#define MSG_SMS_GET_STATISTICS_EX_REQ		653
-#define MSG_SMS_GET_STATISTICS_EX_RES		654
-#define MSG_SMS_SLEEP_RESUME_COMP_IND		655
+#define MSG_SMS_SET_ANTENNA_CONFIG_REQ			651
+#define MSG_SMS_SET_ANTENNA_CONFIG_RES			652
+#define MSG_SMS_GET_STATISTICS_EX_REQ			653
+#define MSG_SMS_GET_STATISTICS_EX_RES			654
+#define MSG_SMS_SLEEP_RESUME_COMP_IND			655
 #define MSG_SMS_DATA_DOWNLOAD_REQ			660
 #define MSG_SMS_DATA_DOWNLOAD_RES			661
-#define MSG_SMS_SWDOWNLOAD_TRIGGER_REQ		664
-#define MSG_SMS_SWDOWNLOAD_TRIGGER_RES		665
-#define MSG_SMS_SWDOWNLOAD_BACKDOOR_REQ		666
-#define MSG_SMS_SWDOWNLOAD_BACKDOOR_RES		667
+#define MSG_SMS_SWDOWNLOAD_TRIGGER_REQ			664
+#define MSG_SMS_SWDOWNLOAD_TRIGGER_RES			665
+#define MSG_SMS_SWDOWNLOAD_BACKDOOR_REQ			666
+#define MSG_SMS_SWDOWNLOAD_BACKDOOR_RES			667
 #define MSG_SMS_GET_VERSION_EX_REQ			668
 #define MSG_SMS_GET_VERSION_EX_RES			669
-#define MSG_SMS_SET_CLOCK_OUTPUT_REQ		670
+#define MSG_SMS_SET_CLOCK_OUTPUT_REQ			670
 #define MSG_SMS_I2C_SET_FREQ_REQ			685
 #define MSG_SMS_GENERIC_I2C_REQ				687
 #define MSG_SMS_GENERIC_I2C_RES				688
 #define MSG_SMS_DVBT_BDA_DATA				693
-#define MSG_SW_RELOAD_REQ					697
-#define MSG_SMS_DATA_MSG					699
+#define MSG_SW_RELOAD_REQ				697
+#define MSG_SMS_DATA_MSG				699
 #define MSG_SW_RELOAD_START_REQ				702
 #define MSG_SW_RELOAD_START_RES				703
 #define MSG_SW_RELOAD_EXEC_REQ				704
 #define MSG_SW_RELOAD_EXEC_RES				705
-#define MSG_SMS_SPI_INT_LINE_SET_REQ		710
+#define MSG_SMS_SPI_INT_LINE_SET_REQ			710
 #define MSG_SMS_GPIO_CONFIG_EX_REQ			712
 #define MSG_SMS_GPIO_CONFIG_EX_RES			713
 #define MSG_SMS_ISDBT_TUNE_REQ				776
@@ -294,11 +294,11 @@ enum SMS_DEVICE_MODE {
 };
 
 struct SmsMsgHdr_ST {
-	u16	msgType;
-	u8	msgSrcId;
-	u8	msgDstId;
-	u16	msgLength; /* Length of entire message, including header */
-	u16	msgFlags;
+	u16 msgType;
+	u8 msgSrcId;
+	u8 msgDstId;
+	u16 msgLength; /* Length of entire message, including header */
+	u16 msgFlags;
 };
 
 struct SmsMsgData_ST {
@@ -312,42 +312,42 @@ struct SmsMsgData_ST2 {
 };
 
 struct SmsDataDownload_ST {
-	struct SmsMsgHdr_ST	xMsgHeader;
-	u32			MemAddr;
-	u8			Payload[SMS_MAX_PAYLOAD_SIZE];
+	struct SmsMsgHdr_ST xMsgHeader;
+	u32 MemAddr;
+	u8 Payload[SMS_MAX_PAYLOAD_SIZE];
 };
 
 struct SmsVersionRes_ST {
-	struct SmsMsgHdr_ST	xMsgHeader;
+	struct SmsMsgHdr_ST xMsgHeader;
 
-	u16		ChipModel; /* e.g. 0x1102 for SMS-1102 "Nova" */
-	u8		Step; /* 0 - Step A */
-	u8		MetalFix; /* 0 - Metal 0 */
+	u16 ChipModel; /* e.g. 0x1102 for SMS-1102 "Nova" */
+	u8 Step; /* 0 - Step A */
+	u8 MetalFix; /* 0 - Metal 0 */
 
-	u8		FirmwareId; /* 0xFF � ROM, otherwise the
-				     * value indicated by
-				     * SMSHOSTLIB_DEVICE_MODES_E */
-	u8		SupportedProtocols; /* Bitwise OR combination of
-					     * supported protocols */
+	u8 FirmwareId; /* 0xFF � ROM, otherwise the
+	 * value indicated by
+	 * SMSHOSTLIB_DEVICE_MODES_E */
+	u8 SupportedProtocols; /* Bitwise OR combination of
+	 * supported protocols */
 
-	u8		VersionMajor;
-	u8		VersionMinor;
-	u8		VersionPatch;
-	u8		VersionFieldPatch;
+	u8 VersionMajor;
+	u8 VersionMinor;
+	u8 VersionPatch;
+	u8 VersionFieldPatch;
 
-	u8		RomVersionMajor;
-	u8		RomVersionMinor;
-	u8		RomVersionPatch;
-	u8		RomVersionFieldPatch;
+	u8 RomVersionMajor;
+	u8 RomVersionMinor;
+	u8 RomVersionPatch;
+	u8 RomVersionFieldPatch;
 
-	u8		TextLabel[34];
+	u8 TextLabel[34];
 };
 
 struct SmsFirmware_ST {
-	u32			CheckSum;
-	u32			Length;
-	u32			StartAddress;
-	u8			Payload[1];
+	u32 CheckSum;
+	u32 Length;
+	u32 StartAddress;
+	u8 Payload[1];
 };
 
 struct SMSHOSTLIB_STATISTICS_ST {
@@ -359,22 +359,22 @@ struct SMSHOSTLIB_STATISTICS_ST {
 	u32 IsExternalLNAOn; /* 0 - external LNA off, 1 - external LNA on */
 
 	/* Reception quality */
-	s32  SNR; /* dB */
+	s32 SNR; /* dB */
 	u32 BER; /* Post Viterbi BER [1E-5] */
-	u32 FIB_CRC;	/* CRC errors percentage, valid only for DAB */
+	u32 FIB_CRC; /* CRC errors percentage, valid only for DAB */
 	u32 TS_PER; /* Transport stream PER, 0xFFFFFFFF indicate N/A,
-		     * valid only for DVB-T/H */
+	 * valid only for DVB-T/H */
 	u32 MFER; /* DVB-H frame error rate in percentage,
-		   * 0xFFFFFFFF indicate N/A, valid only for DVB-H */
-	s32  RSSI; /* dBm */
-	s32  InBandPwr; /* In band power in dBM */
-	s32  CarrierOffset; /* Carrier Offset in bin/1024 */
+	 * 0xFFFFFFFF indicate N/A, valid only for DVB-H */
+	s32 RSSI; /* dBm */
+	s32 InBandPwr; /* In band power in dBM */
+	s32 CarrierOffset; /* Carrier Offset in bin/1024 */
 
 	/* Transmission parameters, valid only for DVB-T/H */
 	u32 Frequency; /* Frequency in Hz */
 	u32 Bandwidth; /* Bandwidth in MHz */
 	u32 TransmissionMode; /* Transmission Mode, for DAB modes 1-4,
-			       * for DVB-T/H FFT mode carriers in Kilos */
+	 * for DVB-T/H FFT mode carriers in Kilos */
 	u32 ModemState; /* from SMS_DvbModemState_ET */
 	u32 GuardInterval; /* Guard Interval, 1 divided by value */
 	u32 CodeRate; /* Code Rate from SMS_DvbModemState_ET */
@@ -387,7 +387,7 @@ struct SMSHOSTLIB_STATISTICS_ST {
 	u32 BurstDuration; /* Current burst duration in mSec */
 	u32 BurstCycleTime; /* Current burst cycle time in mSec */
 	u32 CalculatedBurstCycleTime; /* Current burst cycle time in mSec,
-				       * as calculated by demodulator */
+	 * as calculated by demodulator */
 	u32 NumOfRows; /* Number of rows in MPE table */
 	u32 NumOfPaddCols; /* Number of padding columns in MPE table */
 	u32 NumOfPunctCols; /* Number of puncturing columns in MPE table */
@@ -395,11 +395,11 @@ struct SMSHOSTLIB_STATISTICS_ST {
 	u32 ErrorTSPackets; /* Number of erroneous transport-stream packets */
 	u32 TotalTSPackets; /* Total number of transport-stream packets */
 	u32 NumOfValidMpeTlbs; /* Number of MPE tables which do not include
-				* errors after MPE RS decoding */
+	 * errors after MPE RS decoding */
 	u32 NumOfInvalidMpeTlbs; /* Number of MPE tables which include errors
-				  * after MPE RS decoding */
+	 * after MPE RS decoding */
 	u32 NumOfCorrectedMpeTlbs; /* Number of MPE tables which were corrected
-				    * by MPE RS decoding */
+	 * by MPE RS decoding */
 
 	/* Common params */
 	u32 BERErrorCount; /* Number of errornous SYNC bits. */
@@ -413,7 +413,7 @@ struct SMSHOSTLIB_STATISTICS_ST {
 
 	/* DVB-H TPS parameters */
 	u32 CellId; /* TPS Cell ID in bits 15..0, bits 31..16 zero;
-		     * if set to 0xFFFFFFFF cell_id not yet recovered */
+	 * if set to 0xFFFFFFFF cell_id not yet recovered */
 
 };
 
@@ -432,9 +432,9 @@ struct SMSHOSTLIB_ISDBT_LAYER_STAT_ST {
 struct SMSHOSTLIB_ISDBT_LAYER_STAT_ST {
 	/* Per-layer information */
 	u32 CodeRate; /* Code Rate from SMSHOSTLIB_CODE_RATE_ET,
-		       * 255 means layer does not exist */
+	 * 255 means layer does not exist */
 	u32 Constellation; /* Constellation from SMSHOSTLIB_CONSTELLATION_ET,
-			    * 255 means layer does not exist */
+	 * 255 means layer does not exist */
 	u32 BER; /* Post Viterbi BER [1E-5], 0xFFFFFFFF indicate N/A */
 	u32 BERErrorCount; /* Post Viterbi Error Bits Count */
 	u32 BERBitCount; /* Post Viterbi Total Bits Count */
@@ -443,23 +443,23 @@ struct SMSHOSTLIB_ISDBT_LAYER_STAT_ST {
 	u32 ErrorTSPackets; /* Number of erroneous transport-stream packets */
 	u32 TotalTSPackets; /* Total number of transport-stream packets */
 	u32 TILdepthI; /* Time interleaver depth I parameter,
-			* 255 means layer does not exist */
+	 * 255 means layer does not exist */
 	u32 NumberOfSegments; /* Number of segments in layer A,
-			       * 255 means layer does not exist */
+	 * 255 means layer does not exist */
 	u32 TMCCErrors; /* TMCC errors */
 };
 
 struct SMSHOSTLIB_STATISTICS_ISDBT_ST {
 	u32 StatisticsType; /* Enumerator identifying the type of the
-				* structure.  Values are the same as
-				* SMSHOSTLIB_DEVICE_MODES_E
-				*
-				* This field MUST always be first in any
-				* statistics structure */
+	 * structure.  Values are the same as
+	 * SMSHOSTLIB_DEVICE_MODES_E
+	 *
+	 * This field MUST always be first in any
+	 * statistics structure */
 
 	u32 FullSize; /* Total size of the structure returned by the modem.
-		       * If the size requested by the host is smaller than
-		       * FullSize, the struct will be truncated */
+	 * If the size requested by the host is smaller than
+	 * FullSize, the struct will be truncated */
 
 	/* Common parameters */
 	u32 IsRfLocked; /* 0 - not locked, 1 - locked */
@@ -467,10 +467,10 @@ struct SMSHOSTLIB_STATISTICS_ISDBT_ST {
 	u32 IsExternalLNAOn; /* 0 - external LNA off, 1 - external LNA on */
 
 	/* Reception quality */
-	s32  SNR; /* dB */
-	s32  RSSI; /* dBm */
-	s32  InBandPwr; /* In band power in dBM */
-	s32  CarrierOffset; /* Carrier Offset in Hz */
+	s32 SNR; /* dB */
+	s32 RSSI; /* dBm */
+	s32 InBandPwr; /* In band power in dBM */
+	s32 CarrierOffset; /* Carrier Offset in Hz */
 
 	/* Transmission parameters */
 	u32 Frequency; /* Frequency in Hz */
@@ -484,7 +484,7 @@ struct SMSHOSTLIB_STATISTICS_ISDBT_ST {
 
 	/* Per-layer information */
 	/* Layers A, B and C */
-	struct SMSHOSTLIB_ISDBT_LAYER_STAT_ST	LayerInfo[3];
+	struct SMSHOSTLIB_ISDBT_LAYER_STAT_ST LayerInfo[3];
 	/* Per-layer statistics, see SMSHOSTLIB_ISDBT_LAYER_STAT_ST */
 
 	/* Interface information */
@@ -494,30 +494,30 @@ struct SMSHOSTLIB_STATISTICS_ISDBT_ST {
 
 struct SMSHOSTLIB_STATISTICS_DVB_ST {
 	u32 StatisticsType; /* Enumerator identifying the type of the
-			     * structure.  Values are the same as
-			     * SMSHOSTLIB_DEVICE_MODES_E
-			     * This field MUST always first in any
-			     * statistics structure */
+	 * structure.  Values are the same as
+	 * SMSHOSTLIB_DEVICE_MODES_E
+	 * This field MUST always first in any
+	 * statistics structure */
 
 	u32 FullSize; /* Total size of the structure returned by the modem.
-		       * If the size requested by the host is smaller than
-		       * FullSize, the struct will be truncated */
+	 * If the size requested by the host is smaller than
+	 * FullSize, the struct will be truncated */
 	/* Common parameters */
 	u32 IsRfLocked; /* 0 - not locked, 1 - locked */
 	u32 IsDemodLocked; /* 0 - not locked, 1 - locked */
 	u32 IsExternalLNAOn; /* 0 - external LNA off, 1 - external LNA on */
 
 	/* Reception quality */
-	s32  SNR; /* dB */
+	s32 SNR; /* dB */
 	u32 BER; /* Post Viterbi BER [1E-5] */
 	u32 BERErrorCount; /* Number of errornous SYNC bits. */
 	u32 BERBitCount; /* Total number of SYNC bits. */
 	u32 TS_PER; /* Transport stream PER, 0xFFFFFFFF indicate N/A */
 	u32 MFER; /* DVB-H frame error rate in percentage,
-		   * 0xFFFFFFFF indicate N/A, valid only for DVB-H */
-	s32  RSSI; /* dBm */
-	s32  InBandPwr; /* In band power in dBM */
-	s32  CarrierOffset; /* Carrier Offset in bin/1024 */
+	 * 0xFFFFFFFF indicate N/A, valid only for DVB-H */
+	s32 RSSI; /* dBm */
+	s32 InBandPwr; /* In band power in dBM */
+	s32 CarrierOffset; /* Carrier Offset in bin/1024 */
 
 	/* Transmission parameters */
 	u32 Frequency; /* Frequency in Hz */
@@ -527,7 +527,7 @@ struct SMSHOSTLIB_STATISTICS_DVB_ST {
 	u32 GuardInterval; /* Guard Interval, 1 divided by value */
 	u32 CodeRate; /* Code Rate from SMSHOSTLIB_CODE_RATE_ET */
 	u32 LPCodeRate; /* Low Priority Code Rate from
-			 * SMSHOSTLIB_CODE_RATE_ET */
+	 * SMSHOSTLIB_CODE_RATE_ET */
 	u32 Hierarchy; /* Hierarchy from SMSHOSTLIB_HIERARCHY_ET */
 	u32 Constellation; /* Constellation from SMSHOSTLIB_CONSTELLATION_ET */
 
@@ -536,7 +536,7 @@ struct SMSHOSTLIB_STATISTICS_DVB_ST {
 	u32 BurstDuration; /* Current burst duration in mSec */
 	u32 BurstCycleTime; /* Current burst cycle time in mSec */
 	u32 CalculatedBurstCycleTime; /* Current burst cycle time in mSec,
-				       * as calculated by demodulator */
+	 * as calculated by demodulator */
 	u32 NumOfRows; /* Number of rows in MPE table */
 	u32 NumOfPaddCols; /* Number of padding columns in MPE table */
 	u32 NumOfPunctCols; /* Number of puncturing columns in MPE table */
@@ -545,23 +545,23 @@ struct SMSHOSTLIB_STATISTICS_DVB_ST {
 	u32 TotalTSPackets; /* Total number of transport-stream packets */
 
 	u32 NumOfValidMpeTlbs; /* Number of MPE tables which do not include
-				* errors after MPE RS decoding */
+	 * errors after MPE RS decoding */
 	u32 NumOfInvalidMpeTlbs; /* Number of MPE tables which include
-				  * errors after MPE RS decoding */
+	 * errors after MPE RS decoding */
 	u32 NumOfCorrectedMpeTlbs; /* Number of MPE tables which were
-				    * corrected by MPE RS decoding */
+	 * corrected by MPE RS decoding */
 
 	u32 NumMPEReceived; /* DVB-H, Num MPE section received */
 
 	/* DVB-H TPS parameters */
 	u32 CellId; /* TPS Cell ID in bits 15..0, bits 31..16 zero;
-		     * if set to 0xFFFFFFFF cell_id not yet recovered */
+	 * if set to 0xFFFFFFFF cell_id not yet recovered */
 	u32 DvbhSrvIndHP; /* DVB-H service indication info,
-			   * bit 1 - Time Slicing indicator,
-			   * bit 0 - MPE-FEC indicator */
+	 * bit 1 - Time Slicing indicator,
+	 * bit 0 - MPE-FEC indicator */
 	u32 DvbhSrvIndLP; /* DVB-H service indication info,
-			   * bit 1 - Time Slicing indicator,
-			   * bit 0 - MPE-FEC indicator */
+	 * bit 1 - Time Slicing indicator,
+	 * bit 0 - MPE-FEC indicator */
 
 	/* Interface information */
 	u32 SmsToHostTxErrors; /* Total number of transmission errors. */
@@ -569,16 +569,16 @@ struct SMSHOSTLIB_STATISTICS_DVB_ST {
 };
 
 struct SMSHOSTLIB_I2C_REQ_ST {
-	u32	DeviceAddress; /* I2c device address */
-	u32	WriteCount; /* number of bytes to write */
-	u32	ReadCount; /* number of bytes to read */
-	u8	Data[1];
+	u32 DeviceAddress; /* I2c device address */
+	u32 WriteCount; /* number of bytes to write */
+	u32 ReadCount; /* number of bytes to read */
+	u8 Data[1];
 };
 
 struct SMSHOSTLIB_I2C_RES_ST {
-	u32	Status; /* non-zero value in case of failure */
-	u32	ReadCount; /* number of bytes read */
-	u8	Data[1];
+	u32 Status; /* non-zero value in case of failure */
+	u32 ReadCount; /* number of bytes read */
+	u8 Data[1];
 };
 #endif
 
@@ -615,51 +615,49 @@ extern void smscore_unregister_hotplug(h
 extern void smscore_unregister_hotplug(hotplug_t hotplug);
 
 extern int smscore_register_device(struct smsdevice_params_t *params,
-				   struct smscore_device_t **coredev);
+		struct smscore_device_t **coredev);
 extern void smscore_unregister_device(struct smscore_device_t *coredev);
 
 extern int smscore_start_device(struct smscore_device_t *coredev);
 extern int smscore_load_firmware(struct smscore_device_t *coredev,
-				 char *filename,
-				 loadfirmware_t loadfirmware_handler);
+		char *filename, loadfirmware_t loadfirmware_handler);
 
 extern int smscore_set_device_mode(struct smscore_device_t *coredev, int mode);
 extern int smscore_get_device_mode(struct smscore_device_t *coredev);
 
 extern int smscore_register_client(struct smscore_device_t *coredev,
-				    struct smsclient_params_t *params,
-				    struct smscore_client_t **client);
+		struct smsclient_params_t *params,
+		struct smscore_client_t **client);
 extern void smscore_unregister_client(struct smscore_client_t *client);
 
-extern int smsclient_sendrequest(struct smscore_client_t *client,
-				 void *buffer, size_t size);
+extern int smsclient_sendrequest(struct smscore_client_t *client, void *buffer,
+		size_t size);
 extern void smscore_onresponse(struct smscore_device_t *coredev,
-			       struct smscore_buffer_t *cb);
+		struct smscore_buffer_t *cb);
 
 #if 1
 extern int smscore_get_common_buffer_size(struct smscore_device_t *coredev);
 extern int smscore_map_common_buffer(struct smscore_device_t *coredev,
-				      struct vm_area_struct *vma);
-extern int smscore_get_fw_filename(struct smscore_device_t *coredev,
-				   int mode, char *filename);
-extern int smscore_send_fw_file(struct smscore_device_t *coredev,
-				u8 *ufwbuf, int size);
+		struct vm_area_struct *vma);
+extern int smscore_get_fw_filename(struct smscore_device_t *coredev, int mode,
+		char *filename);
+extern int smscore_send_fw_file(struct smscore_device_t *coredev, u8 *ufwbuf,
+		int size);
 #endif
 
-extern
-struct smscore_buffer_t *smscore_getbuffer(struct smscore_device_t *coredev);
+extern struct smscore_buffer_t *smscore_getbuffer(
+		struct smscore_device_t *coredev);
 extern void smscore_putbuffer(struct smscore_device_t *coredev,
-			      struct smscore_buffer_t *cb);
+		struct smscore_buffer_t *cb);
 
 int smscore_configure_gpio(struct smscore_device_t *coredev, u32 pin,
-			   struct smscore_gpio_config *pinconfig);
+		struct smscore_gpio_config *pinconfig);
 int smscore_set_gpio(struct smscore_device_t *coredev, u32 pin, int level);
 
 void smscore_set_board_id(struct smscore_device_t *core, int id);
 int smscore_get_board_id(struct smscore_device_t *core);
 
 int smscore_led_state(struct smscore_device_t *core, int led);
-
 
 /* ------------------------------------------------------------------------ */
 



      
