Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:56931 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab0FAW5z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jun 2010 18:57:55 -0400
Received: by mail-ww0-f46.google.com with SMTP id 28so2464375wwb.19
        for <linux-media@vger.kernel.org>; Tue, 01 Jun 2010 15:57:54 -0700 (PDT)
Subject: [PATCH 3/6] gspca - gl860: USB control message delay unification
From: Olivier Lorin <olorin75@gmail.com>
To: V4L Mailing List <linux-media@vger.kernel.org>
Cc: Jean-Francois Moine <moinejf@free.fr>
Content-Type: text/plain
Date: Wed, 02 Jun 2010 00:57:48 +0200
Message-Id: <1275433068.20756.101.camel@miniol>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

gspca - gl860: USB control message delay unification

From: Olivier Lorin <o.lorin@laposte.net>

- 1 ms "msleep" applied to each sensor after USB control data exchange
  This was done for two sensors because these exchanges were known to
  be too quick depending on laptop model.
  It is fairly logical to apply this delay to each sensor
  in order to prevent from having errors with untested hardwares.

Priority: normal

Signed-off-by: Olivier Lorin <o.lorin@laposte.net>

diff -urpN i2/gl860.c gl860/gl860.c
--- i2/gl860.c	2010-06-01 23:11:26.000000000 +0200
+++ gl860/gl860.c	2010-06-01 23:16:59.000000000 +0200
@@ -595,10 +595,7 @@ int gl860_RTx(struct gspca_dev *gspca_de
 	else if (len > 1 && r < len)
 		PDEBUG(D_ERR, "short ctrl transfer %d/%d", r, len);
 
-	if (_MI2020_ && (val || index))
-		msleep(1);
-	if (_OV2640_)
-		msleep(1);
+	msleep(1);
 
 	return r;
 }


