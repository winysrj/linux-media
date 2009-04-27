Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110816.mail.gq1.yahoo.com ([67.195.13.239]:37645 "HELO
	web110816.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754064AbZD0Kvn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2009 06:51:43 -0400
Message-ID: <418456.4637.qm@web110816.mail.gq1.yahoo.com>
Date: Mon, 27 Apr 2009 03:51:42 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0904_1_2] Siano: core header - update include files
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1240829297 -10800
# Node ID f8f75fb71210dfde89f994a97d8a4fa1e6b7b7bc
# Parent  24e0283cbbc9992ea6bc9775906821e323726f34
Re-order the include files list

From: Uri Shkolnik <uris@siano-ms.com>

Re-order the include files list, put the DVB-API v3 within its
own section, within a define container.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 24e0283cbbc9 -r f8f75fb71210 linux/drivers/media/dvb/siano/smscoreapi.h
--- a/linux/drivers/media/dvb/siano/smscoreapi.h	Mon Apr 27 13:41:20 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.h	Mon Apr 27 13:48:17 2009 +0300
@@ -28,15 +28,20 @@ along with this program.  If not, see <h
 #include <linux/mm.h>
 #include <linux/scatterlist.h>
 #include <linux/types.h>
+#include <linux/mutex.h>
+#include <linux/wait.h>
+#include <linux/timer.h>
+
 #include <asm/page.h>
-#include <linux/mutex.h>
 #include "compat.h"
 
+#define SMS_DVB3_SUBSYS
+#ifdef SMS_DVB3_SUBSYS
 #include "dmxdev.h"
 #include "dvbdev.h"
 #include "dvb_demux.h"
 #include "dvb_frontend.h"
-
+#endif
 
 #define kmutex_init(_p_) mutex_init(_p_)
 #define kmutex_lock(_p_) mutex_lock(_p_)



      
