Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110802.mail.gq1.yahoo.com ([67.195.13.225]:23608 "HELO
	web110802.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751881AbZELP2q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 11:28:46 -0400
Message-ID: <842590.46176.qm@web110802.mail.gq1.yahoo.com>
Date: Tue, 12 May 2009 08:28:46 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0905_07] Siano: smsdvb - use 'push' status mechanism
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242142336 -10800
# Node ID 10143bda4ddae2b30af23adb15e536dc8bef7962
# Parent  291604c1821496dd4acd1d5411f8ea3ae955fd2c
[0905_07] Siano: smsdvb - use 'push' status mechanism

From: Uri Shkolnik <uris@siano-ms.com>

This patch replace the old method of pulling the device status by
sending "get_statistics" request, to push mode. This make status update
much faster, and reduce various operation time (UHF scan now takes 15s
instead of 2m). In order to make the change the following modification
have been applied:
1) core header - update statistics headers.
2) dvb adapter - omit the statistics request, add handling of
status indications.
3) core 'onresponse' - re-route messages addressed to other adapter
to the dvb adapter.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 291604c18214 -r 10143bda4dda linux/drivers/media/dvb/siano/smscoreapi.c
--- a/linux/drivers/media/dvb/siano/smscoreapi.c	Tue May 12 17:40:55 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.c	Tue May 12 18:32:16 2009 +0300
@@ -904,15 +904,11 @@ smscore_client_t *smscore_find_client(st
  *
  */
 void smscore_onresponse(struct smscore_device_t *coredev,
-			struct smscore_buffer_t *cb)
-{
-	struct SmsMsgHdr_ST *phdr =
-		(struct SmsMsgHdr_ST *)((u8 *) cb->p + cb->offset);
-	struct smscore_client_t *client =
-		smscore_find_client(coredev, phdr->msgType, phdr->msgDstId);
+		struct smscore_buffer_t *cb) {
+	struct SmsMsgHdr_ST *phdr = (struct SmsMsgHdr_ST *) ((u8 *) cb->p
+			+ cb->offset);
+	struct smscore_client_t *client;
 	int rc = -EBUSY;
-
-#if 1
 	static unsigned long last_sample_time; /* = 0; */
 	static int data_total; /* = 0; */
 	unsigned long time_now = jiffies_to_msecs(jiffies);
@@ -930,7 +926,16 @@ void smscore_onresponse(struct smscore_d
 	}
 
 	data_total += cb->size;
-#endif
+	/* Do we need to re-route? */
+	if ((phdr->msgType == MSG_SMS_HO_PER_SLICES_IND) ||
+			(phdr->msgType == MSG_SMS_TRANSMISSION_IND)) {
+		if (coredev->mode == DEVICE_MODE_DVBT_BDA)
+			phdr->msgDstId = DVBT_BDA_CONTROL_MSG_ID;
+	}
+
+
+	client = smscore_find_client(coredev, phdr->msgType, phdr->msgDstId);
+
 	/* If no client registered for type & id,
 	 * check for control client where type is not registered */
 	if (client)
diff -r 291604c18214 -r 10143bda4dda linux/drivers/media/dvb/siano/smscoreapi.h
--- a/linux/drivers/media/dvb/siano/smscoreapi.h	Tue May 12 17:40:55 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.h	Tue May 12 18:32:16 2009 +0300
@@ -213,19 +213,15 @@ struct smscore_device_t {
 #define MSG_SMS_INIT_DEVICE_RES				579
 #define MSG_SMS_ADD_PID_FILTER_REQ			601
 #define MSG_SMS_ADD_PID_FILTER_RES			602
-#define MSG_SMS_REMOVE_PID_FILTER_REQ		603
-#define MSG_SMS_REMOVE_PID_FILTER_RES		604
-#define MSG_SMS_DAB_CHANNEL					607
-#define MSG_SMS_GET_PID_FILTER_LIST_REQ		608
-#define MSG_SMS_GET_PID_FILTER_LIST_RES		609
-#define MSG_SMS_GET_STATISTICS_REQ			615
-#define MSG_SMS_GET_STATISTICS_RES			616
+#define MSG_SMS_REMOVE_PID_FILTER_REQ			603
+#define MSG_SMS_REMOVE_PID_FILTER_RES			604
+#define MSG_SMS_DAB_CHANNEL				607
+#define MSG_SMS_GET_PID_FILTER_LIST_REQ			608
+#define MSG_SMS_GET_PID_FILTER_LIST_RES			609
 #define MSG_SMS_HO_PER_SLICES_IND			630
-#define MSG_SMS_SET_ANTENNA_CONFIG_REQ		651
-#define MSG_SMS_SET_ANTENNA_CONFIG_RES		652
-#define MSG_SMS_GET_STATISTICS_EX_REQ		653
-#define MSG_SMS_GET_STATISTICS_EX_RES		654
-#define MSG_SMS_SLEEP_RESUME_COMP_IND		655
+#define MSG_SMS_SET_ANTENNA_CONFIG_REQ			651
+#define MSG_SMS_SET_ANTENNA_CONFIG_RES			652
+#define MSG_SMS_SLEEP_RESUME_COMP_IND			655
 #define MSG_SMS_DATA_DOWNLOAD_REQ			660
 #define MSG_SMS_DATA_DOWNLOAD_RES			661
 #define MSG_SMS_SWDOWNLOAD_TRIGGER_REQ		664
@@ -347,225 +343,202 @@ struct SmsFirmware_ST {
 	u8			Payload[1];
 };
 
-struct SMSHOSTLIB_STATISTICS_ST {
-	u32 Reserved; /* Reserved */
+/* Statistics information returned as response for
+ * SmsHostApiGetStatistics_Req */
+struct SMSHOSTLIB_STATISTICS_S {
+	u32 Reserved;		/* Reserved */
 
 	/* Common parameters */
-	u32 IsRfLocked; /* 0 - not locked, 1 - locked */
-	u32 IsDemodLocked; /* 0 - not locked, 1 - locked */
-	u32 IsExternalLNAOn; /* 0 - external LNA off, 1 - external LNA on */
+	u32 IsRfLocked;		/* 0 - not locked, 1 - locked */
+	u32 IsDemodLocked;	/* 0 - not locked, 1 - locked */
+	u32 IsExternalLNAOn;	/* 0 - external LNA off, 1 - external LNA on */
 
 	/* Reception quality */
-	s32  SNR; /* dB */
-	u32 BER; /* Post Viterbi BER [1E-5] */
-	u32 FIB_CRC;	/* CRC errors percentage, valid only for DAB */
-	/* Transport stream PER, 0xFFFFFFFF indicate N/A,
-		     * valid only for DVB-T/H */
-	u32 TS_PER;
-	/* DVB-H frame error rate in percentage,
-		   * 0xFFFFFFFF indicate N/A, valid only for DVB-H */
-	u32 MFER;
-	s32  RSSI; /* dBm */
-	s32  InBandPwr; /* In band power in dBM */
-	s32  CarrierOffset; /* Carrier Offset in bin/1024 */
+	s32 SNR;		/* dB */
+	u32 BER;		/* Post Viterbi BER [1E-5] */
+	u32 FIB_CRC;		/* CRC errors percentage, valid only for DAB */
+	u32 TS_PER;		/* Transport stream PER,
+	0xFFFFFFFF indicate N/A, valid only for DVB-T/H */
+	u32 MFER;		/* DVB-H frame error rate in percentage,
+	0xFFFFFFFF indicate N/A, valid only for DVB-H */
+	s32 RSSI;		/* dBm */
+	s32 InBandPwr;		/* In band power in dBM */
+	s32 CarrierOffset;	/* Carrier Offset in bin/1024 */
 
-	/* Transmission parameters, valid only for DVB-T/H */
-	u32 Frequency; /* Frequency in Hz */
-	u32 Bandwidth; /* Bandwidth in MHz */
-	/* Transmission Mode, for DAB modes 1-4,
-			       * for DVB-T/H FFT mode carriers in Kilos */
-	u32 TransmissionMode;
-	u32 ModemState; /* from SMS_DvbModemState_ET */
-	u32 GuardInterval; /* Guard Interval, 1 divided by value */
-	u32 CodeRate; /* Code Rate from SMS_DvbModemState_ET */
-	u32 LPCodeRate; /* Low Priority Code Rate from SMS_DvbModemState_ET */
-	u32 Hierarchy; /* Hierarchy from SMS_Hierarchy_ET */
-	u32 Constellation; /* Constellation from SMS_Constellation_ET */
+	/* Transmission parameters */
+	u32 Frequency;		/* Frequency in Hz */
+	u32 Bandwidth;		/* Bandwidth in MHz, valid only for DVB-T/H */
+	u32 TransmissionMode;	/* Transmission Mode, for DAB modes 1-4,
+	for DVB-T/H FFT mode carriers in Kilos */
+	u32 ModemState;		/* from SMSHOSTLIB_DVB_MODEM_STATE_ET,
+	valid only for DVB-T/H */
+	u32 GuardInterval;	/* Guard Interval from
+	SMSHOSTLIB_GUARD_INTERVALS_ET, 	valid only for DVB-T/H */
+	u32 CodeRate;		/* Code Rate from SMSHOSTLIB_CODE_RATE_ET,
+	valid only for DVB-T/H */
+	u32 LPCodeRate;		/* Low Priority Code Rate from
+	SMSHOSTLIB_CODE_RATE_ET, valid only for DVB-T/H */
+	u32 Hierarchy;		/* Hierarchy from SMSHOSTLIB_HIERARCHY_ET,
+	valid only for DVB-T/H */
+	u32 Constellation;	/* Constellation from
+	SMSHOSTLIB_CONSTELLATION_ET, valid only for DVB-T/H */
 
 	/* Burst parameters, valid only for DVB-H */
-	u32 BurstSize; /* Current burst size in bytes */
-	u32 BurstDuration; /* Current burst duration in mSec */
-	u32 BurstCycleTime; /* Current burst cycle time in mSec */
-	u32 CalculatedBurstCycleTime; /* Current burst cycle time in mSec,
-				       * as calculated by demodulator */
-	u32 NumOfRows; /* Number of rows in MPE table */
-	u32 NumOfPaddCols; /* Number of padding columns in MPE table */
-	u32 NumOfPunctCols; /* Number of puncturing columns in MPE table */
-	/* Burst parameters */
-	u32 ErrorTSPackets; /* Number of erroneous transport-stream packets */
-	u32 TotalTSPackets; /* Total number of transport-stream packets */
-	u32 NumOfValidMpeTlbs; /* Number of MPE tables which do not include
-				* errors after MPE RS decoding */
-	u32 NumOfInvalidMpeTlbs; /* Number of MPE tables which include errors
-				  * after MPE RS decoding */
-	u32 NumOfCorrectedMpeTlbs; /* Number of MPE tables which were corrected
-				    * by MPE RS decoding */
-
+	u32 BurstSize;		/* Current burst size in bytes,
+	valid only for DVB-H */
+	u32 BurstDuration;	/* Current burst duration in mSec,
+	valid only for DVB-H */
+	u32 BurstCycleTime;	/* Current burst cycle time in mSec,
+	valid only for DVB-H */
+	u32 CalculatedBurstCycleTime;/* Current burst cycle time in mSec,
+	as calculated by demodulator, valid only for DVB-H */
+	u32 NumOfRows;		/* Number of rows in MPE table,
+	valid only for DVB-H */
+	u32 NumOfPaddCols;	/* Number of padding columns in MPE table,
+	valid only for DVB-H */
+	u32 NumOfPunctCols;	/* Number of puncturing columns in MPE table,
+	valid only for DVB-H */
+	u32 ErrorTSPackets;	/* Number of erroneous
+	transport-stream packets */
+	u32 TotalTSPackets;	/* Total number of transport-stream packets */
+	u32 NumOfValidMpeTlbs;	/* Number of MPE tables which do not include
+	errors after MPE RS decoding */
+	u32 NumOfInvalidMpeTlbs;/* Number of MPE tables which include errors
+	after MPE RS decoding */
+	u32 NumOfCorrectedMpeTlbs;/* Number of MPE tables which were
+	corrected by MPE RS decoding */
 	/* Common params */
-	u32 BERErrorCount; /* Number of errornous SYNC bits. */
-	u32 BERBitCount; /* Total number of SYNC bits. */
+	u32 BERErrorCount;	/* Number of errornous SYNC bits. */
+	u32 BERBitCount;	/* Total number of SYNC bits. */
 
 	/* Interface information */
-	u32 SmsToHostTxErrors; /* Total number of transmission errors. */
+	u32 SmsToHostTxErrors;	/* Total number of transmission errors. */
 
 	/* DAB/T-DMB */
-	u32 PreBER; /* DAB/T-DMB only: Pre Viterbi BER [1E-5] */
+	u32 PreBER; 		/* DAB/T-DMB only: Pre Viterbi BER [1E-5] */
 
 	/* DVB-H TPS parameters */
-	u32 CellId; /* TPS Cell ID in bits 15..0, bits 31..16 zero;
-		     * if set to 0xFFFFFFFF cell_id not yet recovered */
+	u32 CellId;		/* TPS Cell ID in bits 15..0, bits 31..16 zero;
+	 if set to 0xFFFFFFFF cell_id not yet recovered */
+	u32 DvbhSrvIndHP;	/* DVB-H service indication info, bit 1 -
+	Time Slicing indicator, bit 0 - MPE-FEC indicator */
+	u32 DvbhSrvIndLP;	/* DVB-H service indication info, bit 1 -
+	Time Slicing indicator, bit 0 - MPE-FEC indicator */
 
+	u32 NumMPEReceived;	/* DVB-H, Num MPE section received */
+
+	u32 ReservedFields[10];	/* Reserved */
 };
 
-struct SmsMsgStatisticsInfo_ST {
-	u32 RequestResult;
+struct PID_STATISTICS_DATA_S {
+	struct PID_BURST_S {
+		u32 size;
+		u32 padding_cols;
+		u32 punct_cols;
+		u32 duration;
+		u32 cycle;
+		u32 calc_cycle;
+	} burst;
 
-	struct SMSHOSTLIB_STATISTICS_ST Stat;
-
-	/* Split the calc of the SNR in DAB */
-	u32 Signal; /* dB */
-	u32 Noise; /* dB */
-
+	u32 tot_tbl_cnt;
+	u32 invalid_tbl_cnt;
+	u32 tot_cor_tbl;
 };
 
-#if 0
-struct SMSHOSTLIB_ISDBT_LAYER_STAT_ST {
-	/* Per-layer information */
-	u32 CodeRate; /* Code Rate from SMSHOSTLIB_CODE_RATE_ET,
-		       * 255 means layer does not exist */
-	u32 Constellation; /* Constellation from SMSHOSTLIB_CONSTELLATION_ET,
-			    * 255 means layer does not exist */
-	u32 BER; /* Post Viterbi BER [1E-5], 0xFFFFFFFF indicate N/A */
-	u32 BERErrorCount; /* Post Viterbi Error Bits Count */
-	u32 BERBitCount; /* Post Viterbi Total Bits Count */
-	u32 PreBER; /* Pre Viterbi BER [1E-5], 0xFFFFFFFF indicate N/A */
-	u32 TS_PER; /* Transport stream PER [%], 0xFFFFFFFF indicate N/A */
-	u32 ErrorTSPackets; /* Number of erroneous transport-stream packets */
-	u32 TotalTSPackets; /* Total number of transport-stream packets */
-	u32 TILdepthI; /* Time interleaver depth I parameter,
-			* 255 means layer does not exist */
-	u32 NumberOfSegments; /* Number of segments in layer A,
-			       * 255 means layer does not exist */
-	u32 TMCCErrors; /* TMCC errors */
+struct PID_DATA_S {
+	u32 pid;
+	u32 num_rows;
+	struct PID_STATISTICS_DATA_S pid_statistics;
 };
 
-struct SMSHOSTLIB_STATISTICS_ISDBT_ST {
-	u32 StatisticsType; /* Enumerator identifying the type of the
-				* structure.  Values are the same as
-				* SMSHOSTLIB_DEVICE_MODES_E
-				*
-				* This field MUST always be first in any
-				* statistics structure */
+#define CORRECT_STAT_RSSI(_stat) ((_stat).RSSI *= -1)
+#define CORRECT_STAT_BANDWIDTH(_stat) (_stat.Bandwidth = 8 - _stat.Bandwidth)
+#define CORRECT_STAT_TRANSMISSON_MODE(_stat) \
+	if (_stat.TransmissionMode == 0) \
+		_stat.TransmissionMode = 2; \
+	else if (_stat.TransmissionMode == 1) \
+		_stat.TransmissionMode = 8; \
+		else \
+			_stat.TransmissionMode = 4;
 
-	u32 FullSize; /* Total size of the structure returned by the modem.
-		       * If the size requested by the host is smaller than
-		       * FullSize, the struct will be truncated */
+struct TRANSMISSION_STATISTICS_S {
+	u32 Frequency;		/* Frequency in Hz */
+	u32 Bandwidth;		/* Bandwidth in MHz */
+	u32 TransmissionMode;	/* FFT mode carriers in Kilos */
+	u32 GuardInterval;	/* Guard Interval from
+	SMSHOSTLIB_GUARD_INTERVALS_ET */
+	u32 CodeRate;		/* Code Rate from SMSHOSTLIB_CODE_RATE_ET */
+	u32 LPCodeRate;		/* Low Priority Code Rate from
+	SMSHOSTLIB_CODE_RATE_ET */
+	u32 Hierarchy;		/* Hierarchy from SMSHOSTLIB_HIERARCHY_ET */
+	u32 Constellation;	/* Constellation from
+	SMSHOSTLIB_CONSTELLATION_ET */
 
-	/* Common parameters */
-	u32 IsRfLocked; /* 0 - not locked, 1 - locked */
-	u32 IsDemodLocked; /* 0 - not locked, 1 - locked */
-	u32 IsExternalLNAOn; /* 0 - external LNA off, 1 - external LNA on */
+	/* DVB-H TPS parameters */
+	u32 CellId;		/* TPS Cell ID in bits 15..0, bits 31..16 zero;
+	 if set to 0xFFFFFFFF cell_id not yet recovered */
+	u32 DvbhSrvIndHP;	/* DVB-H service indication info, bit 1 -
+	 Time Slicing indicator, bit 0 - MPE-FEC indicator */
+	u32 DvbhSrvIndLP;	/* DVB-H service indication info, bit 1 -
+	 Time Slicing indicator, bit 0 - MPE-FEC indicator */
+	u32 IsDemodLocked;	/* 0 - not locked, 1 - locked */
+};
 
-	/* Reception quality */
-	s32  SNR; /* dB */
-	s32  RSSI; /* dBm */
-	s32  InBandPwr; /* In band power in dBM */
-	s32  CarrierOffset; /* Carrier Offset in Hz */
+struct RECEPTION_STATISTICS_S {
+	u32 IsRfLocked;		/* 0 - not locked, 1 - locked */
+	u32 IsDemodLocked;	/* 0 - not locked, 1 - locked */
+	u32 IsExternalLNAOn;	/* 0 - external LNA off, 1 - external LNA on */
+
+	u32 ModemState;		/* from SMSHOSTLIB_DVB_MODEM_STATE_ET */
+	s32 SNR;		/* dB */
+	u32 BER;		/* Post Viterbi BER [1E-5] */
+	u32 BERErrorCount;	/* Number of erronous SYNC bits. */
+	u32 BERBitCount;	/* Total number of SYNC bits. */
+	u32 TS_PER;		/* Transport stream PER,
+	0xFFFFFFFF indicate N/A */
+	u32 MFER;		/* DVB-H frame error rate in percentage,
+	0xFFFFFFFF indicate N/A, valid only for DVB-H */
+	s32 RSSI;		/* dBm */
+	s32 InBandPwr;		/* In band power in dBM */
+	s32 CarrierOffset;	/* Carrier Offset in bin/1024 */
+	u32 ErrorTSPackets;	/* Number of erroneous
+	transport-stream packets */
+	u32 TotalTSPackets;	/* Total number of transport-stream packets */
+
+	s32 MRC_SNR;		/* dB */
+	s32 MRC_RSSI;		/* dBm */
+	s32 MRC_InBandPwr;	/* In band power in dBM */
+};
+
+
+/* Statistics information returned as response for
+ * SmsHostApiGetStatisticsEx_Req for DVB applications, SMS1100 and up */
+struct SMSHOSTLIB_STATISTICS_DVB_S {
+	/* Reception */
+	struct RECEPTION_STATISTICS_S ReceptionData;
 
 	/* Transmission parameters */
-	u32 Frequency; /* Frequency in Hz */
-	u32 Bandwidth; /* Bandwidth in MHz */
-	u32 TransmissionMode; /* ISDB-T transmission mode */
-	u32 ModemState; /* 0 - Acquisition, 1 - Locked */
-	u32 GuardInterval; /* Guard Interval, 1 divided by value */
-	u32 SystemType; /* ISDB-T system type (ISDB-T / ISDB-Tsb) */
-	u32 PartialReception; /* TRUE - partial reception, FALSE otherwise */
-	u32 NumOfLayers; /* Number of ISDB-T layers in the network */
+	struct TRANSMISSION_STATISTICS_S TransmissionData;
 
-	/* Per-layer information */
-	/* Layers A, B and C */
-	struct SMSHOSTLIB_ISDBT_LAYER_STAT_ST	LayerInfo[3];
-	/* Per-layer statistics, see SMSHOSTLIB_ISDBT_LAYER_STAT_ST */
-
-	/* Interface information */
-	u32 SmsToHostTxErrors; /* Total number of transmission errors. */
-
+	/* Burst parameters, valid only for DVB-H */
+#define	SRVM_MAX_PID_FILTERS 8
+	struct PID_DATA_S PidData[SRVM_MAX_PID_FILTERS];
 };
 
-struct SMSHOSTLIB_STATISTICS_DVB_ST {
-	u32 StatisticsType; /* Enumerator identifying the type of the
-			     * structure.  Values are the same as
-			     * SMSHOSTLIB_DEVICE_MODES_E
-			     * This field MUST always first in any
-			     * statistics structure */
+struct SRVM_SIGNAL_STATUS_S {
+	u32 result;
+	u32 snr;
+	u32 tsPackets;
+	u32 etsPackets;
+	u32 constellation;
+	u32 hpCode;
+	u32 tpsSrvIndLP;
+	u32 tpsSrvIndHP;
+	u32 cellId;
+	u32 reason;
 
-	u32 FullSize; /* Total size of the structure returned by the modem.
-		       * If the size requested by the host is smaller than
-		       * FullSize, the struct will be truncated */
-	/* Common parameters */
-	u32 IsRfLocked; /* 0 - not locked, 1 - locked */
-	u32 IsDemodLocked; /* 0 - not locked, 1 - locked */
-	u32 IsExternalLNAOn; /* 0 - external LNA off, 1 - external LNA on */
-
-	/* Reception quality */
-	s32  SNR; /* dB */
-	u32 BER; /* Post Viterbi BER [1E-5] */
-	u32 BERErrorCount; /* Number of errornous SYNC bits. */
-	u32 BERBitCount; /* Total number of SYNC bits. */
-	u32 TS_PER; /* Transport stream PER, 0xFFFFFFFF indicate N/A */
-	u32 MFER; /* DVB-H frame error rate in percentage,
-		   * 0xFFFFFFFF indicate N/A, valid only for DVB-H */
-	s32  RSSI; /* dBm */
-	s32  InBandPwr; /* In band power in dBM */
-	s32  CarrierOffset; /* Carrier Offset in bin/1024 */
-
-	/* Transmission parameters */
-	u32 Frequency; /* Frequency in Hz */
-	u32 Bandwidth; /* Bandwidth in MHz */
-	u32 ModemState; /* from SMSHOSTLIB_DVB_MODEM_STATE_ET */
-	u32 TransmissionMode; /* FFT mode carriers in Kilos */
-	u32 GuardInterval; /* Guard Interval, 1 divided by value */
-	u32 CodeRate; /* Code Rate from SMSHOSTLIB_CODE_RATE_ET */
-	u32 LPCodeRate; /* Low Priority Code Rate from
-			 * SMSHOSTLIB_CODE_RATE_ET */
-	u32 Hierarchy; /* Hierarchy from SMSHOSTLIB_HIERARCHY_ET */
-	u32 Constellation; /* Constellation from SMSHOSTLIB_CONSTELLATION_ET */
-
-	/* Burst parameters, valid only for DVB-H */
-	u32 BurstSize; /* Current burst size in bytes */
-	u32 BurstDuration; /* Current burst duration in mSec */
-	u32 BurstCycleTime; /* Current burst cycle time in mSec */
-	u32 CalculatedBurstCycleTime; /* Current burst cycle time in mSec,
-				       * as calculated by demodulator */
-	u32 NumOfRows; /* Number of rows in MPE table */
-	u32 NumOfPaddCols; /* Number of padding columns in MPE table */
-	u32 NumOfPunctCols; /* Number of puncturing columns in MPE table */
-
-	u32 ErrorTSPackets; /* Number of erroneous transport-stream packets */
-	u32 TotalTSPackets; /* Total number of transport-stream packets */
-
-	u32 NumOfValidMpeTlbs; /* Number of MPE tables which do not include
-				* errors after MPE RS decoding */
-	u32 NumOfInvalidMpeTlbs; /* Number of MPE tables which include
-				  * errors after MPE RS decoding */
-	u32 NumOfCorrectedMpeTlbs; /* Number of MPE tables which were
-				    * corrected by MPE RS decoding */
-
-	u32 NumMPEReceived; /* DVB-H, Num MPE section received */
-
-	/* DVB-H TPS parameters */
-	u32 CellId; /* TPS Cell ID in bits 15..0, bits 31..16 zero;
-		     * if set to 0xFFFFFFFF cell_id not yet recovered */
-	u32 DvbhSrvIndHP; /* DVB-H service indication info,
-			   * bit 1 - Time Slicing indicator,
-			   * bit 0 - MPE-FEC indicator */
-	u32 DvbhSrvIndLP; /* DVB-H service indication info,
-			   * bit 1 - Time Slicing indicator,
-			   * bit 0 - MPE-FEC indicator */
-
-	/* Interface information */
-	u32 SmsToHostTxErrors; /* Total number of transmission errors. */
-
+	s32 inBandPower;
+	u32 requestId;
 };
 
 struct SMSHOSTLIB_I2C_REQ_ST {
@@ -580,7 +553,7 @@ struct SMSHOSTLIB_I2C_RES_ST {
 	u32	ReadCount; /* number of bytes read */
 	u8	Data[1];
 };
-#endif
+
 
 struct smscore_gpio_config {
 #define SMS_GPIO_DIRECTION_INPUT  0
diff -r 291604c18214 -r 10143bda4dda linux/drivers/media/dvb/siano/smsdvb.c
--- a/linux/drivers/media/dvb/siano/smsdvb.c	Tue May 12 17:40:55 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsdvb.c	Tue May 12 18:32:16 2009 +0300
@@ -40,12 +40,15 @@ struct smsdvb_client_t {
 	struct dvb_frontend     frontend;
 
 	fe_status_t             fe_status;
-	int                     fe_ber, fe_snr, fe_unc, fe_signal_strength;
 
-	struct completion       tune_done, stat_done;
+	struct completion       tune_done;
 
 	/* todo: save freq/band instead whole struct */
 	struct dvb_frontend_parameters fe_params;
+
+	struct SMSHOSTLIB_STATISTICS_DVB_S sms_stat_dvb;
+	int event_fe_state;
+	int event_unc_state;
 };
 
 static struct list_head g_smsdvb_clients;
@@ -55,11 +58,19 @@ module_param_named(debug, sms_dbg, int, 
 module_param_named(debug, sms_dbg, int, 0644);
 MODULE_PARM_DESC(debug, "set debug level (info=1, adv=2 (or-able))");
 
+/* Events that may come from DVB v3 adapter */
+static void sms_board_dvb3_event(struct smsdvb_client_t *client,
+		enum SMS_DVB3_EVENTS event) {
+}
+
 static int smsdvb_onresponse(void *context, struct smscore_buffer_t *cb)
 {
 	struct smsdvb_client_t *client = (struct smsdvb_client_t *) context;
-	struct SmsMsgHdr_ST *phdr =
-		(struct SmsMsgHdr_ST *)(((u8 *) cb->p) + cb->offset);
+	struct SmsMsgHdr_ST *phdr = (struct SmsMsgHdr_ST *) (((u8 *) cb->p)
+			+ cb->offset);
+	u32 *pMsgData = (u32 *) phdr + 1;
+	/*u32 MsgDataLen = phdr->msgLength - sizeof(struct SmsMsgHdr_ST);*/
+	bool is_status_update = false;
 
 	smsendian_handle_rx_message((struct SmsMsgData_ST *) phdr);
 
@@ -73,42 +84,109 @@ static int smsdvb_onresponse(void *conte
 		complete(&client->tune_done);
 		break;
 
-	case MSG_SMS_GET_STATISTICS_RES:
-	{
-		struct SmsMsgStatisticsInfo_ST *p =
-			(struct SmsMsgStatisticsInfo_ST *)(phdr + 1);
+	case MSG_SMS_SIGNAL_DETECTED_IND:
+		sms_info("MSG_SMS_SIGNAL_DETECTED_IND");
+		client->sms_stat_dvb.TransmissionData.IsDemodLocked = true;
+		is_status_update = true;
+		break;
 
-		if (p->Stat.IsDemodLocked) {
-			client->fe_status = FE_HAS_SIGNAL |
-					    FE_HAS_CARRIER |
-					    FE_HAS_VITERBI |
-					    FE_HAS_SYNC |
-					    FE_HAS_LOCK;
+	case MSG_SMS_NO_SIGNAL_IND:
+		sms_info("MSG_SMS_NO_SIGNAL_IND");
+		client->sms_stat_dvb.TransmissionData.IsDemodLocked = false;
+		is_status_update = true;
+		break;
 
-			client->fe_snr = p->Stat.SNR;
-			client->fe_ber = p->Stat.BER;
-			client->fe_unc = p->Stat.BERErrorCount;
+	case MSG_SMS_TRANSMISSION_IND: {
+		sms_info("MSG_SMS_TRANSMISSION_IND");
 
-			if (p->Stat.InBandPwr < -95)
-				client->fe_signal_strength = 0;
-			else if (p->Stat.InBandPwr > -29)
-				client->fe_signal_strength = 100;
-			else
-				client->fe_signal_strength =
-					(p->Stat.InBandPwr + 95) * 3 / 2;
+		pMsgData++;
+		memcpy(&client->sms_stat_dvb.TransmissionData, pMsgData,
+				sizeof(struct TRANSMISSION_STATISTICS_S));
+
+		/* Mo need to correct guard interval
+		 * (as opposed to old statistics message).
+		 */
+		CORRECT_STAT_BANDWIDTH(client->sms_stat_dvb.TransmissionData);
+		CORRECT_STAT_TRANSMISSON_MODE(
+				client->sms_stat_dvb.TransmissionData);
+		is_status_update = true;
+		break;
+	}
+	case MSG_SMS_HO_PER_SLICES_IND: {
+		struct RECEPTION_STATISTICS_S *pReceptionData =
+				&client->sms_stat_dvb.ReceptionData;
+		struct SRVM_SIGNAL_STATUS_S SignalStatusData;
+
+		/*sms_info("MSG_SMS_HO_PER_SLICES_IND");*/
+		pMsgData++;
+		SignalStatusData.result = pMsgData[0];
+		SignalStatusData.snr = pMsgData[1];
+		SignalStatusData.inBandPower = (s32) pMsgData[2];
+		SignalStatusData.tsPackets = pMsgData[3];
+		SignalStatusData.etsPackets = pMsgData[4];
+		SignalStatusData.constellation = pMsgData[5];
+		SignalStatusData.hpCode = pMsgData[6];
+		SignalStatusData.tpsSrvIndLP = pMsgData[7] & 0x03;
+		SignalStatusData.tpsSrvIndHP = pMsgData[8] & 0x03;
+		SignalStatusData.cellId = pMsgData[9] & 0xFFFF;
+		SignalStatusData.reason = pMsgData[10];
+		SignalStatusData.requestId = pMsgData[11];
+		pReceptionData->IsRfLocked = pMsgData[16];
+		pReceptionData->IsDemodLocked = pMsgData[17];
+		pReceptionData->ModemState = pMsgData[12];
+		pReceptionData->SNR = pMsgData[1];
+		pReceptionData->BER = pMsgData[13];
+		pReceptionData->RSSI = pMsgData[14];
+		CORRECT_STAT_RSSI(client->sms_stat_dvb.ReceptionData);
+
+		pReceptionData->InBandPwr = (s32) pMsgData[2];
+		pReceptionData->CarrierOffset = (s32) pMsgData[15];
+		pReceptionData->TotalTSPackets = pMsgData[3];
+		pReceptionData->ErrorTSPackets = pMsgData[4];
+
+		/* TS PER */
+		if ((SignalStatusData.tsPackets + SignalStatusData.etsPackets)
+				> 0) {
+			pReceptionData->TS_PER = (SignalStatusData.etsPackets
+					* 100) / (SignalStatusData.tsPackets
+					+ SignalStatusData.etsPackets);
 		} else {
-			client->fe_status = 0;
-			client->fe_snr =
-			client->fe_ber =
-			client->fe_unc =
-			client->fe_signal_strength = 0;
+			pReceptionData->TS_PER = 0;
 		}
 
-		complete(&client->stat_done);
+		pReceptionData->BERBitCount = pMsgData[18];
+		pReceptionData->BERErrorCount = pMsgData[19];
+
+		pReceptionData->MRC_SNR = pMsgData[20];
+		pReceptionData->MRC_InBandPwr = pMsgData[21];
+		pReceptionData->MRC_RSSI = pMsgData[22];
+
+		is_status_update = true;
 		break;
-	} }
+	}
+	}
+	smscore_putbuffer(client->coredev, cb);
 
-	smscore_putbuffer(client->coredev, cb);
+	if (is_status_update) {
+		if (client->sms_stat_dvb.ReceptionData.IsDemodLocked) {
+			client->fe_status = FE_HAS_SIGNAL | FE_HAS_CARRIER
+				| FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
+			sms_board_dvb3_event(client, DVB3_EVENT_FE_LOCK);
+			if (client->sms_stat_dvb.ReceptionData.ErrorTSPackets
+					== 0)
+				sms_board_dvb3_event(client, DVB3_EVENT_UNC_OK);
+			else
+				sms_board_dvb3_event(client,
+						DVB3_EVENT_UNC_ERR);
+
+		} else {
+			/*client->fe_status =
+				(phdr->msgType == MSG_SMS_NO_SIGNAL_IND) ?
+				0 : FE_HAS_SIGNAL;*/
+			client->fe_status = 0;
+			sms_board_dvb3_event(client, DVB3_EVENT_FE_UNLOCK);
+		}
+	}
 
 	return 0;
 }
@@ -194,83 +272,61 @@ static int smsdvb_sendrequest_and_wait(s
 						0 : -ETIME;
 }
 
-static int smsdvb_send_statistics_request(struct smsdvb_client_t *client)
-{
-	struct SmsMsgHdr_ST Msg = { MSG_SMS_GET_STATISTICS_REQ,
-			     DVBT_BDA_CONTROL_MSG_ID,
-			     HIF_TASK, sizeof(struct SmsMsgHdr_ST), 0 };
-	int ret = smsdvb_sendrequest_and_wait(client, &Msg, sizeof(Msg),
-					      &client->stat_done);
-	if (ret < 0)
-		return ret;
-
-	if (client->fe_status & FE_HAS_LOCK)
-		sms_board_led_feedback(client->coredev,
-				       (client->fe_unc == 0) ?
-				       SMS_LED_HI : SMS_LED_LO);
-	else
-		sms_board_led_feedback(client->coredev, SMS_LED_OFF);
-	return ret;
-}
-
 static int smsdvb_read_status(struct dvb_frontend *fe, fe_status_t *stat)
 {
-	struct smsdvb_client_t *client =
-		container_of(fe, struct smsdvb_client_t, frontend);
-	int rc = smsdvb_send_statistics_request(client);
+	struct smsdvb_client_t *client;
+	client = container_of(fe, struct smsdvb_client_t, frontend);
 
-	if (!rc)
-		*stat = client->fe_status;
+	*stat = client->fe_status;
 
-	return rc;
+	return 0;
 }
 
 static int smsdvb_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
-	struct smsdvb_client_t *client =
-		container_of(fe, struct smsdvb_client_t, frontend);
-	int rc = smsdvb_send_statistics_request(client);
+	struct smsdvb_client_t *client;
+	client = container_of(fe, struct smsdvb_client_t, frontend);
 
-	if (!rc)
-		*ber = client->fe_ber;
+	*ber = client->sms_stat_dvb.ReceptionData.BER;
 
-	return rc;
+	return 0;
 }
 
 static int smsdvb_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 {
-	struct smsdvb_client_t *client =
-		container_of(fe, struct smsdvb_client_t, frontend);
-	int rc = smsdvb_send_statistics_request(client);
+	struct smsdvb_client_t *client;
+	client = container_of(fe, struct smsdvb_client_t, frontend);
 
-	if (!rc)
-		*strength = client->fe_signal_strength;
+	if (client->sms_stat_dvb.ReceptionData.InBandPwr < -95)
+		*strength = 0;
+		else if (client->sms_stat_dvb.ReceptionData.InBandPwr > -29)
+			*strength = 100;
+		else
+			*strength =
+				(client->sms_stat_dvb.ReceptionData.InBandPwr
+				+ 95) * 3 / 2;
 
-	return rc;
+	return 0;
 }
 
 static int smsdvb_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
-	struct smsdvb_client_t *client =
-		container_of(fe, struct smsdvb_client_t, frontend);
-	int rc = smsdvb_send_statistics_request(client);
+	struct smsdvb_client_t *client;
+	client = container_of(fe, struct smsdvb_client_t, frontend);
 
-	if (!rc)
-		*snr = client->fe_snr;
+	*snr = client->sms_stat_dvb.ReceptionData.SNR;
 
-	return rc;
+	return 0;
 }
 
 static int smsdvb_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
-	struct smsdvb_client_t *client =
-		container_of(fe, struct smsdvb_client_t, frontend);
-	int rc = smsdvb_send_statistics_request(client);
+	struct smsdvb_client_t *client;
+	client = container_of(fe, struct smsdvb_client_t, frontend);
 
-	if (!rc)
-		*ucblocks = client->fe_unc;
+	*ucblocks = client->sms_stat_dvb.ReceptionData.ErrorTSPackets;
 
-	return rc;
+	return 0;
 }
 
 static int smsdvb_get_tune_settings(struct dvb_frontend *fe,
@@ -294,12 +350,15 @@ static int smsdvb_set_frontend(struct dv
 		struct SmsMsgHdr_ST	Msg;
 		u32		Data[3];
 	} Msg;
-	int ret;
 
-	Msg.Msg.msgSrcId  = DVBT_BDA_CONTROL_MSG_ID;
-	Msg.Msg.msgDstId  = HIF_TASK;
-	Msg.Msg.msgFlags  = 0;
-	Msg.Msg.msgType   = MSG_SMS_RF_TUNE_REQ;
+	client->fe_status = FE_HAS_SIGNAL;
+	client->event_fe_state = -1;
+	client->event_unc_state = -1;
+
+	Msg.Msg.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
+	Msg.Msg.msgDstId = HIF_TASK;
+	Msg.Msg.msgFlags = 0;
+	Msg.Msg.msgType = MSG_SMS_RF_TUNE_REQ;
 	Msg.Msg.msgLength = sizeof(Msg);
 	Msg.Data[0] = fep->frequency;
 	Msg.Data[2] = 12000000;
@@ -316,24 +375,6 @@ static int smsdvb_set_frontend(struct dv
 #endif
 	case BANDWIDTH_AUTO: return -EOPNOTSUPP;
 	default: return -EINVAL;
-	}
-
-	/* Disable LNA, if any. An error is returned if no LNA is present */
-	ret = sms_board_lna_control(client->coredev, 0);
-	if (ret == 0) {
-		fe_status_t status;
-
-		/* tune with LNA off at first */
-		ret = smsdvb_sendrequest_and_wait(client, &Msg, sizeof(Msg),
-						  &client->tune_done);
-
-		smsdvb_read_status(fe, &status);
-
-		if (status & FE_HAS_LOCK)
-			return ret;
-
-		/* previous tune didnt lock - enable LNA and tune again */
-		sms_board_lna_control(client->coredev, 1);
 	}
 
 	return smsdvb_sendrequest_and_wait(client, &Msg, sizeof(Msg),
@@ -360,8 +401,7 @@ static int smsdvb_init(struct dvb_fronte
 	struct smsdvb_client_t *client =
 		container_of(fe, struct smsdvb_client_t, frontend);
 
-	sms_board_power(client->coredev, 1);
-
+	sms_board_dvb3_event(client, DVB3_EVENT_INIT);
 	return 0;
 }
 
@@ -370,8 +410,7 @@ static int smsdvb_sleep(struct dvb_front
 	struct smsdvb_client_t *client =
 		container_of(fe, struct smsdvb_client_t, frontend);
 
-	sms_board_led_feedback(client->coredev, SMS_LED_OFF);
-	sms_board_power(client->coredev, 0);
+	sms_board_dvb3_event(client, DVB3_EVENT_SLEEP);
 
 	return 0;
 }
@@ -503,8 +542,11 @@ static int smsdvb_hotplug(struct smscore
 
 	kmutex_unlock(&g_smsdvb_clientslock);
 
+	client->event_fe_state = -1;
+	client->event_unc_state = -1;
+	sms_board_dvb3_event(client, DVB3_EVENT_HOTPLUG);
+
 	sms_info("success");
-
 	sms_board_setup(coredev);
 
 	return 0;



      
