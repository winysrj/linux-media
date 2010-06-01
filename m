Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:56931 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab0FAW5v (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jun 2010 18:57:51 -0400
Received: by mail-ww0-f46.google.com with SMTP id 28so2464375wwb.19
        for <linux-media@vger.kernel.org>; Tue, 01 Jun 2010 15:57:51 -0700 (PDT)
Subject: [PATCH 2/6] gspca - gl860: setting changes applied after an EOI
From: Olivier Lorin <olorin75@gmail.com>
To: V4L Mailing List <linux-media@vger.kernel.org>
Cc: Jean-Francois Moine <moinejf@free.fr>
Content-Type: text/plain
Date: Wed, 02 Jun 2010 00:57:48 +0200
Message-Id: <1275433068.20756.100.camel@miniol>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

gspca - gl860: setting changes applied after an EOI

From: Olivier Lorin <o.lorin@laposte.net>

- Setting changes applied after an end of image marker reception
  This is the way MI2020 sensor works.
  It seems to be logical to wait for a complete image before 
  to change a setting.

Priority: normal

Signed-off-by: Olivier Lorin <o.lorin@laposte.net>

diff -urpN i1/gl860.c gl860/gl860.c
--- i1/gl860.c	2010-06-01 23:26:22.000000000 +0200
+++ gl860/gl860.c	2010-06-01 23:11:26.000000000 +0200
@@ -63,7 +63,7 @@ static int sd_set_##thename(struct gspca
 \
 	sd->vcur.thename = val;\
 	if (gspca_dev->streaming)\
-		sd->dev_camera_settings(gspca_dev);\
+		sd->waitSet = 1;\
 	return 0;\
 } \
 static int sd_get_##thename(struct gspca_dev *gspca_dev, s32 *val)\


