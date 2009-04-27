Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110806.mail.gq1.yahoo.com ([67.195.13.229]:25592 "HELO
	web110806.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754401AbZD0Kun (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2009 06:50:43 -0400
Message-ID: <357070.92868.qm@web110806.mail.gq1.yahoo.com>
Date: Mon, 27 Apr 2009 03:50:42 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0904_1_1] Siano: core header - update license [Replace 0904_1]
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1240828880 -10800
# Node ID 24e0283cbbc9992ea6bc9775906821e323726f34
# Parent  7311d23c3355629b617013cd51223895a2423770
Modify the file license to match all other Siano's files

From: Uri Shkolnik <uris@siano-ms.com>

Modify the file license to match all other Siano's files

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 7311d23c3355 -r 24e0283cbbc9 linux/drivers/media/dvb/siano/smscoreapi.h
--- a/linux/drivers/media/dvb/siano/smscoreapi.h	Sun Mar 15 12:05:57 2009 +0200
+++ b/linux/drivers/media/dvb/siano/smscoreapi.h	Mon Apr 27 13:41:20 2009 +0300
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
@@ -598,4 +598,4 @@ int smscore_led_state(struct smscore_dev
 	dprintk(KERN_DEBUG, DBG_ADV, fmt, ##arg)
 
 
-#endif /* __smscoreapi_h__ */
+#endif /* __SMS_CORE_API_H__ */



      
