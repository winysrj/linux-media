Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110816.mail.gq1.yahoo.com ([67.195.13.239]:48234 "HELO
	web110816.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751174AbZELK5x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 06:57:53 -0400
Message-ID: <184506.51976.qm@web110816.mail.gq1.yahoo.com>
Date: Tue, 12 May 2009 03:57:54 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0905_01] Siano: smsusb - update license
To: LinuxML <linux-media@vger.kernel.org>
Cc: Mauro Carvalho <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242126057 -10800
# Node ID 766d02fa7c5c42cc6480eaefb14c7dd6f9c0d370
# Parent  8d37e850566419e7905e66f875b9384d96bf340d
[0905_01] Siano: smsusb - update license

From: Uri Shkolnik <uris@siano-ms.com>

This patch updates the license of the USB interface driver

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 8d37e8505664 -r 766d02fa7c5c linux/drivers/media/dvb/siano/smsusb.c
--- a/linux/drivers/media/dvb/siano/smsusb.c	Mon May 11 09:37:41 2009 -0700
+++ b/linux/drivers/media/dvb/siano/smsusb.c	Tue May 12 14:00:57 2009 +0300
@@ -1,23 +1,23 @@
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
+
+Siano Mobile Silicon, Inc.
+MDTV receiver kernel modules.
+Copyright (C) 2005-2009, Uri Shkolnik, Anatoly Greenblat
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
 
 #include <linux/kernel.h>
 #include <linux/init.h>



      
