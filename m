Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110811.mail.gq1.yahoo.com ([67.195.13.234]:20248 "HELO
	web110811.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751318AbZELOhI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 10:37:08 -0400
Message-ID: <169456.23379.qm@web110811.mail.gq1.yahoo.com>
Date: Tue, 12 May 2009 07:37:09 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH]  [0905_06] Siano: smsdvb - add big endian support
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242139255 -10800
# Node ID 291604c1821496dd4acd1d5411f8ea3ae955fd2c
# Parent  ae0f17b305e7762643a9bc7f43c302c11f7b55b5
[0905_06] Siano: smsdvb - add big endian support

From: Uri Shkolnik <uris@siano-ms.com>

Add support for Siano protocol messages
with big endian systems.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r ae0f17b305e7 -r 291604c18214 linux/drivers/media/dvb/siano/smsdvb.c
--- a/linux/drivers/media/dvb/siano/smsdvb.c	Tue May 12 17:32:21 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsdvb.c	Tue May 12 17:40:55 2009 +0300
@@ -23,6 +23,7 @@ along with this program.  If not, see <h
 #include <linux/init.h>
 
 #include "smscoreapi.h"
+#include "smsendian.h"
 #include "sms-cards.h"
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
@@ -59,6 +60,8 @@ static int smsdvb_onresponse(void *conte
 	struct smsdvb_client_t *client = (struct smsdvb_client_t *) context;
 	struct SmsMsgHdr_ST *phdr =
 		(struct SmsMsgHdr_ST *)(((u8 *) cb->p) + cb->offset);
+
+	smsendian_handle_rx_message((struct SmsMsgData_ST *) phdr);
 
 	switch (phdr->msgType) {
 	case MSG_SMS_DVBT_BDA_DATA:
@@ -149,6 +152,7 @@ static int smsdvb_start_feed(struct dvb_
 	PidMsg.xMsgHeader.msgLength = sizeof(PidMsg);
 	PidMsg.msgData[0] = feed->pid;
 
+	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)&PidMsg);
 	return smsclient_sendrequest(client->smsclient,
 				     &PidMsg, sizeof(PidMsg));
 }
@@ -169,6 +173,7 @@ static int smsdvb_stop_feed(struct dvb_d
 	PidMsg.xMsgHeader.msgLength = sizeof(PidMsg);
 	PidMsg.msgData[0] = feed->pid;
 
+	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)&PidMsg);
 	return smsclient_sendrequest(client->smsclient,
 				     &PidMsg, sizeof(PidMsg));
 }
@@ -177,7 +182,10 @@ static int smsdvb_sendrequest_and_wait(s
 					void *buffer, size_t size,
 					struct completion *completion)
 {
-	int rc = smsclient_sendrequest(client->smsclient, buffer, size);
+	int rc;
+
+	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)buffer);
+	rc = smsclient_sendrequest(client->smsclient, buffer, size);
 	if (rc < 0)
 		return rc;
 



      
