Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110807.mail.gq1.yahoo.com ([67.195.13.230]:32748 "HELO
	web110807.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758415AbZDEKUp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 06:20:45 -0400
Message-ID: <975001.7892.qm@web110807.mail.gq1.yahoo.com>
Date: Sun, 5 Apr 2009 03:20:42 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0904_11] Siano: smsendian & smsdvb - binding the smsendian to smsdvb
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1238743608 -10800
# Node ID 01979ae55ffec22d74b77681613f38bd606be227
# Parent  ec7ee486fb86d51bdb48e6a637a6ddd52e9e08c2
[PATCH] [0904_11] Siano: smsendian & smsdvb - binding the smsendian to smsdvb

From: Uri Shkolnik <uris@siano-ms.com>

Bind the smsendian, which manipulates some Siano's messages content
when using Siano chip-set with big-endian target, 
with the DVB-API v3 client adapter.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r ec7ee486fb86 -r 01979ae55ffe linux/drivers/media/dvb/siano/Makefile
--- a/linux/drivers/media/dvb/siano/Makefile	Fri Apr 03 10:10:22 2009 +0300
+++ b/linux/drivers/media/dvb/siano/Makefile	Fri Apr 03 10:26:48 2009 +0300
@@ -1,4 +1,4 @@ sms1xxx-objs := smscoreapi.o sms-cards.o
-sms1xxx-objs := smscoreapi.o sms-cards.o
+sms1xxx-objs := smscoreapi.o sms-cards.o smsendian.o
 
 obj-$(CONFIG_DVB_SIANO_SMS1XXX) += sms1xxx.o
 obj-$(CONFIG_DVB_SIANO_SMS1XXX) += smsusb.o
diff -r ec7ee486fb86 -r 01979ae55ffe linux/drivers/media/dvb/siano/smsdvb.c
--- a/linux/drivers/media/dvb/siano/smsdvb.c	Fri Apr 03 10:10:22 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsdvb.c	Fri Apr 03 10:26:48 2009 +0300
@@ -24,7 +24,7 @@ along with this program.  If not, see <h
 #include <asm/byteorder.h>
 
 #include "smscoreapi.h"
-/*#include "smsendian.h"*/
+#include "smsendian.h"
 #include "sms-cards.h"
 
 #ifndef DVB_DEFINE_MOD_OPT_ADAPTER_NR
@@ -52,7 +52,7 @@ struct smsdvb_client_t {
 	fe_status_t fe_status;
 	int fe_ber, fe_snr, fe_unc, fe_signal_strength;
 
-	struct completion tune_done, stat_done;
+	struct completion tune_done;
 
 	/* todo: save freq/band instead whole struct */
 	struct dvb_frontend_parameters fe_params;
@@ -114,7 +114,7 @@ static int smsdvb_onresponse(void *conte
 	u32 *pMsgData = (u32 *) phdr + 1;
 	/*u32 MsgDataLen = phdr->msgLength - sizeof(struct SmsMsgHdr_ST);*/
 
-	/*smsendian_handle_rx_message((struct SmsMsgData_ST *) phdr);*/
+	smsendian_handle_rx_message((struct SmsMsgData_ST *) phdr);
 
 	switch (phdr->msgType) {
 	case MSG_SMS_DVBT_BDA_DATA:
@@ -271,7 +271,7 @@ static int smsdvb_start_feed(struct dvb_
 	PidMsg.xMsgHeader.msgLength = sizeof(PidMsg);
 	PidMsg.msgData[0] = feed->pid;
 
-	/* smsendian_handle_tx_message((struct SmsMsgHdr_ST *)&PidMsg); */
+	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)&PidMsg);
 	return smsclient_sendrequest(client->smsclient, &PidMsg,
 			sizeof(PidMsg));
 }
@@ -291,7 +291,7 @@ static int smsdvb_stop_feed(struct dvb_d
 	PidMsg.xMsgHeader.msgLength = sizeof(PidMsg);
 	PidMsg.msgData[0] = feed->pid;
 
-	/* smsendian_handle_tx_message((struct SmsMsgHdr_ST *)&PidMsg); */
+	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)&PidMsg);
 	return smsclient_sendrequest(client->smsclient, &PidMsg,
 			sizeof(PidMsg));
 }
@@ -302,7 +302,7 @@ static int smsdvb_sendrequest_and_wait(s
 {
 	int rc;
 
-	/* smsendian_handle_tx_message((struct SmsMsgHdr_ST *)buffer); */
+	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)buffer);
 	rc = smsclient_sendrequest(client->smsclient, buffer, size);
 	if (rc < 0)
 		return rc;



      
