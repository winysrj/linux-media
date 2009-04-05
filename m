Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110811.mail.gq1.yahoo.com ([67.195.13.234]:30853 "HELO
	web110811.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751507AbZDEIhZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 04:37:25 -0400
Message-ID: <399946.98112.qm@web110811.mail.gq1.yahoo.com>
Date: Sun, 5 Apr 2009 01:37:23 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0904_7] Siano: smsdvb - modify license header and included file list.
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1238695774 -10800
# Node ID 7b5d5a3a7b8e80359e770041ca4c8cf407d893d6
# Parent  4a0b207a424af7f05d8eb417a698a82a61dd086f
[PATCH] [0904_7] Siano: smsdvb - modify license header
and included file list.

From: Uri Shkolnik <uris@siano-ms.com>

smsdvb.c (client for DVB-API v3) - modify license header
and included file list. Removing white spaces.
There are no implementation changes.


Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 4a0b207a424a -r 7b5d5a3a7b8e linux/drivers/media/dvb/siano/smsdvb.c
--- a/linux/drivers/media/dvb/siano/smsdvb.c	Thu Apr 02 20:50:24 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsdvb.c	Thu Apr 02 21:09:34 2009 +0300
@@ -1,29 +1,40 @@
-/*
- *  Driver for the Siano SMS1xxx USB dongle
- *
- *  Author: Uri Shkolni
- *
- *  Copyright (c), 2005-2008 Siano Mobile Silicon, Inc.
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2 as
- *  published by the Free Software Foundation;
- *
- *  Software distributed under the License is distributed on an "AS IS"
- *  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied.
- *
- *  See the GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
+/****************************************************************
+
+Siano Mobile Silicon, Inc.
+MDTV receiver kernel modules.
+Copyright (C) 2006-2008, Uri Shkolnik
+
+This program is free software: you can redistribute it and/or modify
+it under the terms of the GNU General Public License as published by
+the Free Software Foundation, either version 2 of the License, or
+(at your option) any later version.
+
+ This program is distributed in the hope that it will be useful,
+but WITHOUT ANY WARRANTY; without even the implied warranty of
+MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+GNU General Public License for more details.
+
+You should have received a copy of the GNU General Public License
+along with this program.  If not, see <http://www.gnu.org/licenses/>.
+
+****************************************************************/
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <asm/byteorder.h>
 
 #include "smscoreapi.h"
+/*#include "smsendian.h"*/
 #include "sms-cards.h"
+
+#ifndef DVB_DEFINE_MOD_OPT_ADAPTER_NR
+#define DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr) \
+		static short adapter_nr[] = \
+		{[0 ... (8 - 1)] = -1 }; \
+		module_param_array(adapter_nr, short, NULL, 0444); \
+		MODULE_PARM_DESC(adapter_nr, "DVB adapter numbers")
+#define SMS_DVB_OLD_DVB_REGISTER_ADAPTER
+#endif
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
@@ -33,15 +44,15 @@ struct smsdvb_client_t {
 	struct smscore_device_t *coredev;
 	struct smscore_client_t *smsclient;
 
-	struct dvb_adapter      adapter;
-	struct dvb_demux        demux;
-	struct dmxdev           dmxdev;
-	struct dvb_frontend     frontend;
+	struct dvb_adapter adapter;
+	struct dvb_demux demux;
+	struct dmxdev dmxdev;
+	struct dvb_frontend frontend;
 
-	fe_status_t             fe_status;
-	int                     fe_ber, fe_snr, fe_unc, fe_signal_strength;
+	fe_status_t fe_status;
+	int fe_ber, fe_snr, fe_unc, fe_signal_strength;
 
-	struct completion       tune_done, stat_done;
+	struct completion tune_done, stat_done;
 
 	/* todo: save freq/band instead whole struct */
 	struct dvb_frontend_parameters fe_params;
@@ -61,7 +72,7 @@ static int smsdvb_onresponse(void *conte
 	struct smsdvb_client_t *client = (struct smsdvb_client_t *) context;
 	struct SmsMsgHdr_ST *phdr = (struct SmsMsgHdr_ST *) (((u8 *) cb->p)
 			+ cb->offset);
-	u32 *pMsgData = (u32 *)phdr+1;
+	u32 *pMsgData = (u32 *) phdr + 1;
 	/*u32 MsgDataLen = phdr->msgLength - sizeof(struct SmsMsgHdr_ST);*/
 
 	/*smsendian_handle_rx_message((struct SmsMsgData_ST *) phdr);*/
@@ -163,22 +174,22 @@ static int smsdvb_onresponse(void *conte
 		client->fe_status = 0;
 	}
 
-/*
-	if (client->fe_status & FE_HAS_LOCK)
-		sms_board_dvb3_event(client->coredev, DVB3_EVENT_FE_LOCK);
-	else
-		sms_board_dvb3_event(client->coredev, DVB3_EVENT_FE_UNLOCK);
+	/*
+	 if (client->fe_status & FE_HAS_LOCK)
+	 sms_board_dvb3_event(client->coredev, DVB3_EVENT_FE_LOCK);
+	 else
+	 sms_board_dvb3_event(client->coredev, DVB3_EVENT_FE_UNLOCK);
 
-	if (client->sms_stat_dvb.ReceptionData.ErrorTSPackets == 0)
-		sms_board_dvb3_event(client->coredev, DVB3_EVENT_UNC_OK);
-	else
-		sms_board_dvb3_event(client->coredev, DVB3_EVENT_UNC_ERR);
-*/
+	 if (client->sms_stat_dvb.ReceptionData.ErrorTSPackets == 0)
+	 sms_board_dvb3_event(client->coredev, DVB3_EVENT_UNC_OK);
+	 else
+	 sms_board_dvb3_event(client->coredev, DVB3_EVENT_UNC_ERR);
+	 */
 
 	if (client->fe_status & FE_HAS_LOCK)
 		sms_board_led_feedback(client->coredev,
-				       (client->fe_unc == 0) ?
-				       SMS_LED_HI : SMS_LED_LO);
+				(client->fe_unc == 0) ?
+				SMS_LED_HI : SMS_LED_LO);
 	else
 		sms_board_led_feedback(client->coredev, SMS_LED_OFF);
 
@@ -203,7 +214,7 @@ static void smsdvb_onremove(void *contex
 {
 	kmutex_lock(&g_smsdvb_clientslock);
 
-	smsdvb_unregister_client((struct smsdvb_client_t *) context);
+	smsdvb_unregister_client((struct smsdvb_client_t *)context);
 
 	kmutex_unlock(&g_smsdvb_clientslock);
 }
@@ -214,18 +225,18 @@ static int smsdvb_start_feed(struct dvb_
 		container_of(feed->demux, struct smsdvb_client_t, demux);
 	struct SmsMsgData_ST PidMsg;
 
-	sms_debug("add pid %d(%x)",
-		  feed->pid, feed->pid);
+	sms_debug("add pid %d(%x)", feed->pid, feed->pid);
 
 	PidMsg.xMsgHeader.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
 	PidMsg.xMsgHeader.msgDstId = HIF_TASK;
 	PidMsg.xMsgHeader.msgFlags = 0;
-	PidMsg.xMsgHeader.msgType  = MSG_SMS_ADD_PID_FILTER_REQ;
+	PidMsg.xMsgHeader.msgType = MSG_SMS_ADD_PID_FILTER_REQ;
 	PidMsg.xMsgHeader.msgLength = sizeof(PidMsg);
 	PidMsg.msgData[0] = feed->pid;
 
-	return smsclient_sendrequest(client->smsclient,
-				     &PidMsg, sizeof(PidMsg));
+	/* smsendian_handle_tx_message((struct SmsMsgHdr_ST *)&PidMsg); */
+	return smsclient_sendrequest(client->smsclient, &PidMsg,
+			sizeof(PidMsg));
 }
 
 static int smsdvb_stop_feed(struct dvb_demux_feed *feed)
@@ -234,31 +245,33 @@ static int smsdvb_stop_feed(struct dvb_d
 		container_of(feed->demux, struct smsdvb_client_t, demux);
 	struct SmsMsgData_ST PidMsg;
 
-	sms_debug("remove pid %d(%x)",
-		  feed->pid, feed->pid);
+	sms_debug("remove pid %d(%x)", feed->pid, feed->pid);
 
 	PidMsg.xMsgHeader.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
 	PidMsg.xMsgHeader.msgDstId = HIF_TASK;
 	PidMsg.xMsgHeader.msgFlags = 0;
-	PidMsg.xMsgHeader.msgType  = MSG_SMS_REMOVE_PID_FILTER_REQ;
+	PidMsg.xMsgHeader.msgType = MSG_SMS_REMOVE_PID_FILTER_REQ;
 	PidMsg.xMsgHeader.msgLength = sizeof(PidMsg);
 	PidMsg.msgData[0] = feed->pid;
 
-	return smsclient_sendrequest(client->smsclient,
-				     &PidMsg, sizeof(PidMsg));
+	/* smsendian_handle_tx_message((struct SmsMsgHdr_ST *)&PidMsg); */
+	return smsclient_sendrequest(client->smsclient, &PidMsg,
+			sizeof(PidMsg));
 }
 
 static int smsdvb_sendrequest_and_wait(struct smsdvb_client_t *client,
-					void *buffer, size_t size,
-					struct completion *completion)
+				       void *buffer, size_t size,
+				       struct completion *completion)
 {
-	int rc = smsclient_sendrequest(client->smsclient, buffer, size);
+	int rc;
+
+	/* smsendian_handle_tx_message((struct SmsMsgHdr_ST *)buffer); */
+	rc = smsclient_sendrequest(client->smsclient, buffer, size);
 	if (rc < 0)
 		return rc;
 
-	return wait_for_completion_timeout(completion,
-					   msecs_to_jiffies(2000)) ?
-						0 : -ETIME;
+	return wait_for_completion_timeout(completion, msecs_to_jiffies(2000))
+			? 0 : -ETIME;
 }
 
 static int smsdvb_read_status(struct dvb_frontend *fe, fe_status_t *stat)
@@ -333,18 +346,18 @@ static int smsdvb_set_frontend(struct dv
 			       struct dvb_frontend_parameters *fep)
 {
 	struct smsdvb_client_t *client =
-		container_of(fe, struct smsdvb_client_t, frontend);
+	container_of(fe, struct smsdvb_client_t, frontend);
 
 	struct {
-		struct SmsMsgHdr_ST	Msg;
-		u32		Data[3];
+		struct SmsMsgHdr_ST Msg;
+		u32 Data[3];
 	} Msg;
 	int ret;
 
-	Msg.Msg.msgSrcId  = DVBT_BDA_CONTROL_MSG_ID;
-	Msg.Msg.msgDstId  = HIF_TASK;
-	Msg.Msg.msgFlags  = 0;
-	Msg.Msg.msgType   = MSG_SMS_RF_TUNE_REQ;
+	Msg.Msg.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
+	Msg.Msg.msgDstId = HIF_TASK;
+	Msg.Msg.msgFlags = 0;
+	Msg.Msg.msgType = MSG_SMS_RF_TUNE_REQ;
 	Msg.Msg.msgLength = sizeof(Msg);
 	Msg.Data[0] = fep->frequency;
 	Msg.Data[2] = 12000000;
@@ -353,14 +366,24 @@ static int smsdvb_set_frontend(struct dv
 		  fep->frequency, fep->u.ofdm.bandwidth);
 
 	switch (fep->u.ofdm.bandwidth) {
-	case BANDWIDTH_8_MHZ: Msg.Data[1] = BW_8_MHZ; break;
-	case BANDWIDTH_7_MHZ: Msg.Data[1] = BW_7_MHZ; break;
-	case BANDWIDTH_6_MHZ: Msg.Data[1] = BW_6_MHZ; break;
+	case BANDWIDTH_8_MHZ:
+		Msg.Data[1] = BW_8_MHZ;
+		break;
+	case BANDWIDTH_7_MHZ:
+		Msg.Data[1] = BW_7_MHZ;
+		break;
+	case BANDWIDTH_6_MHZ:
+		Msg.Data[1] = BW_6_MHZ;
+		break;
 #if 0
-	case BANDWIDTH_5_MHZ: Msg.Data[1] = BW_5_MHZ; break;
+	case BANDWIDTH_5_MHZ:
+		Msg.Data[1] = BW_5_MHZ;
+		break;
 #endif
-	case BANDWIDTH_AUTO: return -EOPNOTSUPP;
-	default: return -EINVAL;
+	case BANDWIDTH_AUTO:
+		return -EOPNOTSUPP;
+	default:
+		return -EINVAL;
 	}
 
 	/* Disable LNA, if any. An error is returned if no LNA is present */
@@ -395,7 +418,7 @@ static int smsdvb_get_frontend(struct dv
 
 	/* todo: */
 	memcpy(fep, &client->fe_params,
-	       sizeof(struct dvb_frontend_parameters));
+			sizeof(struct dvb_frontend_parameters));
 
 	return 0;
 }
@@ -428,20 +451,19 @@ static void smsdvb_release(struct dvb_fr
 
 static struct dvb_frontend_ops smsdvb_fe_ops = {
 	.info = {
-		.name			= "Siano Mobile Digital MDTV Receiver",
-		.type			= FE_OFDM,
-		.frequency_min		= 44250000,
-		.frequency_max		= 867250000,
-		.frequency_stepsize	= 250000,
-		.caps = FE_CAN_INVERSION_AUTO |
-			FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
-			FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
-			FE_CAN_QPSK | FE_CAN_QAM_16 | FE_CAN_QAM_64 |
-			FE_CAN_QAM_AUTO | FE_CAN_TRANSMISSION_MODE_AUTO |
-			FE_CAN_GUARD_INTERVAL_AUTO |
-			FE_CAN_RECOVER |
-			FE_CAN_HIERARCHY_AUTO,
-	},
+		 .name = "Siano Mobile Digital MDTV Receiver",
+		 .type = FE_OFDM,
+		 .frequency_min = 44250000,
+		 .frequency_max = 867250000,
+		 .frequency_stepsize = 250000,
+		 .caps = FE_CAN_INVERSION_AUTO |
+		 FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
+		 FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
+		 FE_CAN_QPSK | FE_CAN_QAM_16 | FE_CAN_QAM_64 |
+		 FE_CAN_QAM_AUTO | FE_CAN_TRANSMISSION_MODE_AUTO |
+		 FE_CAN_GUARD_INTERVAL_AUTO |
+		 FE_CAN_RECOVER | FE_CAN_HIERARCHY_AUTO,
+		 },
 
 	.release = smsdvb_release,
 
@@ -541,7 +563,6 @@ static int smsdvb_hotplug(struct smscore
 	client->coredev = coredev;
 
 	init_completion(&client->tune_done);
-	init_completion(&client->stat_done);
 
 	kmutex_lock(&g_smsdvb_clientslock);
 



      
