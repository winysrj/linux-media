Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110816.mail.gq1.yahoo.com ([67.195.13.239]:26155 "HELO
	web110816.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753869AbZEQJBy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 May 2009 05:01:54 -0400
Message-ID: <15232.6488.qm@web110816.mail.gq1.yahoo.com>
Date: Sun, 17 May 2009 02:01:55 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0905_27] Siano: smscore - fix isdb-t firmware name
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242332684 -10800
# Node ID 7e56c108996ef016c4b2117090e2577aea9ed56c
# Parent  5ad3d2c3d7792ddf125386c43535e68b575305c3
[0905_27] Siano: smscore - fix isdb-t firmware name

From: Uri Shkolnik <uris@siano-ms.com>

Fix mistake with isdb-t firmware name

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 5ad3d2c3d779 -r 7e56c108996e linux/drivers/media/dvb/siano/smscoreapi.c
--- a/linux/drivers/media/dvb/siano/smscoreapi.c	Thu May 14 23:21:04 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.c	Thu May 14 23:24:44 2009 +0300
@@ -813,7 +813,7 @@ static char *smscore_fw_lkup[][SMS_NUM_O
 	/*BDA*/
 	{"none", "dvb_nova_12mhz.inp", "dvb_nova_12mhz_b0.inp", "none"},
 	/*ISDBT*/
-	{"none", "isdbt_nova_12mhz.inp", "dvb_nova_12mhz.inp", "none"},
+	{"none", "isdbt_nova_12mhz.inp", "isdbt_nova_12mhz_b0.inp", "none"},
 	/*ISDBTBDA*/
 	{"none", "isdbt_nova_12mhz.inp", "isdbt_nova_12mhz_b0.inp", "none"},
 	/*CMMB*/



      
