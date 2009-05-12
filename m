Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110816.mail.gq1.yahoo.com ([67.195.13.239]:27701 "HELO
	web110816.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751388AbZELPfW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 11:35:22 -0400
Message-ID: <69644.96087.qm@web110816.mail.gq1.yahoo.com>
Date: Tue, 12 May 2009 08:35:22 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0905_08] Siano: smsdvb - move the dvb related included files
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242142695 -10800
# Node ID 777b32ac3080215d26c35853ea41c1f8f992b70c
# Parent  10143bda4ddae2b30af23adb15e536dc8bef7962
[0905_08] Siano: smsdvb - move the dvb related included files

From: Uri Shkolnik <uris@siano-ms.com>

This patch moves the DVB API related headers from the core,
to the smbdvb (dvb adapter) which is the only component that
uses these headers.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 10143bda4dda -r 777b32ac3080 linux/drivers/media/dvb/siano/smscoreapi.h
--- a/linux/drivers/media/dvb/siano/smscoreapi.h	Tue May 12 18:32:16 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.h	Tue May 12 18:38:15 2009 +0300
@@ -34,13 +34,6 @@ along with this program.  If not, see <h
 
 #include <asm/page.h>
 #include "compat.h"
-
-#ifdef SMS_DVB3_SUBSYS
-#include "dmxdev.h"
-#include "dvbdev.h"
-#include "dvb_demux.h"
-#include "dvb_frontend.h"
-#endif
 
 #define kmutex_init(_p_) mutex_init(_p_)
 #define kmutex_lock(_p_) mutex_lock(_p_)
diff -r 10143bda4dda -r 777b32ac3080 linux/drivers/media/dvb/siano/smsdvb.c
--- a/linux/drivers/media/dvb/siano/smsdvb.c	Tue May 12 18:32:16 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsdvb.c	Tue May 12 18:38:15 2009 +0300
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



      
