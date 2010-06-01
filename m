Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:56931 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab0FAW6F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jun 2010 18:58:05 -0400
Received: by mail-ww0-f46.google.com with SMTP id 28so2464375wwb.19
        for <linux-media@vger.kernel.org>; Tue, 01 Jun 2010 15:58:04 -0700 (PDT)
Subject: [PATCH 5/6] gspca - gl860: fix for wrong 0V9655 resolution
 identifier name
From: Olivier Lorin <olorin75@gmail.com>
To: V4L Mailing List <linux-media@vger.kernel.org>
Cc: Jean-Francois Moine <moinejf@free.fr>
Content-Type: text/plain
Date: Wed, 02 Jun 2010 00:58:02 +0200
Message-Id: <1275433082.20756.103.camel@miniol>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

gspca - gl860: fix for wrong 0V9655 resolution identifier name

From: Olivier Lorin <o.lorin@laposte.net>

- Fix for a wrong OV9655 image resolution identifier name

Priority: normal

Signed-off-by: Olivier Lorin <o.lorin@laposte.net>

diff -urpN i4/gl860-ov9655.c gl860/gl860-ov9655.c
--- i4/gl860-ov9655.c	2010-06-01 23:18:28.000000000 +0200
+++ gl860/gl860-ov9655.c	2010-04-28 13:39:14.000000000 +0200
@@ -69,7 +69,7 @@ static u8 *tbl_640[] = {
 	"\xd0\x01\xd1\x08\xd2\xe0\xd3\x01" "\xd4\x10\xd5\x80"
 };
 
-static u8 *tbl_800[] = {
+static u8 *tbl_1280[] = {
 	"\x00\x40\x07\x6a\x06\xf3\x0d\x6a" "\x10\x10\xc1\x01"
 	,
 	"\x12\x80\x00\x00\x01\x98\x02\x80" "\x03\x12\x04\x01\x0b\x57\x0e\x61"
@@ -217,7 +217,7 @@ static int ov9655_init_post_alt(struct g
 
 	ctrl_out(gspca_dev, 0x40, 5, 0x0001, 0x0000, 0, NULL);
 
-	tbl = (reso == IMAGE_640) ? tbl_640 : tbl_800;
+	tbl = (reso == IMAGE_640) ? tbl_640 : tbl_1280;
 
 	ctrl_out(gspca_dev, 0x40, 3, 0x0000, 0x0200,
 			tbl_length[0], tbl[0]);


