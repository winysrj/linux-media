Return-path: <mchehab@pedra>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35829 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab0JPTH4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Oct 2010 15:07:56 -0400
Received: by pzk33 with SMTP id 33so273602pzk.19
        for <linux-media@vger.kernel.org>; Sat, 16 Oct 2010 12:07:55 -0700 (PDT)
Message-ID: <4CB9F803.6050500@gmail.com>
Date: Sat, 16 Oct 2010 12:07:47 -0700
From: "D. K." <user.vdr@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] dvb-usb-gp8psk: Fix tuner timeout (against git)
Content-Type: multipart/mixed;
 boundary="------------010109090709070703000408"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------010109090709070703000408
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

 This patches adjusts the tuner delay to be longer in response to
several users experiencing tuner timeouts.  This change fixes that
problem and allows those users to be able to tune.

Patched against git.

Signed-off-by: Derek Kelly <user.vdr@gmail.com <mailto:user.vdr@gmail.com>>


--------------010109090709070703000408
Content-Type: text/plain;
 name="gp8psk-fix_tuner_delay_git.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="gp8psk-fix_tuner_delay_git.diff"

diff -pruN v4l-dvb.orig/drivers/media/dvb/dvb-usb/gp8psk-fe.c v4l-dvb/drivers/media/dvb/dvb-usb/gp8psk-fe.c
--- v4l-dvb.orig/drivers/media/dvb/dvb-usb/gp8psk-fe.c	2010-10-16 09:10:18.000000000 -0700
+++ v4l-dvb/drivers/media/dvb/dvb-usb/gp8psk-fe.c	2010-10-16 11:57:57.000000000 -0700
@@ -109,7 +109,7 @@ static int gp8psk_fe_read_signal_strengt
 
 static int gp8psk_fe_get_tune_settings(struct dvb_frontend* fe, struct dvb_frontend_tune_settings *tune)
 {
-	tune->min_delay_ms = 200;
+	tune->min_delay_ms = 800;
 	return 0;
 }
 

--------------010109090709070703000408--
