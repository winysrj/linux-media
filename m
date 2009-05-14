Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110814.mail.gq1.yahoo.com ([67.195.13.237]:23537 "HELO
	web110814.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751956AbZENT2Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2009 15:28:16 -0400
Message-ID: <261583.74225.qm@web110814.mail.gq1.yahoo.com>
Date: Thu, 14 May 2009 12:28:17 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0905_12] Siano: move dvb-api headers' includes to dvb adapter
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242323970 -10800
# Node ID cc2c1513b97c4247614fadcab0a61f3979837d86
# Parent  483a3656a227acbceb26da96b02bebd0058a3961
[0905_12] Siano: move dvb-api headers' includes to dvb adapter

From: Uri Shkolnik <uris@siano-ms.com>

Move the DVB-API v3 headers' include list from the core component
to the smsdvb (DVB adapter) which is the only one that uses them.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 483a3656a227 -r cc2c1513b97c linux/drivers/media/dvb/siano/smscoreapi.h
--- a/linux/drivers/media/dvb/siano/smscoreapi.h	Thu May 14 20:54:22 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.h	Thu May 14 20:59:30 2009 +0300
@@ -35,13 +35,6 @@ along with this program.  If not, see <h
 #include <asm/page.h>
 #include "compat.h"
 
-#define SMS_DVB3_SUBSYS
-#ifdef SMS_DVB3_SUBSYS
-#include "dmxdev.h"
-#include "dvbdev.h"
-#include "dvb_demux.h"
-#include "dvb_frontend.h"
-#endif
 
 #define kmutex_init(_p_) mutex_init(_p_)
 #define kmutex_lock(_p_) mutex_lock(_p_)
diff -r 483a3656a227 -r cc2c1513b97c linux/drivers/media/dvb/siano/smsdvb.c
--- a/linux/drivers/media/dvb/siano/smsdvb.c	Thu May 14 20:54:22 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsdvb.c	Thu May 14 20:59:30 2009 +0300
@@ -21,6 +21,11 @@ along with this program.  If not, see <h
 
 #include <linux/module.h>
 #include <linux/init.h>
+
+#include "dmxdev.h"
+#include "dvbdev.h"
+#include "dvb_demux.h"
+#include "dvb_frontend.h"
 
 #include "smscoreapi.h"
 #include "smsendian.h"



      
