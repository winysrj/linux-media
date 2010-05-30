Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43757 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab0E3W1V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 May 2010 18:27:21 -0400
Received: by wyb36 with SMTP id 36so927660wyb.19
        for <linux-media@vger.kernel.org>; Sun, 30 May 2010 15:27:20 -0700 (PDT)
Subject: [PATCH 3/3] Gspca-gl860 driver update
From: Olivier Lorin <olorin75@gmail.com>
To: V4L Mailing List <linux-media@vger.kernel.org>
Cc: Jean-Francois Moine <moinejf@free.fr>
Content-Type: text/plain
Date: Mon, 31 May 2010 00:27:17 +0200
Message-Id: <1275258437.18267.27.camel@miniol>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

gspca - gl860: minor functional changes

From: Olivier Lorin <o.lorin@laposte.net>

- Setting changes applied after an end of image marker reception
  This is the way MI2020 sensor works.
  It seems to be logical to wait for a complete image before 
  to change a setting.
- 1 ms "msleep" applied to each sensor after USB control data exchange
  This was done for two sensors because these exchanges were known to
  be too quick depending on laptop model.
  It should be fairly logical to apply this delay to each sensor
  in order to prevent from having errors with untested hardwares.

Priority: normal

Signed-off-by: Olivier Lorin <o.lorin@laposte.net>

diff -urpN der_gl860i3/gl860.c gl860/gl860.c
--- der_gl860i3/gl860.c	2010-04-29 21:01:15.000000000 +0200
+++ gl860/gl860.c	2010-04-28 23:45:19.000000000 +0200
@@ -63,7 +63,7 @@ static int sd_set_##thename(struct gspca
 \
 	sd->vcur.thename = val;\
 	if (gspca_dev->streaming)\
-		sd->dev_camera_settings(gspca_dev);\
+		sd->waitSet = 1;\
 	return 0;\
 } \
 static int sd_get_##thename(struct gspca_dev *gspca_dev, s32 *val)\
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


