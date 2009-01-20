Return-path: <linux-media-owner@vger.kernel.org>
Received: from proxy2.bredband.net ([195.54.101.72]:54029 "EHLO
	proxy2.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834AbZATIpK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 03:45:10 -0500
Received: from ironport2.bredband.com (195.54.101.122) by proxy2.bredband.net (7.3.127)
        id 494BF302008BB456 for linux-media@vger.kernel.org; Tue, 20 Jan 2009 09:45:08 +0100
Received: from evermeet.kurelid.se (localhost.localdomain [127.0.0.1])
	by evermeet.kurelid.se (8.14.2/8.13.8) with ESMTP id n0K8j7Fh024802
	for <linux-media@vger.kernel.org>; Tue, 20 Jan 2009 09:45:07 +0100
Message-ID: <6a76f88145aeefe3cd6422b2ed817edb.squirrel@mail.kurelid.se>
Date: Tue, 20 Jan 2009 09:45:06 +0100 (CET)
Subject: [PATCH] separation of ca_info and application_info in dst_test
From: "Henrik Kurelid" <henke@kurelid.se>
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please review and comment.
---
This patch fixes an issue with with dst_test which uses an incorrect tag for retrieving application_info from the CAM.
It also adds support for retrieving ca_info from the CAM.

Signed-off-by: Henrik Kurelid <henrik@kurelid.se>

diff -r e91138b9bdaa -r 46fcaf244831 util/dst-utils/dst_test.c
--- a/util/dst-utils/dst_test.c	Wed Jan 14 20:46:09 2009 +0100
+++ b/util/dst-utils/dst_test.c	Tue Jan 20 09:40:01 2009 +0100
@@ -3,6 +3,7 @@
 	an implementation for the High Level Common Interface

 	Copyright (C) 2004, 2005 Manu Abraham <abraham.manu@gmail.com>
+	Copyright (C) 2009 Henrik Kurelid <henrik@kurelid.se>

 	This program is free software; you can redistribute it and/or modify
 	it under the terms of the GNU Lesser General Public License as
@@ -140,9 +141,10 @@
 	return 0;
 }

-static int dst_get_app_info(int cafd, struct ca_msg *msg)
+static int dst_get_ca_info(int cafd, struct ca_msg *msg)
 {
 	uint32_t tag = 0;
+	int pos;

 	/*	Enquire		*/
 	tag = TAG_CA_INFO_ENQUIRY;
@@ -159,10 +161,45 @@
 	}

 	/*	Process		*/
+	printf("%s: ================================ CI Module CA Info ======================================\n", __FUNCTION__);
+	printf("%s: Supported CA System IDs (%d):\n", __FUNCTION__, msg->msg[3] / 2);
+	pos = 4;
+	while (pos < msg->msg[3] + 4) {
+		printf("%s: 0x%04X\n", __FUNCTION__, (msg->msg[pos] << 8) + msg->msg[pos + 1]);
+		pos += 2;
+	}
+	printf("%s: ==================================================================================================\n", __FUNCTION__);
+
+	return 0;
+}
+
+static int dst_get_app_info(int cafd, struct ca_msg *msg)
+{
+	uint32_t tag = 0;
+	int i;
+
+	/*	Enquire		*/
+	tag = TAG_APP_INFO_ENQUIRY;
+	if ((dst_comms(cafd, tag, CA_SEND_MSG, msg)) < 0) {
+		printf("%s: Dst communication failed\n", __FUNCTION__);
+		return -1;
+	}
+
+	/*	Receive		*/
+	tag = TAG_APP_INFO;
+	if ((dst_comms(cafd, tag, CA_GET_MSG, msg)) < 0) {
+		printf("%s: Dst communication failed\n", __FUNCTION__);
+		return -1;
+	}
+
+	/*	Process		*/
 	printf("%s: ================================ CI Module Application Info ======================================\n", __FUNCTION__);
-	printf("%s: Application Type=[%d], Application Vendor=[%d], Vendor Code=[%d]\n%s: Application info=[%s]\n",
-			__FUNCTION__, msg->msg[7], (msg->msg[8] << 8) | msg->msg[9], (msg->msg[10] << 8) | msg->msg[11], __FUNCTION__,
-			((char *) (&msg->msg[12])));
+	printf("%s: Application Type=[%d], Application Vendor=[0x%04X], Vendor Code=[0x%04X]\n",
+	       __FUNCTION__, msg->msg[4], (msg->msg[5] << 8) | msg->msg[6], (msg->msg[7] << 8) | msg->msg[8]);
+	printf("%s: Application info=[", __FUNCTION__);
+	for (i = 0; i < msg->msg[9]; i++)
+		printf("%c", (char)msg->msg[10 + i]);
+	printf("]\n");
 	printf("%s: ==================================================================================================\n", __FUNCTION__);

 	return 0;
@@ -195,6 +232,7 @@
 				"\t -g get descr\n"
 				"\t -s set_descr\n"
 				"\t -a app_info\n"
+				"\t -b ca_info\n"
 				"\t -t session test\n";


@@ -216,7 +254,7 @@
 			return -1;
 		}

-		switch (getopt(argc, argv, "cirpgsat")) {
+		switch (getopt(argc, argv, "cirpgsabt")) {
 			case 'c':
 				printf("%s: Capabilities\n", __FUNCTION__);
 				dst_get_caps(cafd, caps);
@@ -245,6 +283,10 @@
 				printf("%s: App Info\n", __FUNCTION__);
 				dst_get_app_info(cafd, msg);
 				break;
+			case 'b':
+				printf("%s: CA Info\n", __FUNCTION__);
+				dst_get_ca_info(cafd, msg);
+				break;
 			case 't':
 				printf("%s: Session test\n", __FUNCTION__);
 				dst_session_test(cafd, msg);
