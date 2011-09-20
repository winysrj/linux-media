Return-path: <linux-media-owner@vger.kernel.org>
Received: from mr.siano-ms.com ([62.0.79.70]:6282 "EHLO
	Siano-NV.ser.netvision.net.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932094Ab1ITKSt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Sep 2011 06:18:49 -0400
Subject: [PATCH 10/17]DVB:Siano drivers - Improve signal reception
 parameters monitoring using siano statistic functions
From: Doron Cohen <doronc@siano-ms.com>
Reply-To: doronc@siano-ms.com
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 20 Sep 2011 13:31:31 +0300
Message-ID: <1316514691.5199.88.camel@Doron-Ubuntu>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,
This patch Improve signal reception parameters monitoring using siano
statistic functions.
Thanks,
Doron Cohen

--------------


>From 0325e0559d99ccb5ac04e9edef8eb0281a410c52 Mon Sep 17 00:00:00 2001
From: Doron Cohen <doronc@siano-ms.com>
Date: Mon, 19 Sep 2011 14:43:01 +0300
Subject: [PATCH 13/21] Use get_statistics_ex instead of depracated
get_statistics

---
 drivers/media/dvb/siano/smsdvb.c |   73
+++++++++++++++++++++-----------------
 1 files changed, 40 insertions(+), 33 deletions(-)

diff --git a/drivers/media/dvb/siano/smsdvb.c
b/drivers/media/dvb/siano/smsdvb.c
index b80868c..aa345ed 100644
--- a/drivers/media/dvb/siano/smsdvb.c
+++ b/drivers/media/dvb/siano/smsdvb.c
@@ -48,6 +48,7 @@ struct smsdvb_client_t {
 	fe_status_t             fe_status;
 
 	struct completion       tune_done;
+	struct completion get_stats_done;
 
 	/* todo: save freq/band instead whole struct */
 	struct dvb_frontend_parameters fe_params;
@@ -330,7 +331,7 @@ static int smsdvb_onresponse(void *context, struct
smscore_buffer_t *cb)
 		is_status_update = true;
 		break;
 	}
-	case MSG_SMS_GET_STATISTICS_RES: {
+	case MSG_SMS_GET_STATISTICS_EX_RES: {
 		union {
 			struct SMSHOSTLIB_STATISTICS_ISDBT_S  isdbt;
 			struct SMSHOSTLIB_STATISTICS_DVB_S    dvb;
@@ -343,22 +344,20 @@ static int smsdvb_onresponse(void *context, struct
smscore_buffer_t *cb)
 		is_status_update = true;
 
 		switch (smscore_get_device_mode(client->coredev)) {
+		case SMSHOSTLIB_DEVMD_DVBT:
+		case SMSHOSTLIB_DEVMD_DVBH:
+		case SMSHOSTLIB_DEVMD_DVBT_BDA:
+			smsdvb_update_dvb_stats(pReceptionData, &p->dvb);
+			break;
 		case SMSHOSTLIB_DEVMD_ISDBT:
 		case SMSHOSTLIB_DEVMD_ISDBT_BDA:
 			smsdvb_update_isdbt_stats(pReceptionData, &p->isdbt);
 			break;
 		default:
-			smsdvb_update_dvb_stats(pReceptionData, &p->dvb);
-		}
-		if (!pReceptionData->IsDemodLocked) {
-			pReceptionData->SNR = 0;
-			pReceptionData->BER = 0;
-			pReceptionData->BERErrorCount = 0;
-			pReceptionData->InBandPwr = 0;
-			pReceptionData->ErrorTSPackets = 0;
+			break;
 		}
-
-		complete(&client->tune_done);
+		is_status_update = true;
+		complete(&client->get_stats_done);
 		break;
 	}
 	default:
@@ -470,18 +469,22 @@ static int smsdvb_sendrequest_and_wait(struct
smsdvb_client_t *client,
 						0 : -ETIME;
 }
 
-static int smsdvb_send_statistics_request(struct smsdvb_client_t
*client)
-{
-	int rc;
-	struct SmsMsgHdr_S Msg = { MSG_SMS_GET_STATISTICS_REQ,
-				    DVBT_BDA_CONTROL_MSG_ID,
-				    HIF_TASK,
-				    sizeof(struct SmsMsgHdr_S), 0 };
+static int smsdvb_get_statistics_ex(struct dvb_frontend *fe) {
 
-	rc = smsdvb_sendrequest_and_wait(client, &Msg, sizeof(Msg),
-					  &client->tune_done);
+	struct smsdvb_client_t *client =
+	    container_of(fe, struct smsdvb_client_t, frontend);
+	struct SmsMsgHdr_S Msg;
+
+	Msg.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
+	Msg.msgDstId = HIF_TASK;
+	Msg.msgFlags = 0;
+	Msg.msgType = MSG_SMS_GET_STATISTICS_EX_REQ;
+	Msg.msgLength = sizeof(Msg);
+
+	smsendian_handle_tx_message((struct SmsMsgHdr_S *)&Msg);
+	return smsdvb_sendrequest_and_wait(client, &Msg, sizeof(Msg),
+					   &client->get_stats_done);
 
-	return rc;
 }
 
 static inline int led_feedback(struct smsdvb_client_t *client)
@@ -500,7 +503,7 @@ static int smsdvb_read_status(struct dvb_frontend
*fe, fe_status_t *stat)
 	struct smsdvb_client_t *client;
 	client = container_of(fe, struct smsdvb_client_t, frontend);
 
-	rc = smsdvb_send_statistics_request(client);
+	rc = smsdvb_get_statistics_ex(fe);
 
 	*stat = client->fe_status;
 
@@ -515,7 +518,7 @@ static int smsdvb_read_ber(struct dvb_frontend *fe,
u32 *ber)
 	struct smsdvb_client_t *client;
 	client = container_of(fe, struct smsdvb_client_t, frontend);
 
-	rc = smsdvb_send_statistics_request(client);
+	rc = smsdvb_get_statistics_ex(fe);
 
 	*ber = client->reception_data.BER;
 
@@ -531,7 +534,7 @@ static int smsdvb_read_signal_strength(struct
dvb_frontend *fe, u16 *strength)
 	struct smsdvb_client_t *client;
 	client = container_of(fe, struct smsdvb_client_t, frontend);
 
-	rc = smsdvb_send_statistics_request(client);
+	rc = smsdvb_get_statistics_ex(fe);
 
 	if (client->reception_data.InBandPwr < -95)
 		*strength = 0;
@@ -553,7 +556,7 @@ static int smsdvb_read_snr(struct dvb_frontend *fe,
u16 *snr)
 	struct smsdvb_client_t *client;
 	client = container_of(fe, struct smsdvb_client_t, frontend);
 
-	rc = smsdvb_send_statistics_request(client);
+	rc = smsdvb_get_statistics_ex(fe);
 
 	*snr = client->reception_data.SNR;
 
@@ -568,7 +571,7 @@ static int smsdvb_read_ucblocks(struct dvb_frontend
*fe, u32 *ucblocks)
 	struct smsdvb_client_t *client;
 	client = container_of(fe, struct smsdvb_client_t, frontend);
 
-	rc = smsdvb_send_statistics_request(client);
+	rc = smsdvb_get_statistics_ex(fe);
 
 	*ucblocks = client->reception_data.ErrorTSPackets;
 
@@ -595,10 +598,11 @@ static int smsdvb_dvbt_set_frontend(struct
dvb_frontend *fe,
 	struct smsdvb_client_t *client =
 		container_of(fe, struct smsdvb_client_t, frontend);
 
-	struct 	SmsMsgData3Args_S Msg;
-
+	struct SmsMsgData4Args_S Msg;
 	int ret;
 
+	sms_info("setting DVB freq to %d", p->frequency);
+
 	client->fe_status = FE_HAS_SIGNAL;
 	client->event_fe_state = -1;
 	client->event_unc_state = -1;
@@ -611,9 +615,7 @@ static int smsdvb_dvbt_set_frontend(struct
dvb_frontend *fe,
 	Msg.xMsgHeader.msgLength = sizeof(Msg);
 	Msg.msgData[0] = c->frequency;
 	Msg.msgData[2] = 12000000;
-
-	sms_info("%s: freq %d band %d", __func__, c->frequency,
-		 c->bandwidth_hz);
+	Msg.msgData[3] = 0;
 
 	switch (c->bandwidth_hz / 1000000) {
 	case 8:
@@ -723,9 +725,14 @@ static int smsdvb_set_frontend(struct dvb_frontend
*fe,
 {
 	struct smsdvb_client_t *client =
 		container_of(fe, struct smsdvb_client_t, frontend);
-	struct smscore_device_t *coredev = client->coredev;
+	sms_info("setting the front end");
+
+	client->fe_status = FE_HAS_SIGNAL;
+	client->event_fe_state = -1;
+	client->event_unc_state = -1;
+
 
-	switch (smscore_get_device_mode(coredev)) {
+	switch (smscore_get_device_mode(client->coredev)) {
 	case SMSHOSTLIB_DEVMD_DVBT:
 	case SMSHOSTLIB_DEVMD_DVBT_BDA:
 		return smsdvb_dvbt_set_frontend(fe, fep);
-- 
1.7.4.1
>From 0a248021a6e26209666f66eda63503e62d0bbdfa Mon Sep 17 00:00:00 2001
From: Doron Cohen <doronc@siano-ms.com>
Date: Mon, 19 Sep 2011 17:03:51 +0300
Subject: [PATCH 14/21] Bug fix - DVB statistics were wrong since
get_statistics_ex is not supported for DVB

---
 drivers/media/dvb/siano/smscoreapi.h |   67 ++++++++++++++--
 drivers/media/dvb/siano/smsdvb.c     |  142
++++++++++++++++++----------------
 2 files changed, 136 insertions(+), 73 deletions(-)

diff --git a/drivers/media/dvb/siano/smscoreapi.h
b/drivers/media/dvb/siano/smscoreapi.h
index 4b620c9..1df2fa6 100644
--- a/drivers/media/dvb/siano/smscoreapi.h
+++ b/drivers/media/dvb/siano/smscoreapi.h
@@ -1323,19 +1323,72 @@ typedef struct PID_DATA_S
 }PID_DATA_ST;
 
 
-// Statistics information returned as response for
SmsHostApiGetStatisticsEx_Req for DVB applications, SMS1100 and up
-typedef struct SMSHOSTLIB_STATISTICS_DVB_S
+/// Statistics information returned as response for
SmsHostApiGetStatistics_Req
+typedef struct SMSHOSTLIB_STATISTICS_S
 {
-	// Reception
-	RECEPTION_STATISTICS_ST ReceptionData;
+	u32 Reserved;				//!< Reserved
+
+	// Common parameters
+	u32 IsRfLocked;				//!< 0 - not locked, 1 - locked
+	u32 IsDemodLocked;			//!< 0 - not locked, 1 - locked
+	u32 IsExternalLNAOn;			//!< 0 - external LNA off, 1 - external LNA on
+
+	// Reception quality
+	s32  SNR;				//!< dB
+	u32 BER;				//!< Post Viterbi BER [1E-5]
+	u32 FIB_CRC;				//!< CRC errors percentage, valid only for DAB
+	u32 TS_PER;				//!< Transport stream PER, 0xFFFFFFFF indicate N/A,
valid only for DVB-T/H
+	u32 MFER;		//!< DVB-H frame error rate in percentage, 0xFFFFFFFF
indicate N/A, valid only for DVB-H
+	s32  RSSI;				//!< dBm
+	s32  InBandPwr;			//!< In band power in dBM
+	s32  CarrierOffset;			//!< Carrier Offset in bin/1024
 
 	// Transmission parameters
-	TRANSMISSION_STATISTICS_ST TransmissionData;
+	u32 Frequency;				//!< Frequency in Hz
+	u32 Bandwidth;				//!< Bandwidth in MHz, valid only for DVB-T/H
+	u32 TransmissionMode;		//!< Transmission Mode, for DAB modes 1-4, for
DVB-T/H FFT mode carriers in Kilos
+	u32 ModemState;				//!< from SMSHOSTLIB_DVB_MODEM_STATE_ET , valid
only for DVB-T/H
+	u32 GuardInterval;			//!< Guard Interval from
SMSHOSTLIB_GUARD_INTERVALS_ET, valid only for DVB-T/H
+	u32 CodeRate;				//!< Code Rate from SMSHOSTLIB_CODE_RATE_ET, valid
only for DVB-T/H
+	u32 LPCodeRate;				//!< Low Priority Code Rate from
SMSHOSTLIB_CODE_RATE_ET, valid only for DVB-T/H
+	u32 Hierarchy;				//!< Hierarchy from SMSHOSTLIB_HIERARCHY_ET, valid
only for DVB-T/H
+	u32 Constellation;			//!< Constellation from
SMSHOSTLIB_CONSTELLATION_ET, valid only for DVB-T/H
 
 	// Burst parameters, valid only for DVB-H
-	PID_DATA_ST PidData[SRVM_MAX_PID_FILTERS];
+	u32 BurstSize;				//!< Current burst size in bytes, valid only for
DVB-H
+	u32 BurstDuration;			//!< Current burst duration in mSec, valid only
for DVB-H
+	u32 BurstCycleTime;			//!< Current burst cycle time in mSec, valid
only for DVB-H
+	u32 CalculatedBurstCycleTime;//!< Current burst cycle time in mSec, as
calculated by demodulator, valid only for DVB-H
+	u32 NumOfRows;				//!< Number of rows in MPE table, valid only for
DVB-H
+	u32 NumOfPaddCols;			//!< Number of padding columns in MPE table,
valid only for DVB-H
+	u32 NumOfPunctCols;			//!< Number of puncturing columns in MPE table,
valid only for DVB-H
+	u32 ErrorTSPackets;			//!< Number of erroneous transport-stream
packets
+	u32 TotalTSPackets;			//!< Total number of transport-stream packets
+	u32 NumOfValidMpeTlbs;		//!< Number of MPE tables which do not include
errors after MPE RS decoding
+	u32 NumOfInvalidMpeTlbs;		//!< Number of MPE tables which include
errors after MPE RS decoding
+	u32 NumOfCorrectedMpeTlbs;	//!< Number of MPE tables which were
corrected by MPE RS decoding
+	// Common params
+	u32 BERErrorCount;			//!< Number of errornous SYNC bits.
+	u32 BERBitCount;				//!< Total number of SYNC bits.
+
+	// Interface information
+	u32 SmsToHostTxErrors;		//!< Total number of transmission errors.
+
+	// DAB/T-DMB
+	u32 PreBER; 					//!< DAB/T-DMB only: Pre Viterbi BER [1E-5]
+
+	// DVB-H TPS parameters
+	u32 CellId;	//!< TPS Cell ID in bits 15..0, bits 31..16 zero; if set
to 0xFFFFFFFF cell_id not yet recovered
+	u32 DvbhSrvIndHP;	//!< DVB-H service indication info, bit 1 - Time
Slicing indicator, bit 0 - MPE-FEC indicator
+	u32 DvbhSrvIndLP;	//!< DVB-H service indication info, bit 1 - Time
Slicing indicator, bit 0 - MPE-FEC indicator
+
+	u32 NumMPEReceived;			//!< DVB-H, Num MPE section received
+
+	u32 ErrorsCounter;			//fw errors counter
+	u8  ErrorsHistory[8];	//fw errors
+	u32 ReservedFields[7];		//!< Reserved
 
-} SMSHOSTLIB_STATISTICS_DVB_ST;
+} SMSHOSTLIB_STATISTICS_ST;
 
 
 // Helper struct for ISDB-T statistics
diff --git a/drivers/media/dvb/siano/smsdvb.c
b/drivers/media/dvb/siano/smsdvb.c
index aa345ed..97e1780 100644
--- a/drivers/media/dvb/siano/smsdvb.c
+++ b/drivers/media/dvb/siano/smsdvb.c
@@ -133,43 +133,56 @@ static void sms_board_dvb3_event(struct
smsdvb_client_t *client,
 
 
 static void smsdvb_update_dvb_stats(struct RECEPTION_STATISTICS_S
*pReceptionData,
-				   struct SMSHOSTLIB_STATISTICS_DVB_S *p)
+				   struct SMSHOSTLIB_STATISTICS_S *p)
 {
-	sms_debug("IsRfLocked = %d", p->ReceptionData.IsRfLocked);
-	sms_debug("IsDemodLocked = %d", p->ReceptionData.IsDemodLocked);
-	sms_debug("IsExternalLNAOn = %d", p->ReceptionData.IsExternalLNAOn);
-	sms_debug("SNR = %d", p->ReceptionData.SNR);
-	sms_debug("BER = %d", p->ReceptionData.BER);
-	sms_debug("TS_PER = %d", p->ReceptionData.TS_PER);
-	sms_debug("MFER = %d", p->ReceptionData.MFER);
-	sms_debug("RSSI = %d", p->ReceptionData.RSSI);
-	sms_debug("InBandPwr = %d", p->ReceptionData.InBandPwr);
-	sms_debug("CarrierOffset = %d", p->ReceptionData.CarrierOffset);
-	sms_debug("ModemState = %d", p->ReceptionData.ModemState);
-	sms_debug("Frequency = %d", p->TransmissionData.Frequency);
-	sms_debug("Bandwidth = %d", p->TransmissionData.Bandwidth);
-	sms_debug("TransmissionMode = %d",
p->TransmissionData.TransmissionMode);
-	sms_debug("GuardInterval = %d", p->TransmissionData.GuardInterval);
-	sms_debug("CodeRate = %d", p->TransmissionData.CodeRate);
-	sms_debug("LPCodeRate = %d", p->TransmissionData.LPCodeRate);
-	sms_debug("Hierarchy = %d", p->TransmissionData.Hierarchy);
-	sms_debug("Constellation = %d", p->TransmissionData.Constellation);
+	sms_debug("IsRfLocked = %d", p->IsRfLocked);
+	sms_debug("IsDemodLocked = %d", p->IsDemodLocked);
+	sms_debug("IsExternalLNAOn = %d", p->IsExternalLNAOn);
+	sms_debug("SNR = %d", p->SNR);
+	sms_debug("BER = %d", p->BER);
+	sms_debug("TS_PER = %d", p->TS_PER);
+	sms_debug("MFER = %d", p->MFER);
+	sms_debug("RSSI = %d", p->RSSI);
+	sms_debug("InBandPwr = %d", p->InBandPwr);
+	sms_debug("CarrierOffset = %d", p->CarrierOffset);
+	sms_debug("ModemState = %d", p->ModemState);
+	sms_debug("Frequency = %d", p->Frequency);
+	sms_debug("Bandwidth = %d", p->Bandwidth);
+	sms_debug("TransmissionMode = %d", p->TransmissionMode);
+	sms_debug("GuardInterval = %d", p->GuardInterval);
+	sms_debug("CodeRate = %d", p->CodeRate);
+	sms_debug("LPCodeRate = %d", p->LPCodeRate);
+	sms_debug("Hierarchy = %d", p->Hierarchy);
+	sms_debug("Constellation = %d", p->Constellation);
 
 	/* update reception data */
-	pReceptionData->IsRfLocked = p->ReceptionData.IsRfLocked;
-	pReceptionData->IsDemodLocked = p->ReceptionData.IsDemodLocked;
-	pReceptionData->IsExternalLNAOn = p->ReceptionData.IsExternalLNAOn;
-	pReceptionData->ModemState = p->ReceptionData.ModemState;
-	pReceptionData->SNR = p->ReceptionData.SNR;
-	pReceptionData->BER = p->ReceptionData.BER;
-	pReceptionData->BERErrorCount = p->ReceptionData.BERErrorCount;
-	pReceptionData->BERBitCount = p->ReceptionData.BERBitCount;
-	pReceptionData->RSSI = p->ReceptionData.RSSI;
+	pReceptionData->IsRfLocked = p->IsRfLocked;
+	pReceptionData->IsDemodLocked = p->IsDemodLocked;
+	pReceptionData->IsExternalLNAOn = p->IsExternalLNAOn;
+	pReceptionData->ModemState = p->ModemState;
+	pReceptionData->SNR = p->SNR;
+	pReceptionData->BER = p->BER;
+	pReceptionData->BERErrorCount = p->BERErrorCount;
+	pReceptionData->BERBitCount = p->BERBitCount;
+	pReceptionData->RSSI = p->RSSI;
 	CORRECT_STAT_RSSI(*pReceptionData);
-	pReceptionData->InBandPwr = p->ReceptionData.InBandPwr;
-	pReceptionData->CarrierOffset = p->ReceptionData.CarrierOffset;
-	pReceptionData->ErrorTSPackets = p->ReceptionData.ErrorTSPackets;
-	pReceptionData->TotalTSPackets = p->ReceptionData.TotalTSPackets;
+	pReceptionData->InBandPwr = p->InBandPwr;
+	pReceptionData->CarrierOffset = p->CarrierOffset;
+	pReceptionData->ErrorTSPackets = p->ErrorTSPackets;
+	pReceptionData->TotalTSPackets = p->TotalTSPackets;
+
+	/* TS PER */
+	if ((p->TotalTSPackets + p->ErrorTSPackets) > 0) 
+	{
+		pReceptionData->TS_PER = (p->ErrorTSPackets
+				* 100) / (p->TotalTSPackets
+				+ p->ErrorTSPackets);
+	} 
+	else {
+		pReceptionData->TS_PER = 0;
+	}
+
+	pReceptionData->MFER = 0;
 
 };
 
@@ -331,32 +344,21 @@ static int smsdvb_onresponse(void *context, struct
smscore_buffer_t *cb)
 		is_status_update = true;
 		break;
 	}
-	case MSG_SMS_GET_STATISTICS_EX_RES: {
-		union {
-			struct SMSHOSTLIB_STATISTICS_ISDBT_S  isdbt;
-			struct SMSHOSTLIB_STATISTICS_DVB_S    dvb;
-		} *p = (void *) (phdr + 1);
-		struct RECEPTION_STATISTICS_S *pReceptionData =
-				&client->reception_data;
-
+	case MSG_SMS_GET_STATISTICS_RES: {
+		struct SMSHOSTLIB_STATISTICS_S *p_dvb_stats = (void *)(pMsgData+1);
+		struct RECEPTION_STATISTICS_S *pReceptionData =
&client->reception_data;
 		sms_info("MSG_SMS_GET_STATISTICS_RES");
-
 		is_status_update = true;
-
-		switch (smscore_get_device_mode(client->coredev)) {
-		case SMSHOSTLIB_DEVMD_DVBT:
-		case SMSHOSTLIB_DEVMD_DVBH:
-		case SMSHOSTLIB_DEVMD_DVBT_BDA:
-			smsdvb_update_dvb_stats(pReceptionData, &p->dvb);
-			break;
-		case SMSHOSTLIB_DEVMD_ISDBT:
-		case SMSHOSTLIB_DEVMD_ISDBT_BDA:
-			smsdvb_update_isdbt_stats(pReceptionData, &p->isdbt);
-			break;
-		default:
-			break;
-		}
+		smsdvb_update_dvb_stats(pReceptionData, p_dvb_stats);
+		complete(&client->get_stats_done);
+		break;
+	}
+	case MSG_SMS_GET_STATISTICS_EX_RES: {
+		struct SMSHOSTLIB_STATISTICS_ISDBT_S  *p_isdbt_stats = (void
*)pMsgData+1;
+		struct RECEPTION_STATISTICS_S *pReceptionData =
&client->reception_data;
+		sms_info("MSG_SMS_GET_STATISTICS_EX_RES");
 		is_status_update = true;
+		smsdvb_update_isdbt_stats(pReceptionData, p_isdbt_stats);
 		complete(&client->get_stats_done);
 		break;
 	}
@@ -371,12 +373,10 @@ static int smsdvb_onresponse(void *context, struct
smscore_buffer_t *cb)
 			client->fe_status = FE_HAS_SIGNAL | FE_HAS_CARRIER
 				| FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
 			sms_board_dvb3_event(client, DVB3_EVENT_FE_LOCK);
-			if (client->reception_data.ErrorTSPackets
-					== 0)
+			if (client->reception_data.ErrorTSPackets == 0)
 				sms_board_dvb3_event(client, DVB3_EVENT_UNC_OK);
 			else
-				sms_board_dvb3_event(client,
-						DVB3_EVENT_UNC_ERR);
+				sms_board_dvb3_event(client, DVB3_EVENT_UNC_ERR);
 
 		} else {
 			if (client->reception_data.IsRfLocked)
@@ -478,9 +478,19 @@ static int smsdvb_get_statistics_ex(struct
dvb_frontend *fe) {
 	Msg.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
 	Msg.msgDstId = HIF_TASK;
 	Msg.msgFlags = 0;
-	Msg.msgType = MSG_SMS_GET_STATISTICS_EX_REQ;
 	Msg.msgLength = sizeof(Msg);
 
+	if (smscore_get_device_mode(client->coredev) == SMSHOSTLIB_DEVMD_DVBT
|| 
+	    smscore_get_device_mode(client->coredev) ==
SMSHOSTLIB_DEVMD_DVBT_BDA ||
+	    smscore_get_device_mode(client->coredev) == SMSHOSTLIB_DEVMD_DVBH)
+	{
+		Msg.msgType = MSG_SMS_GET_STATISTICS_REQ;
+	}
+	else
+	{
+		Msg.msgType = MSG_SMS_GET_STATISTICS_EX_REQ;
+	}
+
 	smsendian_handle_tx_message((struct SmsMsgHdr_S *)&Msg);
 	return smsdvb_sendrequest_and_wait(client, &Msg, sizeof(Msg),
 					   &client->get_stats_done);
@@ -601,7 +611,7 @@ static int smsdvb_dvbt_set_frontend(struct
dvb_frontend *fe,
 	struct SmsMsgData4Args_S Msg;
 	int ret;
 
-	sms_info("setting DVB freq to %d", p->frequency);
+	sms_info("setting DVB freq to %d", c->frequency);
 
 	client->fe_status = FE_HAS_SIGNAL;
 	client->event_fe_state = -1;
@@ -673,11 +683,11 @@ static int smsdvb_isdbt_set_frontend(struct
dvb_frontend *fe,
 	Msg.xMsgHeader.msgFlags = 0;
 	Msg.xMsgHeader.msgType   = MSG_SMS_ISDBT_TUNE_REQ;
 	Msg.xMsgHeader.msgLength = sizeof(Msg);
-	Msg.msgData[0] = p->frequency;
+	Msg.msgData[0] = c->frequency;
 	if (c->isdbt_sb_segment_idx == -1)
 		c->isdbt_sb_segment_idx = 0;
-	sms_info("freq %d band %d",
-		  p->frequency, p->u.ofdm.bandwidth);
+	sms_info("freq %d seg %d",
+		  c->frequency, c->isdbt_sb_segment_count);
 
 	switch (c->isdbt_sb_segment_count) {
 	case 3:
@@ -731,7 +741,6 @@ static int smsdvb_set_frontend(struct dvb_frontend
*fe,
 	client->event_fe_state = -1;
 	client->event_unc_state = -1;
 
-
 	switch (smscore_get_device_mode(client->coredev)) {
 	case SMSHOSTLIB_DEVMD_DVBT:
 	case SMSHOSTLIB_DEVMD_DVBT_BDA:
@@ -905,6 +914,7 @@ static int smsdvb_hotplug(void *coredev, struct
device *device, int arrival)
 	client->coredev = coredev;
 
 	init_completion(&client->tune_done);
+	init_completion(&client->get_stats_done);
 
 	kmutex_lock(&g_smsdvb_clientslock);
 
-- 
1.7.4.1

