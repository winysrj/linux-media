Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110814.mail.gq1.yahoo.com ([67.195.13.237]:22024 "HELO
	web110814.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752382AbZELQNN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 12:13:13 -0400
Message-ID: <355845.97955.qm@web110814.mail.gq1.yahoo.com>
Date: Tue, 12 May 2009 09:13:13 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0905_09] Siano: smsdvb - small type fix
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242143183 -10800
# Node ID 179c1575678e08b5626bb918ef300b3ecead633c
# Parent  777b32ac3080215d26c35853ea41c1f8f992b70c
[0905_09] Siano: smsdvb - small type fix

From: Uri Shkolnik <uris@siano-ms.com>

Fix type at the module description

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 777b32ac3080 -r 179c1575678e linux/drivers/media/dvb/siano/smsdvb.c
--- a/linux/drivers/media/dvb/siano/smsdvb.c	Tue May 12 18:38:15 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsdvb.c	Tue May 12 18:46:23 2009 +0300
@@ -601,5 +601,5 @@ void smsdvb_unregister(void)
 }
 
 MODULE_DESCRIPTION("SMS DVB subsystem adaptation module");
-MODULE_AUTHOR("Siano Mobile Silicon, INC. (uris@siano-ms.com)");
+MODULE_AUTHOR("Siano Mobile Silicon, Inc. (uris@siano-ms.com)");
 MODULE_LICENSE("GPL");



      
