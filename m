Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110811.mail.gq1.yahoo.com ([67.195.13.234]:20725 "HELO
	web110811.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757383AbZDEIJS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 04:09:18 -0400
Message-ID: <230177.85090.qm@web110811.mail.gq1.yahoo.com>
Date: Sun, 5 Apr 2009 01:09:16 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0904_1] Siano: core header - update license and include files
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1238689930 -10800
# Node ID c3f0f50d46058f07fb355d8e5531f35cfd0ca37e
# Parent  7311d23c3355629b617013cd51223895a2423770
[PATCH] [0904_1] Siano: core header - update license and included files

From: Uri Shkolnik <uris@siano-ms.com>

This patch does not include any implementation changes.
It update the smscoreapi.h license to be identical to 
other Siano's headers and the #include files list.


Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 7311d23c3355 -r c3f0f50d4605 linux/drivers/media/dvb/siano/smscoreapi.h
--- a/linux/drivers/media/dvb/siano/smscoreapi.h	Sun Mar 15 12:05:57 2009 +0200
+++ b/linux/drivers/media/dvb/siano/smscoreapi.h	Thu Apr 02 19:32:10 2009 +0300
@@ -1,26 +1,26 @@
-/*
- *  Driver for the Siano SMS1xxx USB dongle
- *
- *  author: Anatoly Greenblat
- *
- *  Copyright (c), 2005-2008 Siano Mobile Silicon, Inc.
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2 as
- *  published by the Free Software Foundation;
- *
- *  Software distributed under the License is distributed on an "AS IS"
- *  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied.
- *
- *  See the GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
+/****************************************************************
 
-#ifndef __smscoreapi_h__
-#define __smscoreapi_h__
+Siano Mobile Silicon, Inc.
+MDTV receiver kernel modules.
+Copyright (C) 2006-2008, Uri Shkolnik, Anatoly Greenblat
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
+#ifndef __SMS_CORE_API_H__
+#define __SMS_CORE_API_H__
 
 #include <linux/version.h>
 #include <linux/device.h>
@@ -28,15 +28,23 @@
 #include <linux/mm.h>
 #include <linux/scatterlist.h>
 #include <linux/types.h>
+#include <linux/mutex.h>
+#include <linux/compat.h>
+#include <linux/wait.h>
+#include <linux/timer.h>
+
 #include <asm/page.h>
-#include <linux/mutex.h>
-#include "compat.h"
 
+/* #include "smsir.h" */
+
+#define SMS_DVB3_SUBSYS
+#ifdef SMS_DVB3_SUBSYS
 #include "dmxdev.h"
 #include "dvbdev.h"
 #include "dvb_demux.h"
 #include "dvb_frontend.h"
 
+#endif
 
 #define kmutex_init(_p_) mutex_init(_p_)
 #define kmutex_lock(_p_) mutex_lock(_p_)
@@ -598,4 +606,4 @@ int smscore_led_state(struct smscore_dev
 	dprintk(KERN_DEBUG, DBG_ADV, fmt, ##arg)
 
 
-#endif /* __smscoreapi_h__ */
+#endif /* __SMS_CORE_API_H__ */



      
