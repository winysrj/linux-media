Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110815.mail.gq1.yahoo.com ([67.195.13.238]:30071 "HELO
	web110815.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753006AbZD0MMh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2009 08:12:37 -0400
Message-ID: <306127.22466.qm@web110815.mail.gq1.yahoo.com>
Date: Mon, 27 Apr 2009 05:12:37 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0904_7_3] Siano: smsdvb - remove redundent complete
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1240834193 -10800
# Node ID 5601aa2e8c5e2af2b1f62e03fd4c4e04006c7b87
# Parent  cbd828b0fe102fa023280cfeadbcb20b54a39a47
Siano: smsdvb - remove redundant complete instruction

From: Uri Shkolnik <uris@siano-ms.com>

Remove redundant complete instruction from smsdvb, in the
past this was used by the statistics state machine, but
no longer.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r cbd828b0fe10 -r 5601aa2e8c5e linux/drivers/media/dvb/siano/smsdvb.c
--- a/linux/drivers/media/dvb/siano/smsdvb.c	Mon Apr 27 15:03:26 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsdvb.c	Mon Apr 27 15:09:53 2009 +0300
@@ -550,7 +550,6 @@ static int smsdvb_hotplug(struct smscore
 	client->coredev = coredev;
 
 	init_completion(&client->tune_done);
-	init_completion(&client->stat_done);
 
 	kmutex_lock(&g_smsdvb_clientslock);
 



      
