Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110816.mail.gq1.yahoo.com ([67.195.13.239]:47467 "HELO
	web110816.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752544AbZESP4P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 11:56:15 -0400
Message-ID: <231521.6566.qm@web110816.mail.gq1.yahoo.com>
Date: Tue, 19 May 2009 08:56:16 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [09051_52] Siano: smsendien - declare function as extern
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242748849 -10800
# Node ID b71383c9ab1cd51cc307b488ef4397f6eb345cef
# Parent  11b56bb92bc853666fdc1f7dc1fb799e227a2b41
[09051_52] Siano: smsendien - declare function as extern

From: Uri Shkolnik <uris@siano-ms.com>

Declare the object function as 'extern'

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 11b56bb92bc8 -r b71383c9ab1c linux/drivers/media/dvb/siano/smsendian.h
--- a/linux/drivers/media/dvb/siano/smsendian.h	Tue May 19 18:57:08 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsendian.h	Tue May 19 19:00:49 2009 +0300
@@ -24,9 +24,9 @@ along with this program.  If not, see <h
 
 #include <asm/byteorder.h>
 
-void smsendian_handle_tx_message(void *buffer);
-void smsendian_handle_rx_message(void *buffer);
-void smsendian_handle_message_header(void *msg);
+extern void smsendian_handle_tx_message(void *buffer);
+extern void smsendian_handle_rx_message(void *buffer);
+extern void smsendian_handle_message_header(void *msg);
 
 #endif /* __SMS_ENDIAN_H__ */
 



      
