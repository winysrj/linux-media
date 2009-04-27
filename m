Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110801.mail.gq1.yahoo.com ([67.195.13.224]:37325 "HELO
	web110801.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753117AbZD0MJs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2009 08:09:48 -0400
Message-ID: <483873.44528.qm@web110801.mail.gq1.yahoo.com>
Date: Mon, 27 Apr 2009 05:09:47 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0904_7_1] Siano: smsdvb - modify license
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1240832608 -10800
# Node ID 39bbe3b24abaaa3e049a855cb51be0b917b0c711
# Parent  4a0b207a424af7f05d8eb417a698a82a61dd086f
Siano: smsdvb - Fix licese to match all other Siano's files

From: Uri Shkolnik <uris@siano-ms.com>

Siano: smsdvb - Fix license to match all other Siano's files

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 4a0b207a424a -r 39bbe3b24aba linux/drivers/media/dvb/siano/smsdvb.c
--- a/linux/drivers/media/dvb/siano/smsdvb.c	Thu Apr 02 20:50:24 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsdvb.c	Mon Apr 27 14:43:28 2009 +0300
@@ -1,23 +1,23 @@
-/*
- *  Driver for the Siano SMS1xxx USB dongle
- *
- *  Author: Uri Shkolni
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
+
+Siano Mobile Silicon, Inc.
+MDTV receiver kernel modules.
+Copyright (C) 2006-2008, Uri Shkolnik
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
 
 #include <linux/module.h>
 #include <linux/init.h>



      
