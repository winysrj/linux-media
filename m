Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110803.mail.gq1.yahoo.com ([67.195.13.226]:42845 "HELO
	web110803.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752340AbZDELoO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 07:44:14 -0400
Message-ID: <835564.12852.qm@web110803.mail.gq1.yahoo.com>
Date: Sun, 5 Apr 2009 04:44:11 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0904_15] Siano: core header - bind SMS messages endian handling
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1238758250 -10800
# Node ID 856813745905e07d9fc6be5e136fdf7060c6fc37
# Parent  0ddd2fd20badbf2bb33566a05ff2ea2a6dff8600
[PATCH] [0904_15] Siano: core header - bind SMS messages endian handling

From: Uri Shkolnik <uris@siano-ms.com>

This patch bind the smsedian (which manipulate the content
of Siano's protocol messages) to the smsdvb component.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 0ddd2fd20bad -r 856813745905 linux/drivers/media/dvb/siano/smsdvb.c
--- a/linux/drivers/media/dvb/siano/smsdvb.c	Fri Apr 03 14:18:10 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsdvb.c	Fri Apr 03 14:30:50 2009 +0300
@@ -29,7 +29,7 @@ along with this program.  If not, see <h
 #include "dvb_frontend.h"
 
 #include "smscoreapi.h"
-/*#include "smsendian.h"*/
+#include "smsendian.h"
 #include "sms-cards.h"
 
 #ifndef DVB_DEFINE_MOD_OPT_ADAPTER_NR
@@ -116,7 +116,7 @@ static int smsdvb_onresponse(void *conte
 	u32 *pMsgData = (u32 *) phdr + 1;
 	/*u32 MsgDataLen = phdr->msgLength - sizeof(struct SmsMsgHdr_ST);*/
 
-	/*smsendian_handle_rx_message((struct SmsMsgData_ST *) phdr);*/
+	smsendian_handle_rx_message((struct SmsMsgData_ST *) phdr);
 
 	switch (phdr->msgType) {
 	case MSG_SMS_DVBT_BDA_DATA:
@@ -293,7 +293,7 @@ static int smsdvb_stop_feed(struct dvb_d
 	PidMsg.xMsgHeader.msgLength = sizeof(PidMsg);
 	PidMsg.msgData[0] = feed->pid;
 
-	/* smsendian_handle_tx_message((struct SmsMsgHdr_ST *)&PidMsg); */
+	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)&PidMsg);
 	return smsclient_sendrequest(client->smsclient, &PidMsg,
 			sizeof(PidMsg));
 }
@@ -304,7 +304,7 @@ static int smsdvb_sendrequest_and_wait(s
 {
 	int rc;
 
-	/* smsendian_handle_tx_message((struct SmsMsgHdr_ST *)buffer); */
+	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)buffer);
 	rc = smsclient_sendrequest(client->smsclient, buffer, size);
 	if (rc < 0)
 		return rc;



      
