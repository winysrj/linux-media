Return-path: <mchehab@pedra>
Received: from mail-px0-f174.google.com ([209.85.212.174]:48951 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab0JNTJ7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Oct 2010 15:09:59 -0400
Received: by pxi16 with SMTP id 16so1013292pxi.19
        for <linux-media@vger.kernel.org>; Thu, 14 Oct 2010 12:09:59 -0700 (PDT)
Message-ID: <4CB75577.9090109@gmail.com>
Date: Thu, 14 Oct 2010 12:09:43 -0700
From: "D. K." <user.vdr@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: alannisota@gmail.com
Subject: [PATCH] gp8psk: fix tuner delay
Content-Type: multipart/mixed;
 boundary="------------000005000904090908000308"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------000005000904090908000308
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

 This patches adjusts the tuner delay to be longer in response to
several users experiencing tuner timeouts.  This change fixes that
problem and allows those users to be able to tune.

Signed-off-by: Derek Kelly <user.vdr@gmail.com <mailto:user.vdr@gmail.com>>
----------
diff -pruN v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c v4l-dvb/linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c
--- v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c    2010-08-17 09:53:27.000000000 -0700
+++ v4l-dvb/linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c 2010-08-17 10:00:28.000000000 -0700
@@ -109,7 +109,7 @@ static int gp8psk_fe_read_signal_strengt

 static int gp8psk_fe_get_tune_settings(struct dvb_frontend* fe, struct dvb_frontend_tune_settings *tune)
 {
-       tune->min_delay_ms = 200;
+       tune->min_delay_ms = 800;
        return 0;
 }



--------------000005000904090908000308
Content-Type: text/plain;
 name="gp8psk-fix_tuner_delay.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="gp8psk-fix_tuner_delay.diff"

diff -pruN v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c v4l-dvb/linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c
--- v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c	2010-08-17 09:53:27.000000000 -0700
+++ v4l-dvb/linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c	2010-08-17 10:00:28.000000000 -0700
@@ -109,7 +109,7 @@ static int gp8psk_fe_read_signal_strengt
 
 static int gp8psk_fe_get_tune_settings(struct dvb_frontend* fe, struct dvb_frontend_tune_settings *tune)
 {
-	tune->min_delay_ms = 200;
+	tune->min_delay_ms = 800;
 	return 0;
 }
 

--------------000005000904090908000308--
