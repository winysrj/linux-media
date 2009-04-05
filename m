Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110816.mail.gq1.yahoo.com ([67.195.13.239]:32920 "HELO
	web110816.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751150AbZDEObL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 10:31:11 -0400
Message-ID: <449398.96782.qm@web110816.mail.gq1.yahoo.com>
Date: Sun, 5 Apr 2009 07:31:09 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0904_16] Siano: smsdvb - additional case of endian handling.
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1238758726 -10800
# Node ID c582116cfbb96671629143fced33e3f88c28b3c7
# Parent  856813745905e07d9fc6be5e136fdf7060c6fc37
[PATCH] [0904_16] Siano: smsdvb - additional case of endian handling.

From: Uri Shkolnik <uris@siano-ms.com>

Additional case of endian handling.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 856813745905 -r c582116cfbb9 linux/drivers/media/dvb/siano/smsdvb.c
--- a/linux/drivers/media/dvb/siano/smsdvb.c	Fri Apr 03 14:30:50 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsdvb.c	Fri Apr 03 14:38:46 2009 +0300
@@ -273,7 +273,7 @@ static int smsdvb_start_feed(struct dvb_
 	PidMsg.xMsgHeader.msgLength = sizeof(PidMsg);
 	PidMsg.msgData[0] = feed->pid;
 
-	/* smsendian_handle_tx_message((struct SmsMsgHdr_ST *)&PidMsg); */
+	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)&PidMsg);
 	return smsclient_sendrequest(client->smsclient, &PidMsg,
 			sizeof(PidMsg));
 }
@@ -546,10 +546,15 @@ static int smsdvb_hotplug(struct smscore
 	}
 



      
