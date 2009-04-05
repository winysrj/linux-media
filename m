Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110810.mail.gq1.yahoo.com ([67.195.13.233]:26841 "HELO
	web110810.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751839AbZDEIao (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 04:30:44 -0400
Message-ID: <664474.9228.qm@web110810.mail.gq1.yahoo.com>
Date: Sun, 5 Apr 2009 01:30:42 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0904_6] Siano: smsdvb - new device status mechanism
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1238694624 -10800
# Node ID 4a0b207a424af7f05d8eb417a698a82a61dd086f
# Parent  eb9fed366b2bb2b8a99760f52b9c0e40d72a71e0
siano: smsdvb - new device status mechanism
[PATCH] [0904_6] Siano: smsdvb - new device status mechanism

From: Uri Shkolnik <uris@siano-ms.com>

This is quite large patch, but it atomic. The patch introduces
new , and much better way to be updated about SMS device status.
Instead of pulling (by submitting statistics_request message),
the driver use the information which is pushed by the device.
Changes are: updated statistics structure (header file) and
the implementation in the smsdvb which use this information.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r eb9fed366b2b -r 4a0b207a424a linux/drivers/media/dvb/siano/smscoreapi.h
--- a/linux/drivers/media/dvb/siano/smscoreapi.h	Thu Apr 02 20:14:17 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.h	Thu Apr 02 20:50:24 2009 +0300
@@ -351,240 +351,203 @@ struct SmsFirmware_ST {
 	u8 Payload[1];
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
-	s32 SNR; /* dB */
-	u32 BER; /* Post Viterbi BER [1E-5] */
-	u32 FIB_CRC; /* CRC errors percentage, valid only for DAB */
-	/* Transport stream PER, 0xFFFFFFFF indicate N/A,
-	 * valid only for DVB-T/H */
-	u32 TS_PER;
-	/* DVB-H frame error rate in percentage,
-	 * 0xFFFFFFFF indicate N/A, valid only for DVB-H */
-	u32 MFER;
-	s32 RSSI; /* dBm */
-	s32 InBandPwr; /* In band power in dBM */
-	s32 CarrierOffset; /* Carrier Offset in bin/1024 */
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
-	 * for DVB-T/H FFT mode carriers in Kilos */
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
-	 * as calculated by demodulator */
-	u32 NumOfRows; /* Number of rows in MPE table */
-	u32 NumOfPaddCols; /* Number of padding columns in MPE table */
-	u32 NumOfPunctCols; /* Number of puncturing columns in MPE table */
-	/* Burst parameters */
-	u32 ErrorTSPackets; /* Number of erroneous transport-stream packets */
-	u32 TotalTSPackets; /* Total number of transport-stream packets */
-	u32 NumOfValidMpeTlbs; /* Number of MPE tables which do not include
-	 * errors after MPE RS decoding */
-	u32 NumOfInvalidMpeTlbs; /* Number of MPE tables which include errors
-	 * after MPE RS decoding */
-	u32 NumOfCorrectedMpeTlbs; /* Number of MPE tables which were corrected
-	 * by MPE RS decoding */
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
-	 * if set to 0xFFFFFFFF cell_id not yet recovered */
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
-	 * 255 means layer does not exist */
-	u32 Constellation; /* Constellation from SMSHOSTLIB_CONSTELLATION_ET,
-	 * 255 means layer does not exist */
-	u32 BER; /* Post Viterbi BER [1E-5], 0xFFFFFFFF indicate N/A */
-	u32 BERErrorCount; /* Post Viterbi Error Bits Count */
-	u32 BERBitCount; /* Post Viterbi Total Bits Count */
-	u32 PreBER; /* Pre Viterbi BER [1E-5], 0xFFFFFFFF indicate N/A */
-	u32 TS_PER; /* Transport stream PER [%], 0xFFFFFFFF indicate N/A */
-	u32 ErrorTSPackets; /* Number of erroneous transport-stream packets */
-	u32 TotalTSPackets; /* Total number of transport-stream packets */
-	u32 TILdepthI; /* Time interleaver depth I parameter,
-	 * 255 means layer does not exist */
-	u32 NumberOfSegments; /* Number of segments in layer A,
-	 * 255 means layer does not exist */
-	u32 TMCCErrors; /* TMCC errors */
+struct PID_DATA_S {
+	u32 pid;
+	u32 num_rows;
+	struct PID_STATISTICS_DATA_S pid_statistics;
 };
 
-struct SMSHOSTLIB_STATISTICS_ISDBT_ST {
-	u32 StatisticsType; /* Enumerator identifying the type of the
-	 * structure.  Values are the same as
-	 * SMSHOSTLIB_DEVICE_MODES_E
-	 *
-	 * This field MUST always be first in any
-	 * statistics structure */
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
-	 * If the size requested by the host is smaller than
-	 * FullSize, the struct will be truncated */
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
-	s32 SNR; /* dB */
-	s32 RSSI; /* dBm */
-	s32 InBandPwr; /* In band power in dBM */
-	s32 CarrierOffset; /* Carrier Offset in Hz */
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
-	struct SMSHOSTLIB_ISDBT_LAYER_STAT_ST LayerInfo[3];
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
-	 * structure.  Values are the same as
-	 * SMSHOSTLIB_DEVICE_MODES_E
-	 * This field MUST always first in any
-	 * statistics structure */
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
-	 * If the size requested by the host is smaller than
-	 * FullSize, the struct will be truncated */
-	/* Common parameters */
-	u32 IsRfLocked; /* 0 - not locked, 1 - locked */
-	u32 IsDemodLocked; /* 0 - not locked, 1 - locked */
-	u32 IsExternalLNAOn; /* 0 - external LNA off, 1 - external LNA on */
-
-	/* Reception quality */
-	s32 SNR; /* dB */
-	u32 BER; /* Post Viterbi BER [1E-5] */
-	u32 BERErrorCount; /* Number of errornous SYNC bits. */
-	u32 BERBitCount; /* Total number of SYNC bits. */
-	u32 TS_PER; /* Transport stream PER, 0xFFFFFFFF indicate N/A */
-	u32 MFER; /* DVB-H frame error rate in percentage,
-	 * 0xFFFFFFFF indicate N/A, valid only for DVB-H */
-	s32 RSSI; /* dBm */
-	s32 InBandPwr; /* In band power in dBM */
-	s32 CarrierOffset; /* Carrier Offset in bin/1024 */
-
-	/* Transmission parameters */
-	u32 Frequency; /* Frequency in Hz */
-	u32 Bandwidth; /* Bandwidth in MHz */
-	u32 ModemState; /* from SMSHOSTLIB_DVB_MODEM_STATE_ET */
-	u32 TransmissionMode; /* FFT mode carriers in Kilos */
-	u32 GuardInterval; /* Guard Interval, 1 divided by value */
-	u32 CodeRate; /* Code Rate from SMSHOSTLIB_CODE_RATE_ET */
-	u32 LPCodeRate; /* Low Priority Code Rate from
-	 * SMSHOSTLIB_CODE_RATE_ET */
-	u32 Hierarchy; /* Hierarchy from SMSHOSTLIB_HIERARCHY_ET */
-	u32 Constellation; /* Constellation from SMSHOSTLIB_CONSTELLATION_ET */
-
-	/* Burst parameters, valid only for DVB-H */
-	u32 BurstSize; /* Current burst size in bytes */
-	u32 BurstDuration; /* Current burst duration in mSec */
-	u32 BurstCycleTime; /* Current burst cycle time in mSec */
-	u32 CalculatedBurstCycleTime; /* Current burst cycle time in mSec,
-	 * as calculated by demodulator */
-	u32 NumOfRows; /* Number of rows in MPE table */
-	u32 NumOfPaddCols; /* Number of padding columns in MPE table */
-	u32 NumOfPunctCols; /* Number of puncturing columns in MPE table */
-
-	u32 ErrorTSPackets; /* Number of erroneous transport-stream packets */
-	u32 TotalTSPackets; /* Total number of transport-stream packets */
-
-	u32 NumOfValidMpeTlbs; /* Number of MPE tables which do not include
-	 * errors after MPE RS decoding */
-	u32 NumOfInvalidMpeTlbs; /* Number of MPE tables which include
-	 * errors after MPE RS decoding */
-	u32 NumOfCorrectedMpeTlbs; /* Number of MPE tables which were
-	 * corrected by MPE RS decoding */
-
-	u32 NumMPEReceived; /* DVB-H, Num MPE section received */
-
-	/* DVB-H TPS parameters */
-	u32 CellId; /* TPS Cell ID in bits 15..0, bits 31..16 zero;
-	 * if set to 0xFFFFFFFF cell_id not yet recovered */
-	u32 DvbhSrvIndHP; /* DVB-H service indication info,
-	 * bit 1 - Time Slicing indicator,
-	 * bit 0 - MPE-FEC indicator */
-	u32 DvbhSrvIndLP; /* DVB-H service indication info,
-	 * bit 1 - Time Slicing indicator,
-	 * bit 0 - MPE-FEC indicator */
-
-	/* Interface information */
-	u32 SmsToHostTxErrors; /* Total number of transmission errors. */
-
+	s32 inBandPower;
+	u32 requestId;
 };
-
-struct SMSHOSTLIB_I2C_REQ_ST {
-	u32 DeviceAddress; /* I2c device address */
-	u32 WriteCount; /* number of bytes to write */
-	u32 ReadCount; /* number of bytes to read */
-	u8 Data[1];
-};
-
-struct SMSHOSTLIB_I2C_RES_ST {
-	u32 Status; /* non-zero value in case of failure */
-	u32 ReadCount; /* number of bytes read */
-	u8 Data[1];
-};
-#endif
 
 struct smscore_gpio_config {
 #define SMS_GPIO_DIRECTION_INPUT  0
diff -r eb9fed366b2b -r 4a0b207a424a linux/drivers/media/dvb/siano/smsdvb.c
--- a/linux/drivers/media/dvb/siano/smsdvb.c	Thu Apr 02 20:14:17 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsdvb.c	Thu Apr 02 20:50:24 2009 +0300
@@ -45,6 +45,8 @@ struct smsdvb_client_t {
 
 	/* todo: save freq/band instead whole struct */
 	struct dvb_frontend_parameters fe_params;
+
+	struct SMSHOSTLIB_STATISTICS_DVB_S sms_stat_dvb;
 };
 
 static struct list_head g_smsdvb_clients;
@@ -57,55 +59,128 @@ static int smsdvb_onresponse(void *conte
 static int smsdvb_onresponse(void *context, struct smscore_buffer_t *cb)
 {
 	struct smsdvb_client_t *client = (struct smsdvb_client_t *) context;
-	struct SmsMsgHdr_ST *phdr =
-		(struct SmsMsgHdr_ST *)(((u8 *) cb->p) + cb->offset);
+	struct SmsMsgHdr_ST *phdr = (struct SmsMsgHdr_ST *) (((u8 *) cb->p)
+			+ cb->offset);
+	u32 *pMsgData = (u32 *)phdr+1;
+	/*u32 MsgDataLen = phdr->msgLength - sizeof(struct SmsMsgHdr_ST);*/
+
+	/*smsendian_handle_rx_message((struct SmsMsgData_ST *) phdr);*/
 
 	switch (phdr->msgType) {
 	case MSG_SMS_DVBT_BDA_DATA:
-		dvb_dmx_swfilter(&client->demux, (u8 *)(phdr + 1),
-				 cb->size - sizeof(struct SmsMsgHdr_ST));
+		dvb_dmx_swfilter(&client->demux, (u8 *) (phdr + 1), cb->size
+				- sizeof(struct SmsMsgHdr_ST));
 		break;
 
 	case MSG_SMS_RF_TUNE_RES:
 		complete(&client->tune_done);
 		break;
 
-	case MSG_SMS_GET_STATISTICS_RES:
-	{
-		struct SmsMsgStatisticsInfo_ST *p =
-			(struct SmsMsgStatisticsInfo_ST *)(phdr + 1);
+	case MSG_SMS_SIGNAL_DETECTED_IND:
+		sms_info("MSG_SMS_SIGNAL_DETECTED_IND");
+		client->sms_stat_dvb.TransmissionData.IsDemodLocked = true;
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
+		break;
 
-			client->fe_snr = p->Stat.SNR;
-			client->fe_ber = p->Stat.BER;
-			client->fe_unc = p->Stat.BERErrorCount;
+	case MSG_SMS_TRANSMISSION_IND: {
+		struct TRANSMISSION_STATISTICS_S *ptrans =
+				(struct TRANSMISSION_STATISTICS_S *)pMsgData;
 
-			if (p->Stat.InBandPwr < -95)
-				client->fe_signal_strength = 0;
-			else if (p->Stat.InBandPwr > -29)
-				client->fe_signal_strength = 100;
-			else
-				client->fe_signal_strength =
-					(p->Stat.InBandPwr + 95) * 3 / 2;
+		sms_info("MSG_SMS_TRANSMISSION_IND");
+
+		memcpy(&client->sms_stat_dvb.TransmissionData, ptrans,
+				sizeof(struct TRANSMISSION_STATISTICS_S));
+
+		/* Mo need to correct guard interval
+		 * (as opposed to old statistics message).
+		 */
+		CORRECT_STAT_BANDWIDTH(client->sms_stat_dvb.TransmissionData);
+		CORRECT_STAT_TRANSMISSON_MODE(
+				client->sms_stat_dvb.TransmissionData);
+		break;
+	}
+	case MSG_SMS_HO_PER_SLICES_IND: {
+		struct RECEPTION_STATISTICS_S *pReceptionData =
+				&client->sms_stat_dvb.ReceptionData;
+		struct SRVM_SIGNAL_STATUS_S SignalStatusData;
+
+		sms_info("MSG_SMS_HO_PER_SLICES_IND");
+
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
 		break;
-	} }
+	}
+	}
+	smscore_putbuffer(client->coredev, cb);
 
-	smscore_putbuffer(client->coredev, cb);
+	if (client->sms_stat_dvb.TransmissionData.IsDemodLocked)
+		client->fe_status = FE_HAS_SIGNAL | FE_HAS_CARRIER
+				| FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
+	else {
+		client->fe_status = 0;
+	}
+
+/*
+	if (client->fe_status & FE_HAS_LOCK)
+		sms_board_dvb3_event(client->coredev, DVB3_EVENT_FE_LOCK);
+	else
+		sms_board_dvb3_event(client->coredev, DVB3_EVENT_FE_UNLOCK);
+
+	if (client->sms_stat_dvb.ReceptionData.ErrorTSPackets == 0)
+		sms_board_dvb3_event(client->coredev, DVB3_EVENT_UNC_OK);
+	else
+		sms_board_dvb3_event(client->coredev, DVB3_EVENT_UNC_ERR);
+*/
+
+	if (client->fe_status & FE_HAS_LOCK)
+		sms_board_led_feedback(client->coredev,
+				       (client->fe_unc == 0) ?
+				       SMS_LED_HI : SMS_LED_LO);
+	else
+		sms_board_led_feedback(client->coredev, SMS_LED_OFF);
 
 	return 0;
 }
@@ -186,83 +261,61 @@ static int smsdvb_sendrequest_and_wait(s
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



      
