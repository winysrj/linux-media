Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110804.mail.gq1.yahoo.com ([67.195.13.227]:42750 "HELO
	web110804.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754378AbZEQJBE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 May 2009 05:01:04 -0400
Message-ID: <108583.81032.qm@web110804.mail.gq1.yahoo.com>
Date: Sun, 17 May 2009 02:01:03 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0905_25] Siano: smscore - fix byte ordering bug
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242332055 -10800
# Node ID d826829f17df5ccb89fab3a0d48b8aadd04f9689
# Parent  fc839f80e81fed027a4721f5c679b9af7e27c867
[0905_25] Siano: smscore - fix byte ordering bug

From: Uri Shkolnik <uris@siano-ms.com>

Fix byte ordering bug.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r fc839f80e81f -r d826829f17df linux/drivers/media/dvb/siano/smscoreapi.c
--- a/linux/drivers/media/dvb/siano/smscoreapi.c	Thu May 14 23:11:07 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.c	Thu May 14 23:14:15 2009 +0300
@@ -31,6 +31,7 @@
 
 #include <linux/firmware.h>
 #include <linux/wait.h>
+#include <asm/byteorder.h>
 
 #include "smscoreapi.h"
 #include "smsendian.h"
@@ -516,9 +517,13 @@ static int smscore_load_firmware_family2
 {
 	struct SmsFirmware_ST *firmware = (struct SmsFirmware_ST *) buffer;
 	struct SmsMsgHdr_ST *msg;
-	u32 mem_address = firmware->StartAddress;
+	u32 mem_address;
 	u8 *payload = firmware->Payload;
 	int rc = 0;
+	firmware->StartAddress = le32_to_cpu(firmware->StartAddress);
+	firmware->Length = le32_to_cpu(firmware->Length);
+
+	mem_address = firmware->StartAddress;
 
 	sms_info("loading FW to addr 0x%x size %d",
 		 mem_address, firmware->Length);



      
