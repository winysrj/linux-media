Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110811.mail.gq1.yahoo.com ([67.195.13.234]:38785 "HELO
	web110811.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755072AbZDEI7x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 04:59:53 -0400
Message-ID: <204559.6386.qm@web110811.mail.gq1.yahoo.com>
Date: Sun, 5 Apr 2009 01:59:50 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0904_8] Siano: add messages handling for big-endian target
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1238696826 -10800
# Node ID e8d224d81e2adde182162ab156aa98725e43f5c0
# Parent  7b5d5a3a7b8e80359e770041ca4c8cf407d893d6
[PATCH] [0904_8] Siano: add messages handling for big-endian target

From: Uri Shkolnik <uris@siano-ms.com>

Add code that modify the content of Siano's protocol
messages when running with big-endian target.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 7b5d5a3a7b8e -r e8d224d81e2a linux/drivers/media/dvb/siano/smsendian.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/siano/smsendian.c	Thu Apr 02 21:27:06 2009 +0300
@@ -0,0 +1,100 @@
+/****************************************************************
+
+ Siano Mobile Silicon, Inc.
+ MDTV receiver kernel modules.
+ Copyright (C) 2006-2009, Uri Shkolnik
+
+ This program is free software: you can redistribute it and/or modify
+ it under the terms of the GNU General Public License as published by
+ the Free Software Foundation, either version 2 of the License, or
+ (at your option) any later version.
+
+ This program is distributed in the hope that it will be useful,
+ but WITHOUT ANY WARRANTY; without even the implied warranty of
+ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ GNU General Public License for more details.
+
+ You should have received a copy of the GNU General Public License
+ along with this program.  If not, see <http://www.gnu.org/licenses/>.
+
+ ****************************************************************/
+
+#include <asm/byteorder.h>
+
+#include "smsendian.h"
+#include "smscoreapi.h"
+
+void smsendian_handle_tx_message(void *buffer)
+{
+#ifdef __BIG_ENDIAN
+	struct SmsMsgData_ST *msg = (struct SmsMsgData_ST *)buffer;
+	int i;
+	int msgWords;
+
+	switch (msg->xMsgHeader.msgType) {
+	case MSG_SMS_DATA_DOWNLOAD_REQ:
+	{
+		msg->msgData[0] = le32_to_cpu(msg->msgData[0]);
+		break;
+	}
+
+	default:
+		msgWords = (msg->xMsgHeader.msgLength -
+				sizeof(struct SmsMsgHdr_ST))/4;
+
+		for (i = 0; i < msgWords; i++)
+			msg->msgData[i] = le32_to_cpu(msg->msgData[i]);
+
+		break;
+	}
+#endif /* __BIG_ENDIAN */
+}
+
+void smsendian_handle_rx_message(void *buffer)
+{
+#ifdef __BIG_ENDIAN
+	struct SmsMsgData_ST *msg = (struct SmsMsgData_ST *)buffer;
+	int i;
+	int msgWords;
+
+	switch (msg->xMsgHeader.msgType) {
+	case MSG_SMS_GET_VERSION_EX_RES:
+	{
+		struct SmsVersionRes_ST *ver =
+			(struct SmsVersionRes_ST *) msg;
+		ver->ChipModel = le16_to_cpu(ver->ChipModel);
+		break;
+	}
+
+	case MSG_SMS_DVBT_BDA_DATA:
+	case MSG_SMS_DAB_CHANNEL:
+	case MSG_SMS_DATA_MSG:
+	{
+		break;
+	}
+
+	default:
+	{
+		msgWords = (msg->xMsgHeader.msgLength -
+				sizeof(struct SmsMsgHdr_ST))/4;
+
+		for (i = 0; i < msgWords; i++)
+			msg->msgData[i] = le32_to_cpu(msg->msgData[i]);
+
+		break;
+	}
+	}
+#endif /* __BIG_ENDIAN */
+}
+
+void smsendian_handle_message_header(void *msg)
+{
+#ifdef __BIG_ENDIAN
+	struct SmsMsgHdr_ST *phdr = (struct SmsMsgHdr_ST *)msg;
+
+	phdr->msgType = le16_to_cpu(phdr->msgType);
+	phdr->msgLength = le16_to_cpu(phdr->msgLength);
+	phdr->msgFlags = le16_to_cpu(phdr->msgFlags);
+#endif /* __BIG_ENDIAN */
+}
+
diff -r 7b5d5a3a7b8e -r e8d224d81e2a linux/drivers/media/dvb/siano/smsendian.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/siano/smsendian.h	Thu Apr 02 21:27:06 2009 +0300
@@ -0,0 +1,32 @@
+/****************************************************************
+
+Siano Mobile Silicon, Inc.
+MDTV receiver kernel modules.
+Copyright (C) 2006-2009, Uri Shkolnik
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
+
+#ifndef __SMS_ENDIAN_H__
+#define __SMS_ENDIAN_H__
+
+#include <asm/byteorder.h>
+
+void smsendian_handle_tx_message(void *buffer);
+void smsendian_handle_rx_message(void *buffer);
+void smsendian_handle_message_header(void *msg);
+
+#endif /* __SMS_ENDIAN_H__ */
+



      
