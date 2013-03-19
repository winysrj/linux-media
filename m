Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933155Ab3CSQuW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:50:22 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 20/46] [media] siano: use the newer stats message for recent firmwares
Date: Tue, 19 Mar 2013 13:49:09 -0300
Message-Id: <1363711775-2120-21-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The old statistics request don't work with newer firmwares.
Add a logic to use the newer stats if firmware major is 8.

Note that I have only 2 devices here, one with firmware 2.1
(Hauppauge model 55009 Rev B1F7) and another one with
firmware 8.1. We may need to adjust the firmware minimal
version for the *_EX message variants, as we start finding
firmware versions between 2.x and 8.x.

This patch was based on Doron Cohen patch:
	http://patchwork.linuxtv.org/patch/7886/

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smscoreapi.h | 103 +++++++++++++++++++
 drivers/media/common/siano/smsdvb.c     | 177 ++++++++++++++++++++++++++++----
 2 files changed, 260 insertions(+), 20 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index 8af94c4..7925c04 100644
--- a/drivers/media/common/siano/smscoreapi.h
+++ b/drivers/media/common/siano/smscoreapi.h
@@ -800,6 +800,66 @@ struct SMSHOSTLIB_STATISTICS_ISDBT_ST {
 	u32 SmsToHostTxErrors; /* Total number of transmission errors. */
 };
 
+struct SMSHOSTLIB_STATISTICS_ISDBT_EX_ST {
+	u32 StatisticsType; /* Enumerator identifying the type of the
+				* structure.  Values are the same as
+				* SMSHOSTLIB_DEVICE_MODES_E
+				*
+				* This field MUST always be first in any
+				* statistics structure */
+
+	u32 FullSize; /* Total size of the structure returned by the modem.
+		       * If the size requested by the host is smaller than
+		       * FullSize, the struct will be truncated */
+
+	/* Common parameters */
+	u32 IsRfLocked; /* 0 - not locked, 1 - locked */
+	u32 IsDemodLocked; /* 0 - not locked, 1 - locked */
+	u32 IsExternalLNAOn; /* 0 - external LNA off, 1 - external LNA on */
+
+	/* Reception quality */
+	s32  SNR; /* dB */
+	s32  RSSI; /* dBm */
+	s32  InBandPwr; /* In band power in dBM */
+	s32  CarrierOffset; /* Carrier Offset in Hz */
+
+	/* Transmission parameters */
+	u32 Frequency; /* Frequency in Hz */
+	u32 Bandwidth; /* Bandwidth in MHz */
+	u32 TransmissionMode; /* ISDB-T transmission mode */
+	u32 ModemState; /* 0 - Acquisition, 1 - Locked */
+	u32 GuardInterval; /* Guard Interval, 1 divided by value */
+	u32 SystemType; /* ISDB-T system type (ISDB-T / ISDB-Tsb) */
+	u32 PartialReception; /* TRUE - partial reception, FALSE otherwise */
+	u32 NumOfLayers; /* Number of ISDB-T layers in the network */
+
+	u32 SegmentNumber; /* Segment number for ISDB-Tsb */
+	u32 TuneBW;	   /* Tuned bandwidth - BW_ISDBT_1SEG / BW_ISDBT_3SEG */
+
+	/* Per-layer information */
+	/* Layers A, B and C */
+	struct SMSHOSTLIB_ISDBT_LAYER_STAT_ST	LayerInfo[3];
+	/* Per-layer statistics, see SMSHOSTLIB_ISDBT_LAYER_STAT_ST */
+
+	/* Interface information */
+	u32 Reserved1;    /* Was SmsToHostTxErrors - obsolete . */
+ /* Proprietary information */
+	u32 ExtAntenna;    /* Obsolete field. */
+	u32 ReceptionQuality;
+	u32 EwsAlertActive;   /* Signals if EWS alert is currently on */
+	u32 LNAOnOff;	/* Internal LNA state: 0: OFF, 1: ON */
+
+	u32 RfAgcLevel;	 /* RF AGC Level [linear units], full gain = 65535 (20dB) */
+	u32 BbAgcLevel;    /* Baseband AGC level [linear units], full gain = 65535 (71.5dB) */
+	u32 FwErrorsCounter;   /* Application errors - should be always zero */
+	u8 FwErrorsHistoryArr[8]; /* Last FW errors IDs - first is most recent, last is oldest */
+
+	s32  MRC_SNR;     /* dB */
+	u32 SNRFullRes;    /* dB x 65536 */
+	u32 Reserved4[4];
+};
+
+
 struct PID_STATISTICS_DATA_S {
 	struct PID_BURST_S {
 		u32 size;
@@ -880,6 +940,35 @@ struct RECEPTION_STATISTICS_S {
 	s32 MRC_InBandPwr;	/* In band power in dBM */
 };
 
+struct RECEPTION_STATISTICS_EX_S {
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
+	s32  RefDevPPM;
+	s32  FreqDevHz;
+
+	s32 MRC_SNR;		/* dB */
+	s32 MRC_RSSI;		/* dBm */
+	s32 MRC_InBandPwr;	/* In band power in dBM */
+};
+
 
 /* Statistics information returned as response for
  * SmsHostApiGetStatisticsEx_Req for DVB applications, SMS1100 and up */
@@ -895,6 +984,20 @@ struct SMSHOSTLIB_STATISTICS_DVB_S {
 	struct PID_DATA_S PidData[SRVM_MAX_PID_FILTERS];
 };
 
+/* Statistics information returned as response for
+ * SmsHostApiGetStatisticsEx_Req for DVB applications, SMS1100 and up */
+struct SMSHOSTLIB_STATISTICS_DVB_EX_S {
+	/* Reception */
+	struct RECEPTION_STATISTICS_EX_S ReceptionData;
+
+	/* Transmission parameters */
+	struct TRANSMISSION_STATISTICS_S TransmissionData;
+
+	/* Burst parameters, valid only for DVB-H */
+#define	SRVM_MAX_PID_FILTERS 8
+	struct PID_DATA_S PidData[SRVM_MAX_PID_FILTERS];
+};
+
 struct SRVM_SIGNAL_STATUS_S {
 	u32 result;
 	u32 snr;
diff --git a/drivers/media/common/siano/smsdvb.c b/drivers/media/common/siano/smsdvb.c
index 864f53e..dbb807e 100644
--- a/drivers/media/common/siano/smsdvb.c
+++ b/drivers/media/common/siano/smsdvb.c
@@ -50,7 +50,7 @@ struct smsdvb_client_t {
 	struct completion       tune_done;
 	struct completion       stats_done;
 
-	struct SMSHOSTLIB_STATISTICS_DVB_S sms_stat_dvb;
+	struct SMSHOSTLIB_STATISTICS_DVB_EX_S sms_stat_dvb;
 	int event_fe_state;
 	int event_unc_state;
 };
@@ -115,12 +115,10 @@ static void sms_board_dvb3_event(struct smsdvb_client_t *client,
 	}
 }
 
-
-static void smsdvb_update_dvb_stats(struct RECEPTION_STATISTICS_S *pReceptionData,
+static void smsdvb_update_dvb_stats(struct RECEPTION_STATISTICS_EX_S *pReceptionData,
 				   struct SMSHOSTLIB_STATISTICS_ST *p)
 {
 	if (sms_dbg & 2) {
-		printk(KERN_DEBUG "Reserved = %d", p->Reserved);
 		printk(KERN_DEBUG "IsRfLocked = %d", p->IsRfLocked);
 		printk(KERN_DEBUG "IsDemodLocked = %d", p->IsDemodLocked);
 		printk(KERN_DEBUG "IsExternalLNAOn = %d", p->IsExternalLNAOn);
@@ -132,6 +130,7 @@ static void smsdvb_update_dvb_stats(struct RECEPTION_STATISTICS_S *pReceptionDat
 		printk(KERN_DEBUG "RSSI = %d", p->RSSI);
 		printk(KERN_DEBUG "InBandPwr = %d", p->InBandPwr);
 		printk(KERN_DEBUG "CarrierOffset = %d", p->CarrierOffset);
+		printk(KERN_DEBUG "ModemState = %d", p->ModemState);
 		printk(KERN_DEBUG "Frequency = %d", p->Frequency);
 		printk(KERN_DEBUG "Bandwidth = %d", p->Bandwidth);
 		printk(KERN_DEBUG "TransmissionMode = %d", p->TransmissionMode);
@@ -163,17 +162,24 @@ static void smsdvb_update_dvb_stats(struct RECEPTION_STATISTICS_S *pReceptionDat
 		printk(KERN_DEBUG "NumMPEReceived = %d", p->NumMPEReceived);
 	}
 
+	/* update reception data */
+	pReceptionData->IsRfLocked = p->IsRfLocked;
 	pReceptionData->IsDemodLocked = p->IsDemodLocked;
-
+	pReceptionData->IsExternalLNAOn = p->IsExternalLNAOn;
+	pReceptionData->ModemState = p->ModemState;
 	pReceptionData->SNR = p->SNR;
 	pReceptionData->BER = p->BER;
 	pReceptionData->BERErrorCount = p->BERErrorCount;
+	pReceptionData->BERBitCount = p->BERBitCount;
+	pReceptionData->RSSI = p->RSSI;
+	CORRECT_STAT_RSSI(*pReceptionData);
 	pReceptionData->InBandPwr = p->InBandPwr;
+	pReceptionData->CarrierOffset = p->CarrierOffset;
 	pReceptionData->ErrorTSPackets = p->ErrorTSPackets;
+	pReceptionData->TotalTSPackets = p->TotalTSPackets;
 };
 
-
-static void smsdvb_update_isdbt_stats(struct RECEPTION_STATISTICS_S *pReceptionData,
+static void smsdvb_update_isdbt_stats(struct RECEPTION_STATISTICS_EX_S *pReceptionData,
 				    struct SMSHOSTLIB_STATISTICS_ISDBT_ST *p)
 {
 	int i;
@@ -212,18 +218,100 @@ static void smsdvb_update_isdbt_stats(struct RECEPTION_STATISTICS_S *pReceptionD
 		}
 	}
 
+	/* update reception data */
+	pReceptionData->IsRfLocked = p->IsRfLocked;
 	pReceptionData->IsDemodLocked = p->IsDemodLocked;
+	pReceptionData->IsExternalLNAOn = p->IsExternalLNAOn;
+	pReceptionData->ModemState = p->ModemState;
+	pReceptionData->SNR = p->SNR;
+	pReceptionData->BER = p->LayerInfo[0].BER;
+	pReceptionData->BERErrorCount = p->LayerInfo[0].BERErrorCount;
+	pReceptionData->BERBitCount = p->LayerInfo[0].BERBitCount;
+	pReceptionData->RSSI = p->RSSI;
+	CORRECT_STAT_RSSI(*pReceptionData);
+	pReceptionData->InBandPwr = p->InBandPwr;
 
+	pReceptionData->CarrierOffset = p->CarrierOffset;
+	pReceptionData->ErrorTSPackets = p->LayerInfo[0].ErrorTSPackets;
+	pReceptionData->TotalTSPackets = p->LayerInfo[0].TotalTSPackets;
+	pReceptionData->MFER = 0;
+
+	/* TS PER */
+	if ((p->LayerInfo[0].TotalTSPackets +
+		 p->LayerInfo[0].ErrorTSPackets) > 0) {
+		pReceptionData->TS_PER = (p->LayerInfo[0].ErrorTSPackets
+				* 100) / (p->LayerInfo[0].TotalTSPackets
+				+ p->LayerInfo[0].ErrorTSPackets);
+	} else {
+		pReceptionData->TS_PER = 0;
+	}
+}
+
+static void smsdvb_update_isdbt_stats_ex(struct RECEPTION_STATISTICS_EX_S *pReceptionData,
+				    struct SMSHOSTLIB_STATISTICS_ISDBT_EX_ST *p)
+{
+	int i;
+
+	if (sms_dbg & 2) {
+		printk(KERN_DEBUG "IsRfLocked = %d", p->IsRfLocked);
+		printk(KERN_DEBUG "IsDemodLocked = %d", p->IsDemodLocked);
+		printk(KERN_DEBUG "IsExternalLNAOn = %d", p->IsExternalLNAOn);
+		printk(KERN_DEBUG "SNR = %d", p->SNR);
+		printk(KERN_DEBUG "RSSI = %d", p->RSSI);
+		printk(KERN_DEBUG "InBandPwr = %d", p->InBandPwr);
+		printk(KERN_DEBUG "CarrierOffset = %d", p->CarrierOffset);
+		printk(KERN_DEBUG "Frequency = %d", p->Frequency);
+		printk(KERN_DEBUG "Bandwidth = %d", p->Bandwidth);
+		printk(KERN_DEBUG "TransmissionMode = %d", p->TransmissionMode);
+		printk(KERN_DEBUG "ModemState = %d", p->ModemState);
+		printk(KERN_DEBUG "GuardInterval = %d", p->GuardInterval);
+		printk(KERN_DEBUG "SystemType = %d", p->SystemType);
+		printk(KERN_DEBUG "PartialReception = %d", p->PartialReception);
+		printk(KERN_DEBUG "NumOfLayers = %d", p->NumOfLayers);
+		printk(KERN_DEBUG "SegmentNumber = %d", p->SegmentNumber);
+		printk(KERN_DEBUG "TuneBW = %d", p->TuneBW);
+		for (i = 0; i < 3; i++) {
+			printk(KERN_DEBUG "%d: CodeRate = %d", i, p->LayerInfo[i].CodeRate);
+			printk(KERN_DEBUG "%d: Constellation = %d", i, p->LayerInfo[i].Constellation);
+			printk(KERN_DEBUG "%d: BER = %d", i, p->LayerInfo[i].BER);
+			printk(KERN_DEBUG "%d: BERErrorCount = %d", i, p->LayerInfo[i].BERErrorCount);
+			printk(KERN_DEBUG "%d: BERBitCount = %d", i, p->LayerInfo[i].BERBitCount);
+			printk(KERN_DEBUG "%d: PreBER = %d", i, p->LayerInfo[i].PreBER);
+			printk(KERN_DEBUG "%d: TS_PER = %d", i, p->LayerInfo[i].TS_PER);
+			printk(KERN_DEBUG "%d: ErrorTSPackets = %d", i, p->LayerInfo[i].ErrorTSPackets);
+			printk(KERN_DEBUG "%d: TotalTSPackets = %d", i, p->LayerInfo[i].TotalTSPackets);
+			printk(KERN_DEBUG "%d: TILdepthI = %d", i, p->LayerInfo[i].TILdepthI);
+			printk(KERN_DEBUG "%d: NumberOfSegments = %d", i, p->LayerInfo[i].NumberOfSegments);
+			printk(KERN_DEBUG "%d: TMCCErrors = %d", i, p->LayerInfo[i].TMCCErrors);
+		}
+	}
+
+	/* update reception data */
+	pReceptionData->IsRfLocked = p->IsRfLocked;
+	pReceptionData->IsDemodLocked = p->IsDemodLocked;
+	pReceptionData->IsExternalLNAOn = p->IsExternalLNAOn;
+	pReceptionData->ModemState = p->ModemState;
 	pReceptionData->SNR = p->SNR;
+	pReceptionData->BER = p->LayerInfo[0].BER;
+	pReceptionData->BERErrorCount = p->LayerInfo[0].BERErrorCount;
+	pReceptionData->BERBitCount = p->LayerInfo[0].BERBitCount;
+	pReceptionData->RSSI = p->RSSI;
+	CORRECT_STAT_RSSI(*pReceptionData);
 	pReceptionData->InBandPwr = p->InBandPwr;
 
-	pReceptionData->ErrorTSPackets = 0;
-	pReceptionData->BER = 0;
-	pReceptionData->BERErrorCount = 0;
-	for (i = 0; i < 3; i++) {
-		pReceptionData->BER += p->LayerInfo[i].BER;
-		pReceptionData->BERErrorCount += p->LayerInfo[i].BERErrorCount;
-		pReceptionData->ErrorTSPackets += p->LayerInfo[i].ErrorTSPackets;
+	pReceptionData->CarrierOffset = p->CarrierOffset;
+	pReceptionData->ErrorTSPackets = p->LayerInfo[0].ErrorTSPackets;
+	pReceptionData->TotalTSPackets = p->LayerInfo[0].TotalTSPackets;
+	pReceptionData->MFER = 0;
+
+	/* TS PER */
+	if ((p->LayerInfo[0].TotalTSPackets +
+		 p->LayerInfo[0].ErrorTSPackets) > 0) {
+		pReceptionData->TS_PER = (p->LayerInfo[0].ErrorTSPackets
+				* 100) / (p->LayerInfo[0].TotalTSPackets
+				+ p->LayerInfo[0].ErrorTSPackets);
+	} else {
+		pReceptionData->TS_PER = 0;
 	}
 }
 
@@ -260,21 +348,29 @@ static int smsdvb_onresponse(void *context, struct smscore_buffer_t *cb)
 		break;
 
 	case MSG_SMS_TRANSMISSION_IND: {
+
 		pMsgData++;
 		memcpy(&client->sms_stat_dvb.TransmissionData, pMsgData,
 				sizeof(struct TRANSMISSION_STATISTICS_S));
 
+#if 1
+		/*
+		 * FIXME: newer driver doesn't have those fixes
+		 * Are those firmware-specific stuff?
+		 */
+
 		/* Mo need to correct guard interval
 		 * (as opposed to old statistics message).
 		 */
 		CORRECT_STAT_BANDWIDTH(client->sms_stat_dvb.TransmissionData);
 		CORRECT_STAT_TRANSMISSON_MODE(
 				client->sms_stat_dvb.TransmissionData);
+#endif
 		is_status_update = true;
 		break;
 	}
 	case MSG_SMS_HO_PER_SLICES_IND: {
-		struct RECEPTION_STATISTICS_S *pReceptionData =
+		struct RECEPTION_STATISTICS_EX_S *pReceptionData =
 				&client->sms_stat_dvb.ReceptionData;
 		struct SRVM_SIGNAL_STATUS_S SignalStatusData;
 
@@ -329,7 +425,7 @@ static int smsdvb_onresponse(void *context, struct smscore_buffer_t *cb)
 			struct SMSHOSTLIB_STATISTICS_ISDBT_ST  isdbt;
 			struct SmsMsgStatisticsInfo_ST         dvb;
 		} *p = (void *) (phdr + 1);
-		struct RECEPTION_STATISTICS_S *pReceptionData =
+		struct RECEPTION_STATISTICS_EX_S *pReceptionData =
 				&client->sms_stat_dvb.ReceptionData;
 
 		is_status_update = true;
@@ -352,6 +448,34 @@ static int smsdvb_onresponse(void *context, struct smscore_buffer_t *cb)
 
 		break;
 	}
+	case MSG_SMS_GET_STATISTICS_EX_RES: {
+		union {
+			struct SMSHOSTLIB_STATISTICS_ISDBT_EX_ST isdbt;
+			struct SMSHOSTLIB_STATISTICS_ST          dvb;
+		} *p = (void *) (phdr + 1);
+		struct RECEPTION_STATISTICS_EX_S *pReceptionData =
+				&client->sms_stat_dvb.ReceptionData;
+
+		is_status_update = true;
+
+		switch (smscore_get_device_mode(client->coredev)) {
+		case DEVICE_MODE_ISDBT:
+		case DEVICE_MODE_ISDBT_BDA:
+			smsdvb_update_isdbt_stats_ex(pReceptionData, &p->isdbt);
+			break;
+		default:
+			smsdvb_update_dvb_stats(pReceptionData, &p->dvb);
+		}
+		if (!pReceptionData->IsDemodLocked) {
+			pReceptionData->SNR = 0;
+			pReceptionData->BER = 0;
+			pReceptionData->BERErrorCount = 0;
+			pReceptionData->InBandPwr = 0;
+			pReceptionData->ErrorTSPackets = 0;
+		}
+
+		break;
+	}
 	default:
 		sms_info("message not handled");
 	}
@@ -466,10 +590,23 @@ static int smsdvb_sendrequest_and_wait(struct smsdvb_client_t *client,
 static int smsdvb_send_statistics_request(struct smsdvb_client_t *client)
 {
 	int rc;
-	struct SmsMsgHdr_ST Msg = { MSG_SMS_GET_STATISTICS_REQ,
-				    DVBT_BDA_CONTROL_MSG_ID,
-				    HIF_TASK,
-				    sizeof(struct SmsMsgHdr_ST), 0 };
+	struct SmsMsgHdr_ST Msg;
+
+
+	Msg.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
+	Msg.msgDstId = HIF_TASK;
+	Msg.msgFlags = 0;
+	Msg.msgLength = sizeof(Msg);
+
+	/*
+	 * Check for firmware version, to avoid breaking for old cards
+	 */
+	if (client->coredev->fw_version >= 0x800)
+		Msg.msgType = MSG_SMS_GET_STATISTICS_EX_REQ;
+	else
+		Msg.msgType = MSG_SMS_GET_STATISTICS_REQ;
+
+	smsendian_handle_tx_message((struct SmsMsgHdr_S *)&Msg);
 
 	rc = smsdvb_sendrequest_and_wait(client, &Msg, sizeof(Msg),
 					 &client->stats_done);
-- 
1.8.1.4

