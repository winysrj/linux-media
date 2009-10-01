Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp06.mail.tnz.yahoo.co.jp ([203.216.246.69]:48536 "HELO
	smtp06.mail.tnz.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751969AbZJAFZ4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Oct 2009 01:25:56 -0400
Message-ID: <4AC43BD7.5090203@yahoo.co.jp>
Date: Thu, 01 Oct 2009 14:19:19 +0900
From: Akihiro TSUKADA <tskd2@yahoo.co.jp>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/2] dvb-usb-friio: cleaning up unnecessary functions
References: <4AC43967.6070108@yahoo.co.jp>
In-Reply-To: <4AC43967.6070108@yahoo.co.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd2@yahoo.co.jp>

This patch removes some fe->ops.X() functions which do nothing more useful than the default.

Priority: normal

Signed-off-by: Akihiro Tsukada <tskd2@yahoo.co.jp>
---
 friio-fe.c |   38 --------------------------------------
 1 file changed, 38 deletions(-)

diff --git a/linux/drivers/media/dvb/dvb-usb/friio-fe.c b/linux/drivers/media/dvb/dvb-usb/friio-fe.c
--- a/linux/drivers/media/dvb/dvb-usb/friio-fe.c
+++ b/linux/drivers/media/dvb/dvb-usb/friio-fe.c
@@ -232,12 +232,6 @@ static int jdvbt90502_read_status(struct
 	return 0;
 }
 
-static int jdvbt90502_read_ber(struct dvb_frontend *fe, u32 *ber)
-{
-	*ber = 0;
-	return 0;
-}
-
 static int jdvbt90502_read_signal_strength(struct dvb_frontend *fe,
 					   u16 *strength)
 {
@@ -264,27 +258,6 @@ static int jdvbt90502_read_signal_streng
 	return 0;
 }
 
-static int jdvbt90502_read_snr(struct dvb_frontend *fe, u16 *snr)
-{
-	*snr = 0x0101;
-	return 0;
-}
-
-static int jdvbt90502_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
-{
-	*ucblocks = 0;
-	return 0;
-}
-
-static int jdvbt90502_get_tune_settings(struct dvb_frontend *fe,
-					struct dvb_frontend_tune_settings *fs)
-{
-	fs->min_delay_ms = 500;
-	fs->step_size = 0;
-	fs->max_drift = 0;
-
-	return 0;
-}
 
 /* filter out un-supported properties to notify users */
 static int jdvbt90502_set_property(struct dvb_frontend *fe,
@@ -347,12 +320,6 @@ static int jdvbt90502_set_frontend(struc
 	return 0;
 }
 
-static int jdvbt90502_sleep(struct dvb_frontend *fe)
-{
-	deb_fe("%s called.\n", __func__);
-	return 0;
-}
-
 
 /**
  * (reg, val) commad list to initialize this module.
@@ -493,18 +460,13 @@ static struct dvb_frontend_ops jdvbt9050
 	.release = jdvbt90502_release,
 
 	.init = jdvbt90502_init,
-	.sleep = jdvbt90502_sleep,
 	.write = _jdvbt90502_write,
 
 	.set_property = jdvbt90502_set_property,
 
 	.set_frontend = jdvbt90502_set_frontend,
 	.get_frontend = jdvbt90502_get_frontend,
-	.get_tune_settings = jdvbt90502_get_tune_settings,
 
 	.read_status = jdvbt90502_read_status,
-	.read_ber = jdvbt90502_read_ber,
 	.read_signal_strength = jdvbt90502_read_signal_strength,
-	.read_snr = jdvbt90502_read_snr,
-	.read_ucblocks = jdvbt90502_read_ucblocks,
 };

--------------------------------------
Yahoo! JAPAN - Internet Security for teenagers and parents.
http://pr.mail.yahoo.co.jp/security/
